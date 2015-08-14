These two files are the minor edits I made to the Hardware Serial code in the arduino-tiny code, which you can find at https://code.google.com/p/arduino-tiny/

VGATonic needs these edits because it handles UART interrupts on its own.

As arduino-tiny is released under an LGPL license, I have included my modified files so you can reproduce my work exactly.

On a Mac, here's the path:

Arduino (Right Click) -> Show package contents

/Contents/Resources/Java/hardware/tiny/avr/cores/tiny/

(Replace the two Hardware Serial files)