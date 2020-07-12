.data

minus: .double -1.0
one: .double 1.0 

.text
.global taylor
.type taylor, @function

taylor:
    pushq %rbp
    movq %rsp,%rbp

    #rdi = ilosc iteracji
    #xmm0 = argument wejsciowy x

    #ln(x+1) = x - x^2/2 + x^3/3 - x^4/4.... dla x w przedziale (-1,1]

    subq $8,%rsp
    movsd %xmm0,(%rsp)
    fld1	#st(5) = 1 stala do inkrementacji mianownika
    fldz	#st(4) = 0 miejsce do przechowania aktualnego skladnika sumy
    fldl (%rsp)	#st(3) = x argument wejsciowy
    fldz 	#st(2) = 0 suma,wynik
    fldz	#st(1) = 0 mianownik
    fldl minus	#st(0) = -1 licznik
    fwait

    xorq %rcx,%rcx	#licznik petli

loop:
    fxch %st(1)		#!!!!!!
    faddl one		#zwiekszenie mianownika o 1 !!!!
    fxch %st(1)		#!!!!!!!
    fmull minus		#zmiana znaku licznika
    fmul %st(3),%st(0)	#licznik jako kolejna potega x
    fst %st(4)		#kopia licznika do st4
    fdiv %st(1),%st(0)	#dzielenie licznika przez mianownik,wynik w st(0)
    fadd %st(0),%st(2)	#dodanie wartosci do wyniku
    fxch %st(4)		#przywrocenie wartosci x^n w st(0) poprzez wymiane z st(4)

    incq %rcx
    cmpq %rdi,%rcx
    jl loop

    fxch %st(2)		#wynik w st(0)
    fstpl (%rsp)
    movsd (%rsp),%xmm0

    movq    %rbp, %rsp
    pop     %rbp
    ret
