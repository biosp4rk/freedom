; overwrite CheckOnEvent_EnteredPumpControl
; used to check if water control pad should be active
; should return true if WaterLevelEvent not set
.org 0x8061478
    push    r14
    mov     r0,WaterLevelEvent
    bl      CheckEvent
    mov     r1,1
    eor     r0,r1       ; negate return value
    pop     r1
    bx      r1
; set water lowered event
; called by ? when ?
.org 0x80397E6
    mov     r0,WaterLevelEvent
    bl      SetEvent

; overwrite CheckOnEvent_ToAnimals
; used to ?
; should return true if AnimalsEvent not set
.org 0x80614B0
    push    r14
    mov     r0,AnimalsEvent
    bl      CheckEvent
    mov     r1,1
    eor     r0,r1       ; negate return value
    pop     r1
    bx      r1
; overwrite CheckAfterEvent_ToAnimals
; used to ?
; should return true if AnimalsEvent is set
.org 0x80614C8
    push    r14
    mov     r0,AnimalsEvent
    bl      CheckEvent
    pop     r1
    bx      r1
; set animals event
; called by ? when ?
.org 0x8039804
    mov     r0,AnimalsEvent
    bl      SetEvent

; overwrite CheckOnEvent_SAXDefeated
; used to ?
; should return true if SaxDeadEvent is set
.org 0x80614F8
    push    r14
    mov     r0,SaxDeadEvent
    bl      CheckEvent
    pop     r1
    bx      r1
; overwrite CheckAfterEvent_SAXDefeated
; used to ?
; should return true if SaxDeadEvent is set
.org 0x8061510
    push    r14
    mov     r0,SaxDeadEvent
    bl      CheckEvent
    pop     r1
    bx      r1

; set escape event
; called by ? when ?
.org 0x8039E44
    mov     r0,EscapeEvent
    bl      SetEvent
