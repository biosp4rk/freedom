; sprite property of each data pad
; sector 2  = 0x84D1646
; sector 3  = 0x85014A9
; sector 5  = 0x851A3E7
; sector 4  = 0x8538F8A

; enable data pad/set item based on property
; download data pad item
; overwrites CheckOrDownloadDataItem
; r0 = download flag
; returns 1 if should be active
.org 0x80756BC
    push    r14
    push    r4
    mov     r4,r0
    bl      GetPrimarySpriteOffset
    add     r0,0x2A
    ldrb    r0,[r0]
    lsr     r0,r0,4
    sub     r0,1            ; r0 = data pad number
    ldr     r1,=DataPadItems
    add     r0,r1,r0
    ldrb    r0,[r0]         ; r0 = item number
    cmp     r4,0
    beq     @@CheckHasItem
    bl      AssignItem
    mov     r0,0
    b       @@Return
@@CheckHasItem:
    bl      CheckHasItem
    mov     r1,1
    eor     r0,r1           ; negate return value
@@Return:
    pop     r4
    pop     r1
    bx      r1
    .pool
