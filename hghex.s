; vim:syntax=fasm
format ELF64 executable 3

segment readable executable
entry _start

_start:

.loop:
  mov rax, 0
  mov rdi, 0
  mov rsi, buffer
  mov rdx, buffer.maxlen
  syscall

  test rax, rax
  jz  .end
  mov  qword [buffer.len], rax

  mov rsi, buffer
  mov rcx, qword [buffer.len]
@@:
  lodsb
.1:
  cmp al, 10
  ja .2

  mov  byte [flags.comment], 0
  jmp .continue
.2:
  cmp byte [flags.comment], 1
  je .continue
.3:
  cmp  al, "|"
  jne .4
  
  mov byte [flags.comment], 1
  je .continue
.4:
  cmp al, "0"
  jb .continue

  cmp al, "9"
  ja .5

  sub al, "0"
  shl byte [current_byte], 4
  add byte [current_byte], al

  jmp .write
.5:
  cmp al, "A"
  jb .continue
  
  cmp al, "F"
  ja .6

  sub al, ("A" - 10)
  shl byte [current_byte], 4
  add byte [current_byte], al

  jmp .write
.6:
  cmp al, "a"
  jb .continue

  cmp al, "f"
  ja .continue
  
  sub al, ("a" - 10)
  shl byte [current_byte], 4
  add byte [current_byte], al
.write:
  cmp  byte [flags.write], 1
  jne .next

  push rsi
  push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, current_byte
    mov rdx, 1
    syscall
  pop rcx
  pop rsi

  mov byte [flags.write], 0
  mov byte [current_byte], 0

  jmp .continue
.next:
  mov byte [flags.write], 1
.continue:
  dec rcx
  jnz @b
  jmp .loop
.end:
  mov rax, 60
  mov rdi, 0
  syscall

segment readable writeable

buffer: rb 256
  .maxlen = $ - buffer
  .len: dq 0

current_byte: db 0xF0

flags:
  .comment: db 0
  .write: db 0

