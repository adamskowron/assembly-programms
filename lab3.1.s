.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCES = 0

BUFLEN = 512


.bss
.comm text,BUFLEN

.text

.globl _start
_start:

movq $SYSREAD,%rax
movq $STDIN,%rdi
movq $text,%rsi
movq $BUFLEN,%rdx
syscall
decq %rax


xorq %rcx,%rcx
movq $text,%rdx
call find
int3

movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall

.type find, @function
find:
cmpq %rax,%rcx
jg error
movb (%rdx,%rcx,1),%bl #w rax dlugosc ciagu w rcx licznik
incq %rcx
cmpb $'a',%bl
jne find
cmpq %rax,%rcx
jg error
movb (%rdx,%rcx,1),%bl
incq %rcx
cmpb $'b',%bl
jne find
cmpq %rax,%rcx
jg error
movb (%rdx,%rcx,1),%bl
incq %rcx
cmpb $'c',%bl
jne find
cmpq %rax,%rcx
jg error

subq $3,%rcx
ret

error:
movq $-1,%rcx
ret
