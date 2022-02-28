/*
* Defines required for the screen device IO
*/

#define VIDEO_MEMORY 0xb8000
#define VIDEO_MEM_MAX_ROW 25
#define VIDEO_MEM_MAX_COL 80

// ATTRIBUTE byte for text colour scheme
#define WHITE_ON_BLACK 0x0f
#define LIGHTGREY_ON_BLACK 0x07 //(DOS default)
#define WHITE_ON_BLUE 0x1f
#define GREEN_MONOCHROME 0x2a
#define RED_ON_WHITE 0xf4

// Screen IO ports
#define SCREEN_REG_CTRL 0x3d4
#define SCREEN_REG_DATA 0x3d5

// Public APIs
void clear_screen();
void kprint_location(char *message, int row, int col);
void kprint(char *message);
