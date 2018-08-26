EasyNormalText:
    .import "easy_normal_text.bin"
    
EasyNormalHardText:
    .import "easy_normal_hard_text.bin"
    
LanguageChosen:
    ldrb    r0,[r1,0x16]
    cmp     r0,0
    bne     @@Japanese
    mov     r0,2		; english
    b @@Return
@@Japanese:
    mov     r0,0
@@Return:
    strb    r0,[r2]
    mov     r0,0xC
    strh    r0,[r1,0xA]
    ldr     r0,=0x809FE4C
    mov     r15,r0
    .pool