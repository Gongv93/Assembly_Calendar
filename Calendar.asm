; Name: Vincent Gong
; ID:	5614
; Proj:	1
; CSC210 Sec. F

.Model small
.stack 100h

.data
dtxt db "SunMonTueWedThuFriSat2014Z-Previous X-Next C-Quit"

; Length: 48
jant db "              J  A  N  U  A  R  Y               "
febt db "              F  E  B  U  A  R  Y               "
mart db "                 M  A  R  C  H                  "
aprt db "                 A  P  R  I  L                  "
mayt db "                    M  A  Y                     "
junt db "                  J  U  N  E                    "
jult db "                  J  U  L  Y                    "
augt db "               A  U  G  U  S  T                 "
sept db "           S  E  P  T  E  M  B  E  R            "
octt db "              O  C  T  O  B  E  R               " 
novt db "            N  O  V  E  M  B  E  R              "
dest db "            D  E  C  E  M  B  E  R              "

;Length: 84
jan db "      1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262728293031                "
feb db "            1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262727                "
mar db "            1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262728293031          "
apr db "    1 2 3 4 5 6 7 8 9 101112131415161718192021222324252627282930                    "
may db "        1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262728293031              "
jun db "              1 2 3 4 5 6 7 8 9 101112131415161718192021222324252627282930          "
jul db "    1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262728293031                  "
aug db "          1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262728293031            "
sep db "  1 2 3 4 5 6 7 8 9 101112131415161718192021222324252627282930                      "
oct db "      1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262728293031                " 
nov db "            1 2 3 4 5 6 7 8 9 101112131415161718192021222324252627282930            "
des db "  1 2 3 4 5 6 7 8 9 10111213141516171819202122232425262728293031                    "

.code
.386
org 100h

jmp START

SAVSCR proc near
	pusha
	savedscr dw 80*25 dup(?)
	mov cx,25*80
	sub si,si
ssl:mov ax,es:[si]
	mov savedscr[si],ax
	add si,2
	loop ssl
	popa
	ret
SAVSCR endp

CLRSCR proc near
	pusha
	; Makes the back blue (cls)
	mov ax,1f20h
	mov cx,25*80
	mov si,0
l:	mov es:[si],ax
	add si,2
	loop l	
	; Get rid of cursor
	mov cx,2607h
    mov ah,01h
	int 10h
	popa
	ret
CLRSCR endp

RECSCR proc near
	; Recovers screen
	mov cx,25*80
	mov si,0
r1: mov ax,savedscr[si]
	mov es:[si],ax
	add si,2
	loop r1
	; Restore cursor
	mov cx,0607h
    mov ah,01h
	int 10h
	ret
RECSCR endp

DRWHD proc near
	pusha
	; Draw the top part of the calendar
	; Color banner
	mov cx,160
	mov si,0
	mov ax,3f20h
dh1:mov es:[si],ax
	add si,2
	loop dh1
	; Head decorations
	mov ax,3fbah
	mov es:[0],ax
	mov es:[158],ax
	mov ax,3fc8h
	mov es:[160],ax
	mov ax,3fbch
	mov es:[318],ax
	mov ax,3fcdh
	mov si,162
	mov cx,34
dh2:mov es:[si],ax
	add si,2
	loop dh2
	add si,14
	mov cx,37
dh3:mov es:[si],ax
	add si,2
	loop dh3
	
	; Draw some other decorations 
	mov ax,3fcbh
	mov es:[168],ax
	mov es:[310],ax
	
	mov ax,1fbah
	mov si,328	; 3rd row 4th col
	mov cx,21
dh4:mov es:[si],ax
	add si,142
	mov es:[si],ax
	add si,18
	loop dh4
	
	mov ax,1fc8h	; si at bottom left corner
	mov es:[si],ax
	add si,2
	
	mov ax,1fcdh	;bottom row
	mov cx,70
dh5:mov es:[si],ax
	add si,2
	loop dh5
	
	mov ax,1fbch	; si is at bottom right corner
	mov es:[si],ax

	popa
	ret
DRWHD endp

DRWBD proc near
	pusha
	; Draws the body of the calendar
	;=====Draw verticals======================================================
	mov cx,20
	mov si,502		; start
	mov ax,02b3h
db1:mov dx,8
db2:mov es:[si],ax
	add si,16
	dec dx
	jnz db2
	add si,32
	loop db1
	;=====Draw Horizontals====================================================
	; Top horizontal
	mov cx,57
	mov si,342
	mov ax,02c4h
db3:mov es:[si],ax
	add si,2
	loop db3
	; The rest
	mov cx,7
	mov si,662
db4:mov dx,57
db5:mov es:[si],ax
	add si,2
	dec dx
	jnz db5
	add si,366
	loop db4
	;=====Connections=========================================================	
; Day connections
	mov si,342
	mov cx,6
	mov ax,02dah
	mov es:[si],ax
	add si,16
	mov ax,02c2h
db6:mov es:[si],ax
	add si,16
	loop db6

	mov ax,02bfh
	mov es:[454],ax
	
; body connections
	; side connections
	mov cx,7
	mov si,662
db7:mov ax,02c3h
	mov es:[si],ax
	mov ax,02b4h
	add si,112
	mov es:[si],ax
	add si,368
	loop db7
	
	; inner connections
	mov ax,02c5h
	mov si,678
	mov cx,7
db8:mov dx,6
db9:mov es:[si],ax
	add si,16
	dec dx
	jnz db9
	add si,384
	loop db8
	
;Bottom connections
	mov si,3542
	mov cx,6
	mov ax,02c0h
	mov es:[si],ax
	add si,16
	mov ax,02c1h
db0:mov es:[si],ax
	add si,16
	loop db0

	mov ax,02d9h
	mov es:[3654],ax
	
	popa
	ret
DRWBD endp

COLBD proc near
	pusha
	; Colors calendar
	; Day colors
	mov al,67h
	mov si,343
	mov cx,3
c1:	mov bx,57
c2: mov es:[si],al
	add si,2
	dec bx
	jnz c2
	add si,46
	loop c1
	
	; Number colors
	mov al,47
	mov si,823
	mov cx,18
c3:	mov bx,57
c4:	mov es:[si],al
	add si,2
	dec bx
	jnz c4
	add si,46
	loop c3
	
	popa
	ret
COLBD endp

DRWTXT proc near
	pusha
	; Writes the days of the week and the year on the calendar
	mov ax,@data
	mov ds,ax
	
	mov cx,7	; 7 days
	mov si,offset dtxt
	; Draw days
	mov di,0
	mov bx,506
	mov ah,60h
dt1:mov dx,3
dt2:lodsb
	mov es:[bx],ax
	add bx,2
	dec dx
	jnz dt2
	add bx,10
	loop dt1
	
	; Year
	mov cx,4	; Length of year
	mov bx,230
	mov ah,3fh
dt3:lodsb
	mov es:[bx],ax
	add bx,4
	loop dt3
	
	; Controls
	mov cx,24	; Length of instructions
	mov bx,3898
	mov ah,0fh	; Match the back color
dt4:lodsb
	mov es:[bx],ax
	add bx,2
	loop dt4
	
	popa
	ret
DRWTXT endp

MONTH proc near
	pusha
	; Writes the current month text on the banner
	mov cx,48	; Size of month text
	mov bx,32	; Month start position
	mov ah,60h	; Text 

cm:lodsb
	mov es:[bx],ax
	add bx,2
	loop cm
	
	popa
	ret
MONTH endp

CALEND proc near
	pusha
	; dh has the current date
	; compare, if not equal move on to next month
	;		   if equal rewrite month and jmp to don
	; jan - dec: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
	
	cmp dh,1	; Jan
	jne cl1
	mov si,offset jant	; Set to jan text
	call MONTH
	mov si,offset jan	
	jmp don
	
cl1:cmp dh,2	; Feb
	jne cl2
	mov si,offset febt
	call MONTH
	mov si, offset feb
	jmp don
	
cl2:cmp dh,3	; Mar
	jne cl3
	mov si,offset mart
	call MONTH
	mov si, offset mar
	jmp don
	
cl3:cmp dh,4	; Apr
	jne cl4
	mov si,offset aprt
	call MONTH
	mov si, offset apr
	jmp don
	
cl4:cmp dh,5	; May
	jne cl5
	mov si,offset mayt
	call MONTH
	mov si, offset may
	jmp don
	
cl5:cmp dh,6	; Jun
	jne cl6
	mov si,offset junt
	call MONTH
	mov si, offset jun
	jmp don
	
cl6:cmp dh,7	; Jul
	jne cl7
	mov si,offset jult
	call MONTH
	mov si, offset jul
	jmp don
	
cl7:cmp dh,8	; Aug
	jne cl8
	mov si,offset augt
	call MONTH
	mov si, offset aug
	jmp don
	
cl8:cmp dh,9 	; Sep
	jne cl9
	mov si,offset sept
	call MONTH
	mov si, offset sep
	jmp don
	
cl9:cmp dh,10	; Oct
	jne cl0
	mov si,offset octt
	call MONTH
	mov si, offset oct
	jmp don
	
cl0:cmp dh,11	; Nov
	jne cla
	mov si,offset novt
	call MONTH
	mov si, offset nov
	jmp don
	
cla:mov si,offset dest	; Dec
	call MONTH
	mov si, offset des
	jmp don

; Ende of compare
don:				; Write out the numbers to the month
	mov ah,60h		; Text color
	mov bx,986		; Starting box
	mov cx,6		; length of dates 48
da1:mov dx,7
da2:lodsb
	mov es:[bx],al
	lodsb
	add bx,2
	mov es:[bx],al
	add bx,14		; Jump to next cell
	dec dx
	jnz da2
	add bx,368		; Jump to next row
	loop da1

	popa
	ret
CALEND endp

CONTROL proc near
	; Get user input (Z-Previous X-Next C-Quit)
IP1:mov ah,00h	; Get key press
	int 16h
	cmp al,7ah	; z/prev
	je pre
	cmp al,78h	; x/next
	je nex
	cmp al,63h  ; c/esc
	je exi
	jmp IP1		; If no input keep waiting...	
	
pre:cmp dh,1	; If its jan you cant move back anymore, just wait for next input
	je IP1
	dec dh		; Otherwise show the month
	call CALEND
	jmp IP1

nex:cmp dh,12	; If dec, just wait for next input
	je IP1
	inc dh		; Otherwide show month
	call CALEND
	jmp IP1
	
exi:ret			; Exit
CONTROL endp

START:
	mov 	ax,0300h
	int 	10h
	mov 	ax,0B800h	; Move segment of video buffer into ax
	mov		es,ax		; then into es so we can write to screen
	call	SAVSCR		; Saves screen
	call	CLRSCR		; Makes my background (blue)
	call 	DRWHD		; Draws my banner
	call	DRWBD		; Draws my calendar body
	call	COLBD		; Colors it in
	call	DRWTXT		; Adds some text so theres meaning to my calendar
	mov 	ah,2ah		; Adds 2ah into ah so we get our current month
	int 	21h			; Month is put in dh
	call 	CALEND		; Prints number dates
	call 	CONTROL		; Loop where it gets user input
	call	RECSCR		; Restores users screen prior to when program started
.exit
end START