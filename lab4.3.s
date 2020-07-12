.data

.text

.global oblicz
.type oblicz, @function

oblicz:
push %rbp
movq %rsp,%rbp
#rdi ptr na string,rsi dlugosc

xorq %rcx,%rcx #licznik dlugosci
xorq %rdx,%rdx
xorq %r9,%r9
movq $1,%r10

petla:
movq %r10,%r8 #numer silni
movq $1,%rax 
movq $0,%rbx
silnia:
incq %rbx
mulq %rbx

decq %r8
cmpq $1,%r8
jge silnia

movb (%rdi,%rcx,1),%dl
subb $'0',%dl
mulq %rdx #pozycja*waga
addq %rax,%r9
incq %rcx
incq %r10

cmpq %rcx,%rsi #w rsi dlugosc
jg petla

movq %r9,%rax #wynik w rax

movq %rbp,%rsp
pop %rbp
ret
