
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

movq $SYSREAD,%rax	#wczytanie ciagu
movq $STDIN,%rdi
movq $textin,%rsi
movq $BUFLEN,%rdx
syscall

movb $2,%bl  #wartossc 2 do bl

movq %rax,%rsi  #przekopiowanie zawartosci rax do rsi
decq %rsi  #ilosc liter ustawiona na n-1
movq $0,%rcx	#ustawienie licznika na 0

zmianaznaku:

movb textin(,%rcx,1),%al
xorb %ah,%ah
divb %bl
cmpb $1,%ah	#reszta z dzielenia
je bezzmianyznaku

movb $0x20,%dh #stala 20 do dh
movb textin(,%rcx,1),%dl

xorb %dl,%dh #zmiana znaku
movb %dh,textout(,%rcx,1)

kontynuuj:
incq %rcx
cmpq %rsi,%rcx
jl zmianaznaku

movq $SYSWRITE,%rax
movq $STDOUT,%rdi
movq $textout,%rsi
movq $BUFLEN,%rdx
syscall

movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall

bezzmianyznaku:

movb %dl,textout(,%rcx,1)
jmp kontynuuj
