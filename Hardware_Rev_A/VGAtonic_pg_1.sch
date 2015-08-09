EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:PK
LIBS:1wire
LIBS:3M
LIBS:7sh
LIBS:20f001n
LIBS:29le010
LIBS:40xx
LIBS:65xxx
LIBS:74ah
LIBS:74hc(t)4046
LIBS:74xx-eu
LIBS:74xx-little-us
LIBS:78xx_with_heatsink
LIBS:con-vg
LIBS:VGAtonic-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 2
Title "VGAtonic First Draft"
Date "21 jul 2014"
Rev "0.01"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ATTINY2313A-S IC1
U 1 1 53C381E4
P 2250 1850
F 0 "IC1" H 1400 2800 60  0000 C CNN
F 1 "ATTINY2313A-S" H 3050 1000 60  0000 C CNN
F 2 "SO20" H 1250 1000 60  0001 C CNN
F 3 "" H 2250 1850 60  0000 C CNN
	1    2250 1850
	1    0    0    -1  
$EndComp
$Comp
L LTC6903 U1
U 1 1 53C381F3
P 2550 6700
F 0 "U1" H 2900 7250 60  0000 C CNN
F 1 "LTC6903" H 2850 6150 60  0000 C CNN
F 2 "" H 2550 6700 60  0000 C CNN
F 3 "" H 2550 6700 60  0000 C CNN
	1    2550 6700
	1    0    0    -1  
$EndComp
$Comp
L IS61LV5128AL U3
U 1 1 53C3827F
P 9400 2950
F 0 "U3" H 9850 4200 60  0000 C CNN
F 1 "IS61LV5128AL" H 10050 1250 60  0000 C CNN
F 2 "" H 9400 2500 60  0000 C CNN
F 3 "" H 9400 2500 60  0000 C CNN
	1    9400 2950
	1    0    0    -1  
$EndComp
Text Label 8350 2100 0    60   ~ 0
IO0
Text Label 8350 2200 0    60   ~ 0
IO1
Text Label 8350 2300 0    60   ~ 0
IO2
Text Label 8350 2400 0    60   ~ 0
IO3
Text Label 8350 2500 0    60   ~ 0
IO4
Text Label 8350 2600 0    60   ~ 0
IO5
Text Label 8350 2700 0    60   ~ 0
IO6
Text Label 8350 2800 0    60   ~ 0
IO7
$Comp
L +3.3V #PWR01
U 1 1 53C42E72
P 9350 1300
F 0 "#PWR01" H 9350 1260 30  0001 C CNN
F 1 "+3.3V" H 9350 1410 30  0000 C CNN
F 2 "" H 9350 1300 60  0000 C CNN
F 3 "" H 9350 1300 60  0000 C CNN
	1    9350 1300
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR02
U 1 1 53C42ECA
P 5600 1250
F 0 "#PWR02" H 5600 1210 30  0001 C CNN
F 1 "+3.3V" H 5600 1360 30  0000 C CNN
F 2 "" H 5600 1250 60  0000 C CNN
F 3 "" H 5600 1250 60  0000 C CNN
	1    5600 1250
	1    0    0    -1  
$EndComp
Text Label 10300 2100 0    60   ~ 0
A0
Text Label 10300 2200 0    60   ~ 0
A1
Text Label 10300 2300 0    60   ~ 0
A2
Text Label 10300 2400 0    60   ~ 0
A3
Text Label 10300 2500 0    60   ~ 0
A4
Text Label 10300 2600 0    60   ~ 0
A5
Text Label 10300 2700 0    60   ~ 0
A6
Text Label 10300 2800 0    60   ~ 0
A7
Text Label 10300 2900 0    60   ~ 0
A8
Text Label 10300 3000 0    60   ~ 0
A9
Text Label 10300 3100 0    60   ~ 0
A10
Text Label 10300 3200 0    60   ~ 0
A11
Text Label 10300 3300 0    60   ~ 0
A12
Text Label 10300 3400 0    60   ~ 0
A13
Text Label 10300 3500 0    60   ~ 0
A14
Text Label 10300 3600 0    60   ~ 0
A15
Text Label 10300 3700 0    60   ~ 0
A16
Text Label 10300 3800 0    60   ~ 0
A17
Text Label 10300 3900 0    60   ~ 0
A18
NoConn ~ 8500 3450
NoConn ~ 8500 3550
NoConn ~ 8500 3650
NoConn ~ 8500 3750
NoConn ~ 8500 3850
NoConn ~ 8500 3950
NoConn ~ 8500 4050
NoConn ~ 8500 4150
NoConn ~ 8500 4250
NoConn ~ 8500 4350
$Comp
L GND #PWR03
U 1 1 53C43F4E
P 5700 7600
F 0 "#PWR03" H 5700 7600 30  0001 C CNN
F 1 "GND" H 5700 7530 30  0001 C CNN
F 2 "" H 5700 7600 60  0000 C CNN
F 3 "" H 5700 7600 60  0000 C CNN
	1    5700 7600
	1    0    0    -1  
$EndComp
$Comp
L XC95144PQ100 U2
U 1 1 53C71CB2
P 5950 4350
F 0 "U2" H 6600 7000 60  0000 C CNN
F 1 "XC95144PQ100" H 6900 1600 60  0000 C CNN
F 2 "~" H 5950 4350 60  0000 C CNN
F 3 "~" H 5950 4350 60  0000 C CNN
	1    5950 4350
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR04
U 1 1 53C73B93
P 2550 5600
F 0 "#PWR04" H 2550 5560 30  0001 C CNN
F 1 "+3.3V" H 2550 5710 30  0000 C CNN
F 2 "" H 2550 5600 60  0000 C CNN
F 3 "" H 2550 5600 60  0000 C CNN
	1    2550 5600
	1    0    0    -1  
$EndComp
NoConn ~ 3300 6800
$Comp
L GND #PWR05
U 1 1 53C73C98
P 2550 7650
F 0 "#PWR05" H 2550 7650 30  0001 C CNN
F 1 "GND" H 2550 7580 30  0001 C CNN
F 2 "" H 2550 7650 60  0000 C CNN
F 3 "" H 2550 7650 60  0000 C CNN
	1    2550 7650
	1    0    0    -1  
$EndComp
NoConn ~ 4800 6750
NoConn ~ 4800 6850
$Comp
L GND #PWR06
U 1 1 53C74314
P 2250 3000
F 0 "#PWR06" H 2250 3000 30  0001 C CNN
F 1 "GND" H 2250 2930 30  0001 C CNN
F 2 "" H 2250 3000 60  0000 C CNN
F 3 "" H 2250 3000 60  0000 C CNN
	1    2250 3000
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 53C7454E
P 1150 750
F 0 "R2" V 1230 750 40  0000 C CNN
F 1 "4.7k" V 1157 751 40  0000 C CNN
F 2 "~" V 1080 750 30  0000 C CNN
F 3 "~" H 1150 750 30  0000 C CNN
	1    1150 750 
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 53C74719
P 1550 5850
F 0 "R1" V 1630 5850 40  0000 C CNN
F 1 "10k" V 1557 5851 40  0000 C CNN
F 2 "~" V 1480 5850 30  0000 C CNN
F 3 "~" H 1550 5850 30  0000 C CNN
	1    1550 5850
	0    -1   -1   0   
$EndComp
Text Label 700  5650 3    39   ~ 0
~AVR_SEL_CLK
Text Label 3650 1350 0    39   ~ 0
~AVR_SEL_CPLD
Text Label 3650 1450 0    39   ~ 0
~AVR_SEL_CLK
$Sheet
S 1100 3350 1650 1800
U 53C72D11
F0 "InputsOutputsPower" 50
F1 "VGATonicInputsOutputsPower.sch" 50
F2 "HSYNC" I R 2750 3400 39 
F3 "VSYNC" I R 2750 3450 39 
F4 "Red1" I R 2750 3500 39 
F5 "Red2" I R 2750 3550 39 
F6 "Red3" I R 2750 3600 39 
F7 "Green1" I R 2750 3650 39 
F8 "Green2" I R 2750 3700 39 
F9 "Green3" I R 2750 3750 39 
F10 "Blue1" I R 2750 3800 39 
F11 "Blue2" I R 2750 3850 39 
F12 "TDI" I R 2750 4950 39 
F13 "TMS" O R 2750 5000 39 
F14 "TCK" O R 2750 5050 39 
F15 "TDO" O R 2750 5100 39 
F16 "EXT_MISO" I R 2750 4850 39 
F17 "EXT_MOSI" O R 2750 4800 39 
F18 "EXT_SCK" O R 2750 4750 39 
F19 "~EXT_SEL_CPLD" O R 2750 4700 39 
F20 "AVR_GPIO_1" B L 1100 3750 39 
F21 "AVR_GPIO_2" B L 1100 3800 39 
F22 "AVR_GPIO_3" B L 1100 3850 39 
F23 "AVR_GPIO_4" B L 1100 3900 39 
F24 "AVR_GPIO_5" B L 1100 3950 39 
F25 "AVR_GPIO_6" B L 1100 4000 39 
F26 "CPLD_GPIO_1" B L 1100 4100 39 
F27 "CPLD_GPIO_2" B L 1100 4150 39 
F28 "CPLD_GPIO_3" B L 1100 4200 39 
F29 "CPLD_GPIO_4" B L 1100 4250 39 
F30 "CPLD_GPIO_5" B L 1100 4300 39 
F31 "CPLD_GPIO_6" B L 1100 4350 39 
F32 "CPLD_GPIO_7" B L 1100 4400 39 
F33 "CPLD_GPIO_8" B L 1100 4450 39 
F34 "CPLD_GPIO_9" B L 1100 4500 39 
F35 "CPLD_GPIO_10" B L 1100 4550 39 
F36 "CPLD_GPIO_11" B L 1100 4600 39 
F37 "CPLD_GPIO_12" B L 1100 4650 39 
F38 "CPLD_GPIO_13" B L 1100 4700 39 
F39 "CPLD_GPIO_14" B L 1100 4750 39 
F40 "CPLD_GPIO_15" B L 1100 4800 39 
F41 "CPLD_GPIO_16" B L 1100 4850 39 
F42 "~AVR_RESET" O L 1100 4950 39 
F43 "AVR_MOSI" O L 1100 5000 39 
F44 "AVR_MISO" I L 1100 5050 39 
F45 "AVR_SCK" O L 1100 5100 39 
F46 "Blue3" I R 2750 3900 39 
F47 "AVR_RX" O R 2750 4600 39 
F48 "SW_1" I R 2750 4100 39 
F49 "SW_2" I R 2750 4150 39 
F50 "SW_3" I R 2750 4200 39 
F51 "AVR_TX" I R 2750 4550 39 
F52 "LUMA2" I L 1100 3550 39 
F53 "LUMA3" I L 1100 3600 39 
F54 "LUMA4" I L 1100 3650 39 
F55 "COLORBURST" I L 1100 3450 39 
F56 "SYNC" I L 1100 3400 39 
F57 "LUMA1" I L 1100 3500 39 
$EndSheet
$Comp
L R R3
U 1 1 53C750C6
P 4450 1750
F 0 "R3" V 4530 1750 40  0000 C CNN
F 1 "10k" V 4457 1751 40  0000 C CNN
F 2 "~" V 4380 1750 30  0000 C CNN
F 3 "~" H 4450 1750 30  0000 C CNN
	1    4450 1750
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 53C750D5
P 4300 2550
F 0 "R4" V 4380 2550 40  0000 C CNN
F 1 "10k" V 4307 2551 40  0000 C CNN
F 2 "~" V 4230 2550 30  0000 C CNN
F 3 "~" H 4300 2550 30  0000 C CNN
	1    4300 2550
	1    0    0    -1  
$EndComp
Text Label 4300 6150 0    39   ~ 0
AVR_CPLD_RESET
Text Label 3650 1250 0    39   ~ 0
AVR_CPLD_RESET
$Comp
L +3.3V #PWR07
U 1 1 53C9562C
P 8350 5800
F 0 "#PWR07" H 8350 5760 30  0001 C CNN
F 1 "+3.3V" H 8350 5910 30  0000 C CNN
F 2 "" H 8350 5800 60  0000 C CNN
F 3 "" H 8350 5800 60  0000 C CNN
	1    8350 5800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 53C9563B
P 10550 6600
F 0 "#PWR08" H 10550 6600 30  0001 C CNN
F 1 "GND" H 10550 6530 30  0001 C CNN
F 2 "" H 10550 6600 60  0000 C CNN
F 3 "" H 10550 6600 60  0000 C CNN
	1    10550 6600
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 53C9564A
P 8350 6200
F 0 "C1" H 8350 6300 40  0000 L CNN
F 1 "0.1uF" H 8356 6115 40  0000 L CNN
F 2 "~" H 8388 6050 30  0000 C CNN
F 3 "~" H 8350 6200 60  0000 C CNN
	1    8350 6200
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 53C95657
P 8550 6200
F 0 "C2" H 8550 6300 40  0000 L CNN
F 1 "0.1uF" H 8556 6115 40  0000 L CNN
F 2 "~" H 8588 6050 30  0000 C CNN
F 3 "~" H 8550 6200 60  0000 C CNN
	1    8550 6200
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 53C9565D
P 8750 6200
F 0 "C3" H 8750 6300 40  0000 L CNN
F 1 "0.1uF" H 8756 6115 40  0000 L CNN
F 2 "~" H 8788 6050 30  0000 C CNN
F 3 "~" H 8750 6200 60  0000 C CNN
	1    8750 6200
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 53C95663
P 8950 6200
F 0 "C4" H 8950 6300 40  0000 L CNN
F 1 "0.1uF" H 8956 6115 40  0000 L CNN
F 2 "~" H 8988 6050 30  0000 C CNN
F 3 "~" H 8950 6200 60  0000 C CNN
	1    8950 6200
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 53C95669
P 9150 6200
F 0 "C5" H 9150 6300 40  0000 L CNN
F 1 "0.1uF" H 9156 6115 40  0000 L CNN
F 2 "~" H 9188 6050 30  0000 C CNN
F 3 "~" H 9150 6200 60  0000 C CNN
	1    9150 6200
	1    0    0    -1  
$EndComp
$Comp
L C C6
U 1 1 53C9566F
P 9350 6200
F 0 "C6" H 9350 6300 40  0000 L CNN
F 1 "0.1uF" H 9356 6115 40  0000 L CNN
F 2 "~" H 9388 6050 30  0000 C CNN
F 3 "~" H 9350 6200 60  0000 C CNN
	1    9350 6200
	1    0    0    -1  
$EndComp
$Comp
L C C7
U 1 1 53C95675
P 9550 6200
F 0 "C7" H 9550 6300 40  0000 L CNN
F 1 "0.1uF" H 9556 6115 40  0000 L CNN
F 2 "~" H 9588 6050 30  0000 C CNN
F 3 "~" H 9550 6200 60  0000 C CNN
	1    9550 6200
	1    0    0    -1  
$EndComp
$Comp
L C C8
U 1 1 53C9567B
P 9750 6200
F 0 "C8" H 9750 6300 40  0000 L CNN
F 1 "0.1uF" H 9756 6115 40  0000 L CNN
F 2 "~" H 9788 6050 30  0000 C CNN
F 3 "~" H 9750 6200 60  0000 C CNN
	1    9750 6200
	1    0    0    -1  
$EndComp
$Comp
L C C9
U 1 1 53C95681
P 9950 6200
F 0 "C9" H 9950 6300 40  0000 L CNN
F 1 "0.1uF" H 9956 6115 40  0000 L CNN
F 2 "~" H 9988 6050 30  0000 C CNN
F 3 "~" H 9950 6200 60  0000 C CNN
	1    9950 6200
	1    0    0    -1  
$EndComp
$Comp
L C C10
U 1 1 53C95687
P 10150 6200
F 0 "C10" H 10150 6300 40  0000 L CNN
F 1 "0.1uF" H 10156 6115 40  0000 L CNN
F 2 "~" H 10188 6050 30  0000 C CNN
F 3 "~" H 10150 6200 60  0000 C CNN
	1    10150 6200
	1    0    0    -1  
$EndComp
$Comp
L C C11
U 1 1 53C9568D
P 10350 6200
F 0 "C11" H 10350 6300 40  0000 L CNN
F 1 "0.1uF" H 10356 6115 40  0000 L CNN
F 2 "~" H 10388 6050 30  0000 C CNN
F 3 "~" H 10350 6200 60  0000 C CNN
	1    10350 6200
	1    0    0    -1  
$EndComp
Text Notes 650  6950 0    39   ~ 0
Leaving this connected to the uC means\nwe can get other resolutions out of the CPLD\nthrough software changes.
Text Notes 750  2750 0    39   ~ 0
ATTINY2313A chosen in case we want to take\nadvantage of that UART...
Text Label 3650 1050 0    39   ~ 0
AVR_CPLD_EXT_2
Text Label 3650 1150 0    39   ~ 0
AVR_CPLD_EXT_1
Text Label 4550 3400 2    39   ~ 0
AVR_CPLD_EXT_3
Text Label 3950 6650 2    39   ~ 0
50MHz_CLK
Text Notes 9550 5650 2    61   ~ 0
Decap
$Comp
L C C12
U 1 1 53CD9CA8
P 10550 6200
F 0 "C12" H 10550 6300 40  0000 L CNN
F 1 "1uF" H 10556 6115 40  0000 L CNN
F 2 "~" H 10588 6050 30  0000 C CNN
F 3 "~" H 10550 6200 60  0000 C CNN
	1    10550 6200
	1    0    0    -1  
$EndComp
Text Notes 10700 6450 1    28   ~ 0
Extra 1uF for LTC6903
Text Label 4550 3300 2    39   ~ 0
AVR_CPLD_EXT_2
Text Label 4550 3200 2    39   ~ 0
AVR_CPLD_EXT_1
Text Label 4050 3500 0    39   ~ 0
SYNC
Text Label 4050 3600 0    39   ~ 0
COLORBURST
Text Label 4050 3700 0    39   ~ 0
LUMA1
Text Label 4050 3800 0    39   ~ 0
LUMA2
Text Label 4050 3900 0    39   ~ 0
LUMA3
Text Label 4050 4000 0    39   ~ 0
LUMA4
Text Label 650  3400 0    39   ~ 0
SYNC
Text Label 650  3450 0    39   ~ 0
COLORBURST
Text Label 650  3500 0    39   ~ 0
LUMA1
Text Label 650  3550 0    39   ~ 0
LUMA2
Text Label 650  3600 0    39   ~ 0
LUMA3
Text Label 650  3650 0    39   ~ 0
LUMA4
Text Label 4500 2400 0    39   ~ 0
EXT_SCK
Text Label 4500 2500 0    39   ~ 0
EXT_MOSI
Text Label 4500 2600 0    39   ~ 0
EXT_MISO
Text Label 4350 2800 0    39   ~ 0
AVR_SCK
Text Label 4350 3000 0    39   ~ 0
AVR_MOSI
Text Label 4350 2900 0    39   ~ 0
AVR_MISO
Text Label 4500 2700 0    39   ~ 0
~EXT_SEL_CPLD
Text Label 2800 4700 0    39   ~ 0
~EXT_SEL_CPLD
Text Label 2800 4750 0    39   ~ 0
EXT_SCK
Text Label 2800 4800 0    39   ~ 0
EXT_MOSI
Text Label 2800 4850 0    39   ~ 0
EXT_MISO
Wire Wire Line
	8350 2100 8500 2100
Wire Wire Line
	8350 2200 8500 2200
Wire Wire Line
	8350 2300 8500 2300
Wire Wire Line
	8350 2400 8500 2400
Wire Wire Line
	8350 2500 8500 2500
Wire Wire Line
	8350 2800 8500 2800
Wire Wire Line
	8350 2700 8500 2700
Wire Wire Line
	8350 2600 8500 2600
Wire Wire Line
	9350 1300 9350 1500
Wire Wire Line
	5600 1250 5600 1500
Wire Wire Line
	5600 1350 6400 1350
Connection ~ 5600 1350
Wire Wire Line
	5700 1350 5700 1500
Wire Wire Line
	6400 1350 6400 1500
Connection ~ 5700 1350
Wire Wire Line
	6300 1500 6300 1350
Connection ~ 6300 1350
Wire Wire Line
	6200 1500 6200 1350
Connection ~ 6200 1350
Wire Wire Line
	6100 1500 6100 1350
Connection ~ 6100 1350
Wire Wire Line
	5800 1500 5800 1350
Connection ~ 5800 1350
Wire Wire Line
	10200 2100 10500 2100
Wire Wire Line
	10200 2200 10500 2200
Wire Wire Line
	10200 2300 10500 2300
Wire Wire Line
	10200 2400 10500 2400
Wire Wire Line
	10500 2500 10200 2500
Wire Wire Line
	10200 2600 10500 2600
Wire Wire Line
	10200 2700 10500 2700
Wire Wire Line
	10200 2800 10500 2800
Wire Wire Line
	10200 2900 10500 2900
Wire Wire Line
	10200 3000 10500 3000
Wire Wire Line
	10200 3100 10500 3100
Wire Wire Line
	10200 3200 10500 3200
Wire Wire Line
	10200 3300 10500 3300
Wire Wire Line
	10200 3400 10500 3400
Wire Wire Line
	10200 3500 10500 3500
Wire Wire Line
	10200 3600 10500 3600
Wire Wire Line
	10200 3700 10500 3700
Wire Wire Line
	10200 3800 10500 3800
Wire Wire Line
	10200 3900 10500 3900
Wire Wire Line
	10450 4150 10200 4150
Wire Wire Line
	10450 4250 10200 4250
Wire Wire Line
	10450 4350 10200 4350
Wire Wire Line
	9350 4800 9350 5000
Wire Wire Line
	9500 4800 9500 5000
Connection ~ 10800 5000
Wire Wire Line
	7100 6550 7300 6550
Wire Wire Line
	7100 6650 7300 6650
Wire Wire Line
	7100 6750 7300 6750
Wire Wire Line
	7100 6850 7300 6850
Wire Wire Line
	7100 5300 7400 5300
Wire Wire Line
	7100 5400 7400 5400
Wire Wire Line
	7100 5500 7400 5500
Wire Wire Line
	7100 5600 7400 5600
Wire Wire Line
	7100 5700 7400 5700
Wire Wire Line
	7100 5800 7400 5800
Wire Wire Line
	7100 5900 7400 5900
Wire Wire Line
	7100 6000 7400 6000
Wire Wire Line
	7100 6100 7400 6100
Wire Wire Line
	7100 6200 7400 6200
Wire Wire Line
	6400 7400 6400 7200
Wire Wire Line
	5700 7400 6400 7400
Wire Wire Line
	5700 7200 5700 7600
Connection ~ 5700 7400
Wire Wire Line
	5800 7200 5800 7400
Connection ~ 5800 7400
Wire Wire Line
	5900 7200 5900 7400
Connection ~ 5900 7400
Wire Wire Line
	6000 7200 6000 7400
Connection ~ 6000 7400
Wire Wire Line
	6100 7200 6100 7400
Connection ~ 6100 7400
Wire Wire Line
	6200 7200 6200 7400
Connection ~ 6200 7400
Wire Wire Line
	6300 7200 6300 7400
Connection ~ 6300 7400
Wire Wire Line
	4800 6650 3300 6650
Wire Wire Line
	2550 5600 2550 5900
Wire Wire Line
	2550 5750 3500 5750
Wire Wire Line
	3500 5750 3500 6500
Wire Wire Line
	3500 6500 3300 6500
Connection ~ 2550 5750
Wire Wire Line
	2550 7650 2550 7450
Wire Wire Line
	700  6800 1750 6800
Wire Wire Line
	2250 3000 2250 2850
Wire Wire Line
	700  5650 700  6800
Wire Wire Line
	700  5850 1300 5850
Wire Wire Line
	1800 5850 2550 5850
Connection ~ 2550 5850
Connection ~ 700  5850
Wire Wire Line
	4500 2500 4800 2500
Wire Wire Line
	4800 2600 4500 2600
Wire Wire Line
	4800 2700 4450 2700
Wire Wire Line
	4050 3500 4800 3500
Wire Wire Line
	4800 3600 4050 3600
Wire Wire Line
	4800 3700 4050 3700
Wire Wire Line
	4800 3800 4050 3800
Wire Wire Line
	4800 3900 4050 3900
Wire Wire Line
	4800 4000 4050 4000
Wire Wire Line
	4300 6150 4800 6150
Wire Wire Line
	3600 1350 4050 1350
Wire Wire Line
	3600 1450 4050 1450
Wire Wire Line
	3600 1250 4050 1250
Wire Wire Line
	4800 6250 4300 6250
Wire Wire Line
	4800 6350 4300 6350
Wire Wire Line
	4800 6450 4300 6450
Wire Wire Line
	4800 6550 4300 6550
Wire Wire Line
	3600 2150 3900 2150
Wire Wire Line
	3600 2250 3900 2250
Wire Wire Line
	3600 2350 3900 2350
Wire Wire Line
	3600 2450 3900 2450
Wire Wire Line
	900  1350 550  1350
Wire Wire Line
	900  1550 550  1550
Wire Wire Line
	4800 4400 4050 4400
Wire Wire Line
	4800 4500 4050 4500
Wire Wire Line
	4800 4600 4050 4600
Wire Wire Line
	4800 4700 4050 4700
Wire Wire Line
	4800 4800 4050 4800
Wire Wire Line
	4800 4900 4050 4900
Wire Wire Line
	4800 5000 4050 5000
Wire Wire Line
	4800 5100 4050 5100
Wire Wire Line
	4050 5200 4800 5200
Wire Wire Line
	4800 5300 4050 5300
Wire Wire Line
	4800 5400 4050 5400
Wire Wire Line
	4800 5500 4050 5500
Wire Wire Line
	4800 5600 4050 5600
Wire Wire Line
	4800 5700 4050 5700
Wire Wire Line
	4800 5800 4050 5800
Wire Wire Line
	4800 5900 4050 5900
Wire Wire Line
	8350 6400 8350 6450
Wire Wire Line
	8350 6450 10550 6450
Wire Wire Line
	10350 6450 10350 6400
Connection ~ 10350 6450
Wire Wire Line
	10150 6400 10150 6450
Connection ~ 10150 6450
Wire Wire Line
	9950 6400 9950 6450
Connection ~ 9950 6450
Wire Wire Line
	9750 6400 9750 6450
Connection ~ 9750 6450
Wire Wire Line
	9550 6400 9550 6450
Connection ~ 9550 6450
Wire Wire Line
	9350 6400 9350 6450
Connection ~ 9350 6450
Wire Wire Line
	9150 6400 9150 6450
Connection ~ 9150 6450
Wire Wire Line
	8950 6400 8950 6450
Connection ~ 8950 6450
Wire Wire Line
	8750 6400 8750 6450
Connection ~ 8750 6450
Wire Wire Line
	8550 6400 8550 6450
Connection ~ 8550 6450
Wire Wire Line
	10350 5950 10350 6000
Wire Wire Line
	8350 5950 10550 5950
Wire Wire Line
	8350 5800 8350 6000
Connection ~ 8350 5950
Wire Wire Line
	8550 6000 8550 5950
Connection ~ 8550 5950
Wire Wire Line
	8750 6000 8750 5950
Connection ~ 8750 5950
Wire Wire Line
	8950 6000 8950 5950
Connection ~ 8950 5950
Wire Wire Line
	9150 6000 9150 5950
Connection ~ 9150 5950
Wire Wire Line
	9350 6000 9350 5950
Connection ~ 9350 5950
Wire Wire Line
	9550 6000 9550 5950
Connection ~ 9550 5950
Wire Wire Line
	9750 6000 9750 5950
Connection ~ 9750 5950
Wire Wire Line
	9950 6000 9950 5950
Connection ~ 9950 5950
Wire Wire Line
	10150 6000 10150 5950
Connection ~ 10150 5950
Wire Notes Line
	8100 5550 10800 5550
Wire Notes Line
	10800 5550 10800 6800
Wire Notes Line
	10800 6800 8100 6800
Wire Notes Line
	8100 6800 8100 5550
Wire Wire Line
	1300 6500 1750 6500
Wire Wire Line
	1300 6650 1750 6650
Wire Wire Line
	4350 2900 4800 2900
Wire Wire Line
	4800 3000 4350 3000
Wire Wire Line
	4300 3100 4800 3100
Wire Wire Line
	3600 1550 4050 1550
Wire Wire Line
	3600 1650 4050 1650
Wire Wire Line
	3600 1750 4050 1750
Wire Wire Line
	4050 3300 4800 3300
Wire Wire Line
	4050 3400 4800 3400
Wire Wire Line
	3600 2550 3900 2550
Wire Wire Line
	3600 1050 4050 1050
Wire Wire Line
	3600 1150 4050 1150
Wire Wire Line
	3900 1950 3600 1950
Wire Wire Line
	3600 2050 3900 2050
Connection ~ 10350 5950
Wire Wire Line
	10550 6400 10550 6600
Connection ~ 10550 6450
Wire Wire Line
	10550 5950 10550 6000
Wire Wire Line
	1100 3400 650  3400
Wire Wire Line
	1100 3450 650  3450
Wire Wire Line
	650  3500 1100 3500
Wire Wire Line
	1100 3550 650  3550
Wire Wire Line
	1100 3600 650  3600
Wire Wire Line
	1100 3650 650  3650
Wire Wire Line
	2750 4700 3200 4700
Wire Wire Line
	2750 4750 3200 4750
Wire Wire Line
	2750 4800 3200 4800
Wire Wire Line
	2750 4850 3200 4850
Wire Wire Line
	1100 4950 650  4950
Wire Wire Line
	1100 5000 650  5000
Wire Wire Line
	1100 5050 650  5050
Wire Wire Line
	650  5100 1100 5100
Text Label 650  4950 0    39   ~ 0
~AVR_RESET
Text Label 650  5000 0    39   ~ 0
AVR_MOSI
Text Label 650  5050 0    39   ~ 0
AVR_MISO
Text Label 650  5100 0    39   ~ 0
AVR_SCK
Text Label 4050 4400 0    39   ~ 0
CPLD_GPIO_1
Text Label 4050 4500 0    39   ~ 0
CPLD_GPIO_2
Text Label 4050 4600 0    39   ~ 0
CPLD_GPIO_3
Text Label 4050 4700 0    39   ~ 0
CPLD_GPIO_4
Text Label 4050 4800 0    39   ~ 0
CPLD_GPIO_5
Text Label 4050 4900 0    39   ~ 0
CPLD_GPIO_6
Text Label 4050 5000 0    39   ~ 0
CPLD_GPIO_7
Text Label 4050 5100 0    39   ~ 0
CPLD_GPIO_8
Text Label 4050 5200 0    39   ~ 0
CPLD_GPIO_9
Text Label 4050 5300 0    39   ~ 0
CPLD_GPIO_10
Text Label 4050 5400 0    39   ~ 0
CPLD_GPIO_11
Text Label 4050 5500 0    39   ~ 0
CPLD_GPIO_12
Text Label 4050 5600 0    39   ~ 0
CPLD_GPIO_13
Text Label 4050 5700 0    39   ~ 0
CPLD_GPIO_14
Text Label 4050 5800 0    39   ~ 0
CPLD_GPIO_15
Text Label 4050 5900 0    39   ~ 0
CPLD_GPIO_16
Wire Wire Line
	1100 4100 650  4100
Wire Wire Line
	1100 4150 650  4150
Wire Wire Line
	1100 4200 650  4200
Wire Wire Line
	1100 4250 650  4250
Wire Wire Line
	1100 4300 650  4300
Wire Wire Line
	1100 4350 650  4350
Wire Wire Line
	1100 4400 650  4400
Wire Wire Line
	1100 4450 650  4450
Wire Wire Line
	1100 4500 650  4500
Wire Wire Line
	1100 4550 650  4550
Wire Wire Line
	1100 4600 650  4600
Wire Wire Line
	1100 4650 650  4650
Wire Wire Line
	1100 4700 650  4700
Wire Wire Line
	1100 4750 650  4750
Wire Wire Line
	1100 4800 650  4800
Wire Wire Line
	1100 4850 650  4850
Text Label 650  4100 0    39   ~ 0
CPLD_GPIO_1
Text Label 650  4150 0    39   ~ 0
CPLD_GPIO_2
Text Label 650  4200 0    39   ~ 0
CPLD_GPIO_3
Text Label 650  4250 0    39   ~ 0
CPLD_GPIO_4
Text Label 650  4300 0    39   ~ 0
CPLD_GPIO_5
Text Label 650  4350 0    39   ~ 0
CPLD_GPIO_6
Text Label 650  4400 0    39   ~ 0
CPLD_GPIO_7
Text Label 650  4450 0    39   ~ 0
CPLD_GPIO_8
Text Label 650  4500 0    39   ~ 0
CPLD_GPIO_9
Text Label 650  4550 0    39   ~ 0
CPLD_GPIO_10
Text Label 650  4600 0    39   ~ 0
CPLD_GPIO_11
Text Label 650  4650 0    39   ~ 0
CPLD_GPIO_12
Text Label 650  4700 0    39   ~ 0
CPLD_GPIO_13
Text Label 650  4750 0    39   ~ 0
CPLD_GPIO_14
Text Label 650  4800 0    39   ~ 0
CPLD_GPIO_15
Text Label 650  4850 0    39   ~ 0
CPLD_GPIO_16
Text Label 4300 6550 0    39   ~ 0
SW_1
Text Label 4300 6250 0    39   ~ 0
SW_2
Text Label 4300 6350 0    39   ~ 0
SW_3
Text Label 4300 6450 0    39   ~ 0
Red1
Text Label 7150 6200 0    39   ~ 0
Red2
Text Label 7150 6100 0    39   ~ 0
Red3
Text Label 7150 6000 0    39   ~ 0
Green1
Text Label 7150 5900 0    39   ~ 0
Green2
Text Label 7150 5800 0    39   ~ 0
Green3
Text Label 7150 5700 0    39   ~ 0
Blue1
Text Label 7150 5600 0    39   ~ 0
Blue2
Text Label 7150 5500 0    39   ~ 0
Blue3
Text Label 7150 5300 0    39   ~ 0
HSYNC
Text Label 7150 5400 0    39   ~ 0
VSYNC
Wire Wire Line
	2750 3500 3050 3500
Wire Wire Line
	2750 3550 3050 3550
Wire Wire Line
	2750 3600 3050 3600
Wire Wire Line
	2750 3650 3050 3650
Wire Wire Line
	2750 3700 3050 3700
Wire Wire Line
	2750 3750 3050 3750
Wire Wire Line
	2750 3800 3050 3800
Wire Wire Line
	2750 3850 3050 3850
Wire Wire Line
	2750 3900 3050 3900
Text Label 2800 3500 0    39   ~ 0
Red1
Text Label 2800 3550 0    39   ~ 0
Red2
Text Label 2800 3600 0    39   ~ 0
Red3
Text Label 2800 3650 0    39   ~ 0
Green1
Text Label 2800 3700 0    39   ~ 0
Green2
Text Label 2800 3750 0    39   ~ 0
Green3
Text Label 2800 3800 0    39   ~ 0
Blue1
Text Label 2800 3850 0    39   ~ 0
Blue2
Text Label 2800 3900 0    39   ~ 0
Blue3
Wire Wire Line
	2750 4100 3050 4100
Wire Wire Line
	2750 4150 3050 4150
Wire Wire Line
	2750 4200 3050 4200
Text Label 2800 4100 0    39   ~ 0
SW_1
Text Label 2800 4150 0    39   ~ 0
SW_2
Text Label 2800 4200 0    39   ~ 0
SW_3
Wire Wire Line
	2750 3400 3050 3400
Wire Wire Line
	2750 3450 3050 3450
Text Label 2800 3400 0    39   ~ 0
HSYNC
Text Label 2800 3450 0    39   ~ 0
VSYNC
Text Label 7150 6550 0    39   ~ 0
TDI
Text Label 7150 6650 0    39   ~ 0
TMS
Text Label 7150 6750 0    39   ~ 0
TCK
Text Label 7150 6850 0    39   ~ 0
TDO
Wire Wire Line
	2750 4950 3200 4950
Wire Wire Line
	2750 5000 3200 5000
Wire Wire Line
	3200 5050 2750 5050
Wire Wire Line
	2750 5100 3200 5100
Text Label 2800 4950 0    39   ~ 0
TDI
Text Label 2800 5000 0    39   ~ 0
TMS
Text Label 2800 5050 0    39   ~ 0
TCK
Text Label 2800 5100 0    39   ~ 0
TDO
Text Label 1300 6500 0    39   ~ 0
AVR_MOSI
Text Label 1300 6650 0    39   ~ 0
AVR_SCK
Wire Wire Line
	2750 4550 3050 4550
Wire Wire Line
	2750 4600 3050 4600
Text Label 2800 4550 0    39   ~ 0
AVR_TX
Text Label 2800 4600 0    39   ~ 0
AVR_RX
Text Label 3650 1950 0    39   ~ 0
AVR_RX
Text Label 3650 2050 0    39   ~ 0
AVR_TX
Text Label 3650 1550 0    39   ~ 0
AVR_MOSI
Text Label 3650 1650 0    39   ~ 0
AVR_MISO
Text Label 3650 1750 0    39   ~ 0
AVR_SCK
Text Label 550  1350 0    39   ~ 0
AVR_GPIO_1
Text Label 550  1550 0    39   ~ 0
AVR_GPIO_2
Text Label 3650 2150 0    39   ~ 0
AVR_GPIO_3
Text Label 3650 2250 0    39   ~ 0
AVR_GPIO_4
Text Label 3650 2350 0    39   ~ 0
AVR_GPIO_5
Text Label 3650 2450 0    39   ~ 0
AVR_GPIO_6
Wire Wire Line
	1100 3750 650  3750
Wire Wire Line
	650  3800 1100 3800
Wire Wire Line
	1100 3850 650  3850
Wire Wire Line
	650  3900 1100 3900
Wire Wire Line
	1100 3950 650  3950
Wire Wire Line
	650  4000 1100 4000
Text Label 650  3750 0    39   ~ 0
AVR_GPIO_1
Text Label 650  3800 0    39   ~ 0
AVR_GPIO_2
Text Label 650  3850 0    39   ~ 0
AVR_GPIO_3
Text Label 650  3900 0    39   ~ 0
AVR_GPIO_4
Text Label 650  3950 0    39   ~ 0
AVR_GPIO_5
Text Label 650  4000 0    39   ~ 0
AVR_GPIO_6
Wire Wire Line
	550  1050 900  1050
Wire Wire Line
	9500 1500 9500 1450
Wire Wire Line
	9500 1450 9350 1450
Connection ~ 9350 1450
$Comp
L GND #PWR09
U 1 1 53D088EC
P 9500 5000
F 0 "#PWR09" H 9500 5000 30  0001 C CNN
F 1 "GND" H 9500 4930 30  0001 C CNN
F 2 "" H 9500 5000 60  0000 C CNN
F 3 "" H 9500 5000 60  0000 C CNN
	1    9500 5000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 53D089A1
P 9350 5000
F 0 "#PWR010" H 9350 5000 30  0001 C CNN
F 1 "GND" H 9350 4930 30  0001 C CNN
F 2 "" H 9350 5000 60  0000 C CNN
F 3 "" H 9350 5000 60  0000 C CNN
	1    9350 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 750  2250 600 
Wire Wire Line
	900  750  850  750 
Wire Wire Line
	850  750  850  1050
Connection ~ 850  1050
Wire Wire Line
	1400 750  1400 600 
Text Label 550  1050 0    39   ~ 0
~AVR_RESET
$Comp
L +3.3V #PWR011
U 1 1 53CBA44C
P 2250 600
F 0 "#PWR011" H 2250 560 30  0001 C CNN
F 1 "+3.3V" H 2250 710 30  0000 C CNN
F 2 "" H 2250 600 60  0000 C CNN
F 3 "" H 2250 600 60  0000 C CNN
	1    2250 600 
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR012
U 1 1 53CBA459
P 1400 600
F 0 "#PWR012" H 1400 560 30  0001 C CNN
F 1 "+3.3V" H 1400 710 30  0000 C CNN
F 2 "" H 1400 600 60  0000 C CNN
F 3 "" H 1400 600 60  0000 C CNN
	1    1400 600 
	1    0    0    -1  
$EndComp
Text Label 10300 4150 0    39   ~ 0
~CE
Text Label 10300 4250 0    39   ~ 0
~WE
Text Label 10300 4350 0    39   ~ 0
~OE
Wire Wire Line
	7100 2000 7450 2000
Wire Wire Line
	7100 2100 7450 2100
Wire Wire Line
	7100 2200 7450 2200
Wire Wire Line
	7100 2300 7450 2300
Wire Wire Line
	7100 2400 7450 2400
Wire Wire Line
	7100 2500 7450 2500
Wire Wire Line
	7100 2600 7450 2600
Wire Wire Line
	7100 2700 7450 2700
Wire Wire Line
	7100 2800 7450 2800
Wire Wire Line
	7100 2900 7450 2900
Wire Wire Line
	7100 3000 7450 3000
Wire Wire Line
	7100 3100 7450 3100
Wire Wire Line
	7100 3200 7450 3200
Wire Wire Line
	7100 3300 7450 3300
Wire Wire Line
	7100 3400 7450 3400
Wire Wire Line
	7100 3500 7450 3500
Wire Wire Line
	7100 3600 7450 3600
Wire Wire Line
	7100 3700 7450 3700
Wire Wire Line
	7100 3800 7450 3800
Wire Wire Line
	7100 3900 7450 3900
Wire Wire Line
	7100 4000 7450 4000
Wire Wire Line
	7100 4800 7450 4800
Wire Wire Line
	7100 4900 7450 4900
Wire Wire Line
	7100 5000 7450 5000
Wire Wire Line
	7100 5100 7450 5100
Wire Wire Line
	7100 5200 7450 5200
Wire Wire Line
	7100 4400 7450 4400
Wire Wire Line
	7100 4500 7450 4500
Wire Wire Line
	7100 4600 7450 4600
Wire Wire Line
	7100 4700 7450 4700
Text Label 7150 2000 0    39   ~ 0
A9
Text Label 7150 2100 0    39   ~ 0
A8
Text Label 7150 2200 0    39   ~ 0
A7
Text Label 7150 2300 0    39   ~ 0
A6
Text Label 7150 2400 0    39   ~ 0
A5
Text Label 7150 2500 0    39   ~ 0
~WE
Text Label 7150 2600 0    39   ~ 0
IO3
Text Label 7150 2700 0    39   ~ 0
IO2
Text Label 7150 2800 0    39   ~ 0
IO1
Text Label 7150 2900 0    39   ~ 0
IO0
Text Label 7150 3000 0    39   ~ 0
~CE
Text Label 7150 3100 0    39   ~ 0
A4
Text Label 7150 3200 0    39   ~ 0
A3
Text Label 7150 3300 0    39   ~ 0
A2
Text Label 7150 3400 0    39   ~ 0
A1
Text Label 7150 3500 0    39   ~ 0
A0
Text Label 7150 3600 0    39   ~ 0
A10
Text Label 7150 3700 0    39   ~ 0
A11
Text Label 7150 3800 0    39   ~ 0
A12
Text Label 7150 3900 0    39   ~ 0
A13
Text Label 7150 4000 0    39   ~ 0
A14
Text Label 7150 4800 0    39   ~ 0
~OE
Text Label 7150 4900 0    39   ~ 0
A15
Text Label 7150 5000 0    39   ~ 0
A16
Text Label 7150 5100 0    39   ~ 0
A17
Text Label 7150 5200 0    39   ~ 0
A18
Text Label 7150 4400 0    39   ~ 0
IO4
Text Label 7150 4500 0    39   ~ 0
IO5
Text Label 7150 4600 0    39   ~ 0
IO6
Text Label 7150 4700 0    39   ~ 0
IO7
Wire Wire Line
	4300 1400 5600 1400
Connection ~ 5600 1400
Text Label 4350 3100 0    39   ~ 0
~AVR_SEL_CPLD
Wire Wire Line
	4350 2800 4800 2800
Wire Wire Line
	4300 3100 4300 2800
Wire Wire Line
	4300 2300 4300 1400
Wire Wire Line
	4800 2400 4500 2400
Wire Wire Line
	4450 2700 4450 2000
Wire Wire Line
	4450 1400 4450 1500
Connection ~ 4450 1400
Wire Wire Line
	4800 3200 4050 3200
Text Label 3650 2550 0    39   ~ 0
AVR_CPLD_EXT_3
$EndSCHEMATC
