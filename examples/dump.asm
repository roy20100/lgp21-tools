;
; Dump the contents of the LGP-21 disk.
;
; Program resides in track 0 and dumps tracks 1 to 63.
;
    .org    0000
    .entry  start
start:
    ld      newline
    pr6
    ld      first_address
    sta     read_word
;
; Print the number of the next track in hexadecimal.
;
next_track:
    ld      read_word
    shl6
    shl6
    shl4
    pr4
    shl4
    pr4
    ld      newline
    pr6
;
; Print the contents of the track.
;
read_word:
;
; Print the next word in hexadecimal.
;
    ld      0000
    pr4
    shl4
    pr4
    shl4
    pr4
    shl4
    pr4
    shl4
    pr4
    shl4
    pr4
    shl4
    pr4
    shl4
    pr4
    ld      space
    pr6
;
; Advance to the next word.  Print a newline every 8 words.
;
    ld      read_word
    add     inc_addr
    sta     read_word
    and     addr_mod_8
    sub     inc_addr
    jn      print_newline
    jmp     read_word
;
print_newline:
    ld      newline
    pr6
;
; Have we reached the end of the track yet?
;
    ld      read_word
    and     addr_mod_64
    sub     inc_addr
    jn      check_for_end
    jmp     read_word
;
; Are we done?
;
check_for_end:
    ld      read_word
    and     track_mask
    sub     inc_addr
    jn      done
    jmp     next_track
done:
;
; Constants.
;
space:
    .dw     " "     ; This also acts as the halt instruction for "done".
first_address:
    .dw     0100
track_mask:
    .dw     6363
inc_addr:
    .dw     0001
addr_mod_8:
    .dw     0007
addr_mod_64:
    .dw     0063
newline:
    .dw     "\n"
