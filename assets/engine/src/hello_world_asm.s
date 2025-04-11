    ; Let gbspack put this wherever it fits.
    .area _CODE_255

    ; Let GBVM know that this bank is managed by gbspack.
    ; The double equal sign causes this value to be made available to GBVM.
    b_hello_world_asm == 255


; Store our message in ROM alongside our code.
;
; Label the message's address.
_message:

    ; Define the message.
    .ascii "Hello, World!"

    ; Signal that '!' was the final character in the message by appending a null character.
    .db 0x00


; Define our routine.
;
; We'll use these registers:
;   A           The character being copied.
;   BC          Loop index.
;   HL          Memory addresses.
;   E           Bank index.
;
; Label the routine's address.  The double colon causes this label to be made available to GBVM.
hello_world_asm::

    ; Clear the index.
    ld bc, #0x0000

; Copy our message into the buffer.
copyloop:

    ; Load the address of the first character in "Hello, World!".
    ld hl, #_message

    ; Add BC into HL, offsetting the address by the number of times we've looped.
    add hl, bc

    ; Fetch the character from memory and load it into register A.
    ld a, (hl)
    
    ; If A is 0, set the Zero flag by comparing A with itself.
    or a, a

    ; If the Zero flag is set, we have nothing more to copy so jump to the end of the loop.
    jr Z, donecopying

    ; Otherwise, load the address of the ui_text_data buffer.
    ld hl, #_ui_text_data

    ; Add BC into HL, again offsetting the address by the times we've looped.
    add hl, bc

    ; Store the character we copied to the buffer.
    ld (hl), A

    ; Increment the index.
    inc bc

    ; Continue looping.
    jr copyloop

; Exit the loop.
donecopying:


    ; Next we need to position the overlay.

    ; Load the address of the overlay's Y position.
    ld hl, #_win_pos_y

    ; Store the screen's origin point to this memory location.
    ld (hl), #0x00

    ; Load the address of the overlay's Y destination position, used by the engine for opening and closing animations.
    ld hl, #_win_dest_pos_y

    ; Store the origin to this memory location, too.
    ld (hl), #0x00

    ; Load the address of the overlay's X position.
    ld hl, #_win_pos_x

    ; Store the origin to this location as well.
    ld (hl), #0x00

    ; Load the address of the overlay's X destination position, also used for opening and closing animations.
    ld hl, #_win_dest_pos_x

    ; Store the origin one last time.
    ld (hl), #0x00


    ; Last of all, we need to write the text.

    ; Load the index for the bank that holds the vm_display_text routine.
    ld e, #b_vm_display_text

    ; Load the address for vm_display_text.
    ld hl, #_vm_display_text

    ; Invoke the vm_display_text routine.
    call ___sdcc_bcall_ehl


    ; We're done!  Exit the hello_world_asm routine.
    ret

