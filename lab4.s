.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCES = 0
BUFLEN = 512

format_d: .asciz "%d"
format_f: .asciz "%f"
text: .asciz "%lf\n%lf"
float: .float 6.3
double1: .double 4.7
double2: .double 2.9

.bss
.comm buf1,BUFLEN
.comm buf2,BUFLEN

.text
.globl f
.globl main
main:

pushq %rbp
movq %rsp,%rbp

#pobranie liczby calkowitej za pomoca scanf
movq $0,%rax
movq $format_d,%rdi #pierwszy parametr dla scanf
movq $buf1,%rsi #adres bufora dla scanf jako drugi parametr
call scanf #wywolanie scanf


#pobranie liczby zmiennoprzecinkowej za pomoca scanf
movq $0,%rax
movq $format_f,%rdi
movq $buf2,%rsi
call scanf


#wywolanie funkcji
movq $1,%rax #ilosc argumentow zmiennoprzecinkowych
xorq %rcx,%rcx
movq buf1(,%rcx,4),%rdi
movss buf2,%xmm0
call f


#dwukrotne wypisanie wyniku za pomoca pojedynczego wywolania funkcji printf %lf\n%lf
movq $2,%rax
movq $text,%rdi
movsd %xmm0,%xmm1
call printf
#int3

xorq %rax,%rax
movq %rbp,%rsp
pop %rbp
ret
