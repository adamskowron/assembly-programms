.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCES = 0
BUFLEN = 512

napis: .ascii "podaj ciag znakow\n"
napis_dlugosc = .-napis

.bss
.comm textin,BUFLEN
.comm textout,BUFLEN

.text
.globl _start

_start:

movq $SYSWRITE,%rax #wypisanie wiadomosci powitalnej
movq $STDOUT,%rdi
movq $napis,%rsi
movq $napis_dlugosc,%rdx
syscall

movq $SYSREAD,%rax #wczytanie znakow do textin
movq $STDIN,%rdi
movq $textin,%rsi
movq $BUFLEN,%rdx
syscall

decq %rax	#dec licznika znakow textin

movq $-1,%rcx # ustawienie licznika na 0


rozpoznajznak:
incq %rcx
movb textin(,%rcx,1),%bl

cmpb $0x40,%bl #skrajne najmniejsze
jle znakbezzmian

cmpb $0x7B,%bl		#skrajne najwieksze
jge znakbezzmian

cmpb $0x5B,%bl		
jge zakres

zmienznak:
movb $0x20,%dh
xor %bl,%dh
movb %dh,textout(,%rcx,1)
cmpq %rax,%rcx
jl rozpoznajznak
jmp koniec

znakbezzmian:
movb textin(,%rcx,1), %dl
movb %dl,textout(,%rcx,1)
cmpq %rax,%rcx
jl rozpoznajznak

koniec:
movq $SYSWRITE,%rax #wypisanie wyniku
movq $STDOUT,%rdi
movq $textout,%rsi
movq $BUFLEN,%rdx
syscall

movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall


zakres:
cmpb $0x60,%bl
jle znakbezzmian
jg zmienznak
