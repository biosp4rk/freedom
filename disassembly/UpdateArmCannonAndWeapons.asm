UpdateArmCannonAndWeapons:
    push    r4-r7,r14
    mov     r7,r8
    push    r7
    add     sp,-0xC
    ldr     r0,=SubGameMode1
    mov     r1,0
    ldsh    r0,[r0,r1]
    cmp     r0,2
    beq     @@_8081F64
    b       @@_80825A0
@@_8081F64:
    bl      CallUpdateArmCannonOAM
    ldr     r2,=ArmCannonYPos
    ldr     r1,=SamusData
    ldrh    r0,[r1,0x18]
    ldr     r3,=SamusOAMPointer
    lsr     r0,r0,2
    ldrh    r4,[r3,0x24]
    add     r0,r0,r4
    lsl     r0,r0,2
    strh    r0,[r2]			; update ArmCannonYPos
    ldr     r2,=ArmCannonXPos
    ldrh    r0,[r1,0x16]
    lsr     r0,r0,2
    ldrh    r3,[r3,0x22]
    add     r0,r0,r3
    lsl     r0,r0,2
    strh    r0,[r2]			; update ArmCannonXPos
    ldrb    r0,[r1,0xC]
    cmp     r0,0x10
    bne     @@_8081FCA		; if charging beam
    mov     r3,0
    mov     r5,0
    mov     r4,1
    ldr     r2,=ParticleEffects
@@_8081F96:
    ldrb    r1,[r2]				; count num of 43 particle effects
    mov     r0,r4
    and     r0,r1
    cmp     r0,0
    beq     @@_8081FA6
    ldrb    r0,[r2,2]
    cmp     r0,0x43
    beq     @@_808205C
@@_8081FA6:
    add     r2,0xC
    add     r5,1
    cmp     r5,0xF
    ble     @@_8081F96
@@_8081FAE:
    cmp     r3,0
    bne     @@_8081FCA			; if no 43 particle effects
    ldr     r5,=ArmCannonYPos
    ldrh    r0,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r1,[r4]
    mov     r2,0x43
    bl      SetParticleEffect		; particle 43
    ldrh    r0,[r5]
    ldrh    r1,[r4]
    mov     r2,0x44
    bl      SetParticleEffect		; particle 44
@@_8081FCA:
    ldr     r0,=0x3001324
    ldrb    r0,[r0,0x13]
    cmp     r0,0x10
    bne     @@_8082004		; if charging diffusion
    mov     r3,0
    mov     r5,0
    mov     r4,1
    ldr     r2,=ParticleEffects
@@_8081FDA:
    ldrb    r1,[r2]				; count num of 45 particles
    mov     r0,r4
    and     r0,r1
    cmp     r0,0
    beq     @@_8081FEA
    ldrb    r0,[r2,2]
    cmp     r0,0x45
    beq     @@_8082054
@@_8081FEA:
    add     r2,0xC
    add     r5,1
    cmp     r5,0xF
    ble     @@_8081FDA
@@_8081FF2:
    cmp     r3,0
    bne     @@_8082004			; if no 45 particles
    ldr     r0,=ArmCannonYPos
    ldrh    r0,[r0]
    ldr     r1,=ArmCannonXPos
    ldrh    r1,[r1]
    mov     r2,0x45
    bl      SetParticleEffect		; particle 45
@@_8082004:
    ldr     r0,=SamusData
    ldrb    r0,[r0,9]
    sub     r0,1
    cmp     r0,5
    bls     @@_8082010
    b       @@_808254A
@@_8082010:
    lsl     r0,r0,2			; if new projectile fired
    ldr     r1,=0x808203C
    add     r0,r0,r1
    ldr     r0,[r0]
    mov     r15,r0
    .pool
@@_808203C:
    .word @@_8082064,@@_8082218,@@_808254A,@@_8082340,@@_80823A0,@@_8082368
@@_8082054:
    add     r0,r3,1
    lsl     r0,r0,24
    lsr     r3,r0,24
    b       @@_8081FF2
@@_808205C:
    add     r0,r3,1
    lsl     r0,r0,24
    lsr     r3,r0,24
    b       @@_8081FAE
@@_8082064:
    ldr     r0,=Equipment		; if beam fired
    ldrb    r1,[r0,0xA]
    mov     r0,8
    and     r0,r1
    cmp     r0,0
    beq     @@_80820B8				; if wave
    mov     r0,4
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_8082080
    b       @@_8082544
@@_8082080:
    ldr     r5,=ArmCannonYPos			; if under limit
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,4
    mov     r3,0
    bl      InitializeProjectile			; spawn part 1
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,4
    mov     r3,1
    bl      InitializeProjectile			; spawn part 2
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,4
    mov     r3,2
    bl      InitializeProjectile			; spawn part 3
    b       @@_80821B6
    .pool
@@_80820B8:
    mov     r0,4
    and     r0,r1
    cmp     r0,0
    beq     @@_8082104				; else if plasma
    mov     r0,3
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_80820D0
    b       @@_8082544
@@_80820D0:
    ldr     r5,=ArmCannonYPos			; if under limit
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,3
    mov     r3,0
    bl      InitializeProjectile			; spawn part 1
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,3
    mov     r3,1
    bl      InitializeProjectile			; spawn part 2
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,3
    mov     r3,2
    bl      InitializeProjectile			; spawn part 3
    b       @@_80821B6
    .pool
@@_8082104:
    mov     r0,2
    and     r0,r1
    cmp     r0,0
    beq     @@_8082150				; if wide
    mov     r0,2
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_808211C
    b       @@_8082544
@@_808211C:
    ldr     r5,=ArmCannonYPos			; if under limit
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,2
    mov     r3,0
    bl      InitializeProjectile			; spawn part 1
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,2
    mov     r3,1
    bl      InitializeProjectile			; spawn part 2
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,2
    mov     r3,2
    bl      InitializeProjectile			; spawn part 3
    b       @@_80821B6
    .pool
@@_8082150:
    mov     r0,1
    and     r1,r0
    cmp     r1,0
    beq     @@_80821D8				; if charge
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_8082166
    b       @@_8082544
@@_8082166:
    ldr     r5,=ArmCannonYPos			; if under limit
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,1
    mov     r3,0
    bl      InitializeProjectile			; spawn beam
    lsl     r0,r0,24
    lsr     r6,r0,24
    ldr     r1,=ProjectileDataSlot0
    lsl     r0,r6,5
    add     r0,r0,r1
    ldrb    r7,[r0,0x10]
    mov     r8,r7
    ldrb    r1,[r0]
    mov     r0,0x40
    and     r0,r1
    lsl     r0,r0,24
    lsr     r7,r0,24
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    str     r7,[sp]
    mov     r0,r8
    str     r0,[sp,4]
    str     r6,[sp,8]
    mov     r0,1
    mov     r3,1
    bl      InitializeSecondaryProjectile	; spawn half 1
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    str     r7,[sp]
    mov     r3,r8
    str     r3,[sp,4]
    str     r6,[sp,8]
    mov     r0,1
    mov     r3,2
    bl      InitializeSecondaryProjectile	; spawn half 2
@@_80821B6:
    ldr     r1,=SamusData
    mov     r0,7
    strb    r0,[r1,0xA]						; set cooldown = 7
    ldrh    r0,[r5]
    ldrh    r1,[r4]
    mov     r2,0x2B
    bl      SetParticleEffect				; particle 2B
    b       @@_8082544
    .pool
@@_80821D8:
    mov     r0,0					; else (normal)
    mov     r1,3
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_80821E8
    b       @@_8082544
@@_80821E8:
    ldr     r5,=ArmCannonYPos			; if under limit
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,0
    mov     r3,0
    bl      InitializeProjectile			; spawn beam
    ldr     r1,=SamusData
    mov     r0,7
    strb    r0,[r1,0xA]						; set cooldown = 7
    ldrh    r0,[r5]
    ldrh    r1,[r4]
    mov     r2,0x2B
    bl      SetParticleEffect				; particle 2B
    b       @@_8082544
    .pool
@@_8082218:
    ldr     r0,=Equipment		; else if missile fired
    ldrb    r1,[r0,0xB]
    mov     r0,8
    and     r0,r1
    cmp     r0,0
    beq     @@_8082294				; if diffusion
    mov     r0,0xD
    mov     r1,2
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_8082234
    b       @@_8082544
@@_8082234:
    ldr     r0,=0x3001324				; if under limit
    ldrb    r0,[r0,0x13]
    lsl     r0,r0,24
    asr     r0,r0,24
    cmp     r0,0
    bge     @@_8082264
    ldr     r0,=ArmCannonYPos				; if charged
    ldrh    r1,[r0]
    ldr     r0,=ArmCannonXPos
    ldrh    r2,[r0]
    mov     r0,0xE
    mov     r3,0
    bl      InitializeProjectile				; spawn missile
    b       @@_8082274
    .pool
@@_8082264:
    ldr     r0,=ArmCannonYPos				; else (uncharged)
    ldrh    r1,[r0]
    ldr     r0,=ArmCannonXPos
    ldrh    r2,[r0]
    mov     r0,0xD
    mov     r3,0
    bl      InitializeProjectile				; spawn missile
@@_8082274:
    ldr     r1,=SamusData
    mov     r2,0
    mov     r0,0x10
    strb    r0,[r1,0xA]						; set cooldown = 10
    ldr     r0,=0x3001324
    strb    r2,[r0,0x13]					; reset charge counter
    b       @@_8082544
    .pool
@@_8082294:
    mov     r0,4
    and     r0,r1
    cmp     r0,0
    beq     @@_80822D0				; else if ice
    mov     r0,0xC
    mov     r1,2
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_80822AC
    b       @@_8082544
@@_80822AC:
    ldr     r0,=ArmCannonYPos			; if under limit
    ldrh    r1,[r0]
    ldr     r0,=ArmCannonXPos
    ldrh    r2,[r0]
    mov     r0,0xC
    mov     r3,0
    bl      InitializeProjectile			; spawn missile
    ldr     r1,=SamusData
    mov     r0,0xF							; set cooldown = F
    b       @@_8082330
    .pool
@@_80822D0:
    mov     r0,2
    and     r1,r0
    cmp     r1,0
    beq     @@_808230C				; else if super
    mov     r0,0xB
    mov     r1,2
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_80822E8
    b       @@_8082544
@@_80822E8:
    ldr     r0,=ArmCannonYPos			; if under limit
    ldrh    r1,[r0]
    ldr     r0,=ArmCannonXPos
    ldrh    r2,[r0]
    mov     r0,0xB
    mov     r3,0
    bl      InitializeProjectile			; spawn missile
    ldr     r1,=SamusData
    mov     r0,0xE							; set cooldown = E
    b       @@_8082330
    .pool
@@_808230C:
    mov     r0,0xA					; else (normal)
    mov     r1,2
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_808231C
    b       @@_8082544
@@_808231C:
    ldr     r0,=ArmCannonYPos			; if under limit
    ldrh    r1,[r0]
    ldr     r0,=ArmCannonXPos
    ldrh    r2,[r0]
    mov     r0,0xA
    mov     r3,0
    bl      InitializeProjectile			; spawn missile
    ldr     r1,=SamusData
    mov     r0,9							; set cooldown = 9
@@_8082330:
    strb    r0,[r1,0xA]
    b       @@_8082544
    .pool
@@_8082340:
    mov     r0,0x10				; else if bomb laid
    mov     r1,4
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_8082350
    b       @@_8082544
@@_8082350:
    ldr     r4,=SamusData			; if under limit
    ldrh    r1,[r4,0x18]
    ldrh    r2,[r4,0x16]
    mov     r0,0x10
    mov     r3,0
    bl      InitializeProjectile		; spawn bomb
    mov     r0,7
    strb    r0,[r4,0xA]					; set cooldown = 7
    b       @@_8082544
    .pool
@@_8082368:
    mov     r0,0x11				; else if pb laid
    mov     r1,1
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_8082378
    b       @@_8082544
@@_8082378:
    ldr     r0,=PowerBombAnimState
    ldrb    r0,[r0]
    cmp     r0,0
    beq     @@_8082382
    b       @@_8082544
@@_8082382:
    ldr     r4,=SamusData			; if under limit and none exploding
    ldrh    r1,[r4,0x18]
    ldrh    r2,[r4,0x16]
    mov     r0,0x11
    mov     r3,0
    bl      InitializeProjectile		; spawn pb
    mov     r0,5
    strb    r0,[r4,0xA]					; set cooldown = 5
    b       @@_8082544
    .pool
@@_80823A0:
    ldr     r0,=Equipment		; else if charged beam fired
    ldrb    r1,[r0,0xA]
    mov     r0,8
    and     r0,r1
    cmp     r0,0
    beq     @@_80823F4
    mov     r0,9
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_80823BC
    b       @@_8082544
@@_80823BC:
    ldr     r5,=ArmCannonYPos
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,9
    mov     r3,0
    bl      InitializeProjectile
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,9
    mov     r3,1
    bl      InitializeProjectile
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,9
    mov     r3,2
    bl      InitializeProjectile
    b       @@_80824EE
    .pool
@@_80823F4:
    mov     r0,4
    and     r0,r1
    cmp     r0,0
    beq     @@_8082440
    mov     r0,8
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    bne     @@_808240C
    b       @@_8082544
@@_808240C:
    ldr     r5,=ArmCannonYPos
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,8
    mov     r3,0
    bl      InitializeProjectile
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,8
    mov     r3,1
    bl      InitializeProjectile
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,8
    mov     r3,2
    bl      InitializeProjectile
    b       @@_80824EE
    .pool
@@_8082440:
    mov     r0,2
    and     r0,r1
    cmp     r0,0
    beq     @@_8082488
    mov     r0,7
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    beq     @@_8082544
    ldr     r5,=ArmCannonYPos
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,7
    mov     r3,0
    bl      InitializeProjectile
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,7
    mov     r3,1
    bl      InitializeProjectile
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,7
    mov     r3,2
    bl      InitializeProjectile
    b       @@_80824EE
    .pool
@@_8082488:
    mov     r0,1
    and     r1,r0
    cmp     r1,0
    beq     @@_8082514
    mov     r0,6
    mov     r1,7
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    beq     @@_8082544
    ldr     r5,=ArmCannonYPos
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,6
    mov     r3,0
    bl      InitializeProjectile
    lsl     r0,r0,24
    lsr     r6,r0,24
    ldr     r1,=ProjectileDataSlot0
    lsl     r0,r6,5
    add     r0,r0,r1
    ldrb    r7,[r0,0x10]
    mov     r8,r7
    ldrb    r1,[r0]
    mov     r0,0x40
    and     r0,r1
    lsl     r0,r0,24
    lsr     r7,r0,24
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    str     r7,[sp]
    mov     r0,r8
    str     r0,[sp,4]
    str     r6,[sp,8]
    mov     r0,6
    mov     r3,1
    bl      InitializeSecondaryProjectile
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    str     r7,[sp]
    mov     r3,r8
    str     r3,[sp,4]
    str     r6,[sp,8]
    mov     r0,6
    mov     r3,2
    bl      InitializeSecondaryProjectile
@@_80824EE:
    ldr     r1,=SamusData
    mov     r0,3
    strb    r0,[r1,0xA]
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,0xF
    mov     r3,0
    bl      InitializeProjectile
    b       @@_8082544
    .pool
@@_8082514:
    mov     r0,5
    mov     r1,3
    bl      CheckNumProjectiles
    lsl     r0,r0,24
    cmp     r0,0
    beq     @@_8082544
    ldr     r5,=ArmCannonYPos
    ldrh    r1,[r5]
    ldr     r4,=ArmCannonXPos
    ldrh    r2,[r4]
    mov     r0,5
    mov     r3,0
    bl      InitializeProjectile
    ldr     r1,=SamusData
    mov     r0,3
    strb    r0,[r1,0xA]				; set cooldown = 3
    ldrh    r1,[r5]
    ldrh    r2,[r4]
    mov     r0,0xF
    mov     r3,0
    bl      InitializeProjectile	; spawn flare
@@_8082544:
    ldr     r1,=SamusData
    mov     r0,0
    strb    r0,[r1,9]			; reset projectile type
@@_808254A:
    bl      CheckWeaponHitSprite
    mov     r5,0
    ldr     r6,=CurrProjectileData
    ldr     r4,=ProcessProjectilePointers
    mov     r8,r4
@@_8082556:
    ldr     r1,=ProjectileDataSlot0
    lsl     r0,r5,5
    add     r4,r0,r1
    ldrb    r1,[r4]
    mov     r0,1
    and     r0,r1
    cmp     r0,0
    beq     @@_808259A		; for each projectile
    mov     r1,r6
    mov     r0,r4
    ldmia   [0]!,r2,r3,r7
    stmia   [1]!,r2,r3,r7
    ldmia   [0]!,r2,r3,r7
    stmia   [1]!,r2,r3,r7
    ldmia   [0]!,r2,r7
    stmia   [1]!,r2,r7			; copy to CurrProjectileData
    ldrb    r0,[r6,0xF]
    lsl     r0,r0,2
    add     r0,r8
    ldr     r0,[r0]
    bl      bx_r0				; projectile specific processing
    bl      AdvanceProjectileAnim
    bl      CheckDespawnProjectile
    mov     r1,r4
    mov     r0,r6
    ldmia   [0]!,r3,r4,r7
    stmia   [1]!,r3,r4,r7
    ldmia   [0]!,r2-r4
    stmia   [1]!,r2-r4
    ldmia   [0]!,r2,r7
    stmia   [1]!,r2,r7			; copy back
@@_808259A:
    add     r5,1
    cmp     r5,0xF
    ble     @@_8082556
@@_80825A0:
    add     sp,0xC
    pop     r3
    mov     r8,r3
    pop     r4-r7
    pop     r0
    bx      r0
    .pool
