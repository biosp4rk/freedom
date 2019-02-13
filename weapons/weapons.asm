; stackable beams
.include "stackable_beams.asm"

; stackable missile
.include "stackable_missiles.asm"

; obtain missiles from missile expansion
; .org 0x806C3D8
; 0x806C9FE
    ; strh    r0,[r1,6]
    ; strh    r0,[r1,4]
    ; ldrb    r0,[r1,0xB]
    ; mov     r2,1
    ; orr     r0,r2
    ; strb    r0,[r1,0xB]

; obtain power bombs from power bomb expansion
; .org 0x806C42A
; 0x806CA94
    ; strb    r0,[r1,9]
    ; strb    r0,[r1,8]
    ; ldrb    r0,[r1,0xB]
    ; mov     r2,0x20
    ; orr     r0,r2
    ; strb    r0,[r1,0xB]

; fix starting capacities
.org 0x828F5B8
    .halfword 0         ; starting missile supply
    .halfword 0         ; starting missile capacity
    .byte 0             ; starting power bomb supply
    .byte 0             ; starting power bomb capacity
