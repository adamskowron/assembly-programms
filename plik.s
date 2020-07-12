.data

STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512

.bss

.comm textin,BUFLEN
.comm textout,BUFLEN

.text

.globl _start

_start:

movq $SYSREAD, %rax   #wczytanie slowa
movq $STDIN, %rdi
movq $textin,%rsi
movq $BUFLEN,%rdx
syscall

decq %rax		#obnizenie o 1 dlugosci slowa zeby nie liczylo 0?
movq $0, %rsi		 #licznik ustawiany na 0


zamienlitery:

movb textin(,%rsi,1), %bh  #kolejny bajt ze slowa do rejestru 
movb $0x20, %bl		#roznica miedzy mala i duza literu do rejestru bl
xorb %bh, %bl		#xor zamienia male na duze i odwrotnie wynik w bl

movq %rsi,%rcx   #kopia licznika do rcx
andq $7,%rcx    #mod n-1 z rcx czyli licznika i wynik w rcx
cmpq $0, %rcx
jg zostawlitere

jmp zmienlitere

kontynuuj:

incq %rsi
cmpq %rax,%rsi
jl zamienlitery

movb $'\n',textout(,%rsi,1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout,%rsi
movq $BUFLEN,%rdx
syscall

movq $SYSEXIT,%rax
movq $EXIT_SUCCESS,%rdi
syscall

zostawlitere:

movb %bh,textout(,%rsi,1)
jmp kontynuuj

zmienlitere:

movb %bl,textout(,%rsi,1)
jmp kontynuuj
