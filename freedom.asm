.gba
.relativeinclude on
.open "MF_J.gba","MF_J_freedom.gba",0x8000000

; debug for testing
.org 0x80771EA
	mov r0,r9
	strb r0,[r4,2]

; items
.definelabel ChargeBeam,		0x0
.definelabel WideBeam,			0x1
.definelabel PlasmaBeam,		0x2
.definelabel WaveBeam,			0x3
.definelabel IceBeam,			0x4
.definelabel NormalMissiles,	0x5
.definelabel SuperMissiles,		0x6
.definelabel IceMissiles,		0x7
.definelabel DiffusionMissiles,	0x8
.definelabel NormalBombs,		0x9
.definelabel PowerBombs,		0xA
.definelabel HiJump,			0xB
.definelabel SpeedBooster,		0xC
.definelabel SpaceJump,			0xD
.definelabel ScrewAttack,		0xE
.definelabel VariaSuit,			0xF
.definelabel GravitySuit,		0x10
.definelabel MorphBall,			0x11

; core-x items
.definelabel ArachnusItem,	MorphBall
.definelabel ZazabiItem,	HiJump
.definelabel SerrisItem,	SpeedBooster
.definelabel MegaXItem,		VariaSuit
.definelabel YakuzaItem,	SpaceJump
.definelabel NightmareItem,	GravitySuit
.definelabel RidleyItem,	ScrewAttack

; eye core-x items
.definelabel ChargeItem,	ChargeBeam
.definelabel WideItem,		WideBeam
.definelabel PlasmaItem,	PlasmaBeam
.definelabel WaveItem,		WaveBeam

; data room items
.definelabel DataPad1,      NormalBombs
.definelabel DataPad2,      SuperMissiles
.definelabel DataPad3,      IceMissiles
.definelabel DataPad4,      DiffusionMissiles
.definelabel DataPad5,      0
.definelabel DataPad6,      0
.definelabel DataPad7,      0

; custom events
.definelabel EasyEvent,				0x01
.definelabel HardEvent,				0x02
.definelabel ArachnusDeadEvent,		0x03
.definelabel ElevatorEvent,			0x04
.definelabel ChargeCoreDeadEvent,	0x05
.definelabel ZazabiDeadEvent,		0x06
.definelabel SerrisDeadEvent,		0x07
.definelabel WaterLevelEvent,		0x08
.definelabel Box1TriggerEvent,		0x09
.definelabel Box1DeadEvent,			0x0A
.definelabel MegaXDeadEvent,		0x0B
.definelabel WideCoreDeadEvent,		0x0C
.definelabel AnimalsEvent,			0x0D
.definelabel YakuzaDeadEvent,		0x0E
.definelabel NettoriDeadEvent,		0x0F
.definelabel NightmareDeadEvent,	0x10
.definelabel Box2TriggerEvent,		0x11
.definelabel Box2DeadEvent,			0x12
.definelabel LabExplosionEvent,		0x13
.definelabel LabDestroyedEvent,		0x14
.definelabel RidleyDeadEvent,		0x15
.definelabel SaxDeadEvent,			0x16
.definelabel EscapeEvent,			0x17


; ram and rom addresses
.include "symbols.asm"


;----------
; New Code
;----------
.org 0x822B9E8  ; unused sound

.include "language\language_new.asm"
.include "bosses_new.asm"
.include "abilities_new.asm"
.include "navigation_new.asm"

;---------------
; Modifications
;---------------

; force english and allow choosing japanese
.include "language\language.asm"

; fix boss spawning, hatch locking, and music
.include "bosses.asm"

; allow obtaining core-x items
;.include "abilities.asm"

; allow unlocking hatches
.include "security_pad.asm"

; allow downloading items
.include "data_pad.asm"

; navigation rooms
.include "navigation.asm"

; stackable beams/missiles
;.include "weapons.asm"

.include "misc.asm"


; end game


.close
