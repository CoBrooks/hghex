; vim:syntax=fasm
format ELF64 executable 3

segment readable executable
entry _start

_start:
  enter 4, 0
  mov dword [rbp-4], 0

.loop:
  xor rax, rax
  xor rdi, rdi
  lea rsi, byte [rbp-1]
  mov rdx, 1
  syscall
  
  test al, al
  jz .end

  mov al, byte [rbp-1]
.1:
  cmp al, 10
  ja .2

  mov  byte [rbp-2], 0
  jmp .continue
.2:
  cmp byte [rbp-2], 1
  je .continue
.3:
  cmp  al, "|"
  jne .4
  
  mov byte [rbp-2], 1
  je .continue
.4:
  cmp al, "0"
  jb .continue

  cmp al, "9"
  ja .5

  sub al, "0"
  shl byte [rbp-4], 4
  add byte [rbp-4], al

  jmp .write
.5:
  cmp al, "A"
  jb .continue
  
  cmp al, "F"
  ja .continue

  sub al, ("A" - 10)
  shl byte [rbp-4], 4
  add byte [rbp-4], al
.write:
  cmp  byte [rbp-3], 1
  jne .next

  mov rax, 1
  mov rdi, 1
  lea rsi, byte [rbp-4]
  mov rdx, 1
  syscall

  mov byte [rbp-3], 0
  mov byte [rbp-4], 0

  jmp .continue
.next:
  mov byte [rbp-3], 1
.continue:
  jmp .loop
.end:
  mov rax, 60
  mov rdi, 0
  syscall

