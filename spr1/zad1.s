
.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCES = 0
BUFLEN = 512


.bss
.comm textin,BUFLEN
.comm textout,BUFLEN

.text
.globl _start

_start:

movq $SYSREAD,%rax #wczytanie znakow do textin
movq $STDIN,%rdi
movq $textin,%rsi
movq $BUFLEN,%rdx
syscall

decq %rax       #dec licznika znakow textin

movq $0,%rcx # ustawienie licznika na 0


rozpoznajznak:
movb textin(,%rcx,1),%bl
cmpb $0x30,%bl
jl inne
cmpb $0x39,%dl
jle cyfry
cmpb $0x40,%dl
jle inne
cmpb $0x5a,%dl
jle literyduze
jg inne
kontynuuj:
incq %rcx
cmpq %rax,%rcx
jl rozpoznajznak

movq $SYSWRITE,%rax #wypisanie wyniku
movq $STDOUT,%rdi
movq $textout,%rsi
movq $BUFLEN,%rdx
syscall

movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall

inne:
movb %bl,textout(,%rcx,1)
jmp kontynuuj

cyfry:
addb $5,%bl
movb %bl,textout(,%rcx,1)
jmp kontynuuj

literyduze:
addb $3,%bl
movb %bl,textout(,%rcx,1)
jmp kontynuuj

