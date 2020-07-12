.text

.globl main
main:

movq $0,%rcx
movq $100,%rdx

loop:
incq %rcx
cmpq %rdx,%rcx
jl loop

int3
