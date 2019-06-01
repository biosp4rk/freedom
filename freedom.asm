.gba
.relativeinclude on
.open "MF_J.gba","MF_J_freedom.gba",0x8000000

; debug for testing
.org 0x80771EA
	mov r0,r9
	strb r0,[r4,2]

; items
.definelabel Energy,		    0x00
.definelabel MissileTank,		0x01
.definelabel PowerBombTank,		0x02
.definelabel ChargeBeam,		0x03
.definelabel WideBeam,			0x04
.definelabel PlasmaBeam,		0x05
.definelabel WaveBeam,			0x06
.definelabel IceBeam,			0x07
.definelabel NormalMissiles,	0x08
.definelabel SuperMissiles,		0x09
.definelabel IceMissiles,		0x0A
.definelabel DiffusionMissiles,	0x0B
.definelabel NormalBombs,		0x0C
.definelabel PowerBombs,		0x0D
.definelabel HiJump,			0x0E
.definelabel SpeedBooster,		0x0F
.definelabel SpaceJump,			0x10
.definelabel ScrewAttack,		0x11
.definelabel VariaSuit,			0x12
.definelabel GravitySuit,		0x13
.definelabel MorphBall,			0x14

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

; custom events
.definelabel EasyEvent,				0x01
.definelabel HardEvent,				0x02
.definelabel ArachnusDeadEvent,		0x03
.definelabel ElevatorEvent,			0x04
.definelabel ChargeCoreDeadEvent,	0x05
.definelabel DataPad1Event,         0x06
.definelabel ZazabiDeadEvent,		0x07
.definelabel SerrisDeadEvent,		0x08
.definelabel WaterLevelEvent,		0x09
.definelabel DataPad2Event,         0x0A
.definelabel Box1TriggerEvent,		0x0B
.definelabel Box1DeadEvent,			0x0C
.definelabel MegaXDeadEvent,		0x0D
.definelabel WideCoreDeadEvent,		0x0E
.definelabel DataPad3Event,         0x0F
.definelabel AnimalsEvent,			0x10
.definelabel YakuzaDeadEvent,		0x11
.definelabel NettoriDeadEvent,		0x12
.definelabel NightmareDeadEvent,	0x13
.definelabel DataPad4Event,         0x14
.definelabel Box2TriggerEvent,		0x15
.definelabel Box2DeadEvent,			0x16
.definelabel LabExplosionEvent,		0x17
.definelabel LabDestroyedEvent,		0x18
.definelabel RidleyDeadEvent,		0x19
.definelabel SaxDeadEvent,			0x1A
.definelabel EscapeEvent,			0x1B


; ram and rom addresses
.include "symbols.asm"


;----------
; New Code
;----------
.org 0x822B9E8  ; unused sound

.include "language\language_new.asm"
.include "events\events_new.asm"
.include "bosses_new.asm"
.include "items_new.asm"
.include "navigation_new.asm"

;---------------
; Modifications
;---------------

; force english and allow choosing japanese
.include "language\language.asm"

; ; new event system
; .include "events\events.asm"

; fix boss spawning, hatch locking, and music
.include "bosses.asm"

; allow unlocking hatches
.include "security_pad.asm"

; allow downloading items
.include "data_pad.asm"

; navigation rooms
.include "navigation.asm"

; stackable beams/missiles
.include "weapons\weapons.asm"

.include "misc.asm"


.close
