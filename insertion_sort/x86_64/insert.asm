
section .text:

global insertion_sort

; insertion_sort, c_decl, (int *data, int len)
insertion_sort:
    push rbx;
    push rdi;
    push rsi;
    push rbp; stack base
    mov rbp, rsp ;make ebp point to this point in the stack

    ; first argument is 6*4 = ebp+ 0x18 
%define INS_DATA rdi
%define INS_DATALEN rsi
.begin:
    mov rdx, INS_DATA  ; our array base pointer not gonna change
    mov rcx, INS_DATALEN ; length of array
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
        ;mov edi, eax;
        ; above is a redundancy
        mov rsi, [rdx+rbx]; this is the source int we're trying to find where it fits
        mov rdi, rbx ; holds next index (moved to)
        .find_loop:
            ; comparing pointers, if edi is below the bondary of our array then swap
            ; because it is the lowest value in the array
            mov rbp, [rdx+rax]
            mov [rdx+rdi],rbp
            ; to make space for the last inserted value
            test rax, rax
            jo .do_swap;
            ; if the value we're holding [edx+ebx] is still less than
            ; the value we're looking at which is behind it, then keep 
            ; looking for previous values until we find one or we reach the beginning of the array
            ;esi is being used as a temporary register
            sub rax, 0x8 
            sub rdi, 0x8 
            cmp rsi,[rdx+rax]
            jl .find_loop ; if it's larger then it will fall through to the swap part


        ; now esi is holding the value that we're trying to find where it fits
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

