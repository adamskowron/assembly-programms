
.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCES = 0

SYSOPEN = 2
SYSCLOSE = 3

BUFLEN = 512
plikodczyt1: .asciz "odczyt1"
plikodczyt2: .asciz "odczyt2"
plikzapis: .asciz "zapis"
komunikatbledu: .ascii "wystapil blad\n"
BLADDLUGOSC = .-komunikatbledu

.bss
.comm textin1,BUFLEN
.comm textin2 ,BUFLEN
.comm number1,BUFLEN
.comm number2,BUFLEN
.comm textout,BUFLEN
.comm out,BUFLEN

.text
.globl _start 
_start:

movq $SYSOPEN,%rax	#otwarcie pliku 1
movq $plikodczyt1,%rdi
movq $0,%rsi
movq $0666,%rdx
syscall

cmpq $0,%rax
jl blad

movq %rax,%r8 #handler pliku do r8

movq $SYSREAD,%rax      #zapisanie znakow z pliku1 do bufora
movq %r8,%rdi
movq $textin1,%rsi
movq $BUFLEN,%rdx 
syscall

decq %rax  #niewlicznie \n do ilosci znakow

movq %rax,%r10 #kopia ilosci znakow do r10

xorq %rsi,%rsi #zerowanie licznika

konwersja1:
movb textin1(,%rsi,1),%bl	#konwersja na reprezentacje szzesnastkowa
cmpb $'9',%bl
jle cyfra1
cmpb $'Z',%bl
jle duzalitera1

subb $'a',%bl  #jesli nie spelnily sie poprzednie warunki to musi to byc mala litera
addb $10,%bl

kontynuuj1.1:
movb %bl,textin1(,%rsi,1) 
incq %rsi
cmpq %rax,%rsi
jl konwersja1 #koniec konwersji

#w rax i rsi jest dlugosc wczytanego ciagu inddeksowanie od 1
xorq %rdx,%rdx
movq $2,%r9
divq %r9 #w rdx reszta z dzielenia przez 2 jak = 1 to nieparzysta dlugosc ciagu
movq %rsi,%rax #ilosc znakow z powrotem do rax

#rax i rsi sa sobie rowne
decq %rsi	#indeksowanie od 0(n-2)
decq %rsi	#rsi o 1 mniejsze od rax(n-1)
decq %rax

xorq %rcx,%rcx

sklejanie1:
movb textin1(,%rax,1),%bl
movb textin1(,%rsi,1),%bh
shlb $4,%bh
addb %bh,%bl
movb %bl,number1(,%rcx,1)
subq $2,%rax # decq %rax
subq $2,%rsi # decq %rsi
incq %rcx
cmpq $0,%rsi
jge sklejanie1  

cmpq $1,%rdx #jak ciag nieparzysty 
je ostatniznak1
kontynuuj1.2:

movq $SYSCLOSE,%rax	#zamkniecie pliku1
movq %r8,%rdi
syscall



movq $SYSOPEN,%rax      #otwarcie pliku 2
movq $plikodczyt2,%rdi
movq $0,%rsi
movq $0666,%rdx
syscall

cmpq $0,%rax
jl blad

movq %rax,%r8 #handler pliku do r8

movq $SYSREAD,%rax      #wczytanie znakow z pliku do bufora
movq %r8,%rdi
movq $textin2,%rsi
movq $BUFLEN,%rdx
syscall

decq %rax

movq %rax,%r15 #dlugosc drugiego pliku do r11

xorq %rsi,%rsi

konwersja2:
movb textin2(,%rsi,1),%bl       #konwersja na reprezentacje szzesnastkowa
cmpb $'9',%bl
jle cyfra2
cmpb $'Z',%bl
jle duzalitera2

subb $'a',%bl  #jesli nie spelnily sie poprzednie warunki to musi to byc mala litera
addb $10,%bl
kontynuuj2.1:
movb %bl,textin2(,%rsi,1) 
incq %rsi
cmpq %rax,%rsi
jl konwersja2  #koniec konwersji

#w rax i rsi jest dlugosc wczytanego ciagu inddeksowanie od 1
xorq %rdx,%rdx
movq $2,%r9
divq %r9 #w rdx reszta z dzielenia przez 2 jak = 1 to nieparzysta dlugosc ciagu
movq %rsi,%rax #ilosc znakow z powrotem do rax

#rax i rsi sa sobie rowne
decq %rsi	#indeksowanie od 0(n-2)
decq %rsi	#rsi o 1 mniejsze od rax(n-1)
decq %rax


xorq %rcx,%rcx
sklejanie2:
movb textin2(,%rax,1),%bl
movb textin2(,%rsi,1),%bh
shlb $4,%bh
addb %bh,%bl
movb %bl,number2(,%rcx,1)
subq $2,%rax # decq %rax
subq $2,%rsi # decq %rsi
incq %rcx
cmpq $0,%rsi
jge sklejanie2 

cmpq $1,%rdx #bylo 1
je ostatniznak2
kontynuuj2.2:

movq $SYSCLOSE,%rax
movq %r8,%rdi
syscall

#dodanie wczytanych liczb


movq %r10,%r12  #ciag 1 dluzszy kopia jego dlugosci do r12
xorq %rsi,%rsi

shrq %r10
shrq $3,%r10 #po sklejeniu ciag jest 2 razy krotszy

clc

movq number1(,%rsi,8),%rax
movq number2(,%rsi,8),%rbx
addq %rbx,%rax
movq %rax,textout(,%rsi,8)

pushf
incq %rsi

dodawanie:
movq number1(,%rsi,8),%rax
movq number2(,%rsi,8),%rbx
popf
adcq %rbx,%rax
pushf
movq %rax,textout(,%rsi,8)
incq %rsi
cmpq %r10,%rsi
jl dodawanie

shlq $4,%rsi


movq %rsi,%r13 #dlugosc wczytanego pliku do r13


xorq %rax,%rax
xorq %rdx,%rdx
xorq %rsi,%rsi
xorq %rcx,%rcx
xorq %rbx,%rbx

kontynuuj3:


#movb textout(,%rcx,1),%al
#incq %rcx
#movb textout(,%rcx,1),%al  #2 kolejne bajty do rejestru a



#---------------------------------------------

movq %r13,%rcx

konwersjaczworkowa:
movb textout(,%rsi,1),%al
movb %al,%bl

andq $3,%rax
movb %al,out(,%rcx,1)
movb %bl,%al
shrq $2,%rax
andq $3,%rax
#incq %rcx
decq %rcx
movb %al,out(,%rcx,1)
movb %bl,%al
shrq $4,%rax
andq $3,%rax
decq %rcx
movb %al,out(,%rcx,1)
movb %bl,%al
shrq $6,%rax
andq $3,%rax
decq %rcx
movb %al,out(,%rcx,1)
incq %rsi
#incq %rcx
decq %rcx
cmpq $0,%rcx
jge konwersjaczworkowa

movq $SYSWRITE,%rax
movq $STDOUT,%rdi
movq $out,%rsi
movq $BUFLEN,%rdx
syscall

int3

#--------------------------------------------

#xorq %r14,%r14


#konwersjaczworkowa:
#movq %rax,%rbx
#andq $3,%rbx #przepisanie 2 bitow
#addb $'0',%bl #konwersja na ascii
#movb %bl,out(,%rsi,1)
#shrq $2,%rax
#incq %rsi
#incq %r14
#cmpq $8,%r14 
#jl konwersjaczworkowa

#incq %rcx

#cmpq %r13,%rcx 
#jl kontynuuj3


movq $SYSOPEN,%rax      #otwarcie pliku do zapisu
movq $plikzapis,%rdi
movq $2,%rsi
movq $0666,%rdx
syscall

movq %rax,%r8

cmpq $0,%rax
jl blad


movq $SYSWRITE,%rax
movq %r8,%rdi
movq $out,%rsi
movq $BUFLEN,%rdx
syscall

movq $SYSCLOSE,%rax
movq %r8,%rdi
syscall


koniec:

movq $SYSEXIT,%rax
movq $EXIT_SUCCES,%rdi
syscall

blad:

movq $SYSWRITE,%rax
movq $STDOUT,%rdi
movq $komunikatbledu,%rsi
movq $BLADDLUGOSC,%rdx
syscall
jmp koniec

cyfra1:
subb $'0',%bl 
jmp kontynuuj1.1

duzalitera1:
subb $'A',%bl
addb $10,%bl
jmp kontynuuj1.1

ostatniznak1:
movb textin1(,%rax,1),%bl
movb %bl,number1(,%rcx,1)
jmp kontynuuj1.2


cyfra2:
subb $'0',%bl 
jmp kontynuuj2.1

duzalitera2:
subb $'A',%bl
addb $10,%bl
jmp kontynuuj2.1

ostatniznak2:
movb textin1(,%rax,1),%bl
movb %bl,number2(,%rcx,1)
jmp kontynuuj2.2

pierwszyciagdluzszy:
xorq %rdx,%rdx #zerowaanie rdx przed dzieleniem
movq %r10,%rax
movq $8,%r12
divq %r12
dodajostatniebajty1:
movq number1(,%rsi,8),%r12
movq %r12,textout(,%rsi,8)
incq %rsi
cmpq %rsi,%rax
jl dodajostatniebajty1

#cmpq $0,%rdx
#jne 

jmp kontynuuj3

drugiciagdluzszy:
xorq %rdx,%rdx #zerowaanie rdx przed dzieleniem
movq %r15,%rax
movq $8,%r12
divq %r12
dodajostatniebajty2:
movq number2(,%rsi,8),%r12
movq %r12,textout(,%rsi,8)
incq %rsi
cmpq %rsi,%rax
jl dodajostatniebajty2 

#cmpq $0,%rdx 
#jne 

jmp kontynuuj3

