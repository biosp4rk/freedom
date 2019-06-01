; r0 = item number
CheckSpawnBoss:
	push    r14
	mov     r1,r12
	push    r1			; need to preserve r12 for some bosses
	bl      CheckEvent
	cmp     r0,0
	bne     @@Return
	mov     r0,0x3F
	bl      LockHatches
	mov     r0,0
@@Return:
	pop     r1
	mov     r12,r1
	pop     r1
	bx      r1
	.pool

; r0 = item number
AssignBossItem:
	push    r14
	bl      AssignItem
	ldr     r1,=DoorUnlockTimer
	mov     r0,0x3C
	strb    r0,[r1]
	pop     r0
	bx      r0
	.pool