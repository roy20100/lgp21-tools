;
; Example that prints "he11o1rd" 5 times and then stops.
;
    .org 0000
    .entry start
start:
    b num_times     ; Initialize the counter.
    h counter
loop:
    b msg           ; Bring first word of message into A.
    p 0200          ; Print top 6 bits of A to the typewriter.
    i 6200          ; Shift A left by 6 bits.
    p 0200          ; Repeat for 4 more characters.
    i 6200
    p 0200
    i 6200
    p 0200
    i 6200
    p 0200
    b msg+1         ; Bring second word of message into A.
    p 0200          ; Print 3 characters out of the second word.
    i 6200
    p 0200
    i 6200
    p 0200
    i 6200
    p 0200
    b counter       ; Increment the counter and stop when it reaches zero.
    a increment
    h counter
    t loop
    hlt             ; Done!
num_times:
    .dw #-10        ; -(N * 2) for N iterations before halting.
increment:
    .dw #2
msg:
    .dw "he11or1d\n"
    .noemit
counter:
    .dw 0
