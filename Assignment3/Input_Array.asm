;This is a library function distributed without accompanying software.                                                      *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public   *
;License version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be   *
;useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.*
;See the GNU General Public License for more details.  A copy of the GNU Lesser General Public License 3.0 should have been *
;distributed with this function.  If the LGPL does not accompany this software then it is available here:                    *
;<https:;www.gnu.org/licenses/>.  
;
;Author information
; Author name: Joseph Haddad
;
;Program information
;  Program name: Array Sum
;  Programming languages: 2 modules in C++, 3 module in X86-64, and 1 module in Bash.
;  Date program began: 2020-Sep-29
;  Date of last update: 2020-Oct-5
;  Status: This program was tested by the author many times.
;
;This file
;  Name: Input_Array.asm
;  Language: X86
;  Syntax: Intel
;  Assemble: nasm -f elf64 -l Input_Array.lis -o Input_Array.o Input_Array.asm
;  Purpose: Take in user input to array after varifying legitimacy of values
;
;
;===== Begin code area =======================================================================================
extern isinteger
extern atolong
extern printf
extern scanf                                     ;External C++ function for writing to standard output device
global Input_Array

segment .data                                     ;Place initialized data here

messageinvalid db "Invalid input please retry:",10,0

integerformat db "%ld", 0                         ;general decimal integer
stringformat db "%s", 0                           ;general string format



segment .bss                                      ;Place un-initialized data here.

segment .text                                     ;Place executable instructions in this segment.
Input_Array:							              ;Entry point.  Execution begins here.

;=========== Back up all the integer registers used in this program =======================================================
;Omitted from back up are rax, rip.
push       rbp                                    ;Save a copy of the stack base pointer
mov        rbp, rsp                               ;We do this in order to be 100% compatible with C and C++.
push       rbx                                    ;Back up rbx
push       rcx                                    ;Back up rcx
push       rdx                                    ;Back up rdx
push       rsi                                    ;Back up rsi
push       rdi                                    ;Back up rdi
push       r8                                     ;Back up r8
push       r9                                     ;Back up r9
push       r10                                    ;Back up r10
push       r11                                    ;Back up r11
push       r12                                    ;Back up r12
push       r13                                    ;Back up r13
push       r14                                    ;Back up r14
push       r15                                    ;Back up r15
pushf                                             ;Back up rflags
push qword 0



mov r12, 0
mov r14, rdi
mov r15, rsi
;=========== Input array ============================================================================================================================
retry:

push qword 0
mov qword  rax,0
mov      rdi, stringformat
mov      rsi, rsp

call scanf                        ;read in array as string





;===========ctrl - D ==============================================
cdqe
cmp rax, -1
je ctrld
;========== check validity ==============================================================================================
mov qword  rax, 0
mov      rdi, rsp
        
call isinteger                    ;external library
mov      r13, rax
cmp      r13, 1
je validprocess

;tell user to retry
mov qword  rax, 0
mov      rdi, stringformat
mov      rsi, messageinvalid
pop r8
call printf

jmp retry

validprocess:

mov qword  rax, 0
mov rdi, rsp
call atolong   ;professors function file he gave

mov [r14+8*r12], rax   ;r14 holds arr   
inc r12
pop r8

cmp r12, r15
je jumpend
;else

jmp retry
ctrld:
pop r8
jumpend:



;=========== Now cleanup and return to the caller =========================================================================

mov rax,r12



pop r8; poop pop
popf                                              ;Restore rflags
pop        r15                                    ;Restore r15
pop        r14                                    ;Restore r14
pop        r13                                    ;Restore r13
pop        r12                                    ;Restore r12
pop        r11                                    ;Restore r11
pop        r10                                    ;Restore r10
pop        r9                                     ;Restore r9
pop        r8                                     ;Restore r8
pop        rdi                                    ;Restore rdi
pop        rsi                                    ;Restore rsi
pop        rdx                                    ;Restore rdx
pop        rcx                                    ;Restore rcx
pop        rbx                                    ;Restore rbx
pop        rbp                                    ;Restore rbp


ret
;====== The End ===========================================================================================================
