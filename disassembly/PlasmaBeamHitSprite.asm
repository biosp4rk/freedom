PlasmaBeamHitSprite:
    ; r0 = Sprite slot number
	; r1 = Projectile slot number
	; r2 = Projectile Y position
	; r3 = Projectile X position
    push    r4-r7,r14
    mov     r7,r10
    mov     r6,r9
    mov     r5,r8
    push    r5-r7
    add     sp,-8
    lsl     r0,r0,24
    lsr     r4,r0,24	; r4 = SpriteSlotNum
    str     r4,[sp]		; sp[00] = SpriteSlotNum
    lsl     r1,r1,24
    lsr     r1,r1,24
    mov     r8,r1		; r8 = ProjSlotNum
    mov     r9,r8		; r9 = ProjSlotNum
    lsl     r2,r2,16
    lsr     r6,r2,16	; r6 = ProjYpos
    str     r6,[sp,4]	; r6 = ProjYpos
    lsl     r3,r3,16
    lsr     r7,r3,16	; r7 = ProjXpos
    mov     r10,r7		; r10 = ProjXpos
    ldr     r1,=SpriteDataSlot0
    lsl     r0,r4,3
    sub     r0,r0,r4
    lsl     r0,r0,3
    add     r0,r0,r1
    add     r0,0x34
    ldrb    r1,[r0]		; r1 = SpriteCollision
    mov     r0,8
    and     r0,r1
    lsl     r0,r0,24
    lsr     r5,r0,24
    cmp     r5,0
    beq     @@_8084D40	; if Collision has 8
    mov     r0,r4
    bl      0x80847D4		; update flash timer
    mov     r0,r6
    mov     r1,r7
    mov     r2,6			; particle 6 (plasma beam hit)
    bl      SetParticleEffect
    ldr     r0,=ProjectileDataSlot0
    mov     r2,r8
    lsl     r1,r2,5
    add     r1,r1,r0
    mov     r0,0
    strb    r0,[r1]			; remove projectile
    b       @@_8084DA8
    .pool
@@_8084D40:
    mov     r0,0x40
    and     r0,r1
    cmp     r0,0
    beq     @@_8084D64	; else if Collision has 40
    mov     r0,r6
    mov     r1,r7
    mov     r2,7			; particle 7 (tink)
    bl      SetParticleEffect
    ldr     r1,=ProjectileDataSlot0
    mov     r2,r9
    lsl     r0,r2,5
    add     r0,r0,r1
    strb    r5,[r0]			; remove projectile
    b       @@_8084DA8
    .pool
@@_8084D64:
    mov     r0,r4		; else
    bl      GetSpriteWeakness
    mov     r1,2
    and     r1,r0
    cmp     r1,0
    beq     @@_8084D98		; if weak to beams
    mov     r0,r4
    mov     r1,3
    bl      LowerSpriteHealth	; lower health by 3
    lsl     r0,r0,24
    lsr     r5,r0,24			; r5 = FlashTimer
    mov     r0,r4
    bl      GetSpriteDamageReduction
    lsl     r0,r0,16
    cmp     r0,0				; if no cloud when hit
    beq     @@_8084DA8				; return
    mov     r0,1				; cloud type = non-ice
    mov     r1,r5
    mov     r2,r6
    mov     r3,r7
    bl      0x8083E24			; make cloud
    b       @@_8084DA8
@@_8084D98:
    ldr     r0,[sp]			; else
    bl      0x80847D4			; update flash timer
    ldr     r0,[sp,4]
    mov     r1,r10
    mov     r2,7				; particle 7 (tink)
    bl      SetParticleEffect
@@_8084DA8:
    add     sp,8
    pop     r3-r5
    mov     r8,r3
    mov     r9,r4
    mov     r10,r5
    pop     r4-r7
    pop     r0
    bx      r0
