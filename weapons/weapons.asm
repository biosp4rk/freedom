; stackable beams
.include "stackable_beams.asm"

; stackable missile
.include "stackable_missiles.asm"

; obtain missiles from missile tank
.org 0x806C9FE
    bl      AddMissiles
    b       0x806CAC2

; energy tank
.org 0x806CA58
	bl      AddEnergy
	b       0x806CAC2

; obtain power bombs from power bomb tank
.org 0x806CA94
    bl      AddPowerBombs
    b       0x806CAC2

; fix starting capacities
.org 0x828F5B8
    .dh 0       ; starting missile supply
    .dh 0       ; starting missile capacity
    .db 0		; starting power bomb supply
    .db 0		; starting power bomb capacity
