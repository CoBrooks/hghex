format ELF executable 3

segment readable executable
entry _start

_start:
  enter 4, 0
  mov dword [ebp-4], 0

.loop:
  mov eax, 3
  mov ebx, 0
  lea ecx, byte [ebp-1]
  mov edx, 1
  int 80h
  
  test al, al
  jz .end

  mov al, byte [ebp-1]
.1:
  cmp al, 10
  ja .2

  mov  byte [ebp-2], 0
  jmp .continue
.2:
  cmp byte [ebp-2], 1
  je .continue
.3:
  cmp  al, "|"
  jne .4
  
  mov byte [ebp-2], 1
  je .continue
.4:
  cmp al, "0"
  jb .continue

  cmp al, "9"
  ja .5

  sub al, "0"
  shl byte [ebp-4], 4
  add byte [ebp-4], al

  jmp .write
.5:
  cmp al, "A"
  jb .continue
  
  cmp al, "F"
  ja .continue

  sub al, ("A" - 10)
  shl byte [ebp-4], 4
  add byte [ebp-4], al
.write:
  cmp  byte [ebp-3], 1
  jne .next

  mov eax, 4
  mov ebx, 1
  lea ecx, byte [ebp-4]
  mov edx, 1
  int 80h

  mov byte [ebp-3], 0
  mov byte [ebp-4], 0

  jmp .continue
.next:
  mov byte [ebp-3], 1
.continue:
  jmp .loop
.end:
  mov eax, 1
  mov ebx, 0
  int 80h

