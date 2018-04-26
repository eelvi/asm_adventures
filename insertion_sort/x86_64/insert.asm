
; github/eelvi
; see the x86 version for more comments, this is a slightly modified version of
; it to use 64bit integers


section .text:

global insertion_sort

; insertion_sort, SYSTEM V 64 call convention(i guess), (int *data, int len)
insertion_sort:
    push rbx;
    push rdi;
    push rsi;
    push rbp; stack base
    mov rbp, rsp ;make ebp point to this point in the stack

%define INS_DATA rdi
%define INS_DATALEN rsi
.begin:
    mov rdx, INS_DATA  
    mov rcx, INS_DATALEN 
    shl rcx, 3 ; ecx*=8
    jz .fail
    test rdx,rdx ;null pointer check
    jz .fail

    xor rax,rax ; idx = 0
    xor rbx,rbx ; second index
    .loop:
        add rbx, 0x8 ;
        cmp rbx, rcx;
        je .success
        mov rsi, [rdx+rbx]
        cmp [rdx+rax], rsi
        jg .need_correction
        mov rax, rbx
        jmp .loop
   
    ; find position to insert
    .need_correction:
        mov rsi, [rdx+rbx]; this is the source int we're trying to find where it fits
        mov rdi, rbx ; holds next index (moved to)
        .find_loop:
            mov rbp, [rdx+rax]
            mov [rdx+rdi],rbp
            test rax, rax
            jo .do_swap;
            sub rax, 0x8 
            sub rdi, 0x8 
            cmp rsi,[rdx+rax]
            jl .find_loop 


        .do_swap:
            mov [rdx+rdi], rsi
            mov rax, rbx
            jmp .loop



.fail:
    mov rax, -1;
    jmp .end
.success:
    mov rax, 0;


.end:
    mov rbp, rsp
    leave
    pop rsi;
    pop rdi;
    pop rbx;
    ret

