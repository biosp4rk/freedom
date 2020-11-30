; function to set an event
SetEvent:
    ; r0 = EventNum
    cmp     r0,0
    beq     @@Return
    sub     r0,1
    mov     r1,1
    lsl     r1,r0
    ldr     r2,=EventFlags
    ldr     r0,[r2]
    orr     r0,r1
    str     r0,[r2]
@@Return:
    bx      r14
    .pool

; function to check an event
CheckEvent:
    ; r0 = EventNum
    cmp     r0,0
    beq     @@Return
    sub     r0,1
    mov     r1,1
    lsl     r1,r0
    ldr     r2,=EventFlags
    ldr     r0,[r2]
    and     r0,r1
    cmp     r0,0
    beq     @@Return
    mov     r0,1
@@Return:
    bx      r14
    .pool
