; display correct message when obtaining item
.org 0x807A0CC
	ldr     r0,=MessageToDisplay
	ldrb    r2,[r0]
	ldr     r7,=MessageTextPointers
	ldr     r6,=Language
	b       0x807A126	; jump to code that gets text offset
	.pool

; skip intro
.org 0x80886F6
	mov     r0,0xB		; show ship landing

; skip to credits
.org 0x8095E54
	mov     r0,3		; set SubGameMode1 = 3

; fix starting values
.org 0x828F5C1
	.byte 0				; start with security level 0
	.byte 0				; start without main deck map

; improve eyedoor rng
.org 0x8043304
	cmp     r0,8		; 9/16 chance of opening

; faster elevators
.org 0x8009C9C
	mov     r0,8
.org 0x8009CAC
	.word 0xFFF8

; TODO: mid-air bomb jump
; .org 0x800922E
	; b       0x8009268
; .org 0x8009238
	; b       0x8009268
; .org 0x800924A
	; beq     0x8009268

; play music track for room
;.org 0x8090FC8
;	mov r1,0		; sets 0x30019F1 to 0

; TODO: abilities add percent
.org 0x80A4458
	nop				; don't subtract 10 from missile count
.org 0x80A446A
	nop				; don't subtract 10 from power bomb count
