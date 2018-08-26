; TODO: stackable beams

; TODO: stackable missiles

; obtain missiles from missile expansion

	
; obtain power bombs from power bomb expansion


; fix starting capacities
.org 0x828F5B8
	.halfword 0			; starting missile supply
	.halfword 0			; starting missile capacity
	.byte 0				; starting power bomb supply
	.byte 0				; starting power bomb capacity
