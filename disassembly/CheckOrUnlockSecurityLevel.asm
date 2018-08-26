; r0 = Unlock flag
.org 0x80756FC
    push    r4-r7,r14
    lsl     r0,r0,24
    lsr     r0,r0,24
    mov     r12,r0
    ldr     r0,=Equipment
    ldrb    r4,[r0,0xD]		; r4 = SecurityLevel
    cmp     r4,0xFF
    bne     @@_807570E		; if power is off
    mov     r4,0				; r4 = 0
@@_807570E:
    mov     r5,0			; r5 = 0
    mov     r3,0			; r3 = 0
    ldr     r0,=AreaID
    ldr     r1,=SecurityUnlockEvents
    ldrb    r2,[r0]			; r2 = AreaID
    mov     r6,r0			; r6 = AreaID
    ldrb    r0,[r1,1]		; r0 = SecurityArea
    cmp     r2,r0
    bne     @@_8075730		; if areas match
    ldrb    r5,[r1]				; r5 = NewSecurityLevel
    b       @@_8075744
    .pool
@@_8075730:
    add     r3,1			; else (areas don't match)
    cmp     r3,3				; for each security pad area
    bgt     @@_8075744
    lsl     r0,r3,3
    add     r2,r0,r1
    ldrb    r0,[r6]
    ldrb    r7,[r2,1]
    cmp     r0,r7					; if areas match
    bne     @@_8075730
    ldrb    r5,[r2]						; r5 = NewSecurityLevel
@@_8075744:
    cmp     r4,r5			; if no match or PrevSecurityLevel >= NewSecurityLevel
    blt     @@_807574C
    mov     r0,0				; return 0
    b       @@_8075780
@@_807574C:
    ldr     r2,=EventCounter
    lsl     r0,r3,3
    add     r1,r0,r1
    ldrb    r0,[r2]			; r0 = CurrEvent
    ldrb    r3,[r1,2]		; r3 = SecurityEvent
    cmp     r0,r3			; if CurrEvent != SecurityEvent
    bne     @@_807577C			; return 0
    mov     r7,r12
    cmp     r7,0			; if arg0 == 0
    beq     @@_807577E			; return NewSecurityLevel
    add     r0,1			; r0 = CurrEvent+1
    ldrb    r1,[r1,3]		; r1 = NewEvent
    cmp     r0,r1			; if next events don't match
    bne     @@_807577E			; return NewSecurityLevel
    lsl     r0,r0,24
    lsr     r0,r0,24
    bl      SetEvent		; set new event
    mov     r0,2
    bl      0x8063A30		; set 0x3000050 to 2
    b       @@_807577E
    .pool
@@_807577C:
    mov     r5,0
@@_807577E:
    mov     r0,r5
@@_8075780:
    pop     r4-r7
    pop     r1
    bx      r1
