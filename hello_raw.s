    .global _start
    .extern GetStdHandle
    .extern WriteFile
    .extern ExitProcess

    .section .data
msg:
    .ascii "Hello World from pure Assembly!\n"
    .set msg_len, . - msg

    .section .bss
bytes_written:
    .space 4

    .section .text
_start:
    # Cấp phát shadow space theo chuẩn gọi hàm Windows x64 (32 bytes) + 8 bytes padding
    subq $40, %rsp

    # Gọi GetStdHandle(STD_OUTPUT_HANDLE = -11)
    movq $-11, %rcx
    call GetStdHandle

    # Gọi WriteFile(hConsole, msg, msg_len, &bytes_written, NULL)
    movq %rax, %rcx                # Tham số 1: hConsole (kết quả từ GetStdHandle)
    leaq msg(%rip), %rdx           # Tham số 2: con trỏ chuỗi
    movq $msg_len, %r8             # Tham số 3: độ dài chuỗi
    leaq bytes_written(%rip), %r9  # Tham số 4: con trỏ lưu số byte đã ghi
    movq $0, 32(%rsp)              # Tham số 5: lpOverlapped = NULL (đẩy vào stack)
    call WriteFile

    # Gọi ExitProcess(0)
    movq $0, %rcx
    call ExitProcess
