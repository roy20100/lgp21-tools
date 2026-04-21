;
; Erases the contents of the LGP-21 disk to all zeroes.
;
; Program resides in track 63 and erases everything up to "start".
;
    .org    6300
start:
;
; Prompt the user to make sure they really, really, really want to do this.
;
    ld      erase_msg
    pr6
    shl6
    pr6
    shl6
    pr6
    shl6
    pr6
    shl6
    pr6
    ld      erase_msg+1
    pr6
    shl6
    pr6
    shl6
    pr6
    shl6
    pr6
    shl6
    pr6
    ld      zero
    sta     erase_word
    in6
    sub     yes_response    ; Is it "yes"?
    jn      bye
    sub     inc_addr
    jn      erase_disk
bye:                        ; Quit without erasing.
    hlt
;
; Now erase the disk.
;
erase_disk:
    ld      erase_word
    and     addr_mod_64
    sub     inc_addr
    jn      print_track
erase_next_word:
    ld      zero
erase_word:
    st      0000
;
; Advance to the next word.
;
    ld      erase_word
    add     inc_addr
    sta     erase_word
    sub     end_word
    jn      erase_disk
;
; Done.
;
    hlt
;
; Print the track numbers as we go.
;
print_track:
    ld      erase_msg       ; Print a newline.
    pr6
    ld      erase_word      ; Print the track number.
    shl6
    shl6
    shl4
    pr4
    shl4
    pr4
    jmp     erase_next_word
;
; Constants.
;
erase_msg:
    .dw     "\nerase? "
yes_response:
    .dw     $997c           ; "yes" in the low bits of the word.
zero:
    .dw     0
inc_addr:
    .dw     0001
addr_mod_64:
    .dw     0063
end_word:
    st      start
;
; Some padding before the bootstrap to ensure there are no gaps
; that will leave original data on the disk.
;
    .dw     0
    .dw     0
