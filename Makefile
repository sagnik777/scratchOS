# Wildcards for all files
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
# Syntax for file replacement
OBJ = ${C_SOURCES:.c=.o}

# GCC and GDB paths
# Change paths if different
CC = /root/Desktop/scratch_OS/toolchain/bin/i386-elf-gcc
GDB = /root/Desktop/scratch_OS/toolchain/bin/i386-elf-gdb
LINK = /root/Desktop/scratch_OS/toolchain/bin/i386-elf-ld

#Compilation Flags
CFLAGS = -g

#First rule, default => Build os_image.bin
os_image.bin: boot/boot_main.bin kernel.bin
	./os_bin_make

# Kernel withput GDB as `--oformat` deletes all symbols
kernel.bin: boot/kernel_entry.o ${OBJ}
	${LINK} -o $@ -Ttext 0x1000 $^ --oformat binary

# Kernel for GDB
kernel.elf: boot/kernel_entry.o ${OBJ}
	${LINK} -o $@ -Ttext 0x1000 $^

# Release Build run command
release: os_image.bin
	qemu-system-x86_64 os_image.bin

# Debug build run command
debug: os_image.bin kernel.elf
	qemu-system-x86_64 -s os_image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# Generic rules for wildcards
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	nasm -f elf $< -o $@

%.bin: %.asm
	nasm -f bin $< -o $@

# Clean
clean:
	rm -rfv *.bin *.dis *.o os_imagebin *.elf
	rm -rfv kernel/*.o boot/*.bin drivers/*.o boot/*.o
