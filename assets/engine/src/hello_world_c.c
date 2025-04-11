// Let gbspack put this wherever it fits.
#pragma bank 255

// Include the UI routines.
#include "vm_ui.h"

// Reference the text buffer defined by the engine.
extern unsigned char ui_text_data[255];

void hello_world_c(SCRIPT_CTX * THIS) OLDCALL BANKED {

    // Define the message.
    const char * hello = "Hello, World!";

    // Copy the message into the text buffer.
    char idx = 0;
    while (hello[idx] != 0) {
        ui_text_data[idx] = hello[idx++];
    }

    // Display the message...
    vm_display_text(THIS, 
                    // ...using default options...
                    0,
                    // ...at the default location.
                    0xFF);

    // Show the overlay window, where the text was displayed...
    vm_overlay_move_to(THIS,
                       // ...halway down the screen...
                       0, 7,
                       // ...instantly.
                       -3);
}
