NormalBeamHitSprite:
    ; r0 = Sprite slot number
	; r1 = Projectile slot number
	; r2 = Projectile Y position
	; r3 = Projectile X position
    push    r4-r7,r14
    mov     r7,r10
    mov     r6,r9
    mov     r5,r8
    push    r5-r7
    lsl     r0,r0,24
    lsr     r4,r0,24	; r4 = SpriteSlotNum
    mov     r9,r4		; r9 = SpriteSlotNum
    lsl     r1,r1,24
    lsr     r1,r1,24
    mov     r10,r1		; r10 = ProjSlotNum
    lsl     r2,r2,16
    lsr     r5,r2,16	; r5 = ProjYpos
    mov     r8,r5		; r8 = ProjYpos
    lsl     r3,r3,16
    lsr     r6,r3,16	; r6 = ProjXpos
    mov     r7,r6		; r6 = ProjXpos
    ldr     r1,=SpriteDataSlot0
    lsl     r0,r4,3
    sub     r0,r0,r4
    lsl     r0,r0,3
    add     r0,r0,r1
    add     r0,0x34
    ldrb    r1,[r0]		; r1 = SpriteProperties
    mov     r0,8
    and     r0,r1
    cmp     r0,0
    beq     @@_808484C	; if Properties has 8
    mov     r0,r4
    bl      0x80847D4		; update flash timer
    b       @@_8084892		; particle 3 (normal beam hit)
    .pool
@@_808484C:
    mov     r0,0x40
    and     r0,r1
    cmp     r0,0
    beq     @@_8084860	; else if properties has 40
    mov     r0,r5
    mov     r1,r6
    mov     r2,7			; particle 7 (tink)
    bl      SetParticleEffect
    b       @@_80848AE
@@_8084860:
    mov     r0,r4		; else
    bl      GetSpriteWeakness
    mov     r1,2
    and     r1,r0
    cmp     r1,0
    beq     @@_808489E		; if weak to beams
    mov     r0,r4
    mov     r1,2
    bl      LowerSpriteHealth	; lower health by 2
    lsl     r0,r0,24
    lsr     r7,r0,24
    mov     r0,r4
    bl      GetSpriteDamageReduction
    lsl     r0,r0,16
    cmp     r0,0
    beq     @@_8084892			; if debris when hit
    mov     r0,1					; cloud type = non-ice
    mov     r1,r7
    mov     r2,r5
    mov     r3,r6
    bl      CreateDebris				; make debris
@@_8084892:
    mov     r0,r5
    mov     r1,r6
    mov     r2,3				; particle 3 (normal beam hit)
    bl      SetParticleEffect
    b       @@_80848AE
@@_808489E:
    mov     r0,r9			; else
    bl      0x80847D4			; update flash counter
    mov     r0,r8
    mov     r1,r7
    mov     r2,7				; particle 7 (tink)
    bl      SetParticleEffect
@@_80848AE:
    ldr     r0,=ProjectileDataSlot0
    mov     r2,r10
    lsl     r1,r2,5
    add     r1,r1,r0
    mov     r0,0
    strb    r0,[r1]
    pop     r3-r5
    mov     r8,r3
    mov     r9,r4
    mov     r10,r5
    pop     r4-r7
    pop     r0
    bx      r0
