.global main
.func main

main:
        BL _seedrand
        MOV R0, #0
writeloop:
        CMP R0, #10
        BEQ writedone
        LDR R1, =a
        LSL R2, R0, #2
        ADD R2, R1, R2
        STR R2, [R2]
        ADD R0, R0, #1
        B writeloop
writedone:
        MOV R0, #0
readloop:
        CMP R0, #10
        MOVEQ R0, #0
        BEQ maxloop
        LDR R1, =a
        LSL R2, R0, #2
        ADD R2, R1, R2
        LDR R1, [R2]
        PUSH {R0}
        PUSH {R1}
        PUSH {R2}
        MOV R2, R1
        MOV R1, R0
        BL _printf
        POP {R2}
        POP {R1}
        POP {R0}
        ADD R0, R0, #1
        B readloop
maxloop:
        CMP R0, #10
        MOVEQ R0, R4
        BLEQ _printmax
        @MOVEQ R0, #0
        BEQ _r
        LDR R1, =a
        LSL R2, R0, #2
        ADD R2, R1, R2
        LDR R1, [R2]
        CMP R0, #0
        MOVEQ R4, R1
        CMP R1, R4
        MOVGT R4, R1
        MOVGT R0, #0
        ADD R0, R0, #1
        B maxloop
_r:
        MOV R2, #0
        MOV R0, #0
        B minloop
minloop:
        CMP R0, #10
        MOVEQ R0, R4
        BLEQ _printmin
        BEQ _done
        LDR R1, =a
        LSL R2, R0, #2
        ADD R2, R1, R2
        LDR R1, [R2]
        CMP R0, #0
        MOVEQ R4, R1
        CMP R1, R4
        MOVLT R4, R1
        MOVLT R0, #0
        ADD R0, R0, #1
        B minloop
_done:
        B _exit

_exit:
        MOV R7, #4
        MOV R0, #1
        MOV R2, #21
        LDR R1, =exit_str
        SWI 0
        MOV R7, #1
        SWI 0

_printmax:
        MOV R4, LR
        LDR R0, =max_str
        BL printf
        MOV LR, R4
        MOV PC, LR

_printmin:
        MOV R4, LR
        LDR R0, =min_str
        BL printf
        MOV LR, R4
        MOV PC, LR

_printf:
        PUSH {LR}
        LDR R0, =printf_str
        BL printf
        POP {PC}

_seedrand:
        PUSH {LR}
        MOV R0, #0
        BL time
        MOV R1, R0
        BL srand
        POP {PC}

_getrand:
        PUSH {LR}
        BL rand
        POP {PC}

.data

.balign 4
a:      .skip   400
printf_str:     .asciz  "a[%d] = %d\n"
exit_str:       .ascii  "Terminating program.\n"
max_str:        .asciz  "Maximum = %d\n"
min_str:        .asciz  "Minimum = %d\n"