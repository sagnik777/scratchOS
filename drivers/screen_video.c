/* Driver code to print messages on screen.
*
* Author	: Sagnik
* Created	: March, 2022
*/
#include "screen_video.h"

/*		FUNCTION DECLARATIONS		*/
int print_char(char character, int row, int col, char attr);
int get_cursor_offset();
void set_cursor_offset(int cursor_offset);
void clear_screen();
int get_offset(int row, int col);
int get_col_offset(int offset);
int get_row_offset(int offset);


/************************************************
*				PUBLIC APIs						*
************************************************/

/* Function to print a messsage on screen
* @Params -
* 	message : Pointer to the message to print
*/
void kprint(char *message) {
	kprint_location(message, -1, -1);
}

/* Function to print message at a given position
*  If position not mentioned, calculate offset and print
*
* @Params - 
* 	message : Pointer to the message
* 	row		: Row position to print
* 	col		: Col position to print
*/
void kprint_location(char *message, int row, int col) {
	int i = 0;
	int offset = 0;

	/* If row and col are specified, get the offset to start writing
	*  else get the cursor position, and calculate offset.
	*/
	if(row >= 0 && col >= 0) {
		offset = get_offset(row, col);		
	} else {
		offset = get_cursor_offset();
		row = get_row_offset(offset);
		col = get_col_offset(offset);
	}

	while(message[i] != 0) {
		offset = print_char(message[i++], row, col, WHITE_ON_BLACK);
		row = get_row_offset(offset);
		col = get_col_offset(offset);
	}
}

/************************************************
*				PRIVATE FUNCTIONS				*
************************************************/

/*
* Base function to print a character 
* at the location calculated by the offset from the video memory.
*
* @Params -
* character : Data to display (char)
* row 		: Row location for cursor (int)
* col 		: Col location for cursor (int)
* attr		: Attribute for the text display -> Background and Foreground colours (char)
*
* Return 	: the offset for next character.
*/
int print_char(char character, int row, int col, char attr) {
	unsigned char *videoMemory = (unsigned char*)VIDEO_MEMORY;
	int cursor_offset = 0;
		
	// If no attribute, set default attr -> WHITE_ON_BLACK
	if(!attr) {
		attr = WHITE_ON_BLACK;
	}

	// Get Offset for cursor position
	if(row >= 0 && col >= 0) {
		cursor_offset = get_offset(row, col);
	} else {
		cursor_offset = get_cursor_offset();
	}

	/* Print char 
	* If new line -> get the row offset and go to new line
	* else put the char and attr in the videoMemory location
	*/
	if(character == '\n') {
		row = get_row_offset(cursor_offset);
		cursor_offset = get_offset(row+1, 0);
	} else {
		videoMemory[cursor_offset] = character;
		videoMemory[cursor_offset+1] = attr;
		cursor_offset += 2;
	}

	set_cursor_offset(cursor_offset);
	return cursor_offset;
}

/*
* VGA ports to get current cursor position
* Read the CRTC register - 0x3d4(Address) 0x3d5(Data)
* CRTC -> Index 14/15 => Cursor Position Registers.
* High byte in index 14
*
* Return : Offset
*/
int get_cursor_offset() {
	int offset = 0;

	/* High byte: << 8 */
    port_byte_out(SCREEN_REG_CTRL, 14);
    offset = port_byte_in(SCREEN_REG_DATA) << 8;
    port_byte_out(SCREEN_REG_CTRL, 15);
    offset += port_byte_in(SCREEN_REG_DATA);

	/* Position * size of character cell */
    return (offset*2);
}

void set_cursor_offset(int cursor_offset) {
	cursor_offset /= 2;
    port_byte_out(SCREEN_REG_CTRL, 14);
    port_byte_out(SCREEN_REG_DATA, (unsigned char)(cursor_offset >> 8));
    port_byte_out(SCREEN_REG_CTRL, 15);
    port_byte_out(SCREEN_REG_DATA, (unsigned char)(cursor_offset & 0xff));
}

void clear_screen() {
	int screen_size = VIDEO_MEM_MAX_ROW * VIDEO_MEM_MAX_COL;
	char *video_mem = VIDEO_MEMORY;
	int i = 0;

	for(i=0; i<screen_size; i++) {
		video_mem[(i*2)] = ' ';
		video_mem[(i*2)+1] = WHITE_ON_BLACK;
	}
	set_cursor_offset(get_offset(0, 0));
}

int get_offset(int row, int col) {
	return (2*((row * VIDEO_MEM_MAX_COL) + col));
}

int get_row_offset(int offset) {
	return (offset / (2 * VIDEO_MEM_MAX_COL));
}

int get_col_offset(int offset) {
	return (offset - (get_row_offset(offset) * 2 * VIDEO_MEM_MAX_COL))/2;
}
