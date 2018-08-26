; skip first ship navigation altogether
.org 0x800044A
	mov     r0,1		; in-game
	strh    r0,[r1]
	mov     r0,0
	strh    r0,[r1,2]
	strh    r0,[r1,4]
	b       0x800076C

; don't show map when entering ship
.org 0x802008C
	b       0x802009A	; skip overwriting GameMode (didn't save)
.org 0x8020102
	b       0x8020110	; skip overwriting GameMode (saved)

; enable navigation pad only if map data not obtained
.org 0x802A338
	; replaces call to event check
	bl      CheckDownloadedAreaMap

; disable after downloading map
.org 0x802A932
	b       0x802A942	; skip function call (checks if samus on pad)

; skip navigation text
.org 0x807795E
	mov     r1,9		; stage to exit map screen

; prevent event counter from incrementing
.org 0x807563C
	b       0x8075682	; skips checking nav location and event

; prevent doors from locking
.org 0x8063A4A
	b       0x8063A52	; skip call to DetermineNavRoomHatchesToLock

; map room text (english)
.org 0x86B3B82
	.halfword 0x8050,0x008D,0x00C1,0x00D0,0x0040,0x0092,0x00CF,0x00CF,0x00CD,0xFF00
; map room text (japanese)
.org 0x86B163E
	.halfword 0x8056,0x018F,0x014F,0x01D1,0x0199,0x0150,0x0191,0xFF00
