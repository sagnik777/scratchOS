/*
* Read / write a byte to the port registers
*/

unsigned char port_byte_in (unsigned short port)
{
	/* 
	** "=a" : Get the result from eax and store in c variable result
	** "d"  : Map the c varibale (port) value to edx
	** Input and Output are seprated by : 
	*/

	unsigned char result;
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}

unsigned short port_word_in (unsigned short port)
{
	unsigned short result;
	__asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
	return result;
}

void port_byte_out (unsigned short port, unsigned char data)
{
	/* 
	** "a"  : Map to data variable in c
	** "d"  : Map the c varibale (port) value to edx
	** No output, so no "=" variable
	** Only input variables separated by , 
	*/
	__asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

void port_word_out (unsigned short port, unsigned short data)
{
	__asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}

