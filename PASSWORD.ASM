;password.asm
;org 0x0100
org 0x7c00

size: equ 0x00
mov dh, size
mov bx, pwd
count:
 mov al,[bx]
 test al,al
 je f1
 inc bx
 inc dh
 jmp count

f1:

mov bx, hello
call print

start:
mov cx, pwd
pass: equ 0x00
mov si, pass
;size: equ 0x06
;mov dh, size
step: equ 0x00
mov dl, step

mov ah, 0x0e
mov al, 0x0a	; LF
int 0x10
mov al, 0x0d	; CR
int 0x10
mov bx, password
call print
call type

print:
 mov al,[bx]
 test al,al
 je cont
 push bx
 mov ah,0x0e
 mov bx,0x000f
 int 0x10
 pop bx
 inc bx
 jmp print

type:
 mov ax, 0x00
 int 0x16
 mov ah, 0x0f
 cmp al, 0x1b ; ESC
 je start

cbw
push ax
mov bx, asterisk
call print

pop ax

mov bx, cx
mov ah, [bx]
inc cx
cmp al, ah
jne unauth

inc dl
cmp dl, dh
je final

 jmp type

cont:
 ret

final:
test si, si
je auth

mov bx, asterisk
call print

jmp start

unauth:
inc si
jmp type

auth:
;int 0x20
int 0x19
 hello: db "Hello, Mc Toxic",0
 password: db "Password:",0
 asterisk: db "*",0
 pwd: db "Secret Input", 0

times 510-($-$$) db 0 ; Fills boot sector (510 bytes)
db 0x55,0xaa 
