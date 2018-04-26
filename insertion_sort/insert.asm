
section .text:

global insertion_sort

; insertion_sort, c_decl, (int *data, int len)
insertion_sort:
    push ebx;
    push edi;
    push esi;
    push ebp; stack base
    mov ebp, esp ;make ebp point to this point in the stack

    ; first argument is 6*4 = ebp+ 0x18 
%define INS_DATA [ebp+0x14]
%define INS_DATALEN [ebp+0x18]
.begin:
    mov edx, INS_DATA  ; our array base pointer not gonna change
    mov ecx, INS_DATALEN ; length of array
    shl ecx, 2 ; ecx*=4
    jz .fail
    test edx,edx ;null pointer check
    jz .fail

    xor eax,eax ; idx = 0
    xor ebx,ebx ; second index
    .loop:
        add ebx, 0x4 ;
        cmp ebx, ecx;
        je .success
        mov esi, [edx+ebx]
        cmp [edx+eax], esi
        jg .need_correction
        mov eax, ebx
        jmp .loop
   
    ; find position to insert
    .need_correction:
        ;mov edi, eax;
        ; above is a redundancy
        mov esi, [edx+ebx]; this is the source int we're trying to find where it fits
        mov edi, ebx ; holds next index (moved to)
        .find_loop:
            ; comparing pointers, if edi is below the bondary of our array then swap
            ; because it is the lowest value in the array
            mov ebp, [edx+eax]
            mov [edx+edi],ebp
            ; to make space for the last inserted value
            test eax, eax
            jo .do_swap;
            ; if the value we're holding [edx+ebx] is still less than
            ; the value we're looking at which is behind it, then keep 
            ; looking for previous values until we find one or we reach the beginning of the array
            ;esi is being used as a temporary register
            sub eax, 0x4 
            sub edi, 0x4 
            cmp esi,[edx+eax]
            jl .find_loop ; if it's larger then it will fall through to the swap part


        ; now esi is holding the value that we're trying to find where it fits
        .do_swap:
            mov [edx+edi], esi
            mov eax, ebx
            jmp .loop



.fail:
    mov eax, -1;
    jmp .end
.success:
    mov eax, 0;


.end:
    mov ebp, esp
    leave
    pop esi;
    pop edi;
    pop ebx;
    ret

