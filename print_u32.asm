;
;
;
; a couple of subroutines to print unsigned integers in linux without relying on something like printf
; another print a new line
;
;   tested and was found to work as expected, at least 99.7% of the time
;

section .data
section .text

    global _start

_start:
            nop ; first instruction, no operation

            mov eax, 12345 ;  move 12345 to eax
            call print_u32; print the integer
            call print_nl; print a new line charecter to make things prettier a little

            mov eax, 1337; move 1337 to eax
            call print_u32; print the integer
            call print_nl; print a new line charecter to make things prettier a little

            ;end of the program
            mov eax, 1;
            mov ebx, 0;
            int 80h; end program

            nop ; last instruction, no operation


base: equ 10 ;
ascii_num: equ 48; ascii of '0'


                ;
                ;       Print unsigned integer(32bit or less)
                ;       arguments: eax; prints it
                ;       return value: none
                ;

    print_u32:             

            push ebp; store stack base ptr in the stack
            push eax ; keep a copy of the number

            mov ebp, esp;  make the top of the stack our stack base pointer

            mov ecx, 2; minimum length 
            sub esp, ecx ; the minimum length we need to keep as a buffer on the stack, it will be increased
                         ; as needed by the following loop

            mov byte [esp-1], 0 ; move the null terminator to what's after the top of the stack 
                                ; it's not needed to have a '\0' in linux system calls but it
                                ; might be useful for something else to have a null terminated string


loop_a1:    
            ;(dividend lowerbits) are already in eax
            mov edx, 0 ; dividened higher bits
            mov ebx, base; move the divisor (10) to ebx
            div ebx ; divide by the base (10) storing quotient in eax, remainder in edx
            add edx,ascii_num ; convert the remainder to the appropriate ascii symbol
            mov byte [esp],dl ; move the remainder byte to the top of the stack (lowest address because we're doing it
                              ; backwards )
            or eax,eax ; test whether quotient is zero
            jz loop_a1_end ; end the loop if the quotient is zero
            inc ecx; increment our length counter
            dec esp; decrement our stack pointer ( to have more space for the preceding charecters )
            jmp loop_a1 ; continue the loop

loop_a1_end:
            

            mov eax, 4 ; write to file syscall
            mov ebx, 1 ; file 1 stdout
            mov edx, ecx ; edx is the length of the string (this is the 4th argument)
            mov ecx, esp ; ecx is the string ptr it is our stack base +1 (this is the 3d argument)
            ;inc ecx; the plus 1

            int 80h ; system interrupt to print

           mov esp,ebp ; restore the base stack pointer
           pop eax ; not to forget the copy of number that is probably useless
           pop ebp; restore the caller's stack baseptr so he's happy
           ret ;

           nop; 




            ;
            ;   print new line
            ;   arguments: none
            ;   return value: none
            ;
new_line_char: equ 10 ; ascci '\n'

print_nl:
            push ebp; store the caller's ebp
            mov ebp, esp; make the current stack pointer our boundary
            
            sub esp, 1 ; reserve 1 byte in the stack to add our newline charecter
            mov byte [esp], new_line_char ; move the new line charecter
            
            mov eax, 4 ; file write syscall
            mov ebx, 1 ; stdout file
            mov ecx, esp ; the address of our byte
            mov edx, 1; the length of our message

            int 80h; system interrupt
            
            
            ; oops forgot to add the next instruction, destroyed the stack in the process, not a big deal 
            mov esp,ebp ;  we no longer need the byte we reserved

            pop ebp; restore the caller's ebp
            ret ; return

            nop ; 


section .bss


section .bss
