%include "const_value.inc"

scn db 18h,19h,2ah,4dh,77h,4fh,00h,00h,0,0f0h,0,0,0,0,0,0

scn_2674_init:
   mov cx,2000h
   mov al,0
   out ppi_porta,al
   out ppi_portc,al
   mov al,4
   out ppi_portc,al
   xor al,2
   out ppi_portc,al
   xor al,2
   out ppi_portc,al
   
   xor al,2
   out ppi_portc,al
   xor al,2
   out ppi_portc,al
   
   mov al,0
   out ppi_portc,al
   mov al,3fh
   out ppi_porta,al
   mov al,4
   out ppi_portc,al
   xor al,2
   out ppi_portc,al
   xor al,2
   out ppi_portc,al
scn_2674_loop:
    cmp si,0fh
    jz scn_out
    mov al,scn[si]
    out ppi_porta,al
    mov al,2
    out ppi_portc,al
    mov al,0
    out ppi_portc,al
    inc si
    jmp scn_2674_loop 
scn_out:
    mov si,0
    ret