    .org 1000
    .entry start

iLow:
    .dw -1.15 >> 4
iHigh:
    .dw 1.1 >> 4
iStep:
    .dw 0.05 >> 4
iPos:
    .dw 0

rLow:
    .dw -2.1 >> 4
rHigh:
    .dw 0.52 >> 4
rStep:
    .dw 0.020 >> 4
rPos:
    .dw 0;

eol:
    .dw "\n"
dot:
    .dw "."
star:
    .dw " "
                    
start:              ;Start a new fractal
    ld  iLow        ;Reset iPos to iLow
    st  iPos
newLine:            ;Start a new line
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
nextChar:
    ld  rPos        ;rPos += rStep
    add rStep
    st  rPos

    sub rHigh       ;if rPos > rHigh goto newLine
    jnt compute
    jmp newLine


max:
    .dw #36
dec:
    .dw #2
itr:
    .dw 0
x:
    .dw 0
y:
    .dw 0
xTemp:
    .dw 0
xx:
    .dw 0
yy:
    .dw 0
twoF:
    .dw 2.0 >> 4
fourF:
    .dw 4.0 >> 4

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
    ld x            ; x*x
    mulh x
    shl4
    st xx
    sub yy          ; ... - y*y
    add rPos        ; + x0
    st  xTemp

                    ; y := 2*x*y + y0
    ld twoF
    mulh x
    shl4
    mulh y
    shl4
    add iPos
    st y

                    ; x := xtemp
    ld xTemp
    st x

    ld itr          ;Decrement Iterator
    sub dec
    st itr

    jnt in         ;Iterator went negative, we are IN

    ld xx
    add yy
    sub fourF
    jnt iterate         ;Left the circle, we are out

    jmp out


in:
    ld star
    pr6
    jmp nextChar

out:
    ld  itr
    shl4
    shl4
    shl4
    shl4
    shl4
    shl6
    ;shl4
    pr4
    jmp nextChar