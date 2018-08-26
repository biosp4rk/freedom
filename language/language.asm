; TODO: fix difficulty and area displayed for file
; TODO: fix endings

; set language to english during game initialization
.org 0x807F7B8
    mov     r0,2

; skip reseting language for SRAM reset menu
.org 0x808199C
    b       0x80819AE

; fix SRAM reset text
.org 0x858ABCC
    .import "reset_sram_1.bin"
.org 0x858AFA0
    .import "reset_sram_2.bin"
    
; skip check for kanji/hiragana
.org 0x809FBD0
    b       0x809FBEC

; load proper language select text
.org 0x809FDD4
    .halfword 0x4805    ; ldr r0,=0x87F13FC
    b       0x809FDE2

; change language select text to English
.org 0x8746412
    .import "set_language_text.bin"
    
; set language after choosing
.org 0x809FE44
    ldr     r0,=LanguageChosen
    mov     r15,r0
    .pool
    
; fix text loaded for difficulty select
.org 0x809FFD4
    .halfword 0x4807    ; ldr r0,=0x87F13FC
    b       0x809FFE2

; fix difficulty select text pointers
.org 0x87F1180
    .word EasyNormalText
    .word EasyNormalHardText
    
; fix default difficulty chosen
.org 0x80A001C
    strb    r2,[r5,0x17]
    b       0x80A0034
.org 0x80A0072
    b       0x80A007A
