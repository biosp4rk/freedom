.definelabel BeamLimit,3
.definelabel WideBeamLimit,7

.definelabel NormalType,0
.definelabel IceType,1
.definelabel WideType,2
.definelabel PlasmaType,3
.definelabel WaveType,4
.definelabel ChargedNormalType,5
.definelabel ChargedIceType,6
.definelabel ChargedWideType,7
.definelabel ChargedPlasmaType,8
.definelabel ChargedWaveType,9

.definelabel ChargeFlag,1
.definelabel WideFlag,2
.definelabel PlasmaFlag,4
.definelabel WaveFlag,8
.definelabel IceFlag,0x10

; beam type:    plasma > wide > wave > ice > normal
; graphics:     plasma > wide > wave > ice > normal
; palette:      ice > wave > plasma > wide > normal
; fire sound:   ice > plasma > wide > wave > normal
; charge sound: ice > plasma > wide > wave > normal
; beam hit:     plasma > wide > normal

; damage:
; base  2
; ice  +1
; wave +1
; charged x5
; charged plasma x3

;---------------------------
; UpdateArmCannonAndWeapons
;---------------------------

; modified portion of UpdateArmCannonAndWeapons
; where a new beam is initialized
.org 0x8082064
.area 0x1B4
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    mov     r0,WideFlag
    and     r0,r1
    cmp     r0,0
    bne     @@HaveWide          ; get beam limit based on having wide
    mov     r4,BeamLimit
    b       @@CheckPlasma
@@HaveWide:
    mov     r4,WideBeamLimit
@@CheckPlasma:
    mov     r0,PlasmaFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWide
    mov     r0,PlasmaType
    b       @@CheckNumBeams
@@CheckWide:
    cmp     r4,WideBeamLimit
    bne     @@CheckWave
    mov     r0,WideType
    b       @@CheckNumBeams
@@CheckWave:
    mov     r0,WaveFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckIce
    mov     r0,WaveType
    b       @@CheckNumBeams
@@CheckIce:
    mov     r0,IceFlag
    and     r1,r0
    cmp     r1,0
    beq     @@IsNormal
    mov     r0,IceType
    b       @@CheckNumBeams
@@IsNormal:
    mov     r0,NormalType
@@CheckNumBeams:
    mov     r5,r0               ; r5 = beam type
    mov     r1,r4               ; r1 = beam limit
    bl      CheckNumProjectiles
    cmp     r0,0
    bne     @@UnderLimit
    b       0x8082544           ; ResetProjType
@@UnderLimit:
    ldr     r6,=ArmCannonYPos
    ldrh    r1,[r6]
    ldr     r7,=ArmCannonXPos
    ldrh    r2,[r7]
    mov     r0,r5
    mov     r3,0
    bl      InitProjectile
    ; check for wide beam
    cmp     r4,BeamLimit
    beq     @@SetCooldown
    ldrh    r1,[r6]
    ldrh    r2,[r7]
    mov     r0,r5
    mov     r3,1
    bl      InitProjectile
    ldrh    r1,[r6]
    ldrh    r2,[r7]
    mov     r0,r5
    mov     r3,2
    bl      InitProjectile
@@SetCooldown:
    ldr     r1,=SamusData
    mov     r0,7
    strb    r0,[r1,0xA]
    ; muzzle flash
    ldrh    r0,[r6]
    ldrh    r1,[r7]
    mov     r2,0x2B
    bl      SetParticleEffect
    b       0x8082544                   ; ResetProjType
    .pool
.endarea

; modified portion of UpdateArmCannonAndWeapons
; where a new charged beam is initialized
.org 0x80823A0
.area 0x1A4
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    mov     r0,WideFlag
    and     r0,r1
    cmp     r0,0
    bne     @@HaveWide          ; get beam limit based on having wide
    mov     r4,BeamLimit
    b       @@CheckPlasma
@@HaveWide:
    mov     r4,WideBeamLimit
@@CheckPlasma:
    mov     r0,PlasmaFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWide
    mov     r0,ChargedPlasmaType
    b       @@CheckNumBeams
@@CheckWide:
    cmp     r4,WideBeamLimit
    bne     @@CheckWave
    mov     r0,ChargedWideType
    b       @@CheckNumBeams
@@CheckWave:
    mov     r0,WaveFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckIce
    mov     r0,ChargedWaveType
    b       @@CheckNumBeams
@@CheckIce:
    mov     r0,IceFlag
    and     r1,r0
    cmp     r1,0
    beq     @@IsNormal
    mov     r0,ChargedIceType
    b       @@CheckNumBeams
@@IsNormal:
    mov     r0,ChargedNormalType
@@CheckNumBeams:
    mov     r5,r0               ; r5 = beam type
    mov     r1,r4               ; r1 = beam limit
    bl      CheckNumProjectiles
    cmp     r0,0
    bne     @@UnderLimit
    b       0x8082544           ; reset proj type
@@UnderLimit:
    ldr     r6,=ArmCannonYPos
    ldrh    r1,[r6]
    ldr     r7,=ArmCannonXPos
    ldrh    r2,[r7]
    mov     r0,r5
    mov     r3,0
    bl      InitProjectile
    ; check for wide beam
    cmp     r4,BeamLimit
    beq     @@SetCooldown
    ldrh    r1,[r6]
    ldrh    r2,[r7]
    mov     r0,r5
    mov     r3,1
    bl      InitProjectile
    ldrh    r1,[r6]
    ldrh    r2,[r7]
    mov     r0,r5
    mov     r3,2
    bl      InitProjectile
@@SetCooldown:
    ldr     r1,=SamusData
    mov     r0,3
    strb    r0,[r1,0xA]
    ; spawn flare
    ldrh    r1,[r6]
    ldrh    r2,[r7]
    mov     r0,0xF
    mov     r3,0
    bl      InitProjectile
    b       0x8082544           ; reset proj type
    .pool
.endarea


;-------------
; LoadBeamGFX
;-------------
.org 0x8082ABC
.area 0x1B4
    push    r14
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    ; check plasma
    mov     r0,PlasmaFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWideGFX
    ldr     r0,=PlasmaBeamGFX0
    ldr     r1,=PlasmaBeamGFX1
    b       @@LoadGraphics
@@CheckWideGFX:
    mov     r0,WideFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWaveGFX
    ldr     r0,=WideBeamGFX0
    ldr     r1,=WideBeamGFX1
    b       @@LoadGraphics
@@CheckWaveGFX:
    mov     r0,WaveFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckIceGFX
    ldr     r0,=NormalBeamGFX0  ; potentially change this later
    ldr     r1,=NormalBeamGFX1
    b       @@LoadGraphics
@@CheckIceGFX:
    mov     r0,IceFlag
    and     r0,r1
    cmp     r0,0
    beq     @@IsNormalGFX
    ldr     r0,=NormalBeamGFX0  ; potentially change this later
    ldr     r1,=NormalBeamGFX1
    b       @@LoadGraphics
@@IsNormalGFX:
    ldr     r0,=NormalBeamGFX0
    ldr     r1,=NormalBeamGFX1
@@LoadGraphics:
    ldr     r2,=DMA3SourceAddress
    str     r0,[r2]
    ldr     r0,=0x6011000
    str     r0,[r2,4]           ; pointer 1
    ldr     r3,=0x80000140
    str     r3,[r2,8]
    ldr     r0,[r2,8]
    str     r1,[r2]             ; pointer 2
    ldr     r0,=0x6011400
    str     r0,[r2,4]
    str     r3,[r2,8]
    ldr     r0,[r2,8]
    ; set palette
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    ; check ice
    mov     r0,IceFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWavePal
    ldr     r0,=IceBeamPalette
    b       @@LoadPalette
@@CheckWavePal:
    mov     r0,WaveFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckPlasmaPal
    ldr     r0,=WaveBeamPalette
    b       @@LoadPalette
@@CheckPlasmaPal:
    mov     r0,PlasmaFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWidePal
    ldr     r0,=PlasmaBeamPalette
    b       @@LoadPalette
@@CheckWidePal:
    mov     r0,WideFlag
    and     r0,r1
    cmp     r0,0
    beq     @@IsNormalPal
    ldr     r0,=WideBeamPalette
    b       @@LoadPalette
@@IsNormalPal:
    ldr     r0,=NormalBeamPalette
@@LoadPalette:
    str     r0,[r2]
    ldr     r0,=0x5000240
    str     r0,[r2,4]
    ldr     r0,=0x80000005
    str     r0,[r2,8]
    ldr     r0,[r2,8]
    pop     r0
    bx      r0
    .pool
.endarea

;---------------
; BeamHitSprite
;---------------

; overwrite normal calls to beam hit sprite
.org 0x8083946
    bl      BeamHitSprite           ; normal
.org 0x808396C
    bl      BeamHitSprite           ; ice
.org 0x8083996
    bl      BeamHitSprite           ; wide
.org 0x80839BE
    bl      BeamHitSprite           ; plasma
.org 0x80839E4
    bl      BeamHitSprite           ; wave
.org 0x8083A0C
    bl      ChargedBeamHitSprite    ; charged normal
.org 0x8083A34
    bl      ChargedBeamHitSprite    ; charged ice
.org 0x8083A6A
    bl      ChargedBeamHitSprite    ; charged wide
.org 0x8083A90
    bl      ChargedBeamHitSprite    ; charged plasma
.org 0x8083AB8
    bl      ChargedBeamHitSprite    ; charged wave

; shared implementation for beam hitting sprite
.org 0x8084808
BeamHitSprite:
.area 0x988
    push    r4-r7,r14
    mov     r5,r8
    mov     r6,r9
    mov     r7,r10
    push    r5-r7
    mov     r4,r0               ; r4 = SpriteSlotNum
    mov     r5,r1               ; r5 = ProjSlotNum
    mov     r10,r1              ; r10 = ProjSlotNum
    mov     r8,r2               ; r8 = ProjYPos
    mov     r9,r3               ; r9 = ProjXPos
    ; get beam flags
    ldr     r0,=Equipment
    ldrb    r7,[r0,0xA]         ; r7 = BeamFlags
    ; get sprite ram offset
    ldr     r1,=SpriteDataSlot0
    lsl     r0,r4,3
    sub     r0,r0,r4
    lsl     r0,r0,3
    add     r6,r0,r1            ; r6 = SpriteDataOffset
    ; check if sprite is solid for projectiles
    mov     r0,r6
    add     r0,0x34
    ldrb    r1,[r0]             ; r1 = Properties
    mov     r0,8
    and     r0,r1
    cmp     r0,0
    beq     @@CheckIfImmune     ; if sprite is solid for projectiles
    ; update sprite flash timer
    mov     r0,r4
    bl      UpdateSpriteFlashTimer
    ; check for ice
    mov     r0,IceFlag
    and     r0,r7
    cmp     r0,0
    beq     @@CheckNotWave
    ; check if not frozen
    mov     r0,r6                   ; if ice
    add     r0,0x32
    ldrb    r0,[r0]                     ; r0 = FreezeTimer
    cmp     r0,0
    bne     @@CheckNotWave          ; and not frozen
    ; check can be frozen
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,0x40
    and     r1,r0
    cmp     r1,0
    beq     @@CheckNotWave          ; and can be frozen
    ; freeze sprite
    mov     r0,r6
    add     r0,0x33
    mov     r1,0
    strb    r1,[r0]                     ; StandingOnSpriteFlag = 0
    sub     r0,1
    mov     r1,0xF0
    strb    r1,[r0]                     ; FreezeTimer = F0
    add     r0,3
    ldrb    r1,[r0]                     ; r1 = FrozenPaletteRow
    ldrb    r2,[r6,0x1F]                ; r2 = SpritesetGfxSlot
    add     r1,r1,r2
    mov     r2,0xF
    sub     r1,r2,r1                    ; r1 = F - (SpritesetGfxSlot + FrozenPaletteRow)
    sub     r0,0x15
    strb    r1,[r0]                     ; PaletteRow = r1
@@CheckNotWave:
    mov     r0,WaveFlag
    and     r0,r7
    cmp     r0,0
    beq     @@BeamHitParticle       ; if not wave
    b       @@Return                    ; set particle effect and remove proj
@@CheckIfImmune:
    mov     r0,0x40
    and     r0,r1
    cmp     r0,0
    beq     @@NotImmune         ; else if immune to projectiles
    ; tink
    mov     r0,r8
    mov     r1,r9
    mov     r2,7
    bl      SetParticleEffect
    b       @@RemoveProj            ; remove projectile
@@NotImmune:
    ; check for ice
    mov     r0,IceFlag          ; else (sprite not immune)
    and     r0,r7
    cmp     r0,0
    beq     @@NotIce                ; if ice
    ; check weak to beam or can be frozen
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,0x42
    and     r1,r0
    cmp     r1,0
    beq     @@NotWeak                   ; if weak to beam or can be frozen
    ; lower health
    bl      CalcBeamDamage
    mov     r2,r0                           ; r2 = damage
    mov     r0,r4                           ; r0 = SpriteSlotNum
    mov     r1,r5                           ; r1 = ProjSlotNum
    bl      LowerSpriteHealth_IceBeam
    mov     r5,r0                           ; r5 = FlashTimer
    mov     r6,2                            ; r6 = DebrisType
    b       @@CheckCreatesDebris
@@NotIce:
    ; check weak to beam
    mov     r0,r4                   ; else (not ice)
    bl      GetSpriteWeakness
    mov     r1,2
    and     r1,r0
    cmp     r1,0
    beq     @@NotWeak                   ; if weak to beam
    ; lower health
    bl      CalcBeamDamage
    mov     r1,r0                           ; r1 = damage
    mov     r0,r4                           ; r0 = SpriteSlotNum
    bl      LowerSpriteHealth
    mov     r5,r0                           ; r5 = FlashTimer
    mov     r6,1                            ; r6 = DebrisType
    b       @@CheckCreatesDebris
@@NotWeak:
    ; update sprite flash timer
    mov     r0,r4                   ; if not weak to beam
    bl      UpdateSpriteFlashTimer
    ; tink
    mov     r0,r7
    mov     r1,r8
    mov     r2,7
    bl      SetParticleEffect
    b       @@CheckRemove
@@CheckCreatesDebris:
    mov     r0,r4                   ; else (weak to beam)
    bl      GetSpriteDamageReduction
    cmp     r0,0
    beq     @@CheckSetHitParticle       ; if sprite creates debris
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    bne     @@IsPlasma                      ; if not plasma
    ; create normal sprite debris
    mov     r0,r6                               ; r0 = DebrisType
    mov     r1,r5                               ; r1 = FlashTimer
    mov     r2,r8                               ; r2 = ProjYPos
    mov     r3,r9                               ; r3 = ProjXPos
    bl      CreateSpriteDebris
    b       @@WideParticle                  ; if is plasma
@@IsPlasma:
    ; create plasma sprite debris
    mov     r0,r6                               ; r0 = DebrisType
    mov     r1,r5                               ; r1 = FlashTimer
    mov     r2,r8                               ; r2 = ProjYPos
    mov     r3,r9                               ; r3 = ProjXPos
    bl      CreateSpriteDebris_PiercingBeam
    b       @@Return
@@CheckSetHitParticle:
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    beq     @@WideParticle
    b       @@Return
@@SpriteNotWeak:
    ; update sprite flash timer
    mov     r0,r4
    bl      UpdateSpriteFlashTimer
    ; tink
    mov     r0,r8
    mov     r1,r9
    mov     r2,7
    bl      SetParticleEffect
@@CheckRemove:
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    beq     @@RemoveProj        ; remove beam if not plasma
    b       @@Return
@@BeamHitParticle:
    ; check for plasma
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    beq     @@WideParticle
    mov     r2,6                ; plasma beam hit
@@WideParticle:
    ; check for wide
    mov     r0,WideFlag
    and     r0,r7
    cmp     r0,0
    beq     @@NormalParticle
    mov     r2,5                ; wide beam hit
    b       @@SetParticle
@@NormalParticle:
    mov     r2,3                ; normal beam hit
@@SetParticle:
    ; set beam hit particle effect
    mov     r0,r8
    mov     r1,r9
    bl      SetParticleEffect
@@RemoveProj:
    ldr     r1,=ProjectileDataSlot0
    mov     r0,r10
    lsl     r0,r0,5
    add     r0,r0,r1
    mov     r1,0
    strb    r1,[r0]             ; remove projectile
@@Return:
    pop     r3-r5
    mov     r8,r3
    mov     r9,r4
    mov     r10,r5
    pop     r4-r7
    pop     r0
    bx      r0
    .pool

ChargedBeamHitSprite:
    push    r4-r7,r14
    mov     r5,r8
    mov     r6,r9
    mov     r7,r10
    push    r5-r7
    mov     r4,r0               ; r4 = SpriteSlotNum
    mov     r5,r1               ; r5 = ProjSlotNum
    mov     r10,r1              ; r10 = ProjSlotNum
    mov     r8,r2               ; r8 = ProjYPos
    mov     r9,r3               ; r9 = ProjXPos
    ; get beam flags
    ldr     r0,=Equipment
    ldrb    r7,[r0,0xA]         ; r7 = BeamFlags
    ; get sprite ram offset
    ldr     r1,=SpriteDataSlot0
    lsl     r0,r4,3
    sub     r0,r0,r4
    lsl     r0,r0,3
    add     r6,r0,r1            ; r6 = SpriteDataOffset
    ; check if sprite is solid for projectiles
    mov     r0,r6
    add     r0,0x34
    ldrb    r1,[r0]             ; r1 = Properties
    mov     r0,8
    and     r0,r1
    cmp     r0,0
    beq     @@CheckIfImmune     ; if sprite is solid for projectiles
    ; update sprite flash timer
    mov     r0,r4
    bl      UpdateSpriteFlashTimer
    ; check for ice
    mov     r0,IceFlag
    and     r0,r7
    cmp     r0,0
    beq     @@CheckNotWave
    ; check if not frozen
    mov     r0,r6                   ; if ice
    add     r0,0x32
    ldrb    r0,[r0]                     ; r0 = FreezeTimer
    cmp     r0,0
    bne     @@CheckNotWave          ; and not frozen
    ; check can be frozen
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,0x40
    and     r1,r0
    cmp     r1,0
    beq     @@CheckNotWave          ; and can be frozen
    ; freeze sprite
    mov     r0,r6
    add     r0,0x33
    mov     r1,0
    strb    r1,[r0]                     ; StandingOnSpriteFlag = 0
    sub     r0,1
    mov     r1,0xF0
    strb    r1,[r0]                     ; FreezeTimer = F0
    add     r0,3
    ldrb    r1,[r0]                     ; r1 = FrozenPaletteRow
    ldrb    r2,[r6,0x1F]                ; r2 = SpritesetGfxSlot
    add     r1,r1,r2
    mov     r2,0xF
    sub     r1,r2,r1                    ; r1 = F - (SpritesetGfxSlot + FrozenPaletteRow)
    sub     r0,0x15
    strb    r1,[r0]                     ; PaletteRow = r1
@@CheckNotWave:
    mov     r0,WaveFlag
    and     r0,r7
    cmp     r0,0
    beq     @@BeamHitParticle       ; if not wave
    b       @@Return                    ; set particle effect and remove proj
@@CheckIfImmune:
    mov     r0,0x40
    and     r0,r1
    cmp     r0,0
    beq     @@NotImmune         ; else if immune to projectiles
    ; tink
    mov     r0,r8
    mov     r1,r9
    mov     r2,7
    bl      SetParticleEffect
    b       @@RemoveProj            ; remove projectile
@@NotImmune:
    ; check for ice
    mov     r0,IceFlag          ; else (sprite not immune)
    and     r0,r7
    cmp     r0,0
    beq     @@NotIce                ; if ice
    ; check weak to beam or can be frozen
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,0x43
    and     r1,r0
    cmp     r1,0
    beq     @@NotWeak                   ; if weak to beam or can be frozen
    ; lower health
    bl      CalcChargedBeamDamage
    mov     r2,r0                           ; r2 = damage
    mov     r0,r4                           ; r0 = SpriteSlotNum
    mov     r1,r5                           ; r1 = ProjSlotNum
    bl      LowerSpriteHealth_IceBeam
    mov     r5,r0                           ; r5 = FlashTimer
    mov     r6,2                            ; r6 = DebrisType
    b       @@CheckCreatesDebris
@@NotIce:
    ; check weak to beam
    mov     r0,r4                   ; else (not ice)
    bl      GetSpriteWeakness
    mov     r1,3
    and     r1,r0
    cmp     r1,0
    beq     @@NotWeak                   ; if weak to beam
    ; lower health
    bl      CalcChargedBeamDamage
    mov     r1,r0                           ; r1 = damage
    mov     r0,r4                           ; r0 = SpriteSlotNum
    bl      LowerSpriteHealth
    mov     r5,r0                           ; r5 = FlashTimer
    mov     r6,1                            ; r6 = DebrisType
    b       @@CheckCreatesDebris
@@NotWeak:
    ; update sprite flash timer
    mov     r0,r4                   ; if not weak to beam
    bl      UpdateSpriteFlashTimer
    ; tink
    mov     r0,r7
    mov     r1,r8
    mov     r2,7
    bl      SetParticleEffect
    b       @@CheckRemove
@@CheckCreatesDebris:
    mov     r0,r4                   ; else (weak to beam)
    bl      GetSpriteDamageReduction
    cmp     r0,0
    beq     @@CheckSetHitParticle       ; if sprite creates debris
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    bne     @@IsPlasma                      ; if not plasma
    ; create normal sprite debris
    mov     r0,r6                               ; r0 = DebrisType
    mov     r1,r5                               ; r1 = FlashTimer
    mov     r2,r8                               ; r2 = ProjYPos
    mov     r3,r9                               ; r3 = ProjXPos
    bl      CreateSpriteDebris
    b       @@WideParticle                  ; if is plasma
@@IsPlasma:
    ; create plasma sprite debris
    mov     r0,r6                               ; r0 = DebrisType
    mov     r1,r5                               ; r1 = FlashTimer
    mov     r2,r8                               ; r2 = ProjYPos
    mov     r3,r9                               ; r3 = ProjXPos
    bl      CreateSpriteDebris_PiercingBeam
    b       @@Return
@@CheckSetHitParticle:
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    beq     @@WideParticle
    b       @@Return
@@SpriteNotWeak:
    ; update sprite flash timer
    mov     r0,r4
    bl      UpdateSpriteFlashTimer
    ; tink
    mov     r0,r8
    mov     r1,r9
    mov     r2,7
    bl      SetParticleEffect
@@CheckRemove:
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    beq     @@RemoveProj        ; remove beam if not plasma
    b       @@Return
@@BeamHitParticle:
    ; check for plasma
    mov     r0,PlasmaFlag
    and     r0,r7
    cmp     r0,0
    beq     @@WideParticle
    mov     r2,6                ; plasma beam hit
@@WideParticle:
    ; check for wide
    mov     r0,WideFlag
    and     r0,r7
    cmp     r0,0
    beq     @@NormalParticle
    mov     r2,5                ; wide beam hit
    b       @@SetParticle
@@NormalParticle:
    mov     r2,3                ; normal beam hit
@@SetParticle:
    ; set beam hit particle effect
    mov     r0,r8
    mov     r1,r9
    bl      SetParticleEffect
@@RemoveProj:
    ldr     r1,=ProjectileDataSlot0
    mov     r0,r10
    lsl     r0,r0,5
    add     r0,r0,r1
    mov     r1,0
    strb    r1,[r0]             ; remove projectile
@@Return:
    pop     r3-r5
    mov     r8,r3
    mov     r9,r4
    mov     r10,r5
    pop     r4-r7
    pop     r0
    bx      r0
    .pool

CalcBeamDamage:
    mov     r0,2                ; base damage
    ldr     r1,=Equipment
    ldrb    r2,[r1,0xA]
    mov     r1,WaveFlag
    and     r1,r2
    cmp     r1,0
    beq     @@CheckIce
    add     r0,1                ; +1 for wave
@@CheckIce:
    mov     r1,IceFlag
    and     r1,r2
    cmp     r1,0
    beq     @@Return
    add     r0,1                ; +1 for ice
@@Return:
    bx      r14
    .pool

CalcChargedBeamDamage:
    push    r14
    bl      CalcBeamDamage
    ldr     r1,=Equipment
    ldrb    r2,[r1,0xA]
    mov     r1,PlasmaFlag
    and     r1,r2
    cmp     r1,0
    bne     @@HasPlasma
    lsl     r1,r0,2
    add     r0,r1,r0            ; damage x 5
    b       @@Return
@@HasPlasma:
    lsl     r1,r0,1
    add     r0,r1,r0            ; damage x 3
@@Return:
    pop     r1
    bx      r1
    .pool

.endarea

; modified portion of FlareHitSprite
; where damage is calculated
.org 0x80851F2
    ldr     r0,=Equipment
    ldrb    r2,[r0,0xA]
    mov     r1,6                ; base damage
@@Loop:
    lsr     r2,r2,1
    cmp     r2,0
    beq     0x8085220           ; jumps to LowerSpriteHealth
    mov     r0,1
    and     r0,r2
    cmp     r0,0
    beq     @@Loop
    add     r1,3                ; +3 per beam
    b       @@Loop
    .pool

;--------------
; ProcessBeams
;--------------

.org 0x8086668
InitChargedIceBeam:
.area 0xC40
    push    r14
    mov     r0,0xF1
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    ldr     r1,=0xFFF0
    strh    r1,[r3,0x16]        ; TopBound = -10
    strh    r0,[r3,0x18]        ; BottomBound = 10
    strh    r1,[r3,0x1A]        ; LeftBound = -10
    strh    r0,[r3,0x1C]        ; RightBound = 10
    ldrb    r0,[r3]
    mov     r1,0x10
    orr     r0,r1               ; ProjStatus |= 10 (affects environment)
    mov     r1,0xFB
    and     r0,r1               ; ProjStatus &= FB (removes 4)
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20             ; set Y-flip
    orr     r0,r1
    strb    r0,[r3]
@@DiagUp:
    ldr     r0,=0x858DF9C       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858DFB4       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858DF84       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r0
    bx      r0
    .pool

ProcessChargedIceBeam:
    push    r4,r14
    ldr     r4,=CurrProjectileData
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    bl      0x8082E8C           ; collision related
    cmp     r0,0
    beq     @@CheckStage        ; if collided
    mov     r0,0
    strb    r0,[r4]                 ; remove projectile
    ldrh    r0,[r4,8]
    ldrh    r1,[r4,0xA]
    mov     r2,3                    ; normal beam hit
    bl      SetParticleEffect
    b       @@Return
@@CheckStage:
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    ; movement stage 2
    mov     r0,0x18             ; speed = 18
    bl      MoveProjectile
    mov     r0,0xF              ; charged normal trail
    mov     r1,3
    bl      SetBeamTrailGFX
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitChargedIceBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile      ; MoveProjectile(10)
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4
    pop     r0
    bx      r0
    .pool

InitIceBeam:
    push    r14
    mov     r0,0xCD
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    mov     r0,0x8
    ldr     r1,=0xFFF8
    strh    r1,[r3,0x16]        ; TopBound = -8
    strh    r0,[r3,0x18]        ; BottomBound = 8
    strh    r1,[r3,0x1A]        ; LeftBound = -8
    strh    r0,[r3,0x1C]        ; RightBound = 8
    ldrb    r0,[r3]
    mov     r1,0x10
    orr     r0,r1               ; ProjStatus |= 10 (affects environment)
    mov     r1,0xFB
    and     r0,r1               ; ProjStatus &= FB (removes 4)
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@DiagUp:
    ldr     r0,=0x858DF54       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858DF6C       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858DF3C       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r0
    bx      r0
    .pool

ProcessIceBeam:
    push    r4,r14
    ldr     r4,=CurrProjectileData
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    bl      0x8082E8C           ; collision related
    cmp     r0,0
    beq     @@CheckStage        ; if collided
    mov     r0,0
    strb    r0,[r4]                 ; remove projectile
    ldrh    r0,[r4,8]
    ldrh    r1,[r4,0xA]
    mov     r2,3                    ; normal beam hit
    bl      SetParticleEffect
    b       @@Return
@@CheckStage:
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    ; movement stage 2
    mov     r0,0x18             ; speed = 18
    bl      MoveProjectile
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitIceBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4
    pop     r0
    bx      r0
    .pool

InitChargedWideBeam:
    push    r4,r14
    ; check ice
    ldr     r0,=Equipment
    ldrb    r4,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r4
    cmp     r0,0
    bne     @@IceSound
    mov     r0,0xEE
    b       @@PlaySound
@@IceSound:
    mov     r0,0xF1
@@PlaySound:
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    mov     r0,0x14
    ldr     r1,=0xFFEC
    strh    r1,[r3,0x16]        ; TopBound = -14
    strh    r0,[r3,0x18]        ; BottomBound = 14
    strh    r1,[r3,0x1A]        ; LeftBound = -14
    strh    r0,[r3,0x1C]        ; RightBound = 14
    ; check wave
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xA]
    mov     r1,WaveFlag
    and     r0,r1
    cmp     r0,0
    bne     @@WaveStatus
    mov     r1,0x10
    b       @@SetStatus
@@WaveStatus:
    mov     r1,0x18
@@SetStatus:
    ldrb    r0,[r3]
    orr     r0,r1               ; set status flag 10 (and 8)
    mov     r1,0xFB
    and     r0,r1               ; remove status flag 4
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@DiagUp:
    ldr     r0,=0x858E3E4       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858E3FC       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858E3CC       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r4
    pop     r0
    bx      r0
    .pool

ProcessChargedWideBeam:
    push    r4,r5,r14
    ldr     r0,=Equipment
    ldrb    r5,[r0,0xA]         ; r5 = BeamFlags
    ldr     r4,=CurrProjectileData
    ldrb    r0,[r4,0x13]        ; r0 = PartNum
    cmp     r0,0
    beq     @@Movement          ; if not part 0
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@MoveWave              ; if not wave
    ldrb    r0,[r4,0x12]                ; r0 = MovementStage
    cmp     r0,8
    bhi     @@Movement                  ; if MovementStage > 8
    bl      MoveWideBeamParts               ; move wide beam parts
    b       @@Movement
@@MoveWave:
    bl      MoveWaveBeamParts       ; else (wave)
@@Movement:
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@WaveCollision
    ; non-wave collision
    bl      0x8082E8C           ; collision related
    cmp     r0,0
    beq     @@CheckStage        ; if collided
    mov     r0,0
    strb    r0,[r4]                 ; remove projectile
    ldrh    r0,[r4,8]
    ldrh    r1,[r4,0xA]
    mov     r2,5                    ; wide beam hit
    bl      SetParticleEffect
    b       @@Return
@@WaveCollision:
    bl      0x8082E4C           ; collision related
@@CheckStage:
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    cmp     r0,8
    bhi     @@MoveStage2
    add     r0,1
    strb    r0,[r4,0x12]
@@MoveStage2:
    ; movement stage 2
    mov     r0,0x18             ; speed = 10
    bl      MoveProjectile
    mov     r0,0x11             ; charged wide trail
    mov     r1,3
    bl      SetBeamTrailGFX
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitChargedWideBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile      ; MoveProjectile(10)
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4,r5
    pop     r0
    bx      r0
    .pool

InitWideBeam:
    push    r4,r14
    ; check ice
    ldr     r0,=Equipment
    ldrb    r4,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r4
    cmp     r0,0
    bne     @@IceSound
    mov     r0,0xC9
    b       @@PlaySound
@@IceSound:
    mov     r0,0xCD
@@PlaySound:
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    ldr     r1,=0xFFF0
    strh    r1,[r3,0x16]        ; TopBound = -10
    strh    r0,[r3,0x18]        ; BottomBound = 10
    strh    r1,[r3,0x1A]        ; LeftBound = -10
    strh    r0,[r3,0x1C]        ; RightBound = 10
    ; check wave
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xA]
    mov     r1,WaveFlag
    and     r0,r1
    cmp     r0,0
    bne     @@WaveStatus
    mov     r1,0x10
    b       @@SetStatus
@@WaveStatus:
    mov     r1,0x18
@@SetStatus:
    ldrb    r0,[r3]
    orr     r0,r1               ; set status flag 10 (and 8)
    mov     r1,0xFB
    and     r0,r1               ; remove status flag 4
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@DiagUp:
    ldr     r0,=0x858E38C       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858E3AC       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858E36C       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r4
    pop     r0
    bx      r0
    .pool

ProcessWideBeam:
    push    r4,r5,r14
    ldr     r0,=Equipment
    ldrb    r5,[r0,0xA]         ; r5 = BeamFlags
    ldr     r4,=CurrProjectileData
    ldrb    r0,[r4,0x13]        ; r0 = PartNum
    cmp     r0,0
    beq     @@Movement          ; if not part 0
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@MoveWave              ; if not wave
    ldrb    r0,[r4,0x12]                ; r0 = MovementStage
    cmp     r0,8
    bhi     @@Movement                  ; if MovementStage > 8
    bl      MoveWideBeamParts               ; move wide beam parts
    b       @@Movement
@@MoveWave:
    bl      MoveWaveBeamParts       ; else (wave)
@@Movement:
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@WaveCollision
    ; non-wave collision
    bl      0x8082E8C           ; collision related
    cmp     r0,0
    beq     @@CheckStage        ; if collided
    mov     r0,0
    strb    r0,[r4]                 ; remove projectile
    ldrh    r0,[r4,8]
    ldrh    r1,[r4,0xA]
    mov     r2,5                    ; wide beam hit
    bl      SetParticleEffect
    b       @@Return
@@WaveCollision:
    bl      0x8082E4C           ; collision related
@@CheckStage:
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    cmp     r0,8
    bhi     @@MoveStage2
    add     r0,1
    strb    r0,[r4,0x12]
@@MoveStage2:
    mov     r0,0x18             ; speed = 18
    bl      MoveProjectile
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitWideBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4,r5
    pop     r0
    bx      r0
    .pool

InitChargedPlasmaBeam:
    push    r4,r14
    ; check ice
    ldr     r0,=Equipment
    ldrb    r4,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r4
    cmp     r0,0
    bne     @@IceSound
    mov     r0,0xEF
    b       @@PlaySound
@@IceSound:
    mov     r0,0xF1
@@PlaySound:
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    mov     r0,0x14
    ldr     r1,=0xFFEC
    strh    r1,[r3,0x16]        ; TopBound = -14
    strh    r0,[r3,0x18]        ; BottomBound = 14
    strh    r1,[r3,0x1A]        ; LeftBound = -14
    strh    r0,[r3,0x1C]        ; RightBound = 14
    ; check wave
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xA]
    mov     r1,WaveFlag
    and     r0,r1
    cmp     r0,0
    bne     @@WaveStatus
    mov     r1,0x10
    b       @@SetStatus
@@WaveStatus:
    mov     r1,0x18
@@SetStatus:
    ldrb    r0,[r3]
    orr     r0,r1               ; set status flag 10 (and 8)
    mov     r1,0xFB
    and     r0,r1               ; remove status flag 4
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@DiagUp:
    ldr     r0,=0x858E5E4       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858E5FC       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858E5CC       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r4
    pop     r0
    bx      r0
    .pool

ProcessChargedPlasmaBeam:
    push    r4,r5,r14
    ldr     r0,=Equipment
    ldrb    r5,[r0,0xA]         ; r5 = BeamFlags
    ldr     r4,=CurrProjectileData
    ldrb    r0,[r4,0x13]        ; r0 = PartNum
    cmp     r0,0
    beq     @@Movement          ; if not part 0
    mov     r0,WideFlag
    and     r0,r5
    cmp     r0,0
    beq     @@Movement              ; if wide
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@MoveWave                  ; if not wave
    ldrb    r0,[r4,0x12]                    ; r0 = MovementStage
    cmp     r0,8
    bhi     @@Movement                      ; if MovementStage > 8
    bl      MoveWideBeamParts                   ; move wide beam parts
    b       @@Movement
@@MoveWave:
    bl      MoveWaveBeamParts           ; else (wave)
@@Movement:
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@WaveCollision
    ; non-wave collision
    bl      0x8082E8C           ; collision related
    cmp     r0,0
    beq     @@CheckStage        ; if collided
    mov     r0,0
    strb    r0,[r4]                 ; remove projectile
    ldrh    r0,[r4,8]
    ldrh    r1,[r4,0xA]
    mov     r2,6                    ; plasma hit
    bl      SetParticleEffect
    b       @@Return
@@WaveCollision:
    bl      0x8082E4C           ; collision related
@@CheckStage:
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    cmp     r0,8
    bhi     @@MoveStage2
    add     r0,1
    strb    r0,[r4,0x12]
@@MoveStage2:
    ; movement stage 2
    mov     r0,0x1C             ; speed = 1C
    bl      MoveProjectile
    mov     r0,0x12             ; charged plasma trail
    mov     r1,3
    bl      SetBeamTrailGFX
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitChargedPlasmaBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4,r5
    pop     r0
    bx      r0
    .pool

InitPlasmaBeam:
    push    r4,r14
    ; check ice
    ldr     r0,=Equipment
    ldrb    r4,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r4
    cmp     r0,0
    bne     @@IceSound
    mov     r0,0xCB
    b       @@PlaySound
@@IceSound:
    mov     r0,0xCD
@@PlaySound:
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    mov     r0,0xC
    ldr     r1,=0xFFF4
    strh    r1,[r3,0x16]        ; TopBound = -C
    strh    r0,[r3,0x18]        ; BottomBound = C
    strh    r1,[r3,0x1A]        ; LeftBound = -C
    strh    r0,[r3,0x1C]        ; RightBound = C
    ; check wave
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xA]
    mov     r1,WaveFlag
    and     r0,r1
    cmp     r0,0
    bne     @@WaveStatus
    mov     r1,0x10
    b       @@SetStatus
@@WaveStatus:
    mov     r1,0x18
@@SetStatus:
    ldrb    r0,[r3]
    orr     r0,r1               ; set status flag 10 (and 8)
    mov     r1,0xFB
    and     r0,r1               ; remove status flag 4
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@DiagUp:
    ldr     r0,=0x858E59C       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858E5B4       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858E584       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r4
    pop     r0
    bx      r0
    .pool

ProcessPlasmaBeam:
    push    r4,r5,r14
    ldr     r0,=Equipment
    ldrb    r5,[r0,0xA]         ; r5 = BeamFlags
    ldr     r4,=CurrProjectileData
    ldrb    r0,[r4,0x13]        ; r0 = PartNum
    cmp     r0,0
    beq     @@Movement          ; if not part 0
    mov     r0,WideFlag
    and     r0,r5
    cmp     r0,0
    beq     @@Movement              ; if wide
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@MoveWave                  ; if not wave
    ldrb    r0,[r4,0x12]                    ; r0 = MovementStage
    cmp     r0,8
    bhi     @@Movement                      ; if MovementStage > 8
    bl      MoveWideBeamParts                   ; move wide beam parts
    b       @@Movement
@@MoveWave:
    bl      MoveWaveBeamParts           ; else (wave)
@@Movement:
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    mov     r0,WaveFlag
    and     r0,r5
    cmp     r0,0
    bne     @@WaveCollision
    ; non-wave collision
    bl      0x8082E8C           ; collision related
    cmp     r0,0
    beq     @@CheckStage        ; if collided
    mov     r0,0
    strb    r0,[r4]                 ; remove projectile
    ldrh    r0,[r4,8]
    ldrh    r1,[r4,0xA]
    mov     r2,6                    ; plasma hit
    bl      SetParticleEffect
    b       @@Return
@@WaveCollision:
    bl      0x8082E4C           ; collision related
@@CheckStage:
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    cmp     r0,8
    bhi     @@MoveStage2
    add     r0,1
    strb    r0,[r4,0x12]
@@MoveStage2:
    ; movement stage 2
    mov     r0,0x1C             ; speed = 1C
    bl      MoveProjectile
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitPlasmaBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4,r5
    pop     r0
    bx      r0
    .pool

InitChargedWaveBeam:
    push    r4,r14
    ; check ice
    ldr     r0,=Equipment
    ldrb    r4,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r4
    cmp     r0,0
    bne     @@IceSound
    mov     r0,0xC8
    b       @@PlaySound
@@IceSound:
    mov     r0,0xF1
@@PlaySound:
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    ldr     r1,=0xFFF0
    strh    r1,[r3,0x16]        ; TopBound = -10
    strh    r0,[r3,0x18]        ; BottomBound = 10
    strh    r1,[r3,0x1A]        ; LeftBound = -10
    strh    r0,[r3,0x1C]        ; RightBound = 10
    ; set status
    ldrb    r0,[r3]
    mov     r1,0x18
    orr     r0,r1               ; set status flag 10 (and 8)
    mov     r1,0xFB
    and     r0,r1               ; remove status flag 4
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@DiagUp:
    ldr     r0,=0x858DF9C       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858DFB4       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858DF84       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r4
    pop     r0
    bx      r0
    .pool

ProcessChargedWaveBeam:
    push    r4,r5,r14
    ldr     r0,=Equipment
    ldrb    r5,[r0,0xA]         ; r5 = BeamFlags
    ldr     r4,=CurrProjectileData
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    bl      0x8082E4C           ; collision related
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    ; movement stage 2
    mov     r0,0x18             ; speed = 18
    bl      MoveProjectile
    mov     r0,0xF              ; charged normal trail
    mov     r1,3
    bl      SetBeamTrailGFX
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitChargedWaveBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4,r5
    pop     r0
    bx      r0
    .pool

InitWaveBeam:
    push    r4,r14
    ; check ice
    ldr     r0,=Equipment
    ldrb    r4,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r4
    cmp     r0,0
    bne     @@IceSound
    mov     r0,0xC8
    b       @@PlaySound
@@IceSound:
    mov     r0,0xCD
@@PlaySound:
    bl      PlaySound
    ldr     r3,=CurrProjectileData
    mov     r0,0
    strb    r0,[r3,0xE]         ; AnimationCounter = 0
    strh    r0,[r3,0xC]         ; AnimationFrame = 0
    mov     r0,0x10
    strb    r0,[r3,0x14]        ; OffScreenYRange = 10
    strb    r0,[r3,0x15]        ; OffScreenXRange = 10
    mov     r0,8
    ldr     r1,=0xFFF8
    strh    r1,[r3,0x16]        ; TopBound = -8
    strh    r0,[r3,0x18]        ; BottomBound = 8
    strh    r1,[r3,0x1A]        ; LeftBound = -8
    strh    r0,[r3,0x1C]        ; RightBound = 8
    ldrb    r0,[r3]
    mov     r1,0x18
    orr     r0,r1               ; set status flag 10 (and 8)
    mov     r1,0xFB
    and     r0,r1               ; remove status flag 4
    strb    r0,[r3]
    ldrb    r0,[r3,0x10]
    sub     r0,1                ; r0 = ProjDirection - 1
    cmp     r0,4
    bhi     @@Forward
    lsl     r0,r0,2
    ldr     r1,=@@JumpTable
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@JumpTable:
    .dw @@Forward,@@DiagUp,@@DiagDown,@@Up,@@Down
@@DiagDown:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@DiagUp:
    ldr     r0,=0x858DF54       ; potentially change this
    b       @@Return
@@Down:
    ldrb    r1,[r3]
    mov     r0,0x20
    orr     r0,r1
    strb    r0,[r3]             ; set Y-flip
@@Up:
    ldr     r0,=0x858DF6C       ; potentially change this
    b       @@Return
@@Forward:
    ldr     r0,=0x858DF3C       ; potentially change this
@@Return:
    str     r0,[r3,4]           ; set OAM
    pop     r4
    pop     r0
    bx      r0
    .pool

ProcessWaveBeam:
    push    r4,r5,r14
    ldr     r0,=Equipment
    ldrb    r5,[r0,0xA]         ; r5 = BeamFlags
    ldr     r4,=CurrProjectileData
    ldr     r1,=CurrClipdataAffectingAction
    mov     r0,6
    strb    r0,[r1]             ; ClipAction = 6
    bl      0x8082E4C           ; collision related
    ldrb    r0,[r4,0x12]        ; r0 = MovementStage
    cmp     r0,0
    beq     @@MoveStage0
    cmp     r0,1
    beq     @@MoveStage1
    ; movement stage 2
    mov     r0,0x18             ; speed = 18
    bl      MoveProjectile
    b       @@IncrementCounter
@@MoveStage0:
    bl      InitWaveBeam
    b       @@IncrementStage
@@MoveStage1:
    mov     r0,0x10             ; speed = 10
    bl      MoveProjectile
@@IncrementStage:
    ldrb    r0,[r4,0x12]
    add     r0,1
    strb    r0,[r4,0x12]        ; Stage++
@@IncrementCounter:
    ldrb    r0,[r4,0x1E]
    add     r0,1
    strb    r0,[r4,0x1E]        ; Counter++
@@Return:
    pop     r4,r5
    pop     r0
    bx      r0
    .pool

.endarea

; process beam pointers
.org 0x87EE918
    .dw 0x8085B95
    .dw ProcessIceBeam + 1
    .dw ProcessWideBeam + 1
    .dw ProcessPlasmaBeam + 1
    .dw ProcessWaveBeam + 1
    .dw 0x8085A75
    .dw ProcessChargedIceBeam + 1
    .dw ProcessChargedWideBeam + 1
    .dw ProcessChargedPlasmaBeam + 1
    .dw ProcessChargedWaveBeam + 1


; wave beam palette
.org 0x858BC78
    .dh 0x7F3A,0x7A73,0x514A

; skip check to set omega suit
.org 0x8004FA4
    b       0x8004FBE

; play beam charging sound
.org 0x8074940
    push    r14
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckPlasma       ; if ice
    mov     r0,0xE9
    b       @@Return
@@CheckPlasma:
    mov     r0,PlasmaFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWide         ; if plasma
    mov     r0,0xE5
    b       @@Return
@@CheckWide:
    mov     r0,WideFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWave         ; if wide
    mov     r0,0xE3
    b       @@Return
@@CheckWave:
    mov     r0,WaveFlag
    and     r0,r1
    cmp     r0,0
    beq     @@IsNormal          ; if wave
    mov     r0,0xE7
    b       @@Return
@@IsNormal:
    mov     r0,0xE1
@@Return:
    bl      PlaySound
    pop     r0
    bx      r0
    .pool

; stop beam charging sound
.org 0x8074998
    push    r14
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckPlasma       ; if ice
    mov     r0,0xE9
    b       @@Return
@@CheckPlasma:
    mov     r0,PlasmaFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWide         ; if plasma
    mov     r0,0xE5
    b       @@Return
@@CheckWide:
    mov     r0,WideFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWave         ; if wide
    mov     r0,0xE3
    b       @@Return
@@CheckWave:
    mov     r0,WaveFlag
    and     r0,r1
    cmp     r0,0
    beq     @@IsNormal          ; if wave
    mov     r0,0xE7
    b       @@Return
@@IsNormal:
    mov     r0,0xE1
@@Return:
    bl      0x8002780           ; stop sound
    pop     r0
    bx      r0
    .pool

; beam charged sound
.org 0x80749F0
    push    r14
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    mov     r0,IceFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckPlasma       ; if ice
    mov     r0,0xEA
    b       @@Return
@@CheckPlasma:
    mov     r0,PlasmaFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWide         ; if plasma
    mov     r0,0xE6
    b       @@Return
@@CheckWide:
    mov     r0,WideFlag
    and     r0,r1
    cmp     r0,0
    beq     @@CheckWave         ; if wide
    mov     r0,0xE4
    b       @@Return
@@CheckWave:
    mov     r0,WaveFlag
    and     r0,r1
    cmp     r0,0
    beq     @@IsNormal          ; if wave
    mov     r0,0xE8
    b       @@Return
@@IsNormal:
    mov     r0,0xE2
@@Return:
    bl      PlaySound
    pop     r0
    bx      r0
    .pool
