/* Entry Point for the kernel operations
*  Code is linked at 0x1000 for the bootloader to load kernel.
*
*  Author : Sagnik
*  Created : March, 2022
*/
#include "../drivers/screen_video.h"

void main() {
	clear_screen();
	kprint("Hi !!!. This is ScratchOS ... ");
	kprint("Have a Good Day");
	kprint_location("X", 1, 6);
    kprint_location("This text spans multiple lines", 75, 10);
    kprint_location("There is a line\nbreak", 0, 20);
    kprint("There is a line\nbreak");
    kprint_location("What happens when we run out of space?", 45, 24);
}
