; check event when spawning arachnus
.org 0x80255C0
    mov     r0,ArachnusDeadEvent
    bl      CheckSpawnBoss
    mov     r2,0

; check event when spawning zazabi
.org 0x80255D4
    mov     r0,ZazabiDeadEvent
    bl      CheckSpawnBoss
    mov     r2,0

; check event when spawning charge beam boss
.org 0x802D7AE
    mov     r4,r1           ; r4 = CurrSpriteData
    mov     r0,ChargeCoreDeadEvent
    bl      CheckSpawnBoss
    mov     r3,0
    cmp     r0,0

; check event when spawning serris
.org 0x8047A8C
    mov     r0,SerrisDeadEvent
    bl      CheckSpawnBoss
    mov     r7,0
    cmp     r0,0
    beq     0x8047AAC
    b       0x8047A9C

; check event when spawning box
.org 0x8035E1C
    mov     r0,Box1DeadEvent
    bl      CheckSpawnBoss
    cmp     r0,0
    bne     0x8035E30
    ldr     r1,=CurrSpriteData
    strh    r0,[r1]
    b       0x8035FC2
    .pool

; check event when spawning mega-x
.org 0x805793C
    mov     r0,MegaXDeadEvent
    bl      CheckSpawnBoss
    mov     r7,0x10
    mov     r6,0
    cmp     r0,0
    beq     0x8057960
    b       0x805794E

; check event when spawning wide beam boss
.org 0x803A298
    mov     r4,r2           ; r2 = CurrSpriteData
    mov     r0,WideCoreDeadEvent
    bl      CheckSpawnBoss
    mov     r2,r4
    mov     r5,2
    mov     r4,0
    cmp     r0,0

; check event when spawning yakuza
.org 0x805C278
    mov     r0,YakuzaDeadEvent
    bl      CheckSpawnBoss
    mov     r6,0
    cmp     r0,0
    beq     0x805C298
    b       0x805C288

; check event when spawning nettori
.org 0x8043F64
    mov     r0,NettoriDeadEvent
    bl      CheckSpawnBoss
    mov     r7,0
    cmp     r0,0
    beq     0x8043F84
    b       0x8043F74

; check event when spawning nightmare
.org 0x805E2B4
    mov     r0,NightmareDeadEvent
    bl      CheckSpawnBoss
    mov     r7,0
    cmp     r0,0
    beq     0x805E2D4
    b       0x805E2C4

; check event when spawning box 2
.org 0x8051E48
    mov     r0,Box2DeadEvent
    bl      CheckSpawnBoss
    mov     r7,0
    cmp     r0,0
    beq     0x8051E68
    b       0x8051E58

; check event when spawning ridley
.org 0x805BA42
    mov     r0,RidleyDeadEvent
    bl      CheckSpawnBoss
    mov     r5,8
    mov     r4,0
    cmp     r0,0
    beq     0x805BA64
    b       0x805BA54

; check event when spawning sa-x
.org 0x801AA82
    mov     r0,SaxDeadEvent
    bl      CheckSpawnBoss
    cmp     r0,0
    bne     0x801AA98
    ldr     r1,=CurrSpriteData
    strh    r0,[r1]
    b       0x801AAE6
    .pool

; set event for arachnus
.org 0x8025E64
    mov     r0,ArachnusDeadEvent
    bl      SetEvent
; set event for zazabi
.org 0x8025E6C
    mov     r0,ZazabiDeadEvent
    bl      SetEvent
; set event for serris
.org 0x8025E74
    mov     r0,SerrisDeadEvent
    bl      SetEvent
; set event for mega-x
.org 0x8025E7C
    mov     r0,MegaXDeadEvent
    bl      SetEvent
; set event for yakuza
.org 0x8025E84
    mov     r0,YakuzaDeadEvent
    bl      SetEvent
; set event for nightmare
.org 0x8025E8C
    mov     r0,NightmareDeadEvent
    bl      SetEvent
; set event for ridley
.org 0x8025E94
    mov     r0,RidleyDeadEvent
    bl      SetEvent

; set event for box
.org 0x80381DE
    mov     r0,Box1DeadEvent
    bl      SetEvent

; set event for charge beam core
.org 0x802DF96
    mov     r0,ChargeCoreDeadEvent
    bl      SetEvent
; set event for wide beam core
.org 0x802DF9E
    mov     r0,WideCoreDeadEvent
    bl      SetEvent
; set event for nettori
.org 0x802DFA6
    mov     r0,NettoriDeadEvent
    bl      SetEvent
; set event for box 2
.org 0x802DFAE
    mov     r0,Box2DeadEvent
    bl      SetEvent


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

; assign item for box 2
.org 0x802DFAE
    mov     r0,WaveItem
    bl      AssignBossItem

; assign item for ridley
.org 0x8025E94
    mov     r0,RidleyItem
    bl      AssignBossItem
