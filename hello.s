    .global main
    .extern printf

    .section .rdata
msg:
    .asciz "hello world\n"

    .section .text
main:
    subq $40, %rsp
    leaq msg(%rip), %rcx
    call printf
    movq $0, %rax
    addq $40, %rsp
    ret
