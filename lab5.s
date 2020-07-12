.data
integer: .int 0
 
.text
.global zmien
.type zmien, @function

zmien:
    pushq %rbp
    movq %rsp,%rbp

    xorq %rax,%rax
    fstcw integer
    fwait
    movw integer, %ax #zapisanie control register do ax 

    cmpq $1,%rdi
    je bit0
    cmpq $2,%rdi
    je bit1
    cmpq $3,%rdi
    je bit2
    cmpq $4,%rdi
    je bit3
    cmpq $5,%rdi
    je bit4
    cmpq $6,%rdi
    je bit5
    jmp koniec

    bit0:
    xorw $0x1,%ax # 0000 0000 0000 0001 not ostatniego bitu 
    jmp koniec

    bit1:
    xorw $0x2,%ax # 0000 0000 0000 0010 
    jmp koniec

    bit2:
    xorw $0x4,%ax #0000 0000 0000 0100 
    jmp koniec

    bit3:
    xorw $0x8, %ax #0000 0000 0000 1000
    jmp koniec

    bit4:
    xorw $0x10, %ax #0000 0000 0001 0000
    jmp koniec

    bit5:
    xorw $0x20, %ax # 0000 0000 0010 0000

    koniec:
    int3
    movw     %ax, integer
    fldcw   integer
    int3

    movq     %rbp, %rsp
    pop     %rbp
    ret
