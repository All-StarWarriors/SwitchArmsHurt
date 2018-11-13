.global main
.func main

main:
    BL _prompt
    BL _scanf
    MOV R4, R0
    BL _prompt
    BL _scanf
    MOV R5, R0
    MOV R1, R4
    MOV R2, R0
    BL _printf

    MOV R1, R5
    MOV R0, R4

    BL _divide
    MOV R1, R0
    BL  _result      @ print the result
    B   main

_result:
    PUSH {LR}
    LDR R0, =result_str
    BL printf
    POP {PC}

_printf:
    PUSH {LR}
    LDR R0, =math_str
    BL printf
    POP {PC}

_prompt:
    PUSH {R1}
    PUSH {R2}
    PUSH {R7}
    MOV R7, #4
    MOV R0, #1
    MOV R2, #19
    LDR R1, =prompt_str
    SWI 0
    POP {R7}
    POP {R2}
    POP {R1}
    MOV PC, LR

_scanf:
    PUSH {LR}
    PUSH {R1}
    LDR R0, =format_str
    SUB SP, SP, #4
    MOV R1, SP
    BL scanf
    LDR R0, [SP]
    ADD SP, SP, #4
    POP {R1}
    POP {PC}

_divide:
    PUSH {LR}
    VMOV S0, R0
    VMOV S1, R1
    VCVT.F32.S32 S0, S0     @ U32 for unsigned. S32 for signed.
    VCVT.F32.S32 S1, S1     @ U32 for unsigned. S32 for signed.

    VDIV.F32 S2, S0, S1

    VCVT.F64.F32 D4, S2
    VMOV R1, R2, D4
    MOV R0, R1
    POP {PC}

.data
number:         .word       0
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Enter an integer: "
math_str:       .asciz      "%d / %d = "
result_str:     .asciz      "%f \n"