; sprite property of each security pad
; sector 2 (1) = 0x84D6F17
; sector 3 (2) = 0x84FC4E8
; sector 5 (3) = 0x851A3E7
; sector 4 (4) = 0x854032E

; set screen color during initialization
; enable/disable based on current level
.org 0x80210C6
    b       0x80210E4           ; skip past pool
.org 0x80210E4
    mov     r0,r4
    add     r0,0x2A
    ldrb    r1,[r0]
    lsr     r1,r1,4
    add     r0,6
    strb    r1,[r0]             ; sp[30] = sprite property
    ldr     r5,=CurrSpriteData  ; needed later in code
    mov     r7,0                ; needed later in code
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xD]
    cmp     r1,r0
    bhi     0x802119C           ; enable
    b       0x8021114           ; disable
    .pool

; overwrites CheckOrUnlockSecurityLevel
.org 0x80756FC
    push    r14
    bl      GetPrimarySpriteOffset
    add     r0,0x30
    ldrb    r0,[r0]             ; r0 = security level
    ldr     r1,=Equipment
    strb    r0,[r1,0xD]         ; store new security level
    ldr     r1,=MessageToDisplay
    sub     r0,1
    strb    r0,[r1]             ; store message to display
    mov     r0,2
    bl      0x8063A30           ; sets 0x3000050 to 2
    pop     r0
    bx      r0
    .pool
