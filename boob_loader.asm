[BITS 16]	;Tells the assembler that its a 16 bit code
[ORG 0x7C00]	;Origin, tell the assembler that where the code will
		;be in memory after it is been loaded

MOV SI, Line1		;Store string pointer to SI
CALL PrintString	;Call print string procedure

CALL CRLF
MOV SI, Line2
CALL PrintString

CALL CRLF
MOV SI, Line3
CALL PrintString

CALL CRLF
MOV SI, Line4
CALL PrintString

;color character
;MOV AH, 0x09
;MOV AL, 0x0e ;char
;MOV BH, 0x00
;MOV BL, 0x0e ;color
;MOV CX, 1 ;x
;;MOV DX, 1 ;y
;INT 0x10



JMP $ 		;Infinite loop, hang it here.


; FUNCTIONS
CRLF:
  MOV AH, 0x02
  MOV BH, 0x00
  MOV DH, [pos]
  MOV DL, 0x00
  INT 0x10
  INC DH
  MOV [pos], DH
  RET


PrintCharacter:	;Procedure to print character on screen
		;Assume that ASCII value is in register AL
  MOV AH, 0x0E	;Tell BIOS that we need to print one charater on screen.
  MOV BH, 0x00	;Page no.
  MOV BL, 0x07	;Text attribute 0x07 is lightgrey font on black background

  INT 0x10	;Call video interrupt
  RET		;Return to calling procedure



PrintString:		;Procedure to print string on screen
			;Assume that string starting pointer is in register SI
  next_character:	;Lable to fetch next character from string
  MOV AL, [SI]		;Get a byte from string and store in AL register
  INC SI		;Increment SI pointer
  OR AL, AL		;Check if value in AL is zero (end of string)
  JZ exit_function	;If end then return
  CALL PrintCharacter	;Else print the character which is in AL register
  JMP next_character	;Fetch next character from string
  exit_function:	;End label
  RET			;Return from procedure


; DATA
pos db 0x01 

Line1 db 'BOOB LOADER', 0	;HelloWorld string ending with 0
Line2 db 'BOOBS GO HERE', 0	;HelloWorld string ending with 0
Line3 db 'MOAR BOOBS', 0	;HelloWorld string ending with 0
Line4 db 'MOAR MOAR BOOBS', 0	;HelloWorld string ending with 0

TIMES 510 - ($ - $$) db 0	;Fill the rest of sector with 0
DW 0xAA55			;Add boot signature at the end of bootloader
