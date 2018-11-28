.global main
.func main

main:
    MOV R0, #0              @ initialze index variable
    B writeloop
writeloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    PUSH {R0}
    BL _scanf
    LDR R1, =a    @ get address of a
    MOV R3, R0
    POP {R0}
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    STR R3, [R2]            @ write the address of a[i] to a[i]
    @POP {R0}
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration

_scanf:
    PUSH {LR}
    PUSH {R1}
    SUB SP, SP, #4
    LDR R0, =format_str
    MOV R1, SP
    BL scanf
    LDR R0, [SP]
    ADD SP, SP, #4
    POP {R1}
    POP {PC}

writedone:
    MOV R0, #0              @ initialze index variable
    B readloop
readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    PUSH {R0}
    LDR R1, =a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration

readdone:
    BL _prompt
    BL _scanf
    MOV R3, R0
    MOV R0, #0
    MOV R4, #0
    B searchit

searchit:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ checkit            @ exit loop if done
    PUSH {R0}
    LDR R1, =a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    CMP R3, R1
    MOVEQ R4, #1
    PUSHEQ {R1}               @ backup register before printf
    PUSHEQ {R2}               @ backup register before printf
    MOVEQ R2, R1              @ move array value to R2 for printf
    MOVEQ R1, R0              @ move array index to R1 for printf
    BLEQ  _printf             @ branch to print procedure with return
    POPEQ {R2}                @ restore register
    POPEQ {R1}                @ restore register
    POPEQ {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    CMP R0, #10
    CMPEQ R4, #0
    BEQ _printit
    B   searchit            @ branch to next loop iteration

checkit:
    @CMP R4, #0
    @BLEQ _printit
    B _exit

_printit:
    MOV R7, #4
    MOV R0, #1
    MOV R2, #41
    LDR R1, =otherp_str
    SWI 0
    B _exit

_prompt:
    PUSH {R1}
    PUSH {R2}
    PUSH {R7}
    MOV R7, #4
    MOV R0, #1
    MOV R2, #22
    LDR R1, =prompt_str
    SWI 0
    POP {R7}
    POP {R2}
    POP {R1}
    MOV PC, LR

_exit:
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

.data

.balign 4
a:              .skip       400
format_str:     .asciz      "%d"
printf_str:     .asciz      "a[%d] = %d\n"
prompt_str:     .asciz      "ENTER A SEARCH VALUE: "
otherp_str:     .asciz      "That value does not exist in the array!\n"