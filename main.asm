lcd_cmd    equ 0x0000
lcd_data   equ 0x0001
ppi_porta  equ 0x0000
ppi_portb  equ 0x0010
ppi_portc  equ 0x0020
ppi_cmd    equ 0x0030
ppi2_porta equ 0x0040
ppi2_portb equ 0x0050
ppi2_portc equ 0x0060
ppi2_cmd   equ 0x0070
scn_2674   equ 0x00f0

pic_en     equ 0x0040
nmi_num    equ 0x0002
icw1       equ 0x0013
icw2       equ 0x0010
icw4       equ 0x0001
pic_reg    equ 0x0080
kb_nmi     equ 0x0002
kb_intv    equ 0x0010
trap_intv  equ 0x0001

jmp ginit
map:
    dw "????????????? `?"
    dw "?????q1???zsaw2?"
    dw "?cxde43?? vftr5?"   
    dw "?nbhgy6???mju78?"
    dw "?,kio09??./l;p-?"
    dw "??'?[=?????]?\??"
    dw "?????????1?47???"
    dw "0.2568???+3-*9??"
    dw "????????????????"
    dw "????????????????"    
    dw "????????????????"
    dw "????????????????"
    dw "????????????????"
    dw "????????????????"
    dw "????????????????"
cmd db 30h,30h,30h,38h,08h,01h,06h,0fh,0  
scn db 18h,19h,2ah,4dh,77h,4fh,00h,00h,0,0f0h,0,0,0,0,0,0
msg db 'hello world!',0

ginit:
    mov al,10h
    out ppi_portc,al
    cli
    call init    
    call ppi_init
    call scn_2674_init
    call lcd_init
main:
    jmp idle
     
init:
    mov ax,0
    mov es,ax
    mov di,kb_intv*4
    mov ax,kb_int
    stosw
    mov ax,cs
    stosw
    mov ax,cs        
    mov ds,ax
    mov si,0
    mov di,0
    ret
    
ppi_init:
    mov al,82h
    out ppi_cmd,al
    ret        
lcd_init:
    mov al,cmd[si]
    cmp al,0
    jz  ous
    out lcd_cmd,al
    mov al,1
    out ppi_portc,al
    mov al,0
    out ppi_portc,al
    inc si
    mov cx,2000h
    call delay
    jmp lcd_init
ous:mov si,0
    ret 

kb_init:
    mov dx,2000h
    mov ds,dx
    mov bx,0
    mov byte[bx-1],0
    mov byte[bx-2],0
    ret    
lcd_next_line:
    nop
    ret

stop:
    nop
    jmp stop
sos:ret

print:
    out lcd_data,al
    mov al,1
    out ppi_portc+lcd_data,al
    mov al,0
    out ppi_portc+lcd_data,al
    mov cx,1000h
    call delay
    ret


idle:
    cli
    cmp si,di
    sti
    jnz compare
    jmp idle
compare: 
    cli
    mov al,[bx+si]
    cmp al,[bx+si-1]
    sti
    jz key_press
    cli  
    mov al,[bx+si]
    cmp al,[bx+si-2]
    sti
    jz key_press1
    jnz idle
key_press:
    push bx
    mov al,[bx+si] 
    call print 
    dec si
    pop bx
    jmp idle
key_press1:
    push bx
    mov al,[bx+si] 
    call print
    sub si,3
    pop bx
    jmp idle    
kb_int:
    mov cx,1000h
    call delay
    push di
    push bp
    push bx
    push ax
    mov ah,00h 
    in al,ppi_portb
    mov di,ax
    mov dx,cs
    mov ds,dx
    mov al,map[di]
    inc si
    mov dx,2000h
    mov ds,dx
    mov [bx+si],al
    pop ax      
    pop bx
    pop bp 
    pop di  
    iret

scn_2674_init:
   mov cx,2000h
   call delay
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
    jz ous
    mov al,scn[si]
    out ppi_porta,al
    mov al,2
    out ppi_portc,al
    mov al,0
    out ppi_portc,al
    inc si
    jmp scn_2674_loop 

print_hello_world:
    mov al,msg[si]
    cmp si,0ch
    jz ous
    call print
    inc si
    jmp print_hello_world

delay:
    nop
 _1:dec cx
    jnz _1
    ret