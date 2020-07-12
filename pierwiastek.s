.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCES = 0
BUFLEN = 512

komunikat: .ascii "podano zla sekwencje znakow"
komunikat_dl = .-komunikat

.bss

.comm textin,BUFLEN
.comm textout,BUFLEN

.text
.globl _start
_start:

movq $SYSREAD,%rax #wczytanie do textin z klawiatury w rax dlugosc
movq $STDIN,%rdi
movq $textin,%rsi
movq $BUFLEN,%rdx
syscall

decq %rax	#niewliczanie \n
xorq %rcx,%rcx #wyzerowanie rcx licznik

sprawdzznaki:

movb textin(,%rcx,1),%bl	#znak do bl
cmpb $'0',%bl
jl zlyznak
cmpb $'9',%bl
jg zlyznak

incq %rcx
cmpq %rax,%rcx
jl sprawdzznaki
 
movq %rax,%r8  #dlugosc ciagu do r8
movq %rax,%r11 #dlugosc do r11
xorq %rcx,%rcx	#zerowanie rejestrow rcx i rbx
xorq %rbx,%rbx
xorq %r10,%r10
movq $10,%r12	#stala 10 do r12

wpiszliczbe:
movq %r8,%r9 #w r8 i r9 jest dlugosc

cmpq $1,%r9 
je potega0
cmpq $2,%r9 
je potega1

movq $10,%rax

potega:		#funkcja ma zaladowac do rax odpowiedni mnoznik dla danej pozycji 10^i
mulq %r12      #rax razy 10 i wynik w rax	
decq %r9
cmpq $2,%r9	
jg potega 	

pominpotegowanie:


movb textin(,%rcx,1),%bl
subb $'0',%bl  #zamienienie wczytanego znaku ascii na cyfre
mulq %rbx #pomnozenie rax i rbx czyli wczytanego znaku wynik w rax wartosc*10^i

addq %rax,%r10  #liczba wczytana ostatecznie w r10
incq %rcx
decq %r8
#cmpq %rcx,%r8	
#jg wpiszliczbe #tu b	
cmpq %rcx,%r11
jg wpiszliczbe


#movb textin(,%rcx,1),%bl
#subb $0x30,%bl
#addq %rbx,%r10	#to tez

xorq %rcx,%rcx
xorq %rdx,%rdx


pierwiastek:
incq %rcx       #wynik pierwiastkowania w rcx 
movq %rcx,%rax	#licznik skopiowany do rax

shlq %rax	 #2*licznik
decq %rax 	#2*licznik -1 
addq %rax,%rdx	#sumowanie kolejnych wartosci wg wzoru
cmpq %r10,%rdx   
jl pierwiastk

decq %rcx

movq %rcx,%rax	#wynik pierwiastkowania do rax
xorq %rsi,%rsi


policzznakiwyniku:
xorq %rdx,%rdx #zerowanie rdx przed kazdym dzieleniem
divq %r12  #wynik w rax, w r12 stala 10
incq %rsi	#ilosc znakow w rsi
cmpq $0,%rax	
jg policzznakiwyniku


movq %rcx,%rax	#kopiowanie wyniku pierwiastkowania do rax
xorq %rdx,%rdx	#wyzerowanie rdx przed dzieleniem rdx:rax/op wynik w rax reszta w rdx

movb $'\n',textout(,%rsi,1)
decq %rsi #indeksowanie od 0

wyswietlwynik:
xorq %rdx,%rdx
divq %r12	#w rdx reszta z dzielenia

addb $'0',%dl	#zamiana ascii na cyfre 0x30

movb %dl,textout(,%rsi,1)
decq %rsi

cmpq $0,%rsi	
jge wyswietlwynik  

movq $SYSWRITE,%rax
movq $STDOUT,%rdi
movq $textout,%rsi
movq $BUFLEN,%rdx
syscall


koniec:
movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall

zlyznak:
movq $SYSWRITE,%rax
movq $STDOUT,%rdi
movq $komunikat,%rsi
movq $komunikat_dl,%rdx
syscall
jmp koniec

potega0:
movq $1,%rax
jmp pominpotegowanie

potega1:
movq $10,%rax
jmp pominpotegowanie


