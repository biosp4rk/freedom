WaveBeamHitSprite:
	; r0 = Sprite slot number
	; r1 = Projectile slot number
	; r2 = Projectile Y position
	; r3 = Projectile X position
    push    r4-r7,r14
    mov     r7,r10
    mov     r6,r9
    mov     r5,r8
    push    r5-r7
    add     sp,-0xC
    lsl     r0,r0,24
    lsr     r4,r0,24	; r4 = SpriteSlotNum
    str     r4,[sp]		; sp[00] = SpriteSlotNum
    lsl     r1,r1,24
    lsr     r1,r1,24
    mov     r9,r1		; r9 = ProjSlotNum
    mov     r0,r9
    str     r0,[sp,4]	; sp[04] = ProjSlotNum
    lsl     r2,r2,16
    lsr     r7,r2,16	; r7 = ProjYpos
    str     r7,[sp,8]	; sp[08] = ProjYpos
    lsl     r3,r3,16
    lsr     r3,r3,16
    mov     r8,r3		; r8 = ProjXpos
    mov     r10,r8		; r10 = ProjXpos
    ldr     r1,=SpriteDataSlot0
    lsl     r0,r4,3
    sub     r0,r0,r4
    lsl     r0,r0,3
    add     r5,r0,r1	; r5 = SpriteDataOffset
    mov     r0,r5
    add     r0,0x34
    ldrb    r1,[r0]		; r1 = CollisionProperties
    mov     r0,8
    and     r0,r1
    lsl     r0,r0,24
    lsr     r6,r0,24
    cmp     r6,0
    beq     @@_8084F34	; if Collision has 8
    mov     r0,r4
    bl      0x80847D4		; update flash timer
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    mov     r0,0x10
    and     r0,r1
    cmp     r0,0			; if samus has ice
    bne     @@_8084EF2
    b       @@_8084FEA
@@_8084EF2:
    mov     r7,r5
    add     r7,0x32
    ldrb    r6,[r7]
    cmp     r6,0
    bne     @@_8084FEA			; if enemy isn't frozen
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,0x40
    and     r1,r0
    cmp     r1,0
    beq     @@_8084FEA				; if can be frozen
    mov     r0,r5
    add     r0,0x33
    strb    r6,[r0]						; StandingOnSprite = 0
    mov     r0,0xF0
    strb    r0,[r7]						; FreezeTimer = F0
    mov     r0,r5
    add     r0,0x35
    ldrb    r0,[r0]						; r0 = FrozenPaletteRowOffset
    ldrb    r1,[r5,0x1F]				; r1 = SpritesetGfxSlot
    add     r0,r0,r1
    mov     r1,0xF
    sub     r1,r1,r0
    mov     r0,r5
    add     r0,0x20
    strb    r1,[r0]						; set frozen palette
    b       @@_8084FEA
    .pool
@@_8084F34:
    mov     r0,0x40
    and     r0,r1
    cmp     r0,0
    beq     @@_8084F58	; else if Collision has 40 (?)
    mov     r0,r7
    mov     r1,r8
    mov     r2,7			; particle 7 (tink)
    bl      SetParticleEffect
    ldr     r1,=ProjectileDataSlot0
    mov     r2,r9
    lsl     r0,r2,5
    add     r0,r0,r1
    strb    r6,[r0]			; remove projectile
    b       @@_8084FEA
    .pool
@@_8084F58:
    ldr     r0,=Equipment
    ldrb    r1,[r0,0xA]
    mov     r0,0x10
    and     r0,r1
    cmp     r0,0		; else
    beq     @@_8084FA6		; if samus has ice
    mov     r0,r4
    bl      GetSpriteWeakness
    mov     r1,0x42
    and     r1,r0
    cmp     r1,0
    beq     @@_8084F94			; if enemy can be frozen and weak to beams
    mov     r0,r4
    ldr     r1,[sp,4]
    mov     r2,6
    bl      0x80846A0				; lower health by 6?
    lsl     r0,r0,24
    lsr     r5,r0,24
    mov     r0,r4
    bl      GetSpriteDamageReduction
    lsl     r0,r0,16
    cmp     r0,0					; if no cloud when hit
    beq     @@_8084FEA					; return
    mov     r0,2					; cloud type = ice
    b       @@_8084FCE				; make cloud
    .pool
@@_8084F94:
    mov     r0,r4				; else
    bl      0x80847D4				; update flash timer
    mov     r0,r7
    mov     r1,r8
    mov     r2,7					; particle 7 (tink)
    bl      SetParticleEffect
    b       @@_8084FEA
@@_8084FA6:
    mov     r0,r4			; else (wave)
    bl      GetSpriteWeakness
    mov     r1,2
    and     r1,r0
    cmp     r1,0
    beq     @@_8084FDA			; if weak to beams
    mov     r0,r4
    mov     r1,3
    bl      LowerSpriteHealth		; lower health by 3
    lsl     r0,r0,24
    lsr     r5,r0,24
    mov     r0,r4
    bl      GetSpriteDamageReduction
    lsl     r0,r0,16
    cmp     r0,0					; if no cloud when hit
    beq     @@_8084FEA					; return
    mov     r0,1					; cloud type = non-ice
@@_8084FCE:
    mov     r1,r5
    mov     r2,r7
    mov     r3,r8
    bl      0x8083E24				; make cloud
    b       @@_8084FEA
@@_8084FDA:
    ldr     r0,[sp]				; else
    bl      0x80847D4				; update flash timer
    ldr     r0,[sp,8]
    mov     r1,r10
    mov     r2,7
    bl      SetParticleEffect		; particle 7 (tink)
@@_8084FEA:
    add     sp,0xC
    pop     r3-r5
    mov     r8,r3
    mov     r9,r4
    mov     r10,r5
    pop     r4-r7
    pop     r0
    bx      r0
