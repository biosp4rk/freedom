DataPadItems:
    .db DataPad1,DataPad2,DataPad3,DataPad4
    .align

; returns offset of primary sprite
GetPrimarySpriteOffset:
    ldr     r0,=CurrSpriteData
    add     r0,0x23
    ldrb    r0,[r0]         ; r1 = primary sprite RAM slot
    lsl     r1,r0,3
    sub     r1,r1,r0
    lsl     r0,r1,3
    ldr     r1,=SpriteDataSlot0
    add     r0,r1,r0
    bx      r14
    .pool

; routine to check for item
; r0 = item number
; returns 1 if has item
CheckHasItem:
    ldr     r1,=@@JumpTable
    sub     r0,3
    lsl     r0,r0,2
    add     r0,r1,r0
    ldr     r0,[r0]
    ldr     r1,=Equipment
    mov     r15,r0
@@JumpTable:
    .dw @@ChargeBeam,@@WideBeam,@@PlasmaBeam,@@WaveBeam,@@IceBeam
    .dw @@NormalMissiles,@@SuperMissiles,@@IceMissiles,@@DiffusionMissiles
    .dw @@NormalBombs,@@PowerBombs
    .dw @@HiJump,@@SpeedBooster,@@SpaceJump,@@ScrewAttack
    .dw @@VariaSuit,@@GravitySuit,@@MorphBall
@@ChargeBeam:
    ldrb    r1,[r1,0xA]
    mov     r0,1
    b       @@Check
@@WideBeam:
    ldrb    r1,[r1,0xA]
    mov     r0,2
    b       @@Check
@@PlasmaBeam:
    ldrb    r1,[r1,0xA]
    mov     r0,4
    b       @@Check
@@WaveBeam:
    ldrb    r1,[r1,0xA]
    mov     r0,8
    b       @@Check
@@IceBeam:
    ldrb    r1,[r1,0xA]
    mov     r0,0x10
    b       @@Check
@@NormalMissiles:
    ldrb    r1,[r1,0xB]
    mov     r0,1
    b       @@Check
@@SuperMissiles:
    ldrb    r1,[r1,0xB]
    mov     r0,2
    b       @@Check
@@IceMissiles:
    ldrb    r1,[r1,0xB]
    mov     r0,4
    b       @@Check
@@DiffusionMissiles:
    ldrb    r1,[r1,0xB]
    mov     r0,8
    b       @@Check
@@NormalBombs:
    ldrb    r1,[r1,0xB]
    mov     r0,0x10
    b       @@Check
@@PowerBombs:
    ldrb    r1,[r1,0xB]
    mov     r0,0x20
    b       @@Check
@@HiJump:
    ldrb    r1,[r1,0xC]
    mov     r0,1
    b       @@Check
@@SpeedBooster:
    ldrb    r1,[r1,0xC]
    mov     r0,2
    b       @@Check
@@SpaceJump:
    ldrb    r1,[r1,0xC]
    mov     r0,4
    b       @@Check
@@ScrewAttack:
    ldrb    r1,[r1,0xC]
    mov     r0,8
    b       @@Check
@@VariaSuit:
    ldrb    r1,[r1,0xC]
    mov     r0,0x10
    b       @@Check
@@GravitySuit:
    ldrb    r1,[r1,0xC]
    mov     r0,0x20
    b       @@Check
@@MorphBall:
    ldrb    r1,[r1,0xC]
    mov     r0,0x40
@@Check:
    and     r0,r1
    cmp     r0,0
    beq     @@Return
    mov     r0,1
@@Return:
    bx      r14
    .pool

; routine to assign an item
; called by data pads and bosses
; r0 = item number
AssignItem:
    push    r14
    ldr     r1,=@@JumpTable
    lsl     r0,r0,2
    add     r0,r1,r0
    ldr     r0,[r0]
    ldr     r1,=Equipment
    mov     r15,r0
@@JumpTable:
    .dw @@EnergyTank,@@MissileTank,@@PowerTank
    .dw @@ChargeBeam,@@WideBeam,@@PlasmaBeam,@@WaveBeam,@@IceBeam
    .dw @@NormalMissiles,@@SuperMissiles,@@IceMissiles,@@DiffusionMissiles
    .dw @@NormalBombs,@@PowerBombs
    .dw @@HiJump,@@SpeedBooster,@@SpaceJump,@@ScrewAttack
    .dw @@VariaSuit,@@GravitySuit,@@MorphBall
@@EnergyTank:
    bl      AddEnergy
    mov     r0,0x27
    b       @@TankMessage
@@MissileTank:
    bl      AddMissiles
    mov     r0,0x28
    b       @@TankMessage
@@PowerTank:
    bl      AddPowerBombs
    mov     r0,0x29
@@TankMessage:
    ldr     r1,=MessageToDisplay
    strb    r0,[r1]     ; store message
    b       @@Return
@@ChargeBeam:
    mov     r0,1
    add     r1,0xA
    mov     r2,0x11
    b       @@Assign
@@WideBeam:
    mov     r0,2
    add     r1,0xA
    mov     r2,0x12
    b       @@Assign
@@PlasmaBeam:
    mov     r0,4
    add     r1,0xA
    mov     r2,0x14
    b       @@Assign
@@WaveBeam:
    mov     r0,8
    add     r1,0xA
    mov     r2,0x13
    b       @@Assign
@@IceBeam:
    mov     r0,0x10
    add     r1,0xA
    mov     r2,0x15
    b       @@Assign
@@NormalMissiles:
    mov     r0,1
    add     r1,0xB
    mov     r2,4
    b       @@Assign
@@SuperMissiles:
    mov     r0,2
    add     r1,0xB
    mov     r2,5
    b       @@Assign
@@IceMissiles:
    mov     r0,4
    add     r1,0xB
    mov     r2,8
    b       @@Assign
@@DiffusionMissiles:
    mov     r0,8
    add     r1,0xB
    mov     r2,9
    b       @@Assign
@@NormalBombs:
    mov     r0,0x10
    add     r1,0xB
    mov     r2,6
    b       @@Assign
@@PowerBombs:
    mov     r0,0x20
    add     r1,0xB
    mov     r2,7
    b       @@Assign
@@HiJump:
    mov     r0,1
    add     r1,0xC
    mov     r2,0xB
    b       @@Assign
@@SpeedBooster:
    mov     r0,2
    add     r1,0xC
    mov     r2,0xE
    b       @@Assign
@@SpaceJump:
    mov     r0,4
    add     r1,0xC
    mov     r2,0xD
    b       @@Assign
@@ScrewAttack:
    mov     r0,8
    add     r1,0xC
    mov     r2,0xC
    b       @@Assign
@@VariaSuit:
    mov     r0,0x10
    add     r1,0xC
    mov     r2,0xF
    b       @@Assign
@@GravitySuit:
    mov     r0,0x20
    add     r1,0xC
    mov     r2,0x10
    b       @@Assign
@@MorphBall:
    mov     r0,0x40
    add     r1,0xC
    mov     r2,0xA
@@Assign:
    ldr     r3,=MessageToDisplay
    strb    r2,[r3]     ; store message
    ldrb    r2,[r1]
    orr     r0,r2
    strb    r0,[r1]     ; store item
@@Return:
    pop     r0
    bx      r0
    .pool

; increase energy capacity
AddEnergy:
    ldr     r0,=NumTanksPerArea
    ldrb    r0,[r0,0x15]        ; r0 = total number of energy tanks
    ldr     r1,=Difficulty
    ldrb    r1,[r1]
    lsl     r1,r1,2
    ldr     r2,=TankIncreaseAmounts
    add     r1,r2,r1
    ldrb    r1,[r1]             ; r1 = increase amount
    mul     r0,r1
    add     r0,0x63             ; r0 = max capacity
    ldr     r2,=Equipment
    ldrh    r3,[r2,2]
    add     r3,r3,r1            ; r3 = new capacity
    cmp     r0,r3
    blt     @@Return            ; if not over max capacity
    strh    r3,[r2,2]               ; store new capacity
    strh    r3,[r2]                 ; set current to capacity
@@Return:
    bx      r14
    .pool

; increase missile capacity
AddMissiles:
    ldr     r0,=NumTanksPerArea
    ldrb    r0,[r0,0x16]        ; r0 = total number of missile tanks
    ldr     r1,=Difficulty
    ldrb    r1,[r1]
    lsl     r1,r1,2
    ldr     r2,=TankIncreaseAmounts
    add     r1,r2,r1
    ldrb    r1,[r1,1]           ; r1 = increase amount
    mul     r0,r1               ; r0 = max capacity
    ldr     r2,=Equipment
    ldrh    r3,[r2,6]
    add     r3,r3,r1            ; r3 = new capacity
    cmp     r0,r3
    blt     @@Return            ; if not over max capacity
    strh    r3,[r2,6]               ; store new capacity
    ldrh    r0,[r2,4]
    add     r0,r0,r1
    strh    r0,[r2,4]               ; add to current amount
    ldrb    r0,[r2,0xB]
    mov     r1,1
    orr     r0,r1
    strb    r0,[r2,0xB]             ; set missile flag
@@Return:
    bx      r14
    .pool

; increase power bomb capacity
AddPowerBombs:
    ldr     r0,=NumTanksPerArea
    ldrb    r0,[r0,0x17]        ; r0 = total number of power bomb tanks
    ldr     r1,=Difficulty
    ldrb    r1,[r1]
    lsl     r1,r1,2
    ldr     r2,=TankIncreaseAmounts
    add     r1,r2,r1
    ldrb    r1,[r1,2]           ; r1 = increase amount
    mul     r0,r1               ; r0 = max capacity
    ldr     r2,=Equipment
    ldrb    r3,[r2,9]
    add     r3,r3,r1            ; r3 = new capacity
    cmp     r0,r3
    blt     @@Return            ; if not over max capacity
    strb    r3,[r2,9]               ; store new capacity
    ldrb    r0,[r2,8]
    add     r0,r0,r1
    strb    r0,[r2,8]               ; add to current amount
    ldrb    r0,[r2,0xB]
    mov     r1,0x20
    orr     r0,r1
    strb    r0,[r2,0xB]             ; set power bomb flag
@@Return:
    bx      r14
    .pool
