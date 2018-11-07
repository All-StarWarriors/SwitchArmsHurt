.global main
.func main

main:
    BL  _prompt             @ n input
    BL  _scanf
    MOV R4, R0
    BL  _prompt             @ m input
    BL  _scanf
    MOV R5, R0
    MOV R1, R4
    MOV R2, R0
    BL  _count_partitions
    MOV R1, R0
    MOV R2, R4
    MOV R3, R5
    BL  _printf
    B   _exit

_exit:
    MOV R7, #1
    SWI 0

_prompt:
    PUSH {R1}
    PUSH {R2}
    PUSH {R7}
    MOV R7, #4
    MOV R0, #1
    MOV R2, #26
    LDR R1, =prompt_str
    SWI 0
    POP {R7}
    POP {R2}
    POP {R1}
    MOV PC, LR

_printf:
    PUSH {LR}
    LDR R0, =printf_str
    BL printf
    POP {PC}                @ restore the stack pointer and return

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

_count_partitions:
    PUSH {LR}
    CMP R1, #0
    MOVEQ R0, #1
    POPEQ {PC}

    CMP R1, #0
    MOVLT R0, #0
    POPLT {PC}

    CMP R2, #0
    MOVEQ R0, #0
    POPEQ {PC}

    PUSH {R6-R7}
    MOV R6, R1
    MOV R7, R2
    SUB R1, R6, R7
    BL _count_partitions
    SUB R2, R7, #1
    MOV R7, R0
    MOV R1, R6
    BL _count_partitions
    ADD R0, R0, R7
    POP {R6,R7}
    POP {PC}

.data
number:         .word       0
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Enter a positive number: "
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d .\n"
