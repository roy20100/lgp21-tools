;Vertical range & size
.2136:	iLow:	.dw -1.1 >> 4
.1224:	iHigh:	.dw 1.1 >> 4
.1229:	iStep:	.dw 0.1 >> 4

;Horizontal range & size
.1231:	rLow:	.dw -2.1 >> 4
.1230:	rHigh:	.dw 0.52 >> 4
.1235:	rStep:	.dw 0.040 >> 4

;Maximum number of iterations
.1233:	max:	.dw #28

;Current position
.1245:	iPos:	.dw 0
.1262:	rPos:	.dw 0;

;Iteration variables
.1251:	itr:	.dw 0
.1213:	x:	    .dw 0
.1206:	xTemp:	.dw 0
.1247:	xx:	    .dw 0
.1225:	y:	    .dw 0
.1218:	yy:	    .dw 0

;Constants for computation
.1243:	dec:	.dw #2
.1221:	twoF:	.dw 2.0 >> 4
.1255:	fourF:	.dw 4.0 >> 4

;Constants for output
.1226:	eol:	.dw "\n"
.1252:	space:	.dw " "

    .org 1000
    .entry start

start:                      ;Start a new fractal  
            ld  iLow        ;Reset iPos to iLow
            st  iPos

newLine:                    ;Start a new line
            ld  rLow        ;Reset rPos to rLow
            st  rPos
            
            ld  eol         ;Print a new line
            pr6

            ld  iPos        ;iPos += iStep        
            add iStep
            st  iPos

            sub iHigh       ;If iPos > iHigh goto start
            jnt nextChar    ;else goto nextChar:
            hlt             ; TODO jmp start

nextChar:                   ;Work out the next character
            ld  rPos        ;rPos += rStep
            add rStep
            st  rPos

            sub rHigh       ;if rPos < rHigh
            jnt compute     ;   goto compute
            jmp newLine     ;else goto newLine


compute:
            ld  max         ;itr = max
            stc itr
            st x            ; x = 0
            st y            ; y = 0

iterate:
            ; xtemp := x^2 - y^2 + x0    
            ld  y           ; yy = y * y
            mulh y
            shl4
            st yy
            nop
            ld x            ; x*x
            nop
            nop
            mulh x
            shl4
            st xx
            jmp 1039
.1039:
            sub yy          ; ... - y*y
            add rPos        ; + x0
            st  xTemp

                            ; y := 2*x*y + y0
            ld twoF
            jmp 1048
.1048:
            mulh x
            shl4
            mulh y
            shl4
            add iPos
            st y

            ld xTemp        ; x := xtemp
            st x

            ld itr          ;Decrement Iterator
            sub dec
            st itr
            jnt in          ;Iterator went negative, we are IN

            ld yy           ;Are we still inside the 2-unit circle?
            add xx
            sub fourF
            jnt iterate     ;Left the circle, we are out
            jmp out

out:        ld itr
            shl6
            shl6
            shl6
            shl6
            shl4
            pr4
            jmp nextChar

in:         ld space
            pr6
            jmp nextChar

