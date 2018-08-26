DataPadItems:
	.byte DataPad1,DataPad2,DataPad3,DataPad4,DataPad5,DataPad6,DataPad7
	.align

; returns offset of primary sprite
GetPrimarySpriteOffset:
	ldr     r0,=CurrSpriteData
	add     r0,0x23
	ldrb    r0,[r0]			; r1 = primary sprite RAM slot
	lsl     r1,r0,3
	sub     r1,r1,r0
	lsl     r0,r1,3
	ldr     r1,=SpriteDataSlot0
	add     r0,r1,r0
	bx      r14
	.pool

; routine to check for item
; r0 = item number
; returns 1 if has item
CheckHasItem:
	ldr     r1,=@@JumpTable
	lsl     r0,r0,2
	add     r0,r1,r0
	ldr     r0,[r0]
	ldr     r1,=Equipment
	mov     r15,r0
@@JumpTable:
	.word @@ChargeBeam,@@WideBeam,@@PlasmaBeam,@@WaveBeam,@@IceBeam
	.word @@NormalMissiles,@@SuperMissiles,@@IceMissiles,@@DiffusionMissiles,@@NormalBombs,@@PowerBombs
	.word @@HiJump,@@SpeedBooster,@@SpaceJump,@@ScrewAttack,@@VariaSuit,@@GravitySuit,@@MorphBall
@@ChargeBeam:
	ldrb    r1,[r1,0xA]
	mov     r0,1
	b       @@Check
@@WideBeam:
	ldrb    r1,[r1,0xA]
	mov     r0,2
	b       @@Check
@@PlasmaBeam:
	ldrb    r1,[r1,0xA]
	mov     r0,4
	b       @@Check
@@WaveBeam:
	ldrb    r1,[r1,0xA]
	mov     r0,8
	b       @@Check
@@IceBeam:
	ldrb    r1,[r1,0xA]
	mov     r0,0x10
	b       @@Check
@@NormalMissiles:
	ldrb    r1,[r1,0xB]
	mov     r0,1
	b       @@Check
@@SuperMissiles:
	ldrb    r1,[r1,0xB]
	mov     r0,2
	b       @@Check
@@IceMissiles:
	ldrb    r1,[r1,0xB]
	mov     r0,4
	b       @@Check
@@DiffusionMissiles:
	ldrb    r1,[r1,0xB]
	mov     r0,8
	b       @@Check
@@NormalBombs:
	ldrb    r1,[r1,0xB]
	mov     r0,0x10
	b       @@Check
@@PowerBombs:
	ldrb    r1,[r1,0xB]
	mov     r0,0x20
	b       @@Check
@@HiJump:
	ldrb    r1,[r1,0xC]
	mov     r0,1
	b       @@Check
@@SpeedBooster:
	ldrb    r1,[r1,0xC]
	mov     r0,2
	b       @@Check
@@SpaceJump:
	ldrb    r1,[r1,0xC]
	mov     r0,4
	b       @@Check
@@ScrewAttack:
	ldrb    r1,[r1,0xC]
	mov     r0,8
	b       @@Check
@@VariaSuit:
	ldrb    r1,[r1,0xC]
	mov     r0,0x10
	b       @@Check
@@GravitySuit:
	ldrb    r1,[r1,0xC]
	mov     r0,0x20
	b       @@Check
@@MorphBall:
	ldrb    r1,[r1,0xC]
	mov     r0,0x40
@@Check:
	and     r0,r1
	cmp     r0,0
	beq     @@Return
	mov     r0,1
@@Return:
	bx      r14
	.pool

; routine to asign an item
; r0 = item number
AssignItem:
	ldr     r1,=@@JumpTable
	lsl     r0,r0,2
	add     r0,r1,r0
	ldr     r0,[r0]
	ldr     r1,=Equipment
	mov     r15,r0
@@JumpTable:
	.word @@ChargeBeam,@@WideBeam,@@PlasmaBeam,@@WaveBeam,@@IceBeam
	.word @@NormalMissiles,@@SuperMissiles,@@IceMissiles,@@DiffusionMissiles,@@NormalBombs,@@PowerBombs
	.word @@HiJump,@@SpeedBooster,@@SpaceJump,@@ScrewAttack,@@VariaSuit,@@GravitySuit,@@MorphBall
@@ChargeBeam:
	mov     r0,1
	add     r1,0xA
	mov     r2,0x11
	b       @@Assign
@@WideBeam:
	mov     r0,2
	add     r1,0xA
	mov     r2,0x12
	b       @@Assign
@@PlasmaBeam:
	mov     r0,4
	add     r1,0xA
	mov     r2,0x14
	b       @@Assign
@@WaveBeam:
	mov     r0,8
	add     r1,0xA
	mov     r2,0x13
	b       @@Assign
@@IceBeam:
	mov     r0,0x10
	add     r1,0xA
	mov     r2,0x15
	b       @@Assign
@@NormalMissiles:
	mov     r0,1
	add     r1,0xB
	mov     r2,4
	b       @@Assign
@@SuperMissiles:
	mov     r0,2
	add     r1,0xB
	mov     r2,5
	b       @@Assign
@@IceMissiles:
	mov     r0,4
	add     r1,0xB
	mov     r2,8
	b       @@Assign
@@DiffusionMissiles:
	mov     r0,8
	add     r1,0xB
	mov     r2,9
	b       @@Assign
@@NormalBombs:
	mov     r0,0x10
	add     r1,0xB
	mov     r2,6
	b       @@Assign
@@PowerBombs:
	mov     r0,0x20
	add     r1,0xB
	mov     r2,7
	b       @@Assign
@@HiJump:
	mov     r0,1
	add     r1,0xC
	mov     r2,0xB
	b       @@Assign
@@SpeedBooster:
	mov     r0,2
	add     r1,0xC
	mov     r2,0xE
	b       @@Assign
@@SpaceJump:
	mov     r0,4
	add     r1,0xC
	mov     r2,0xB
	b       @@Assign
@@ScrewAttack:
	mov     r0,8
	add     r1,0xC
	mov     r2,0xC
	b       @@Assign
@@VariaSuit:
	mov     r0,0x10
	add     r1,0xC
	mov     r2,0xF
	b       @@Assign
@@GravitySuit:
	mov     r0,0x20
	add     r1,0xC
	mov     r2,0x10
	b       @@Assign
@@MorphBall:
	mov     r0,0x40
	add     r1,0xC
	mov     r2,0xA
@@Assign:
	ldr     r3,=MessageToDisplay
	strb    r2,[r3]		; store message
	ldrb    r2,[r1]
	orr     r0,r2
	strb    r0,[r1]		; store item
	bx      r14
	.pool

; count the number of abilities for end percent
CountAbilities:
	push    r4,r5
	mov     r0,0
	mov     r1,1
	ldr     r2,=Equipment
	ldrb    r3,[r1,0xA]
	mov     r4,1
@@BeamLoop:
	mov     r5,r3
	and     r5,r1
	add     r0,r0,r5
	cmp     r4,5		; check 5 beams
	bcs     @@Missile
	add     r4,1
	b       @@BeamLoop
@@Missile:
	ldrb    r3,[r1,0xB]
	mov     r4,1
@@MissileLoop:
	mov     r5,r3
	and     r5,r1
	add     r0,r0,r5
	cmp     r4,6		; check 6 missiles/bombs
	bcs     @@Suit
	add     r4,1
	b       @@MissileLoop
@@Suit:
	ldrb    r3,[r1,0xB]
	mov     r4,1
@@SuitLoop:
	mov     r5,r3
	and     r5,r1
	add     r0,r0,r5
	cmp     r4,7		; check 7 suit/misc
	bcs     @@Return
	add     r4,1
	b       @@SuitLoop
@@Return:
	bx      r14
	.pool
