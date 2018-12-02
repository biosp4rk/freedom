SetLanguageText1:
	.import "set_language_text_1.bin"
SetLanguageText2:
	.import "set_language_text_2.bin"
SetLanguageText3:
	.import "set_language_text_3.bin"
SetLanguageText4:
	.import "set_language_text_4.bin"
SetLanguageText5:
	.import "set_language_text_5.bin"

EasyNormalText:
    .import "easy_normal_text.bin"
EasyNormalHardText:
    .import "easy_normal_hard_text.bin"

MainDeckOAM:	
	.halfword 2
	.halfword 0x4000,0x8000,0x008A
	.halfword 0x0000,0x4020,0x008E

LoadLanguageText:
	; r0 = WindowPos
	push    r14
	; clear existing text
	ldr     r2,=DMA3SourceAddress
	mov     r1,0
	add     sp,-4
	str     r1,[sp]
	mov     r1,r13
	add     sp,4
	str     r1,[r2]
	ldr     r1,=0x600C800
	str     r1,[r2,4]
	ldr     r1,=0x85000800
	str     r1,[r2,8]
	ldr     r1,[r2,8]
	; load new text
	ldr     r1,=@@LanguageText
	lsl     r0,r0,2
	add     r0,r1,r0
	ldr     r0,[r0]
	ldr     r1,=0x30014B8
	str     r0,[r1,4]
	mov     r0,3
	bl      0x80A29E0
	pop     r0
	bx      r0
@@LanguageText:
	.word SetLanguageText1
	.word SetLanguageText2
	.word SetLanguageText3
	.word SetLanguageText4
	.word SetLanguageText5
	

SetChosenLanguage:
	ldr     r2,=0x30014B8
    mov     r0,0xC
	strh    r0,[r2,0xA]		; ???
	ldrb    r2,[r2,0x16]	; r0 = cursor position
	lsr     r0,r2,4
	mov     r1,0xF
	and     r1,r2
	add     r0,r0,r1
	ldr     r1,=Language
	strb    r0,[r1]
    bx      r14