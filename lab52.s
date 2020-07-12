.data
integer: .int 0
 
.text
.global sprawdz
.type sprawdz, @function

sprawdz:
    pushq %rbp
    movq %rsp,%rbp

    xorq %rax,%rax
    fstsw integer
    fwait
    movw integer, %ax #zapisanie status register do ax
    movw %ax,%bx      #kopia status register w bx

    andw $0x1,%ax
    cmpw $0x1,%ax
    je bit0
    dalej0:
    movw %bx,%ax #przywrocenie stanu poczatkowego
    andw $0x2,%ax
    cmpw $0x2,%ax
    je bit1
    movw %bx,%ax
    andw $0x4,%ax
    cmpw $0x4,%ax
    je bit2
    movw %bx,%ax
    andw $0x8,%ax
    cmpw $0x8,%ax
    je bit3
    movw %bx,%ax
    andw $0x10,%ax
    cmpw $0x10,%ax
    je bit4
    movw %bx,%ax
    andw $0x20,%ax
    cmpw $0x20,%ax
    je bit5
    movw %bx,%ax
    andw $0x40,%ax
    cmpw $0x40,%ax
    je bit6
    jmp koniec



    bit0:
    movq $0,%rax 
    jmp koniec

    bit1:
    movq $1,%rax  
    jmp koniec

    bit2:
    movq $2,%rax  
    jmp koniec

    bit3:
    movq $3,%rax 
    jmp koniec

    bit4:
    movq $4,%rax 
    jmp koniec

    bit5:
    movq $5,%rax 
    jmp koniec

    bit6:
    movq $6,%rax 


    koniec:
    int3

    movq     %rbp, %rsp
    pop     %rbp
    ret
