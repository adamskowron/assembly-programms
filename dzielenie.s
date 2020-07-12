.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCES = 0
BUFLEN = 512


.bss
.comm textout,BUFLEN

.text

.globl _start
_start:

movw $17,%ax
movb $3,%bl
divb %bl

movq $0,%rcx

addb $'0',%ah
addb $'0',%al
movb %al,textout(,%rcx,1)
incq %rcx
movb %ah,textout(,%rcx,1)
incq %rcx
movb $'\n',textout(,%rcx,1)

movq $SYSWRITE,%rax
movq $STDOUT,%rdi
movq $textout,%rsi
movq $BUFLEN,%rdx
syscall

movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall

