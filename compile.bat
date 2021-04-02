nasm bootloader.asm -f bin -o bootloader.bin

nasm extndprog.asm -f elf64 -o extndprog.o

wsl $WSLENV x86_64-elf-gcc -ffreestanding -mno-red-zone -m64 -c "Kernel.cpp" -o "Kernel.o"

wsl $WSLENV custom-ld -o kernel.tmp -Ttext 0x7e00 extndprog.o Kernel.o

wsl $WSLENV objcopy -O binary kernel.tmp kernel.bin

copy /b bootloader.bin+kernel.bin bootloader.flp

pause