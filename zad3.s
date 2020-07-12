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
.globl _start:
_start:

movq $SYSREAD,%rax
movq $STDIN,%rdi
movq $textin,%rsi
movq $BUFLEN,%rdx
syscall

