; count abilities toward percent
; TODO: don't count missile status and power bomb status
; TODO: scale percent if too high?
; NOTE: 16 extra instructions - 14 used to count abilities
.org 0x80A442C
    ldr     r0,=Difficulty
    ldrb    r1,[r0]
    ldr     r0,=0x30014B8
    mov     r8,r0
    cmp     r1,0
    bne     @@_80A443C      ; if difficulty is easy
    add     r0,0x99
    strb    r1,[r0]             ; set EndingTier 0
@@_80A443C:
    ldr     r7,=Equipment
    ldrh    r0,[r7,2]
    sub     r0,0x63
    ldr     r2,=TankIncreaseAmounts
    lsl     r1,r1,2
    add     r5,r1,r2
    ldrb    r1,[r5]
    bl      Divide
    mov     r6,r0           ; EnergyPercent
    ldrh    r0,[r7,6]
    ldrb    r1,[r5,1]
    bl      Divide
    add     r6,r6,r0        ; + MissilePercent
    ldrb    r0,[r7,9]
    ldrb    r1,[r5,2]
    bl      Divide
    add     r0,r6,r0        ; + PowerPercent
    ldrb    r1,[r7,0xA]     ; r1 = BeamStatus
    ldrb    r2,[r7,0xB]     ; r2 = MissileBombStatus
    lsl     r2,r2,8
    orr     r1,r2
    ldrb    r2,[r7,0xC]     ; r2 = SuitMiscStatus
    lsl     r2,r2,8
    orr     r1,r2
@@CountAbilities
    cmp     r1,0
    beq     @@SetPercent    ; while bit flags remaining
    mov     r2,1
    and     r2,r1
    add     r0,r0,r2            ; add 1 if flag present
    lsr     r1,r1,1
    b       @@CountAbilities
@@SetPercent
    mov     r1,r8
    add     r1,0x9A
    strb    r0,[r1]         ; [3001552] = TotalPercent
    cmp     r0,0x64
    bls     @@Return        ; if TotalPercent > 100
    mov     r0,0x64
    strb    r0,[r1]             ; [3001552] = 100
@@Return:
    mov     r0,0x55
    mov     r1,0xE
    bl      PlayMusic?
    ldr     r0,=0x80A4081
    bl      SetVBlankCodePointer
    add     sp,4
    pop     r3,r4
    mov     r8,r3
    mov     r9,r4
    pop     r4-r7
    pop     r0
    bx      r0
    .pool

; skip code that assumes normal difficulty for non-japanese language
.org 0x80A4358
    b       0x80A442C
.org 0x80A4406
    bgt     0x80A442C
.org 0x80A4410
    b       0x80A442C

; check animals event instead of hiragana
; also fix low% ending
.org 0x80A5126
    ldr     r0,=Difficulty
    ldrb    r1,[r0]
    cmp     r1,0
    beq     @@CheckAnimals  ; if not easy mode
    ldr     r0,=0x30014B8
    add     r0,0x9A
    ldrb    r0,[r0]             ; r0 = TotalPercent
    cmp     r0,1
    bhi     @@CheckAnimals      ; if TotalPercent <= 1
    mov     r4,5                    ; r4 = 5 (low% ending)
@@CheckAnimals:
    mov     r0,AnimalsEvent
    bl      CheckEvent
    ldr     r2,=Difficulty
    ldrb    r2,[r2]         ; r2 = Difficulty
    b       0x80A5160       ; jump to code that normally checks for hiragana
    .pool
