
asm_p_u32: asm_p_u32.o
	ld -m elf_i386 -o asm_p_u32 print_u32.o
asm_p_u32.o:
	nasm -f elf -g -F stabs print_u32.asm

clean:
	rm *.o
	rm asm_p_u32

