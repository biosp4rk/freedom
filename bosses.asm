; check for item when spawning arachnus or zazabi
.org 0x80255C0
	mov     r0,ArachnusItem
	bl      CheckSpawnBoss
	mov     r2,0
.org 0x80255D4
	mov     r0,ZazabiItem
	bl      CheckSpawnBoss
	mov     r2,0

; check for item when spawning charge beam boss
.org 0x802D7AE
	mov     r4,r1			; r4 = CurrSpriteData
	mov     r0,ChargeItem
	bl      CheckSpawnBoss
	mov     r3,0
	cmp     r0,0

; check for item when spawning serris
.org 0x8047A8C
	mov     r0,SerrisItem
	bl      CheckSpawnBoss
	mov     r7,0
	cmp     r0,0
	beq     0x8047AAC
	b       0x8047A9C

; TODO: check event when spawning box

; check for item when spawning mega-x
.org 0x805793C
	mov     r0,MegaXItem
	bl      CheckSpawnBoss
	mov     r7,0x10
	mov     r6,0
	cmp     r0,0
	beq     0x8057960
	b       0x805794E

; TODO: remove event check for wide beam boss
; check for item when spawning wide beam boss
.org 0x803A298
	mov     r4,r2			; r4 = CurrSpriteData
	mov     r0,WideItem
	bl      CheckSpawnBoss
	mov     r2,r4
	mov     r5,2
	mov     r4,0
	cmp     r0,0

; check for item when spawning yakuza
.org 0x805C278
	mov     r0,YakuzaItem
	bl      CheckSpawnBoss
	mov     r6,0
	cmp     r0,0
	beq     0x805C298
	b       0x805C288

; check for item when spawning nettori
.org 0x8043F64
	mov     r0,PlasmaItem
	bl      CheckSpawnBoss
	mov     r7,0
	cmp     r0,0
	beq     0x8043F84
	b       0x8043F74

; check for item when spawning nightmare
.org 0x805E2B4
	mov     r0,NightmareItem
	bl      CheckSpawnBoss
	mov     r7,0
	cmp     r0,0
	beq     0x805E2D4
	b       0x805E2C4

; TODO: check for event when spawning box 2

; check for item when spawning ridley
.org 0x805BA42
	mov     r0,RidleyItem
	bl      CheckSpawnBoss
	mov     r5,8
	mov     r4,0
	cmp     r0,0
	beq     0x805BA64
	b       0x805BA54

; TODO: check for event when spawning sa-x


; assign item for arachnus
.org 0x8025E64
	mov     r0,ArachnusItem
	bl      AssignBossItem

; assign item for charge beam boss
.org 0x802DF96
	mov     r0,ChargeItem
	bl      AssignBossItem
	
; assign item for zazabi
.org 0x8025E6C
	mov     r0,ZazabiItem
	bl      AssignBossItem
	
; assign item for serris
.org 0x8025E74
	mov     r0,SerrisItem
	bl      AssignBossItem
	
; assign item for mega-x
.org 0x8025E7C
	mov     r0,MegaXItem
	bl      AssignBossItem

; assign item for wide beam boss
.org 0x802DF9E
	mov     r0,WideItem
	bl      AssignBossItem

; assign item for yakuza
.org 0x8025E84
	mov     r0,YakuzaItem
	bl      AssignBossItem

; assign item for nettori
.org 0x802DFA6
	mov     r0,PlasmaItem
	bl      AssignBossItem

; assign item for nightmare
.org 0x8025E8C
	mov     r0,NightmareItem
	bl      AssignBossItem

; assign item for wave beam boss
.org 0x802DFAE
	mov     r0,WaveItem
	bl      AssignBossItem

; assign item for ridley
.org 0x8025E94
	mov     r0,RidleyItem
	bl      AssignBossItem

