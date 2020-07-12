
.text
.global startpomiar
.type startpomiar, @function

.global koniecpomiar
.type koniecpomiar, @function

#zwraca aktualny 
startpomiar:
    pushq %rbp
    movq %rsp,%rbp

    rdtsc       #wynik w edx:eax
    movl %eax,%ebx
    movl %edx,%eax
    shll $32,%eax
    movl %ebx,%eax	#w rax wynik 

    movq    %rbp, %rsp
    pop     %rbp
    ret



#jako argument czas rozpoczecia w rdi
koniecpomiar:
    pushq %rbp
    movq %rsp,%rbp

    rdtsc       #wynik w edx:eax
    movl %eax,%ebx
    movl %edx,%eax
    shll $32,%eax
    movl %ebx,%eax      #w rax wynik 

    subq %rdi,%rax

    movq    %rbp, %rsp
    pop     %rbp
    ret
