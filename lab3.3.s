
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

.text

.globl _start
_start:

movq $SYSREAD,%rax
movq $STDIN,%rdi
movq $textin,%rsi
movq $BUFLEN,%rdx
syscall

decq %rax
 
movq %rax,%r8  #dlugosc ciagu do r8
movq %rax,%r11 #dlugosc do r11
xorq %rcx,%rcx  #zerowanie rejestrow rcx i rbx
xorq %rbx,%rbx
xorq %r10,%r10
xorq %rsi,%rsi
movq $10,%r12   #stala 10 do r12

wpiszliczbe:
movq %r8,%r9 #w r8 i r9 jest dlugosc

cmpq $1,%r9 
je potega0
cmpq $2,%r9 
je potega1

movq $10,%rax

potega:         #funkcja ma zaladowac do rax odpowiedni mnoznik dla danej pozycji 10^i
mulq %r12      #rax razy 10 i wynik w rax       
decq %r9
cmpq $2,%r9     
jg potega       

pominpotegowanie:

movb textin(,%rsi,1),%bl
subb $'0',%bl  #zamienienie wczytanego znaku ascii na cyfre
mulq %rbx #pomnozenie rax i rbx czyli wczytanego znaku wynik w rax wartosc*10^i

addq %rax,%rcx  #liczba wczytana ostatecznie w rcx
incq %rsi
decq %r8
cmpq %rsi,%r11
jg wpiszliczbe

#------------- w rcx liczba wczytana

pushq %rcx  # argument na stos
call recf
pop %rax
int3


movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall


.type recf, @function
recf:
pushq %rbp
movq %rsp,%rbp

movq 16(%rbp),%rcx  #argument ze stosu do rejestru rcx

#w rcx n
movq $5,%r8	#stala do mnozenia
movq $3,%rbx  #f(n-2)
movq $1,%rax  #f(n-1)
cmpq $0,%rcx
je n1
cmpq $1,%rcx
je out

decq %rcx
decq %rcx

rec:
movq %rax,%r9
mulq %r8
subq %rax,%rbx #w rbx wynik
xchg %rax,%rbx
movq %r9,%rbx
decq %rcx
cmpq $0,%rcx
jge rec


movq %rax,16(%rbp)  #wynik na stos

out:
movq %rbp,%rsp
popq %rbp
ret

n1:
pushq %rbx
jmp out


potega0:
movq $1,%rax
jmp pominpotegowanie

potega1:
movq $10,%rax
jmp pominpotegowanie


