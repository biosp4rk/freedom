.definelabel MissileLimit,3

.definelabel NormalMissileType,0xA
.definelabel SuperMissileType,0xB
.definelabel IceMissileType,0xC
.definelabel DiffusionMissileType,0xD
.definelabel ChargedMissileType,0xE

.definelabel NormalMissileFlag,1
.definelabel SuperMissileFlag,2
.definelabel IceMissileFlag,4
.definelabel DiffusionMissileFlag,8

; Type      Damage  Cooldown
; Normal     10      9
; Super     +20     +4
; Ice       +10     +2
; Diffusion  +5     +1

; Speed
; 1: 04 06 08 0C 0E 10 12
; 2: 04 06 08 0C 10 14 18
; 3: 04 08 0C 10 14 18 1C
; 4: 08 0C 10 14 18 1C 20

; Graphics
; Super > Ice = Diffusion > Normal

; Hitbox size
; Normal     16 x 16
; Super      32 x 24
; Ice        32 x 24
; Diffusion  32 x 24

; Trail graphics
; Ice > Super = Diffusion > Normal

; Fire sound
; Charged > Ice > Super = Diffusion > Normal

; Hit effect
; Charged > Ice > Super = Diffusion > Normal


;---------------------------
; UpdateArmCannonAndWeapons
;---------------------------

; modified portion of UpdateArmCannonAndWeapons
; where a new missile is initialized
.org 0x8082218
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xB]         ; r1 = MissileStatus
    mov     r4,NormalMissileType    ; base type
    mov     r5,9                ; base cooldown
    ; check super
    mov     r0,SuperMissileFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckHasIce
    mov     r4,SuperMissileType
    add     r5,r5,4
@@CheckHasIce:
    mov     r0,IceMissileFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckHasDiffusion
    mov     r4,IceMissileType
    add     r5,r5,2
@@CheckHasDiffusion:
    mov     r0,DiffusionMissileFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckNumber
    mov     r4,DiffusionMissileType
    add     r5,r5,1
@@CheckNumber:
    mov     r0,r4               ; r0 = type
    mov     r1,MissileLimit     ; r1 = limit
    bl      CheckNumProjectiles
    cmp     r0,0
    bne     @@UnderLimit
    b       0x8082544           ; return
@@UnderLimit:
    cmp     r4,DiffusionMissileType
    bne     @@NotCharged        ; if diffusion
    ldr     r1,=0x3001324
    ldrb    r0,[r1,0x13]            ; r0 = charge counter
    cmp     r0,0x80
    bcc     @@ResetCounter          ; if charged diffusion
    mov     r4,ChargedMissileType       ; type = charged
@@ResetCounter:
    mov     r0,0
    strb    r0,[r1,0x13]            ; reset charge counter
@@NotCharged:
    ldr     r1,=SamusData
    strb    r5,[r1,0xA]         ; set cooldown
    mov     r0,r4               ; r0 = type
    ldr     r2,=ArmCannonYPos
    ldrh    r1,[r2]             ; r1 = Ypos
    ldr     r2,=ArmCannonXPos
    ldrh    r2,[r2]             ; r2 = Ypos
    mov     r3,0                ; r3 = part (0)
    bl      InitProjectile
    b       0x8082544           ; return
    .pool


;----------------
; LoadMissileGFX
;----------------
.org 0x08082C70
    push    r14
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xB]
    mov     r2,r1
    ; check super
    mov     r0,SuperMissileFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckIceOrDiffusion
    ldr     r0,=DMA3SourceAddress
    ldr     r1,=SuperMissileGFX0
    str     r1,[r0]
    ldr     r1,=0x6011380
    str     r1,[r0,4]
    ldr     r2,=0x80000040
    str     r2,[r0,8]
    ldr     r1,[r0,8]
    ldr     r1,=SuperMissileGFX1
    b       @@SecondDMA
@@CheckIceOrDiffusion:
    mov     r0,0xC
    and     r0,r1
    cmp     r0,0
    beq     @@CheckNormal
    ldr     r0,=DMA3SourceAddress
    ldr     r1,=IceMissileGFX0
    str     r1,[r0]
    ldr     r1,=0x6011380
    str     r1,[r0,4]
    ldr     r2,=0x80000040
    str     r2,[r0,8]
    ldr     r1,[r0,8]
    ldr     r1,=IceMissileGFX1
    b       @@SecondDMA
@@CheckNormal:
    mov     r0,NormalMissileFlag
    and     r2,r0
    cmp     r2,0
    beq     @@Return
    ldr     r0,=DMA3SourceAddress
    ldr     r1,=NormalMissileGFX0
    str     r1,[r0]
    ldr     r1,=0x6011380
    str     r1,[r0,4]
    ldr     r2,=0x80000040
    str     r2,[r0,8]
    ldr     r1,[r0,8]
    ldr     r1,=NormalMissileGFX1
@@SecondDMA:
    str     r1,[r0]
    ldr     r1,=0x6011780
    str     r1,[r0,4]
    str     r2,[r0,8]
    ldr     r0,[r0,8]
@@Return:
    pop     r0
    bx      r0
    .pool


;-----------------
; MissileHitSpite
;-----------------

; make all missile types branch to same code
.org 0x8083904
    .dw 0x8083B08   ; normal
    .dw 0x8083B08   ; super
    .dw 0x8083B08   ; ice
    .dw 0x8083B08   ; diffusion
    .dw 0x8083B08   ; charged

; combined missile hit sprite
.org 0x8085320
    push    r4-r7,r14
    mov     r6,r9
    mov     r5,r8
    push    r5,r6
    add     sp,-0xC
    ; initialize registers
    mov     r4,r0               ; r4 = SpriteSlotNum
    mov     r5,r1               ; r5 = ProjSlotNum
    mov     r6,r2               ; r6 = ProjYPos
    mov     r7,r3               ; r7 = ProjXPos
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xB]
    mov     r8,r0               ; r8 = MissileFlags
    ; check if sprite is immune
    ldr     r1,=SpriteDataSlot0
    lsl     r0,r4,3
    sub     r0,r0,r4
    lsl     r0,r0,3
    add     r0,r1,r0
    add     r0,0x34
    ldrb    r1,[r0]             ; r1 = Properties
    mov     r0,8
    and     r0,r1
    cmp     r0,0
    beq     @@CheckSpriteSolid
    mov     r0,r4
    bl      UpdateSpriteFlashTimer
    ; check for ice missiles
    mov     r0,r8
    mov     r1,IceMissileFlag
    and     r0,r1
    cmp     r0,0
    beq     @@SuccessfulHit
    ; check if enemy isn't frozen
    ldr     r1,=SpriteDataSlot0
    lsl     r0,r4,3
    sub     r0,r0,r4
    lsl     r0,r0,3
    add     r0,r1,r0
    mov     r9,r0               ; r9 = CurrSprite
    add     r0,0x32
    ldrb    r0,[r0]             ; r0 = FreezeTimer
    cmp     r0,0
    bne     @@SuccessfulHit
    ; check if enemy can be frozen
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,0x40
    and     r0,r1
    cmp     r0,0
    beq     @@SuccessfulHit
    mov     r0,r9
    add     r0,0x33
    mov     r1,0
    strb    r1,[r0]             ; StandingOnSpriteFlag = 0
    mov     r1,0xF0
    sub     r0,1
    strb    r1,[r0]             ; FreezeTimer = F0
    add     r0,3
    ldrb    r1,[r0]             ; r1 = FrozenPaletteRow
    sub     r0,0x16
    ldrb    r2,[r0]             ; r2 = SpritesetGfxSlot
    add     r1,r1,r2
    mov     r2,0xF
    sub     r1,r2,r1            ; r1 = F - (FrozenPaletteRow + SpritesetGfxSlot)
    strb    r1,[r0,1]           ; [SpritePalette] = r1
    b       @@SuccessfulHit
@@CheckSpriteSolid:
    mov     r0,0x40
    and     r0,r1
    cmp     r0,0
    bne     @@MissileTinked
@@CheckLowerHealthIce:
    ; check for ice missiles
    mov     r0,r8
    mov     r1,IceMissileFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckLowerHealth
    ; check if enemy weak to missiles
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,8
    and     r1,r0
    cmp     r1,0
    bne     @@LowerHealthIce
    ; check if enemy weak to super
    mov     r1,4
    and     r1,r0
    cmp     r1,0
    beq     @@CheckCanFreeze
    ; check for super missiles
    mov     r1,r8
    mov     r2,SuperMissileFlag
    and     r1,r2
    cmp     r1,0
    bne     @@LowerHealthIce
@@CheckCanFreeze:
    ; check if enemy can be frozen
    mov     r1,0x40
    and     r0,r1
    cmp     r0,0
    beq     @@CheckLowerHealth
@@LowerHealthIce:
    mov     r0,r8
    bl      GetMissileDamage
    mov     r2,r0
    mov     r0,r4               ; r0 = SpriteSlotNum
    mov     r1,r5               ; r1 = ProjSlotNum
    bl      LowerSpriteHealth_IceMissile
    b       @@CheckDamageReduction
@@CheckLowerHealth:
    ; check if enemy weak to missiles
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,8
    and     r1,r0
    cmp     r1,0
    bne     @@LowerHealth
    ; check if enemy weak to super
    mov     r1,4
    and     r1,r0
    cmp     r1,0
    beq     @@Else
    ; check for super missiles
    mov     r1,r8
    mov     r2,SuperMissileFlag
    and     r1,r2
    cmp     r1,0
    beq     @@Else
@@LowerHealth:
    mov     r0,r8               ; r0 = MissileStatus
    bl      GetMissileDamage
    mov     r1,r0
    mov     r0,r4               ; r0 = SpriteSlotNum
    bl      LowerSpriteHealth
    b       @@CheckDamageReduction
@@Else:
    mov     r0,r4
    bl      UpdateSpriteFlashTimer
@@MissileTinked:
    ; tink effect
    mov     r0,r6
    mov     r1,r7
    mov     r2,7
    bl      SetParticleEffect
    ; call tink function
    mov     r0,r4               ; r0 = SpriteSlotNum
    mov     r1,r5               ; r1 = ProjSlotNum
    bl      MissileTink
    b       @@Return
@@CheckDamageReduction:
    ; check damage reduction
    mov     r9,r0               ; r9 = SpriteFlashTimer
    mov     r0,r4
    bl      GetSpriteDamageReduction
    cmp     r0,0
    beq     @@SuccessfulHit
    ; check ice
    mov     r0,r8
    mov     r1,IceMissileFlag
    and     r0,r1
    lsr     r0,r0,2
    add     r0,1                ; 2 for ice, 1 otherwise
    mov     r1,r9               ; r1 = FlashTimer
    mov     r2,r6               ; r2 = Ypos
    mov     r3,r7               ; r3 = Xpos
    bl      CreateSpriteDebris
@@SuccessfulHit:
    ldr     r0,=ProjectileDataSlot0
    lsl     r1,r5,5
    add     r0,r0,r1
    mov     r9,r0               ; r9 = CurrProj
    ldrb    r0,[r0,0xF]
    cmp     r0,0xE
    bne     @@Uncharged
    ; set graphics effect
    mov     r0,r6
    mov     r1,r7
    mov     r2,0xC
    bl      SetParticleEffect
    ; set projectile RAM values
    mov     r2,r9               ; r1 = CurrProj
    mov     r0,3
    strb    r0,[r2,0x12]        ; MovementStage = 3
    mov     r3,0
    strb    r3,[r2,0x1E]        ; Counter = 0
    ldrb    r1,[r2]
    mov     r0,0xEF
    and     r0,r1               ; Status &= EF
    mov     r1,4
    orr     r0,r1               ; Status |= 4
    strb    r0,[r2]
    str     r3,[sp]
    str     r3,[sp,4]
    ldrb    r0,[r2,0x1F]
    str     r0,[sp,8]
    mov     r0,0x12             ; r0 = ProjType
    mov     r1,r6               ; r1 = ProjYPos
    mov     r2,r7               ; r2 = ProjXPos
    mov     r3,0                ; r3 = ProjPart
    bl      InitSecondaryProjectile
    mov     r0,0x12
    mov     r1,r6
    mov     r2,r7
    mov     r3,0x40
    bl      InitSecondaryProjectile
    mov     r0,0x12
    mov     r1,r6
    mov     r2,r7
    mov     r3,0x80
    bl      InitSecondaryProjectile
    mov     r0,0x12
    mov     r1,r6
    mov     r2,r7
    mov     r3,0xC0
    bl      InitSecondaryProjectile
    b       @@Return
@@Uncharged:
    ; set graphics effect
    mov     r0,r8
    bl      GetMissileHitEffect
    mov     r2,r0
    mov     r0,r6
    mov     r1,r7
    bl      SetParticleEffect
    ; set status to 0
    mov     r1,r9
    mov     r0,0
    strb    r0,[r1]
@@Return:
    add     sp,0xC
    pop     r3,r4
    mov     r8,r3
    mov     r9,r4
    pop     r4-r7
    pop     r0
    bx      r0
    .pool


GetMissileDamage:
    ; r0 = MissileFlags
    push    r14
    mov     r2,0xA              ; base damage
@@CheckSuper:
    mov     r1,2
    and     r1,r0
    cmp     r1,0
    beq     @@CheckIce
    add     r2,0x14
@@CheckIce:
    mov     r1,4
    and     r1,r0
    cmp     r1,0
    beq     @@CheckDiffusion
    add     r2,0xA
@@CheckDiffusion:
    mov     r1,8
    and     r1,r0
    cmp     r1,0
    beq     @@Return
    add     r2,5
@@Return:
    mov     r0,r2
    pop     r1
    bx      r1


GetMissileHitEffect:
    ; r0 = MissileStatus
    push    r14
@@CheckIce:
    mov     r1,IceMissileFlag
    and     r1,r0
    cmp     r1,0
    beq     @@CheckSuperOrDiffusion
    mov     r0,0xA              ; ice missile hit
    b       @@Return
@@CheckSuperOrDiffusion:
    mov     r1,0xA
    and     r1,r0
    cmp     r1,0
    beq     @@Normal
    mov     r0,9                ; super missile hit
    b       @@Return
@@Normal:
    mov     r0,8                ; normal missile hit
@@Return:
    pop     r1
    bx      r1


;----------------
; ProcessMissile
;----------------

; make all missile types branch to same code
.org 0x87EE940
    .dw CombinedProcessMissile + 1      ; normal
    .dw CombinedProcessMissile + 1      ; super
    .dw CombinedProcessMissile + 1      ; ice
    .dw CombinedProcessMissile + 1      ; diffusion
    .dw CombinedProcessMissile + 1      ; charged

.org 0x8085D60
CombinedProcessMissile:
    push    r4-r6,r14
    add     sp,-0xC
    ; check if missile hit something
    ldr     r4,=CurrProjectileData
    ldr     r0,=CurrClipdataAffectingAction
    mov     r1,8
    strb    r1,[r0]
    bl      0x8082E8C           ; non-sprite collision
    cmp     r0,0
    beq     @@CheckMovementStage
    ldrb    r0,[r4,0xF]
    cmp     r0,0xE
    beq     @@ChargedHit
    ; uncharged hit
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xB]         ; r0 = MissileFlags
    bl      GetMissileHitEffect
    mov     r2,r0               ; r2 = hit effect
    mov     r0,0
    strb    r0,[r4]             ; ProjStatus = 0
    ldrh    r0,[r4,8]           ; r0 = ProjYPos
    ldrh    r1,[r4,0xA]         ; r1 = ProjXPos
    bl      SetParticleEffect
    b       @@Return
@@ChargedHit:
    ldrh    r0,[r4,8]           ; r0 = ProjYPos
    ldrh    r1,[r4,0xA]         ; r1 = ProjXPos
    mov     r5,r0
    mov     r6,r1
    mov     r2,0xC              ; r2 = diffusion hit
    bl      SetParticleEffect
    ; set projectile RAM values
    mov     r0,3
    strb    r0,[r4,0x12]        ; MovementStage = 3
    mov     r3,0
    strb    r3,[r4,0x1E]        ; Timer = 0
    ldrb    r1,[r4]
    mov     r0,0xEF
    and     r0,r1               ; Status &= EF
    mov     r1,4
    orr     r0,r1               ; Status |= 4
    strb    r0,[r4]
    str     r3,[sp]
    str     r3,[sp,4]
    ldrb    r0,[r4,0x1F]
    str     r0,[sp,8]
    mov     r0,0x12             ; r0 = ProjType
    mov     r1,r5               ; r1 = ProjYPos
    mov     r2,r6               ; r2 = ProjXPos
    mov     r3,0                ; r3 = ProjPart
    bl      InitSecondaryProjectile
    mov     r0,0x12
    mov     r1,r5
    mov     r2,r6
    mov     r3,0x40
    bl      InitSecondaryProjectile
    mov     r0,0x12
    mov     r1,r5
    mov     r2,r6
    mov     r3,0x80
    bl      InitSecondaryProjectile
    mov     r0,0x12
    mov     r1,r5
    mov     r2,r6
    mov     r3,0xC0
    bl      InitSecondaryProjectile
@@CheckMovementStage:
    ldrb    r0,[r4,0x12]
    cmp     r0,0
    beq     @@MovementStage0
    cmp     r0,1
    beq     @@MovementStage1
    cmp     r0,3
    beq     @@MovementStage3
    cmp     r0,7
    beq     @@MovementStage7
    b       @@MovementStage2
@@MovementStage0:
    ldr     r0,=Equipment
    ldrb    r2,[r0,0xB]         ; r0 = MissileStatus
    ; set boundaries
    ; check super/ice/diffusion
    mov     r1,0xE
    and     r1,r2
    cmp     r1,0
    beq     @@NormalBound
    ldr     r0,=0xFFF4
    strh    r0,[r4,0x16]
    mov     r0,0xC
    strh    r0,[r4,0x18]
    ldr     r0,=0xFFF0
    strh    r0,[r4,0x1A]
    mov     r0,0x10
    strh    r0,[r4,0x1C]
    b       @@Initialize
@@NormalBound:
    ldr     r0,=0xFFF8
    strh    r0,[r4,0x16]
    strh    r0,[r4,0x1A]
    mov     r0,8
    strh    r0,[r4,0x18]
    strh    r0,[r4,0x1C]
@@Initialize:
    ; check ice
    mov     r1,IceMissileFlag
    and     r1,r2
    cmp     r1,0
    beq     @@CheckSuperOrDiffusionInit
    mov     r0,1
    mov     r5,0xD4
    b       @@FinishInit
@@CheckSuperOrDiffusionInit:
    mov     r1,0xA
    and     r1,r2
    cmp     r1,0
    beq     @@NormalInit
    mov     r0,0
    mov     r5,0xD1
    b       @@FinishInit
@@NormalInit:
    mov     r0,0
    mov     r5,0xCE
@@FinishInit:
    ldrb    r1,[r4,0xF]
    cmp     r1,0xE
    bne     @@NoSoundChange
    mov     r5,0xDA
@@NoSoundChange:
    bl      InitMissile
    mov     r0,r5
    bl      PlaySound
    add     r0,r5,1
    bl      PlaySound
    b       @@Return
@@MovementStage1:
    mov     r0,2
    strb    r0,[r4,0x12]        ; MovementStage = 2
    mov     r0,0x30
    bl      MoveProjectile
    b       @@Return
@@MovementStage3:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; ProjTimer++
    cmp     r0,0x78
    bls     @@Return            ; if ProjTimer >= 78
    mov     r0,0
    strb    r0,[r4]                 ; Status = 0
    b       @@Return
@@MovementStage7:
    bl      MoveTinkedMissile
    b       @@Return
@@MovementStage2:
    ; count missiles equipped
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xB]         ; r0 = MissileFlags
    mov     r5,r0
    lsr     r0,r0,1
    mov     r2,1
    and     r2,r0               ; +1 if super
    lsr     r0,r0,1
    mov     r1,1
    and     r1,r0
    add     r2,r2,r1            ; +1 if ice
    lsr     r0,r0,1
    mov     r1,1
    and     r1,r0
    add     r2,r2,r1            ; +1 if diffusion
    ; get missile speed
    ldr     r0,=NormalMissileSpeeds
    lsl     r1,r2,3
    sub     r1,r1,r2
    lsl     r1,r1,1
    add     r0,r0,r1
    ldrb    r1,[r4,0x1E]
    lsr     r1,r1,2             ; r1 = ProjTimer
    lsl     r1,r1,1
    add     r1,r1,r0            ; r1 = SpeedTable + (ProjTimer / 4) * 2
    ldrb    r0,[r1]             ; r0 = speed
    bl      MoveProjectile
    ldrb    r0,[r4,0x1E]
    cmp     r0,0x1A
    bhi     @@CheckIceTrail     ; if ProjTimer <= 1A
    add     r0,1
    strb    r0,[r4,0x1E]            ; ProjTimer++
@@CheckIceTrail:
    mov     r0,4
    and     r0,r5
    cmp     r0,0
    beq     @@CheckSuperOrDiffusionTrail
    mov     r0,0x17
    mov     r1,3
    b       @@FinishTrail
@@CheckSuperOrDiffusionTrail:
    mov     r0,0xA
    and     r0,r5
    cmp     r0,0
    beq     @@NormalTrail
    mov     r0,0x16
    mov     r1,7
    b       @@FinishTrail
@@NormalTrail:
    mov     r0,0x15
    mov     r1,7
@@FinishTrail:
    bl      SetMissileTrailGFX
@@Return:
    add     sp,0xC
    pop     r4-r6
    pop     r0
    bx      r0
    .pool
