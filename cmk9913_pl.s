.global main
.func main
.extern printf

main:
        BL _prompt1
        BL _scanf1
        MOV R6, R0
        BL _prompt2
        BL _getchar
        MOV R5, R0
        BL _prompt3
        BL _scanf1
        MOV R2, R0
        MOV R1, R6
        MOV R3, R5
        MOV R0, #0
        CMP R3, #'+'
        ADDEQ R0, R1, R2

        CMP R3, #'-'
        SUBEQ R0, R1, R2

        CMP R3, #'*'
        MULEQ R0, R1, R2

        CMP R3, #'<'
        BLEQ _zer

        MOV R1, R0
        BL _printf
        B _exit

_prompt1:
        MOV R7, #4
        MOV R0, #1
        MOV R2, #44
        LDR R1, =prompt_str1
        SWI 0
        MOV PC, LR

_prompt2:
        MOV R7, #4
        MOV R0, #1
        MOV R2, #17
        LDR R1, =prompt_str2
        SWI 0
        MOV PC, LR

_prompt3:
        MOV R7, #4
        MOV R0, #1
        MOV R2, #10
        LDR R1, =prompt_str3
        SWI 0
        MOV PC, LR

_scanf1:
        PUSH {LR}
        SUB SP, SP, #4
        LDR R0, =percd
        MOV R1, SP
        BL scanf
        LDR R0, [SP]
        ADD SP, SP, #4
        POP {PC}

_getchar:
        MOV R7, #3
        MOV R0, #0
        MOV R2, #1
        LDR R1, =read_char
        SWI 0
        LDR R0, [R1]
        AND R0, #0xFF
        MOV PC, LR

_printf:
        MOV R4, LR
        LDR R0, =result
        BL printf
        MOV LR, R4
        MOV PC, LR

_zer:
        CMP R1, R2
        MOVLT R0, R1
        MOVGT R0, #0
        MOV PC, LR

_exit:
        MOV R7, #4
        MOV R0, #1
        MOV R2, #21
        LDR R1, =newline
        SWI 0
        MOV R7, #1
        SWI 0

.data
result:
.asciz "%d\n"
read_char:
.ascii " "
percd:
.asciz "%d"
prompt_str1:
.asciz "R1 + R2\nR1 - R2\nR1 * R2\nR1 < R2?\nEnter R1: "
prompt_str2:
.asciz "Enter operation: "
prompt_str3:
.asciz "Enter R2: "
newline:
.ascii "\n"