; overwrite CheckOnEvent_EnteredPumpControl
.org 0x8061478
	push    r14
	mov     r0,WaterLevelEvent
	bl      CheckEvent
	mov     r1,1
	eor     r0,r1		; negate return value
	pop     r1
	bx      r1
; set water lowered event
.org 0x80397E6
	mov     r0,WaterLevelEvent
	bl      SetEvent

; overwrite CheckOnEvent_ToAnimals
.org 0x80614B0
	push    r14
	mov     r0,AnimalsEvent
	bl      CheckEvent
	mov     r1,1
	eor     r0,r1		; negate return value
	pop     r1
	bx      r1
; overwrite CheckAfterEvent_ToAnimals
.org 0x80614C8
	push    r14
	mov     r0,AnimalsEvent
	bl      CheckEvent
	pop     r1
	bx      r1
; set animals event
.org 0x8039804
	mov     r0,AnimalsEvent
	bl      SetEvent

; overwrite CheckOnEvent_SAXDefeated
.org 0x80614F8
	push    r14
	mov     r0,SaxDeadEvent
	bl      CheckEvent
	pop     r1
	bx      r1
; overwrite CheckAfterEvent_SAXDefeated
.org 0x8061510
	push    r14
	mov     r0,SaxDeadEvent
	bl      CheckEvent
	pop     r1
	bx      r1

; set escape event
.org 0x8039E44
	mov     r0,EscapeEvent
	bl      SetEvent

