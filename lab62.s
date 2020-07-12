
.data

short: .short 2,2,2,2

.text
.global wektor
.type wektor, @function

#rdi i rsi tablice wejeciowe rdx tablica wyjsciowa rcx ilosc liczb
wektor:
    pushq %rbp
    movq %rsp,%rbp

    xorq %rbx,%rbx
    movq short,%mm3

loop:
    movq (%rdi,%rbx,8),%mm0

    movq (%rsi,%rbx,8),%mm1

    paddw %mm1,%mm0	#dodanie wektorow

    pmullw %mm3,%mm0

    movq %mm0,(%rdx,%rbx,8)

    incq %rbx
    cmpq %rcx,%rbx
    jl loop

    movq    %rbp, %rsp
    pop     %rbp
    ret
