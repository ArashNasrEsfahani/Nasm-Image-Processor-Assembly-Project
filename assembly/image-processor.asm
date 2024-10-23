%ifndef SYS_EQUAL
%define SYS_EQUAL

    sys_read     equ     0
    sys_write    equ     1
    sys_open     equ     2
    sys_close    equ     3
    
    sys_lseek    equ     8
    sys_create   equ     85
    sys_unlink   equ     87
      

    sys_mkdir       equ 83
    sys_makenewdir  equ 0q777


    sys_mmap     equ     9
    sys_mumap    equ     11
    sys_brk      equ     12
    
     
    sys_exit     equ     60
    
    stdin        equ     0
    stdout       equ     1
    stderr       equ     3

 
	PROT_NONE	  equ   0x0
    PROT_READ     equ   0x1
    PROT_WRITE    equ   0x2
    MAP_PRIVATE   equ   0x2
    MAP_ANONYMOUS equ   0x20
    
    ;access mode
    O_DIRECTORY equ     0q0200000
    O_RDONLY    equ     0q000000
    O_WRONLY    equ     0q000001
    O_RDWR      equ     0q000002
    O_CREAT     equ     0q000100
    O_APPEND    equ     0q002000


    BEG_FILE_POS    equ     0
    CURR_POS        equ     1
    END_FILE_POS    equ     2
    
; create permission mode
    sys_IRUSR     equ     0q400      ; user read permission
    sys_IWUSR     equ     0q200      ; user write permission

    NL            equ   0xA
    Space         equ   0x20

%endif

%ifndef NOWZARI_IN_OUT
%define NOWZARI_IN_OUT

;----------------------------------------------------
newLine:
   push   rax
   mov    rax, NL
   call   putc
   pop    rax
   ret
;---------------------------------------------------------
putc:	

   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

   push   ax
   mov    rsi, rsp    ; points to our char
   mov    rdx, 1      ; how many characters to print
   mov    rax, sys_write
   mov    rdi, stdout 
   syscall
   pop    ax

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx
   ret
;---------------------------------------------------------
writeNum:
   push   rax
   push   rbx
   push   rcx
   push   rdx

   sub    rdx, rdx
   mov    rbx, 10 
   sub    rcx, rcx
   cmp    rax, 0
   jge    wAgain
   push   rax 
   mov    al, '-'
   call   putc
   pop    rax
   neg    rax  

wAgain:
   cmp    rax, 9	
   jle    cEnd
   div    rbx
   push   rdx
   inc    rcx
   sub    rdx, rdx
   jmp    wAgain

cEnd:
   add    al, 0x30
   call   putc
   dec    rcx
   jl     wEnd
   pop    rax
   jmp    cEnd
wEnd:
   pop    rdx
   pop    rcx
   pop    rbx
   pop    rax
   ret

;---------------------------------------------------------
getc:
   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

 
   sub    rsp, 1
   mov    rsi, rsp
   mov    rdx, 1
   mov    rax, sys_read
   mov    rdi, stdin
   syscall
   mov    al, [rsi]
   add    rsp, 1

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx

   ret
;---------------------------------------------------------

readNum:
   push   rcx
   push   rbx
   push   rdx

   mov    bl,0
   mov    rdx, 0
rAgain:
   xor    rax, rax
   call   getc
   cmp    al, '-'
   jne    sAgain
   mov    bl,1  
   jmp    rAgain
sAgain:
   cmp    al, NL
   je     rEnd
   cmp    al, ' ' ;Space
   je     rEnd
   sub    rax, 0x30
   imul   rdx, 10
   add    rdx,  rax
   xor    rax, rax
   call   getc
   jmp    sAgain
rEnd:
   mov    rax, rdx 
   cmp    bl, 0
   je     sEnd
   neg    rax 
sEnd:  
   pop    rdx
   pop    rbx
   pop    rcx
   ret

;-------------------------------------------
printString:
   push    rax
   push    rcx
   push    rsi
   push    rdx
   push    rdi

   mov     rdi, rsi
   call    GetStrlen
   mov     rax, sys_write  
   mov     rdi, stdout
   syscall 
   
   pop     rdi
   pop     rdx
   pop     rsi
   pop     rcx
   pop     rax
   ret
;-------------------------------------------
; rdi : zero terminated string start 
GetStrlen:
   push    rbx
   push    rcx
   push    rax  

   xor     rcx, rcx
   not     rcx
   xor     rax, rax
   cld
         repne   scasb
   not     rcx
   lea     rdx, [rcx -1]  ; length in rdx

   pop     rax
   pop     rcx
   pop     rbx
   ret
;-------------------------------------------

%endif



print_msgs: ; Prints the appropriate messages for costumer to choose from
   mov rax, 1    
   mov rdi, 1          
   mov rsi, welcome_msg
   mov rdx, welcome_msg_len
   syscall
   mov rax, 1    
   mov rdi, 1          
   mov rsi, reshape_msg
   mov rdx, reshape_msg_len
   syscall
   mov rax, 1    
   mov rdi, 1          
   mov rsi, resize_msg
   mov rdx, resize_msg_len
   syscall
   mov rax, 1    
   mov rdi, 1          
   mov rsi, conv_filter_msg
   mov rdx, conv_filter_msg_len
   syscall
   mov rax, 1    
   mov rdi, 1          
   mov rsi, pooling_msg
   mov rdx, pooling_msg_len
   syscall
   mov rax, 1    
   mov rdi, 1          
   mov rsi, noise_msg
   mov rdx, noise_msg_len
   syscall
   ret



choose_edit:
   call readNum
   mov [edit_mode], rax
   cmp rax, 1
   je ask_reshape_details
   cmp rax, 2
   je ask_resize_details
   cmp rax, 3
   je ask_conv_details
   cmp rax, 4
   je ask_pool_details 
   jmp end_choose_edit
ask_reshape_details:
   mov rax, 1    
   mov rdi, 1          
   mov rsi, reshape_details1_msg
   mov rdx, reshape_details1_msg_len
   syscall
   call readNum
   mov [rk], rax
   mov rax, 1    
   mov rdi, 1          
   mov rsi, reshape_details2_msg
   mov rdx, reshape_details2_msg_len
   syscall
   call readNum
   mov [gk], rax
   mov rax, 1    
   mov rdi, 1          
   mov rsi, reshape_details3_msg
   mov rdx, reshape_details3_msg_len
   syscall
   call readNum
   mov [bk], rax
   jmp end_choose_edit
ask_resize_details:
   mov rax, 1    
   mov rdi, 1          
   mov rsi, resize_details1_msg
   mov rdx, resize_details1_msg_len
   syscall
   call readNum
   mov [wg], rax
   call readNum
   mov [hg], rax
   jmp end_choose_edit
ask_conv_details:
   mov rax, 1    
   mov rdi, 1          
   mov rsi, conv_details1_msg
   mov rdx, conv_details1_msg_len
   syscall
   xor rsi, rsi
read_each_num:
   call readNum
   mov [kernel + rsi * 8], rax
   inc rsi
   cmp rsi, 9
   je end_choose_edit
   jmp read_each_num
ask_pool_details:
   mov rax, 1    
   mov rdi, 1          
   mov rsi, pooling_details1_msg
   mov rdx, pooling_details1_msg_len
   syscall
   call readNum
   mov [pool_type], rax
   mov rax, 1    
   mov rdi, 1          
   mov rsi, pooling_details2_msg
   mov rdx, pooling_details2_msg_len
   syscall
   call readNum
   mov [wg], rax
   call readNum
   mov [hg], rax
   jmp end_choose_edit
end_choose_edit:
   ret



apply_reshape:
   mov rax, 1
   cmp [rk], rax
   je check_green_channel
   xor rsi, rsi
red_channel_remove:
   cmp rsi, [pixel]
   je check_green_channel
   xor al, al
   mov [red+rsi], al
   inc rsi
   jmp red_channel_remove
check_green_channel:
   mov rax, 1
   cmp [gk], rax
   je check_blue_channel
   xor rsi, rsi
green_channel_remove:
   cmp rsi, [pixel]
   je check_blue_channel
   xor al, al
   mov [red+rsi], al
   inc rsi
   jmp green_channel_remove
check_blue_channel:
   mov rax, 1
   cmp [bk], rax
   je apply_reshape_end
   xor rsi, rsi
blue_channel_remove:
   cmp rsi, [pixel]
   je apply_reshape_end
   xor al, al
   mov [red+rsi], al
   inc rsi
   jmp blue_channel_remove
apply_reshape_end:
   ret


random_generator:
   push rsi
   rdrand rax
   ; Scale to range [0, 10]
   xor rdx, rdx      
   mov rcx, 11         
   div rcx  
   mov rax, rdx
   pop rsi
   ret

apply_noise:
   xor rsi, rsi
channel_noise_loop:
   cmp rsi, [pixel]
   je end_apply_noise
   call random_generator
   cmp rax, 5
   jge salt_pepper
channel_noise_loop_cont:
   inc rsi
   jmp channel_noise_loop
salt_pepper:
   call random_generator
   cmp rax, 5
   jge salt_apply
   jmp pepper_apply
salt_apply:
   xor rax, rax
   mov al, 255
   mov [gray+rsi], al
   inc rsi
   jmp channel_noise_loop
pepper_apply:
   xor rax, rax
   mov al, 0
   mov [gray+rsi], al
   inc rsi
   jmp channel_noise_loop
end_apply_noise:
   ret



apply_resize:
   xor rsi, rsi
resize_row_loop:
   cmp rsi, [hg]
   je apply_resize_end
   xor rdi, rdi
resize_col_loop:
   cmp rdi, [wg]
   je resize_col_loop_end
   push rsi
   push rdi
   mov rax, rsi
   mov rbx, [wg]
   xor rdx, rdx
   div ebx
   mov rbx, [row_len]
   xor rdx, rdx
   mul ebx
   mov [old_x], rax
   pop rdi
   pop rsi
   push rsi
   push rdi
   mov rax, rdi
   mov rbx, [hg]
   xor rdx, rdx
   div ebx
   mov rbx, [col_len]
   xor rdx, rdx
   mul ebx
   mov [old_y], rax
   
   mov rax, [old_x]
   mov rbx, [col_len]
   xor rdx, rdx
   mul ebx
   add rax, [old_y]
   mov rsi, rax
   mov al, [gray + rsi]
   mov [temp_byte], al

   pop rdi
   pop rsi
   push rsi
   push rdi

   mov rax, rsi
   mov rbx, [col_len]
   xor rdx, rdx
   mul ebx
   add rax, rdi
   mov rsi, rax
   mov al, [temp_byte]
   mov [gray_temp + rsi], al

   pop rdi
   pop rsi
   inc rdi
   jmp resize_col_loop
resize_col_loop_end:
   inc rsi
   jmp resize_row_loop

apply_resize_end:
   xor rsi, rsi
apply_resize_end_loop:
   cmp rsi, [pixel]
   je apply_resize_end_final
   mov al, [gray_temp + rsi]
   mov [gray + rsi], al
   inc rsi
   jmp apply_resize_end_loop
apply_resize_end_final:
   mov rax, [wg]
   mov [col_len], rax
   mov rax, [hg]
   mov [row_len], rax
   ret



calc_rgb: ; Calculates the RGB values of our picture and saves them in their corresponding arrays
   push rax
   push rbx
   push rcx
   push r8
   push rsi
   xor rsi, rsi
   xor rcx, rcx
calc_red_loop:
   xor rax, rax
   mov al, [buffer + rsi]
   inc rsi
   cmp al, ' '
   je end_calc_red
   inc rcx
   push rax
   jmp calc_red_loop
end_calc_red:
   xor rdi, rdi
end_calc_red_loop:
   cmp rcx, rdi
   je calc_green_loop_start
   pop rax
   sub al, '0'
   mov bl, 10
   xor r8, r8
pow_ten_red:
   cmp r8, rdi
   je end_calc_red_loop_cont
   mul bl
   inc r8
   jmp pow_ten_red
end_calc_red_loop_cont:
   add al, [res]
   mov [res], al
   inc rdi
   jmp end_calc_red_loop

calc_green_loop_start:
   xor rax, rax
   mov rdi, [pixel]
   mov al, [res]
   mov [red + rdi], al
   mov byte[res], 0
   xor rcx, rcx
calc_green_loop:
   xor rax, rax
   mov al, [buffer + rsi]
   inc rsi
   cmp al, ' '
   je end_calc_green
   inc rcx
   push rax
   jmp calc_green_loop
end_calc_green:
   xor rdi, rdi
end_calc_green_loop:
   cmp rcx, rdi
   je calc_blue_loop_start
   pop rax
   sub al, '0'
   mov bl, 10
   xor r8, r8
pow_ten_green:
   cmp r8, rdi
   je end_calc_green_loop_cont
   mul bl
   inc r8
   jmp pow_ten_green
end_calc_green_loop_cont:
   add al, [res]
   mov [res], al
   inc rdi
   jmp end_calc_green_loop

calc_blue_loop_start:
   xor rax, rax
   mov rdi, [pixel]
   mov al, [res]
   mov [green + rdi], al
   mov byte[res], 0
   xor rcx, rcx
calc_blue_loop:
   cmp rsi, [word_length]
   je end_calc_blue
   xor rax, rax
   mov al, [buffer + rsi]
   inc rsi
   cmp al, '-'
   je end_calc_blue
   inc rcx
   push rax
   jmp calc_blue_loop
end_calc_blue:
   xor rdi, rdi
end_calc_blue_loop:
   cmp rcx, rdi
   je end_calc_rgb_loop
   pop rax
   sub al, '0'
   mov bl, 10
   xor r8, r8
pow_ten_blue:
   cmp r8, rdi
   je end_calc_blue_loop_cont
   mul bl
   inc r8
   jmp pow_ten_blue
end_calc_blue_loop_cont:
   add al, [res]
   mov [res], al
   inc rdi
   jmp end_calc_blue_loop

end_calc_rgb_loop:
   xor rax, rax
   mov rdi, [pixel]
   mov al, [res]
   mov [blue + rdi], al
   mov byte[res], 0 
   inc qword [pixel]
   pop rsi
   pop r8
   pop rcx
   pop rbx
   pop rax
   ret


calc_gr: ; Calculate grayscale
   push rax
   push rbx
   push rcx
   push r8
   push rsi
   xor rsi, rsi
   xor rcx, rcx
calc_gray_loop:
   cmp rsi, [word_length]
   je end_calc_gray
   xor rax, rax
   mov al, [buffer + rsi]
   inc rsi
   cmp al, '-'
   je end_calc_gray
   inc rcx
   push rax
   jmp calc_gray_loop
end_calc_gray:
   xor rdi, rdi
end_calc_gray_loop:
   cmp rcx, rdi
   je end_calc_gr_loop
   pop rax
   sub al, '0'
   mov bl, 10
   xor r8, r8
pow_ten_gray:
   cmp r8, rdi
   je end_calc_gray_loop_cont
   mul bl
   inc r8
   jmp pow_ten_gray
end_calc_gray_loop_cont:
   add al, [res]
   mov [res], al
   inc rdi
   jmp end_calc_gray_loop

end_calc_gr_loop:
   xor rax, rax
   mov rdi, [pixel]
   mov al, [res]
   mov [gray + rdi], al
   mov byte[res], 0 
   inc qword [pixel]
   pop rsi
   pop r8
   pop rcx
   pop rbx
   pop rax
   ret



int_to_string: ; Saves the number in rax as a string in num_str variable
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   xor rsi, rsi
int_to_string_loop:
   cmp rax, 10
   jl int_to_string_loop_end
   mov rbx, 10
   xor rdx, rdx
   div rbx   
   add dl, '0'
   mov [num_str_temp + rsi], dl
   inc rsi
   jmp int_to_string_loop
int_to_string_loop_end:
   add al, '0'
   mov [num_str_temp + rsi], al
   inc rsi
   mov [num_str_len], rsi
   dec rsi
   xor rdi, rdi
reverse_string_int:
   cmp rdi, [num_str_len]
   je int_to_string_end
   mov al, [num_str_temp + rsi]
   mov [num_str + rdi], al
   dec rsi
   inc rdi
   jmp reverse_string_int
int_to_string_end:
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   ret



write_edited_pic_rgb: ; writes the current values of RGB in the file
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   xor rsi, rsi
   xor rdi, rdi
write_edited_pic_rgb_loop:
   cmp rsi, [pixel]
   je write_edited_pic_rgb_end
   cmp rdi, [col_len]
   je end_of_row_write_rgb
write_edited_pic_rgb_loop_cont:
   push rsi
   push rdi
   xor rax, rax
   mov al, [red + rsi] 
   call int_to_string
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [num_str]       
   mov rdx, [num_str_len]                      
   syscall    
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [space_char]     
   mov rdx, 1                    
   syscall    
   pop rdi
   pop rsi

   push rsi
   push rdi
   xor rax, rax
   mov al, [green + rsi] 
   call int_to_string
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [num_str]       
   mov rdx, [num_str_len]                      
   syscall    
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [space_char]     
   mov rdx, 1                    
   syscall 
   pop rdi   
   pop rsi

   push rsi
   push rdi
   xor rax, rax
   mov al, [blue + rsi] 
   call int_to_string
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [num_str]       
   mov rdx, [num_str_len]                      
   syscall    
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [line_char]     
   mov rdx, 1                    
   syscall    
   pop rdi
   pop rsi

   inc rsi
   inc rdi
   jmp write_edited_pic_rgb_loop

end_of_row_write_rgb:
   push rsi
   push rdi
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [newline_char]     
   mov rdx, 1                    
   syscall  
   pop rdi
   sub rdi, [col_len]  
   pop rsi
   jmp write_edited_pic_rgb_loop_cont
write_edited_pic_rgb_end:
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [newline_char]     
   mov rdx, 1                    
   syscall  
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   ret


write_edited_pic_gr:
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   xor rsi, rsi
   xor rdi, rdi
write_edited_pic_gr_loop:
   cmp rsi, [pixel]
   je write_edited_pic_gr_end
   cmp rdi, [col_len]
   je end_of_row_write_gr
write_edited_pic_gr_loop_cont:
   push rsi
   push rdi
   xor rax, rax
   mov al, [gray + rsi] 
   call int_to_string
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [num_str]       
   mov rdx, [num_str_len]                      
   syscall    
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [line_char]     
   mov rdx, 1                    
   syscall    
   pop rdi
   pop rsi

   inc rsi
   inc rdi
   jmp write_edited_pic_gr_loop
end_of_row_write_gr:
   push rsi
   push rdi
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [newline_char]     
   mov rdx, 1                    
   syscall  
   pop rdi
   sub rdi, [col_len]  
   pop rsi
   jmp write_edited_pic_gr_loop_cont
write_edited_pic_gr_end:
   mov rax, 1                     
   mov rdi, [outfile_descriptor]     
   lea rsi, [newline_char]     
   mov rdx, 1                    
   syscall  
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   ret

section .data
   welcome_msg db 'Hi! How May I Help You With Your Picture Today?', 10
   welcome_msg_len equ $ - welcome_msg
   reshape_msg db '1 - Reshape ', 10
   reshape_msg_len equ $ - reshape_msg
   resize_msg db '2 - Resize ', 10
   resize_msg_len equ $ - resize_msg
   conv_filter_msg db '3 - Convolutional Filter', 10
   conv_filter_msg_len equ $ - conv_filter_msg
   pooling_msg db '4 - Pooling', 10
   pooling_msg_len equ $ - pooling_msg
   noise_msg db '5 - Noise', 10  
   noise_msg_len equ $ - noise_msg
   reshape_details1_msg db 'Do you want to keep red dimension?(y/n)', 10
   reshape_details1_msg_len equ $ - reshape_details1_msg
   reshape_details2_msg db 'Do you want to keep green dimension?(y/n)', 10
   reshape_details2_msg_len equ $ - reshape_details2_msg
   reshape_details3_msg db 'Do you want to keep blue dimension?(y/n)', 10
   reshape_details3_msg_len equ $ - reshape_details3_msg
   resize_details1_msg db 'Write your desired resolution seperated by space.', 10
   resize_details1_msg_len equ $ - resize_details1_msg
   conv_details1_msg db 'Write your desired kernel to be applied.', 10
   conv_details1_msg_len equ $ - conv_details1_msg
   pooling_details1_msg db 'Write your desired pooling method.(Use A for average and M for max.)', 10
   pooling_details1_msg_len equ $ - pooling_details1_msg
   pooling_details2_msg db 'Write your desired pooling size seperated by space.', 10
   pooling_details2_msg_len equ $ - pooling_details2_msg
   done_msg db 'Your edit is done.', 10
   done_msg_len equ $ - done_msg

   filename db 'bwpic.txt', 0
   error_msg db 'Error opening file', 10, 0
   outfilename db 'resize.txt', 0
   error_msg_len equ $ - error_msg
   row_len dq 0
   col_len dq 0
   pixel dq 0
   res db 0
   newline db 10
   space_char db ' '   
   line_char db '-'
   newline_char db 10

section .bss
   file_descriptor resq 1
   outfile_descriptor resq 1
   num_str resb 3
   num_str_temp resb 3
   num_str_len resq 1
   red resb 1000000
   green resb 1000000
   blue resb 1000000
   gray resb 1000000
   gray_temp resb 1000000
   buffer resb 64    ; buffer size
   write_buffer resb 64
   word_length resq 1  ; To keep track of word length
   edit_mode resq 1 ; Determines type of edit(effect)
   rk resq 1 ; red keep
   bk resq 1 ; blue keep
   gk resq 1 ; green keep
   wg resq 1 ; width goal
   hg resq 1 ; height goal
   kernel resq 9 ; kernel for convolutional
   pool_type resq 1
   old_x resq 1
   old_y resq 1
   temp_byte resb 1


section .text
    global _start
_start:
   call print_msgs
   call choose_edit

   ; Open the file
   mov rax, 2     
   mov rdi, filename  
   mov rsi, 0       
   mov rdx, 0         
   syscall

   ; Check if file opened successfully
   cmp rax, 0
   jl error_exit
   mov [file_descriptor], rax


   mov rax, [edit_mode]
   cmp rax, 1
   je read_word_rgb
   jmp read_word_gr

read_word_rgb:
   xor r12, r12   ; Buffer index
   mov qword [word_length], 0  
read_char_rgb:
   ; Read one character
   mov rax, 0         
   mov rdi, [file_descriptor]
   lea rsi, [buffer + r12]  
   mov rdx, 1
   syscall

   ; Check if we've reached EOF
   cmp rax, 0
   je check_effect

   ; Check if the character is a newline or dash
   mov al, [buffer + r12]
   cmp al, 10 ; ASCII for newline
   je end_of_row_rgb
   cmp al, '-'  
   je word_complete_rgb

   inc r12
   inc qword [word_length]
   cmp r12, 63  ; Check if we're about to overflow the buffer
   jl read_char_rgb

end_of_row_rgb:
   inc qword [row_len]
   jmp read_word_rgb
word_complete_rgb:
   call calc_rgb
   jmp read_word_rgb


read_word_gr:
   xor r12, r12   ; Buffer index
   mov qword [word_length], 0  
read_char_gr:
   ; Read one character
   mov rax, 0         
   mov rdi, [file_descriptor]
   lea rsi, [buffer + r12]  
   mov rdx, 1
   syscall

   ; Check if we've reached EOF
   cmp rax, 0
   je check_effect

   ; Check if the character is a newline or dash
   mov al, [buffer + r12]
   cmp al, 10 ; ASCII for newline
   je end_of_row_gr
   cmp al, '-'  
   je word_complete_gr

   inc r12
   inc qword [word_length]
   cmp r12, 63  ; Check if we're about to overflow the buffer
   jl read_char_gr

end_of_row_gr:
   inc qword [row_len]
   jmp read_word_gr
word_complete_gr:
   call calc_gr
   jmp read_word_gr


check_effect:
   xor rdx, rdx
   mov rax, [pixel]
   mov rbx, [row_len]
   div ebx
   mov [col_len], rax

   mov rax, 1
   cmp [edit_mode], rax
   je choice_reshape

   mov rax, 2
   cmp [edit_mode], rax
   je choice_resize

   mov rax, 5
   cmp [edit_mode], rax
   je choice_noise


choice_reshape:
   call apply_reshape
   jmp write_to_file_rgb

choice_resize:
   call apply_resize
   jmp write_to_file_gr

choice_noise:
   call apply_noise
   jmp write_to_file_gr

write_to_file_rgb:
   ; Open the file
   mov rax, 2                     
   lea rdi, [outfilename]           
   mov rsi, 2                    
   mov rdx, 0644            
   syscall                        

   ; Store file descriptor
   mov [outfile_descriptor], rax

   ; Check if file opened successfully
   cmp rax, 0
   jl error_exit    

   call write_edited_pic_rgb
   jmp end_of_file

write_to_file_gr:
   ; Open the file
   mov rax, 2                     
   lea rdi, [outfilename]           
   mov rsi, 2                    
   mov rdx, 0644            
   syscall                        

   ; Store file descriptor
   mov [outfile_descriptor], rax

   ; Check if file opened successfully
   cmp rax, 0
   jl error_exit   

   call write_edited_pic_gr

end_of_file:
   ; Close input file
   mov rax, 3
   mov rdi, [file_descriptor]
   syscall
   ; Close output file
   mov rax, 3
   mov rdi, [outfile_descriptor]
   syscall
   ; Exit program
   mov rax, 60
   xor rdi, rdi
   syscall

error_exit:
   ; Print error message
   mov rax, 1    
   mov rdi, 1          
   mov rsi, error_msg
   mov rdx, error_msg_len
   syscall
   ; Exit with error status
   mov rax, 60         
   mov rdi, 1         
   syscall
