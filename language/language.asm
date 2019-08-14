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

; pretend language is 0 when loading difficulty text
.org 0x80A338A
    mov     r4,0

; fix difficulty/area for save files
; fix OAM for "sector n"
.org 0x8744B6C
    .dh 0x0002,0x4000,0x8000,0x0080,0x8000,0x0023,0x0084
    .dh 0x0002,0x4000,0x8000,0x0080,0x8000,0x0023,0x0085
    .dh 0x0002,0x4000,0x8000,0x0080,0x8000,0x0023,0x0086
    .dh 0x0002,0x4000,0x8000,0x0080,0x8000,0x0023,0x0087
    .dh 0x0002,0x4000,0x8000,0x0080,0x8000,0x0023,0x0088
    .dh 0x0002,0x4000,0x8000,0x0080,0x8000,0x0023,0x0089
; fix pointer for main deck text OAM
.org 0x8745D80
    .dw MainDeckTextOAM

; fix indentation of metroid symbol
.org 0x80A29A6
    mov     r1,0xE4

; skip checking save file's language
.org 0x809FBD0
    b       0x809FBEC

; load proper language select text
.org 0x809FDD4
    ldr     r0,=SetLanguageText1
    str     r0,[r2,4]       ; [30014BC] = text pointer
    bl      0x80A0A7C
    .pool

; fix text indentation for language select text
.org 0x87F0FD4
    .dw 0x8745F9C

; fix behavior of language select cursor
.include "lang_select_cursor.asm"

; set language after choosing
.org 0x809FE40
    bl      SetChosenLanguage
    bl      0x80A0C5A

; fix text loaded for difficulty select
.org 0x809FFD4
    ldr     r0,=0x87F1118
    ldrh    r1,[r5,8]       ; r1 = text number
    lsl     r1,r1,2
    add     r1,r1,r0
    ldr     r0,[r1]
    str     r0,[r5,4]       ; [30014BC] = text pointer 
    bl      0x80A0C5A
    .pool

; fix difficulty select text pointers
.org 0x87F1180
    .dw EasyNormalText
    .dw EasyNormalHardText
    
; fix default difficulty chosen
.org 0x80A001C
    strb    r2,[r5,0x17]    ; [30014CF] = 1
    b       0x80A0034
.org 0x80A0072
    b       0x80A007A
    
; skip overwriting save file's language with english when loading
.org 0x80A01E2
    b       0x80A01F2

; fix file delete text indentation
.org 0x8745F6F
    .db 0xA0                ; move cursor left 6 pixels
.org 0x8745F8A
    .dh 0xB,0xB,0xF
