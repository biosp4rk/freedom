; display correct message when obtaining item
.org 0x807A0CC
    ldr     r0,=MessageToDisplay
    ldrb    r2,[r0]
    ldr     r7,=MessageTextPointers
    ldr     r6,=Language
    b       0x807A126   ; jump to code that gets text offset
    .pool

; skip intro
.org 0x80886F6
    mov     r0,0xB      ; show ship landing

; skip to credits
.org 0x8095E54
    mov     r0,3        ; set SubGameMode1 = 3

; fix starting values
.org 0x828F5C1
    .db 0               ; start with security level 0
    .db 0               ; start without main deck map

; improve eyedoor rng
.org 0x8043304
    cmp     r0,8        ; 9/16 chance of opening

; faster elevators
.org 0x8009C9C
    mov     r0,8
.org 0x8009CAC
    .dw 0xFFF8

; mid-air bomb jump
.org 0x80092A4
    b       0x80092E0
.org 0x80092B0
    b       0x80092E0
.org 0x80092C2
    beq     0x80092E0


; TODO: move
; force music to play first time exiting ship
.org 0x8071D0C
    ldr     r0,=AreaID
    ldrh    r0,[r0]
    cmp     r0,0
    bne     0x8071D76
    mov     r0,0x1E     ; music track
    mov     r1,2
    bl      PlayMusic
    .pool
