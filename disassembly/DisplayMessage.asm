; r0 = spriteset GFX row
; r1 = stage
DrawMessage:
    push    r4-r7,r14
    add     sp,-8
    lsl     r0,r0,24
    lsr     r5,r0,24		; r5 = GfxRow
    lsl     r1,r1,24
    lsr     r3,r1,24		; r3 = Stage
    mov     r0,0xFC
    lsl     r0,r0,24
    add     r1,r1,r0
    lsr     r1,r1,24		; r1 = Stage - 4
    cmp     r1,1
    bhi     @@_807A138		; if Stage <= 5
    mov     r2,0x12
    ldr     r0,=EventCounter
    ldr     r1,=ObtainItemEvents
    ldrb    r0,[r0]				; r0 = Event
    ldr     r7,=MessageTextPointers
    ldr     r6,=Language
    ldrb    r4,[r1,0x12]		; ItemEvent
    cmp     r0,r4
    beq     @@_807A0F0
    mov     r4,r1
    mov     r1,r0
@@_807A0E2:
    sub     r2,1
    cmp     r2,0
    beq     @@_807A114
    add     r0,r2,r4
    ldrb    r0,[r0]
    cmp     r1,r0				; check if on an item event
    bne     @@_807A0E2
@@_807A0F0:
    cmp     r2,0
    beq     @@_807A114			; if on an item event
    ldr     r1,=AbilityRAMFlags
    lsl     r0,r2,3
    add     r0,r0,r1
    ldrb    r2,[r0,4]				; r2 = MessageNumber
    b       @@_807A126
    .pool
@@_807A114:
    ldr     r1,=Equipment
    ldrb    r0,[r1,0xD]			; r0 = SecurityLevel
    sub     r0,1
    lsl     r0,r0,24
    lsr     r0,r0,24
    cmp     r0,3
    bhi     @@_807A126			; if valid security level
    ldrb    r0,[r1,0xD]
    sub     r2,r0,1					; r2 = SecurityLevel-1
@@_807A126:
    mov     r0,0
    ldsb    r0,[r6,r0]
    lsl     r0,r0,2
    add     r0,r0,r7
    ldr     r1,[r0]
    lsl     r0,r2,2
    add     r0,r0,r1
    ldr     r0,[r0]				; r0 = TextOffset
    str     r0,[sp,4]			; sp[04] = TextOffset
@@_807A138:
    cmp     r3,7
    bne     @@_807A14C		; if Stage == 7
    ldr     r1,=0xFFFF			; r1 = FFFF
    mov     r2,0x80
    lsl     r2,r2,18			; r2 = 80000000
    b       @@_807A154
    .pool
@@_807A14C:
    cmp     r3,6			; else if Stage == 6
    bne     @@_807A16C
    ldr     r1,=0xFFFF			; r1 = FFFF
    ldr     r2,=0x2000800		; r2 = 2000800
@@_807A154:
    mov     r3,0x80			; if Stage == 6 or Stage == 7
    lsl     r3,r3,4				; r3 = 400 (length)
    mov     r0,0x10
    str     r0,[sp]				; sp[00] = 10
    mov     r0,3				; r0 = 3
    bl      0x8003034			; DMATransfer?
    b       @@_807A1F4
    .pool
@@_807A16C:
    cmp     r3,5			; else if Stage == 5
    bne     @@_807A174
    mov     r0,1				; r0 = 1
    b       @@_807A17A
@@_807A174:
    cmp     r3,4			; else if Stage == 4
    bne     @@_807A182
    mov     r0,2				; r0 = 2
@@_807A17A:
    add     r1,sp,4			; if Stage == 4 or Stage == 5
    bl      0x8079E28			; ???
    b       @@_807A1F4
@@_807A182:
    cmp     r3,3			; else if Stage == 3
    bne     @@_807A1A0
    ldr     r1,=0x40000D4		; r1 = 40000D4
    mov     r0,0x80
    lsl     r0,r0,18
    str     r0,[r1]				; [40000D4] = 80000000
    lsl     r0,r5,11			; r0 = GfxRow << 11
    ldr     r2,=0x6014000
    add     r0,r0,r2			; r0 = 6014000 + GfxRow * 20000
    b       @@_807A1EC
    .pool
@@_807A1A0:
    cmp     r3,2			; else if Stage == 2
    bne     @@_807A1BC
    ldr     r1,=0x40000D4
    ldr     r0,=0x2000400
    str     r0,[r1]				; [40000D4] = 2000400
    lsl     r0,r5,11			; r0 = 6014400 + GfxRow * 20000
    ldr     r4,=0x6014400
    b       @@_807A1EA			; DMATransfer???
    .pool
@@_807A1BC:
    cmp     r3,1			; else if Stage == 1
    bne     @@_807A1DC
    ldr     r1,=0x40000D4
    ldr     r0,=0x2000800
    str     r0,[r1]				; [40000D4] = 2000800
    lsl     r0,r5,11
    ldr     r2,=0x6014800		
    add     r0,r0,r2			; r0 = 6014800 + GfxRow * 20000
    b       @@_807A1EC
    .pool
@@_807A1DC:
    cmp     r3,0			; else if Stage == 0
    bne     @@_807A1F4
    ldr     r1,=0x40000D4
    ldr     r0,=0x2000C00
    str     r0,[r1]				; [40000D4] = 2000C00
    lsl     r0,r5,11			; r0 = 6014C00 + GfxRow * 20000
    ldr     r4,=0x6014C00
@@_807A1EA:
    add     r0,r0,r4
@@_807A1EC:
    str     r0,[r1,4]			; store destination
    ldr     r0,=0x840000E0
    str     r0,[r1,8]			; DMATransfer
    ldr     r0,[r1,8]
@@_807A1F4:
    add     sp,8
    pop     r4-r7
    pop     r0
    bx      r0
