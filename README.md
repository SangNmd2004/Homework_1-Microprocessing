# Homework 1: Microprocessing - Hello World Comparison

Bài tập này trình bày một chương trình "Hello World" đơn giản được viết bằng 3 ngôn ngữ khác nhau (Python, C, và x86_64 Assembly). Mục tiêu là so sánh kích thước file thực thi và thời gian chạy giữa các ngôn ngữ.

## Danh sách mã nguồn
- `hello.py` : Mã nguồn Python.
- `hello.c` : Mã nguồn C.
- `hello_raw.s` : Mã nguồn Assembly x86_64 nguyên thủy (tương tác trực tiếp qua Windows API).
- `Bao_cao_HelloWorld.tex` : Báo cáo chi tiết định dạng LaTeX.

## Mã nguồn chi tiết

### Python (`hello.py`)
```python
print("hello world")
```

### C (`hello.c`)
```c
#include <stdio.h>
int main() {
    printf("hello world\n");
    return 0;
}
```

### Assembly Nguyên Thủy (`hello_raw.s`)
```assembly
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
    subq $40, %rsp
    movq $-11, %rcx
    call GetStdHandle
    movq %rax, %rcx                
    leaq msg(%rip), %rdx           
    movq $msg_len, %r8             
    leaq bytes_written(%rip), %r9  
    movq $0, 32(%rsp)              
    call WriteFile
    movq $0, %rcx
    call ExitProcess
```

## Hướng dẫn biên dịch (Compile)

### 1. Python
Sử dụng `PyInstaller` để đóng gói script thành một file thực thi độc lập (`.exe`).
```powershell
# Cài đặt thư viện nếu chưa có
pip install pyinstaller

# Biên dịch ra 1 file duy nhất
pyinstaller --onefile hello.py
```
*File `hello.exe` sẽ được tạo ra trong thư mục `dist/`.*

### 2. C
Sử dụng trình biên dịch `gcc` (GNU Compiler Collection).
```powershell
gcc hello.c -o hello_c.exe -O2
```

### 3. Assembly Nguyên thủy (Raw Assembly)
Sử dụng bộ công cụ GNU Binutils (`as` và `ld`) để dịch mã máy và liên kết trực tiếp với nhân hệ điều hành (`kernel32.dll`).
```powershell
# Dịch mã Assembly sang Object file
as hello_raw.s -o hello_raw.o

# Link Object file với Windows API
ld hello_raw.o -o hello_raw.exe -lkernel32 -e _start
```

## Bảng so sánh (Comparison)

| Ngôn ngữ | Kích thước File (File Size) | Thời gian chạy (Execution Time) | Đánh giá |
|----------|-----------------------------|---------------------------------|----------|
| **Assembly** | ~6.2 KB | ~23.75 ms | Dung lượng cực bé, tốc độ vô song do không bị vướng bận các thư viện phụ trợ (C-Runtime) và tương tác trực tiếp với API lõi. |
| **C** | ~120 KB | ~167.75 ms | Tốc độ xuất sắc, file lớn hơn do phải nạp thư viện `stdio` chứa hàm `printf`. Mang lại tính cân bằng lý tưởng nhất. |
| **Python** | ~7 MB | ~1583.32 ms | Siêu to khổng lồ và chậm nhất do file `.exe` phải cõng theo cả một bộ máy ảo Python bên trong để thông dịch mã lệnh. |

> *(Lưu ý: Thời gian chạy mang tính tham khảo và được đo đạc bằng lệnh `Measure-Command` trong PowerShell).*
