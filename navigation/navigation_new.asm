CheckDownloadedAreaMap:
    ldr     r0,=AreaID
    ldrb    r0,[r0]
    mov     r1,1
    lsl     r1,r0       ; r1 = map bit flag
    ldr     r0,=Equipment
    ldrb    r0,[r0,0xE] ; r0 = DownloadedMaps
    and     r0,r1
    cmp     r0,0
    beq     @@Return
    mov     r0,1        ; return 1 if map already downloaded
@@Return:
    bx      r14
    .pool
