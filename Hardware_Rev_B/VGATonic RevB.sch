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
LIBS:VGATonic RevB-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 2
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ATTINY2313A-S IC1
U 1 1 55CE7A49
P 2200 1750
F 0 "IC1" H 1050 2750 40  0000 C CNN
F 1 "ATTINY2313A-S" H 3150 850 40  0000 C CNN
F 2 "Housings_SOIC:SOIC-20_7.5x12.8mm_Pitch1.27mm" H 2200 1750 35  0000 C CIN
F 3 "" H 2200 1750 60  0000 C CNN
	1    2200 1750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR01
U 1 1 55CE5B13
P 6200 6850
F 0 "#PWR01" H 6200 6600 50  0001 C CNN
F 1 "GND" H 6200 6700 50  0000 C CNN
F 2 "" H 6200 6850 60  0000 C CNN
F 3 "" H 6200 6850 60  0000 C CNN
	1    6200 6850
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR02
U 1 1 55CE5B3B
P 7750 700
F 0 "#PWR02" H 7750 550 50  0001 C CNN
F 1 "+3.3V" H 7750 840 50  0000 C CNN
F 2 "" H 7750 700 60  0000 C CNN
F 3 "" H 7750 700 60  0000 C CNN
	1    7750 700 
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 55CE5B53
P 7750 950
F 0 "C1" H 7775 1050 50  0000 L CNN
F 1 "0.1uF" H 7775 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 7788 800 30  0001 C CNN
F 3 "" H 7750 950 60  0000 C CNN
	1    7750 950 
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 55CE5C68
P 8050 950
F 0 "C2" H 8075 1050 50  0000 L CNN
F 1 "0.1uF" H 8075 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 8088 800 30  0001 C CNN
F 3 "" H 8050 950 60  0000 C CNN
	1    8050 950 
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 55CE5CA8
P 8350 950
F 0 "C3" H 8375 1050 50  0000 L CNN
F 1 "0.1uF" H 8375 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 8388 800 30  0001 C CNN
F 3 "" H 8350 950 60  0000 C CNN
	1    8350 950 
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 55CE5CEF
P 8650 950
F 0 "C4" H 8675 1050 50  0000 L CNN
F 1 "0.1uF" H 8675 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 8688 800 30  0001 C CNN
F 3 "" H 8650 950 60  0000 C CNN
	1    8650 950 
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 55CE5D19
P 8950 950
F 0 "C5" H 8975 1050 50  0000 L CNN
F 1 "0.1uF" H 8975 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 8988 800 30  0001 C CNN
F 3 "" H 8950 950 60  0000 C CNN
	1    8950 950 
	1    0    0    -1  
$EndComp
$Comp
L C C6
U 1 1 55CE5D80
P 9250 950
F 0 "C6" H 9275 1050 50  0000 L CNN
F 1 "0.1uF" H 9275 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 9288 800 30  0001 C CNN
F 3 "" H 9250 950 60  0000 C CNN
	1    9250 950 
	1    0    0    -1  
$EndComp
$Comp
L C C7
U 1 1 55CE5DB2
P 9550 950
F 0 "C7" H 9575 1050 50  0000 L CNN
F 1 "0.1uF" H 9575 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 9588 800 30  0001 C CNN
F 3 "" H 9550 950 60  0000 C CNN
	1    9550 950 
	1    0    0    -1  
$EndComp
$Comp
L C C8
U 1 1 55CE5DED
P 9850 950
F 0 "C8" H 9875 1050 50  0000 L CNN
F 1 "0.1uF" H 9875 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 9888 800 30  0001 C CNN
F 3 "" H 9850 950 60  0000 C CNN
	1    9850 950 
	1    0    0    -1  
$EndComp
$Comp
L C C9
U 1 1 55CE5E25
P 10150 950
F 0 "C9" H 10175 1050 50  0000 L CNN
F 1 "0.1uF" H 10175 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 10188 800 30  0001 C CNN
F 3 "" H 10150 950 60  0000 C CNN
	1    10150 950 
	1    0    0    -1  
$EndComp
$Comp
L C C10
U 1 1 55CE5EC0
P 10450 950
F 0 "C10" H 10475 1050 50  0000 L CNN
F 1 "0.1uF" H 10475 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 10488 800 30  0001 C CNN
F 3 "" H 10450 950 60  0000 C CNN
	1    10450 950 
	1    0    0    -1  
$EndComp
$Comp
L C C11
U 1 1 55CE5F00
P 10750 950
F 0 "C11" H 10775 1050 50  0000 L CNN
F 1 "0.1uF" H 10775 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 10788 800 30  0001 C CNN
F 3 "" H 10750 950 60  0000 C CNN
	1    10750 950 
	1    0    0    -1  
$EndComp
$Comp
L C C12
U 1 1 55CE5F3F
P 11050 950
F 0 "C12" H 11075 1050 50  0000 L CNN
F 1 "1uF" H 11075 850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 11088 800 30  0001 C CNN
F 3 "" H 11050 950 60  0000 C CNN
	1    11050 950 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 55CE68DA
P 11050 1300
F 0 "#PWR03" H 11050 1050 50  0001 C CNN
F 1 "GND" H 11050 1150 50  0000 C CNN
F 2 "" H 11050 1300 60  0000 C CNN
F 3 "" H 11050 1300 60  0000 C CNN
	1    11050 1300
	1    0    0    -1  
$EndComp
Text Notes 9250 650  0    60   ~ 0
Decap
$Comp
L +3.3V #PWR04
U 1 1 55CE7557
P 6100 600
F 0 "#PWR04" H 6100 450 50  0001 C CNN
F 1 "+3.3V" H 6100 740 50  0000 C CNN
F 2 "" H 6100 600 60  0000 C CNN
F 3 "" H 6100 600 60  0000 C CNN
	1    6100 600 
	1    0    0    -1  
$EndComp
$Comp
L IS61LV5128AL U3
U 1 1 55CE8160
P 9500 3700
F 0 "U3" H 9900 5350 60  0000 C CNN
F 1 "IS61LV5128AL" H 10250 2400 60  0000 C CNN
F 2 "Footprints:tsop2-44" H 9400 3450 60  0001 C CNN
F 3 "" H 9400 3450 60  0000 C CNN
	1    9500 3700
	1    0    0    -1  
$EndComp
$Comp
L LTC6903 U1
U 1 1 55CE8BF9
P 4450 7000
F 0 "U1" H 4650 7500 60  0000 C CNN
F 1 "LTC6903" H 4650 6550 60  0000 C CNN
F 2 "Housings_SSOP:MSOP-8_3x3mm_Pitch0.65mm" H 4600 6450 60  0001 C CNN
F 3 "" H 4600 6450 60  0000 C CNN
	1    4450 7000
	1    0    0    -1  
$EndComp
$Comp
L XC95144PQ100-100TQFP U2
U 1 1 55CE9774
P 6500 3750
F 0 "U2" H 7070 6350 60  0000 C CNN
F 1 "XC95144PQ100-100TQFP" H 7550 1050 60  0000 C CNN
F 2 "Housings_QFP:TQFP-100_14x14mm_Pitch0.5mm" H 6500 3750 60  0001 C CNN
F 3 "" H 6500 3750 60  0000 C CNN
	1    6500 3750
	1    0    0    -1  
$EndComp
NoConn ~ 5450 6000
NoConn ~ 5450 6100
NoConn ~ 5000 7050
NoConn ~ 8800 3750
NoConn ~ 8800 3850
NoConn ~ 8800 3950
NoConn ~ 8800 4050
NoConn ~ 8800 4150
NoConn ~ 8800 4250
NoConn ~ 8800 4350
NoConn ~ 8800 4450
NoConn ~ 8800 4550
NoConn ~ 8800 4650
$Comp
L GND #PWR05
U 1 1 55CEA451
P 9650 5350
F 0 "#PWR05" H 9650 5100 50  0001 C CNN
F 1 "GND" H 9650 5200 50  0000 C CNN
F 2 "" H 9650 5350 60  0000 C CNN
F 3 "" H 9650 5350 60  0000 C CNN
	1    9650 5350
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR06
U 1 1 55CEA68B
P 9650 2000
F 0 "#PWR06" H 9650 1850 50  0001 C CNN
F 1 "+3.3V" H 9650 2140 50  0000 C CNN
F 2 "" H 9650 2000 60  0000 C CNN
F 3 "" H 9650 2000 60  0000 C CNN
	1    9650 2000
	1    0    0    -1  
$EndComp
Text Label 10500 2550 0    60   ~ 0
A0
Text Label 10500 2650 0    60   ~ 0
A1
Text Label 10500 2750 0    60   ~ 0
A2
Text Label 10500 2850 0    60   ~ 0
A3
Text Label 10500 2950 0    60   ~ 0
A4
Text Label 10500 3050 0    60   ~ 0
A5
Text Label 10500 3150 0    60   ~ 0
A6
Text Label 10500 3250 0    60   ~ 0
A7
Text Label 10500 3350 0    60   ~ 0
A8
Text Label 10500 3450 0    60   ~ 0
A9
Text Label 10500 3550 0    60   ~ 0
A10
Text Label 10500 3650 0    60   ~ 0
A11
Text Label 10500 3750 0    60   ~ 0
A12
Text Label 10500 3850 0    60   ~ 0
A13
Text Label 10500 3950 0    60   ~ 0
A14
Text Label 10500 4050 0    60   ~ 0
A15
Text Label 10500 4150 0    60   ~ 0
A16
Text Label 10500 4250 0    60   ~ 0
A17
Text Label 10500 4350 0    60   ~ 0
A18
Text Label 10500 4600 0    60   ~ 0
~CE
Text Label 10500 4700 0    60   ~ 0
~WE
Text Label 10500 4800 0    60   ~ 0
~OE
Text Label 8600 2550 0    60   ~ 0
IO0
Text Label 8600 2750 0    60   ~ 0
IO2
Text Label 8600 2650 0    60   ~ 0
IO1
Text Label 8600 2850 0    60   ~ 0
IO3
Text Label 8600 2950 0    60   ~ 0
IO4
Text Label 8600 3050 0    60   ~ 0
IO5
Text Label 8600 3150 0    60   ~ 0
IO6
Text Label 8600 3250 0    60   ~ 0
IO7
Text Label 7700 1550 0    60   ~ 0
A9
Text Label 7700 1650 0    60   ~ 0
A8
Text Label 7700 1750 0    60   ~ 0
A7
Text Label 7700 1850 0    60   ~ 0
A6
Text Label 7700 1950 0    60   ~ 0
A5
Text Label 7700 2050 0    60   ~ 0
~WE
Text Label 7700 2150 0    60   ~ 0
IO3
Text Label 7700 2250 0    60   ~ 0
IO2
Text Label 7700 2350 0    60   ~ 0
IO1
Text Label 7700 2450 0    60   ~ 0
IO0
Text Label 7700 2550 0    60   ~ 0
~CE
Text Label 7700 2650 0    60   ~ 0
A4
Text Label 7700 2750 0    60   ~ 0
A3
Text Label 7700 2850 0    60   ~ 0
A2
Text Label 7700 2950 0    60   ~ 0
A1
Text Label 7700 3050 0    60   ~ 0
A0
Text Label 7700 3150 0    60   ~ 0
A10
Text Label 7700 3250 0    60   ~ 0
A11
Text Label 7700 3350 0    60   ~ 0
A12
Text Label 7700 3450 0    60   ~ 0
A13
Text Label 7700 3550 0    60   ~ 0
A14
Text Label 7700 3950 0    60   ~ 0
IO4
Text Label 7700 4050 0    60   ~ 0
IO5
Text Label 7700 4150 0    60   ~ 0
IO6
Text Label 7700 4250 0    60   ~ 0
IO7
Text Label 7700 4350 0    60   ~ 0
~OE
Text Label 7700 4450 0    60   ~ 0
A15
Text Label 7700 4550 0    60   ~ 0
A16
Text Label 7700 4650 0    60   ~ 0
A17
Text Label 7700 4750 0    60   ~ 0
A18
Text Label 7700 4850 0    60   ~ 0
HSYNC
Text Label 7700 4950 0    60   ~ 0
VSYNC
Text Label 7700 5050 0    60   ~ 0
Blue3
Text Label 7700 5150 0    60   ~ 0
Blue2
Text Label 7700 5250 0    60   ~ 0
Blue1
Text Label 7700 5350 0    60   ~ 0
Green3
Text Label 7700 5450 0    60   ~ 0
Green2
Text Label 7700 5550 0    60   ~ 0
Green1
Text Label 7700 5650 0    60   ~ 0
Red3
Text Label 7700 5750 0    60   ~ 0
Red2
Text Label 5300 5700 2    60   ~ 0
Red1
Text Label 5300 5400 2    60   ~ 0
AVR_CPLD_RESET
Text Label 5250 3150 2    60   ~ 0
LUMA4
Text Label 5250 3050 2    60   ~ 0
LUMA3
Text Label 5250 2950 2    60   ~ 0
LUMA2
Text Label 5250 2850 2    60   ~ 0
LUMA1
Text Label 5250 2750 2    60   ~ 0
COLORBURST
Text Label 5250 2650 2    60   ~ 0
SYNC
Text Label 5250 2550 2    60   ~ 0
AVR_CPLD_EXT_3
Text Label 5250 2450 2    60   ~ 0
AVR_CPLD_EXT_2
Text Label 5250 2350 2    60   ~ 0
AVR_CPLD_EXT_1
Text Label 5250 2250 2    60   ~ 0
~AVR_SEL_CPLD
Text Label 5250 2150 2    60   ~ 0
AVR_MISO
Text Label 5250 2050 2    60   ~ 0
AVR_MOSI
Text Label 5250 1950 2    60   ~ 0
AVR_SCK
Text Label 5250 1850 2    60   ~ 0
~EXT_SEL_CPLD
Text Label 5250 1750 2    60   ~ 0
EXT_MISO
Text Label 5250 1650 2    60   ~ 0
EXT_MOSI
Text Label 5250 1550 2    60   ~ 0
EXT_SCK
Text Label 7700 5950 0    60   ~ 0
TDI
Text Label 7700 6050 0    60   ~ 0
TMS
Text Label 7700 6150 0    60   ~ 0
TCK
Text Label 7700 6250 0    60   ~ 0
TDO
$Comp
L +3.3V #PWR07
U 1 1 55CF294E
P 2200 600
F 0 "#PWR07" H 2200 450 50  0001 C CNN
F 1 "+3.3V" H 2200 740 50  0000 C CNN
F 2 "" H 2200 600 60  0000 C CNN
F 3 "" H 2200 600 60  0000 C CNN
	1    2200 600 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 55CF2C0B
P 2200 2900
F 0 "#PWR08" H 2200 2650 50  0001 C CNN
F 1 "GND" H 2200 2750 50  0000 C CNN
F 2 "" H 2200 2900 60  0000 C CNN
F 3 "" H 2200 2900 60  0000 C CNN
	1    2200 2900
	1    0    0    -1  
$EndComp
Text Label 500  950  0    60   ~ 0
~AVR_RESET
$Comp
L R R2
U 1 1 55CF3736
P 1450 650
F 0 "R2" V 1530 650 50  0000 C CNN
F 1 "4.7k" V 1450 650 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 1380 650 30  0001 C CNN
F 3 "" H 1450 650 30  0000 C CNN
	1    1450 650 
	0    1    1    0   
$EndComp
Text Label 500  1250 0    60   ~ 0
XTAL2
Text Label 500  1450 0    60   ~ 0
XTAL1
Text Notes 9200 1700 0    60   ~ 0
Framebuffer Memory
Text Notes 5200 1050 0    60   ~ 0
SPI Slave and\nDisplay Core
$Comp
L +3.3V #PWR09
U 1 1 55CF5E74
P 4450 6350
F 0 "#PWR09" H 4450 6200 50  0001 C CNN
F 1 "+3.3V" H 4450 6490 50  0000 C CNN
F 2 "" H 4450 6350 60  0000 C CNN
F 3 "" H 4450 6350 60  0000 C CNN
	1    4450 6350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 55CF5EAA
P 4450 7600
F 0 "#PWR010" H 4450 7350 50  0001 C CNN
F 1 "GND" H 4450 7450 50  0000 C CNN
F 2 "" H 4450 7600 60  0000 C CNN
F 3 "" H 4450 7600 60  0000 C CNN
	1    4450 7600
	1    0    0    -1  
$EndComp
Text Label 3700 6850 2    60   ~ 0
AVR_MOSI
Text Label 3700 6950 2    60   ~ 0
AVR_SCK
Text Label 3250 7650 1    60   ~ 0
~AVR_SEL_CLK
$Comp
L R R1
U 1 1 55CF64F6
P 3600 6400
F 0 "R1" V 3680 6400 50  0000 C CNN
F 1 "10k" V 3600 6400 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 3530 6400 30  0001 C CNN
F 3 "" H 3600 6400 30  0000 C CNN
	1    3600 6400
	0    1    1    0   
$EndComp
Text Label 3700 950  0    60   ~ 0
AVR_CPLD_EXT_2
Text Label 3700 1050 0    60   ~ 0
AVR_CPLD_EXT_1
Text Label 3700 1150 0    60   ~ 0
AVR_CPLD_RESET
Text Label 3700 1250 0    60   ~ 0
~AVR_SEL_CPLD
Text Label 3700 1350 0    60   ~ 0
~AVR_SEL_CLK
Text Label 3700 1450 0    60   ~ 0
AVR_MISO
Text Label 3700 1550 0    60   ~ 0
AVR_MOSI
Text Label 3700 1650 0    60   ~ 0
AVR_SCK
Text Label 3700 1850 0    60   ~ 0
AVR_RX
Text Label 3700 1950 0    60   ~ 0
AVR_TX
Text Label 3700 2050 0    60   ~ 0
AVR_GPIO_1
Text Label 3700 2150 0    60   ~ 0
AVR_GPIO_2
Text Label 3700 2250 0    60   ~ 0
AVR_LED_1
Text Label 3700 2350 0    60   ~ 0
AVR_LED_2
Text Label 3700 2450 0    60   ~ 0
AVR_CPLD_EXT_3
$Comp
L R R3
U 1 1 55CF8F44
P 4950 1000
F 0 "R3" V 5030 1000 50  0000 C CNN
F 1 "10k" V 4950 1000 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 4880 1000 30  0001 C CNN
F 3 "" H 4950 1000 30  0000 C CNN
	1    4950 1000
	-1   0    0    1   
$EndComp
$Comp
L R R4
U 1 1 55CF9069
P 4700 1000
F 0 "R4" V 4780 1000 50  0000 C CNN
F 1 "10k" V 4700 1000 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 4630 1000 30  0001 C CNN
F 3 "" H 4700 1000 30  0000 C CNN
	1    4700 1000
	-1   0    0    1   
$EndComp
Text Label 5200 6550 1    60   ~ 0
50MHzClock
Text Label 3400 3300 0    60   ~ 0
HSYNC
Text Label 3400 3400 0    60   ~ 0
VSYNC
Text Label 3400 3500 0    60   ~ 0
Red1
Text Label 3400 3600 0    60   ~ 0
Red2
Text Label 3400 3700 0    60   ~ 0
Red3
Text Label 3400 3800 0    60   ~ 0
Green1
Text Label 3400 3900 0    60   ~ 0
Green2
Text Label 3400 4000 0    60   ~ 0
Green3
Text Label 3400 4100 0    60   ~ 0
Blue1
Text Label 3400 4200 0    60   ~ 0
Blue2
Text Label 3400 4300 0    60   ~ 0
Blue3
Text Label 3400 5800 0    60   ~ 0
AVR_TX
Text Label 3400 5900 0    60   ~ 0
AVR_RX
Text Label 3400 4450 0    60   ~ 0
~EXT_SEL_CPLD
Text Label 3400 4550 0    60   ~ 0
EXT_SCK
Text Label 3400 4650 0    60   ~ 0
EXT_MOSI
Text Label 3400 4750 0    60   ~ 0
EXT_MISO
Text Label 3400 5000 0    60   ~ 0
TDO
Text Label 3400 5100 0    60   ~ 0
TCK
Text Label 3400 5200 0    60   ~ 0
TMS
Text Label 3400 4900 0    60   ~ 0
TDI
Text Label 1500 4950 2    60   ~ 0
CPLD_GPIO_11
Text Label 1500 4850 2    60   ~ 0
CPLD_GPIO_12
Text Label 1500 4750 2    60   ~ 0
CPLD_GPIO_13
Text Label 1500 4650 2    60   ~ 0
CPLD_GPIO_14
Text Label 1500 4550 2    60   ~ 0
CPLD_GPIO_15
Text Label 1500 4450 2    60   ~ 0
CPLD_GPIO_16
Text Label 1500 5050 2    60   ~ 0
CPLD_GPIO_10
Text Label 1500 5150 2    60   ~ 0
CPLD_GPIO_9
Text Label 1500 5250 2    60   ~ 0
CPLD_GPIO_8
Text Label 1500 5350 2    60   ~ 0
CPLD_GPIO_7
Text Label 1500 5450 2    60   ~ 0
CPLD_GPIO_6
Text Label 1500 5550 2    60   ~ 0
CPLD_GPIO_5
Text Label 1500 5650 2    60   ~ 0
CPLD_GPIO_4
Text Label 1500 5750 2    60   ~ 0
CPLD_GPIO_3
Text Label 1500 5850 2    60   ~ 0
CPLD_GPIO_2
Text Label 1500 5950 2    60   ~ 0
CPLD_GPIO_1
Text Label 1500 3450 2    60   ~ 0
SYNC
Text Label 1500 3350 2    60   ~ 0
COLORBURST
Text Label 1500 3850 2    60   ~ 0
LUMA1
Text Label 1500 3750 2    60   ~ 0
LUMA2
Text Label 1500 3650 2    60   ~ 0
LUMA3
Text Label 1500 3550 2    60   ~ 0
LUMA4
Text Label 3400 5450 0    60   ~ 0
AVR_MOSI
Text Label 3400 5350 0    60   ~ 0
AVR_MISO
Text Label 3400 5550 0    60   ~ 0
AVR_SCK
Text Label 3400 5650 0    60   ~ 0
~AVR_RESET
Text Label 5250 3450 2    60   ~ 0
CPLD_GPIO_1
Text Label 5250 3550 2    60   ~ 0
CPLD_GPIO_2
Text Label 5250 3650 2    60   ~ 0
CPLD_GPIO_3
Text Label 5250 3750 2    60   ~ 0
CPLD_GPIO_4
Text Label 5250 3850 2    60   ~ 0
CPLD_GPIO_5
Text Label 5250 3950 2    60   ~ 0
CPLD_GPIO_6
Text Label 5250 4050 2    60   ~ 0
CPLD_GPIO_7
Text Label 5250 4150 2    60   ~ 0
CPLD_GPIO_8
Text Label 5250 4250 2    60   ~ 0
CPLD_GPIO_9
Text Label 5250 4350 2    60   ~ 0
CPLD_GPIO_10
Text Label 5250 4450 2    60   ~ 0
CPLD_GPIO_11
Text Label 5250 4550 2    60   ~ 0
CPLD_GPIO_12
Text Label 5250 4650 2    60   ~ 0
CPLD_GPIO_13
Text Label 5250 4750 2    60   ~ 0
CPLD_GPIO_14
Text Label 5250 4850 2    60   ~ 0
CPLD_GPIO_15
Text Label 5250 4950 2    60   ~ 0
CPLD_GPIO_16
NoConn ~ 5450 5500
NoConn ~ 5450 5600
NoConn ~ 5450 5800
$Sheet
S 1700 3200 1550 3000
U 55CF9CFD
F0 "OutputsAndInputs" 60
F1 "OutputsAndInputs.sch" 60
F2 "Red1" I R 3250 3500 60 
F3 "Red2" I R 3250 3600 60 
F4 "Red3" I R 3250 3700 60 
F5 "Green1" I R 3250 3800 60 
F6 "Green2" I R 3250 3900 60 
F7 "Green3" I R 3250 4000 60 
F8 "VSYNC" I R 3250 3400 60 
F9 "HSYNC" I R 3250 3300 60 
F10 "Blue3" I R 3250 4300 60 
F11 "LUMA2" I L 1700 3750 60 
F12 "LUMA3" I L 1700 3650 60 
F13 "LUMA4" I L 1700 3550 60 
F14 "COLORBURST" I L 1700 3350 60 
F15 "SYNC" I L 1700 3450 60 
F16 "TMS" O R 3250 5200 60 
F17 "TDI" O R 3250 4900 60 
F18 "TDO" I R 3250 5000 60 
F19 "TCK" O R 3250 5100 60 
F20 "AVR_MISO_EXT" I R 3250 5450 60 
F21 "AVR_SCK" O R 3250 5550 60 
F22 "~AVR_RESET" O R 3250 5650 60 
F23 "AVR_MOSI_EXT" O R 3250 5350 60 
F24 "AVR_GPIO_1" B L 1700 4000 60 
F25 "AVR_GPIO_2" B L 1700 4100 60 
F26 "CPLD_GPIO_1" B L 1700 5950 60 
F27 "CPLD_GPIO_2" B L 1700 5850 60 
F28 "CPLD_GPIO_3" B L 1700 5750 60 
F29 "CPLD_GPIO_4" B L 1700 5650 60 
F30 "CPLD_GPIO_5" B L 1700 5550 60 
F31 "CPLD_GPIO_6" B L 1700 5450 60 
F32 "CPLD_GPIO_7" B L 1700 5350 60 
F33 "CPLD_GPIO_8" B L 1700 5250 60 
F34 "CPLD_GPIO_9" B L 1700 5150 60 
F35 "CPLD_GPIO_10" B L 1700 5050 60 
F36 "CPLD_GPIO_11" B L 1700 4950 60 
F37 "CPLD_GPIO_12" B L 1700 4850 60 
F38 "CPLD_GPIO_13" B L 1700 4750 60 
F39 "CPLD_GPIO_14" B L 1700 4650 60 
F40 "CPLD_GPIO_15" B L 1700 4550 60 
F41 "CPLD_GPIO_16" B L 1700 4450 60 
F42 "AVR_TX" I R 3250 5800 60 
F43 "AVR_RX" O R 3250 5900 60 
F44 "~EXT_SEL_CPLD" O R 3250 4450 60 
F45 "EXT_MOSI" O R 3250 4650 60 
F46 "EXT_MISO" I R 3250 4750 60 
F47 "EXT_SCK" O R 3250 4550 60 
F48 "LUMA1" I L 1700 3850 60 
F49 "XTAL_1" I L 1700 4200 60 
F50 "XTAL_2" I L 1700 4300 60 
F51 "Blue1" I R 3250 4100 60 
F52 "Blue2" I R 3250 4200 60 
F53 "AVR_LED_1" I R 3250 6000 60 
F54 "AVR_LED_2" I R 3250 6100 60 
$EndSheet
Wire Wire Line
	6900 6700 6900 6500
Wire Wire Line
	6200 6700 6900 6700
Wire Wire Line
	6800 6700 6800 6500
Wire Wire Line
	6700 6500 6700 6700
Connection ~ 6800 6700
Wire Wire Line
	6600 6500 6600 6700
Connection ~ 6700 6700
Wire Wire Line
	6500 6500 6500 6700
Connection ~ 6600 6700
Wire Wire Line
	6400 6500 6400 6700
Connection ~ 6500 6700
Wire Wire Line
	6300 6500 6300 6700
Connection ~ 6400 6700
Wire Wire Line
	6200 6500 6200 6850
Connection ~ 6300 6700
Connection ~ 6200 6700
Wire Wire Line
	7750 800  7750 700 
Wire Wire Line
	7750 800  11050 800 
Connection ~ 8050 800 
Connection ~ 8350 800 
Connection ~ 8650 800 
Connection ~ 8950 800 
Connection ~ 9250 800 
Connection ~ 9550 800 
Connection ~ 9850 800 
Connection ~ 10150 800 
Connection ~ 10450 800 
Connection ~ 10750 800 
Wire Wire Line
	7750 1100 11050 1100
Connection ~ 10750 1100
Connection ~ 10450 1100
Connection ~ 10150 1100
Connection ~ 9850 1100
Connection ~ 9550 1100
Connection ~ 9250 1100
Connection ~ 8950 1100
Connection ~ 8650 1100
Connection ~ 8350 1100
Connection ~ 8050 1100
Wire Wire Line
	11050 1100 11050 1300
Wire Wire Line
	6100 600  6100 1000
Wire Wire Line
	4700 800  6900 800 
Wire Wire Line
	6200 800  6200 1000
Connection ~ 6100 800 
Wire Wire Line
	6300 800  6300 1000
Connection ~ 6200 800 
Wire Wire Line
	6600 800  6600 1000
Connection ~ 6300 800 
Wire Wire Line
	6700 800  6700 1000
Connection ~ 6600 800 
Wire Wire Line
	6800 800  6800 1000
Connection ~ 6700 800 
Wire Wire Line
	6900 800  6900 1000
Connection ~ 6800 800 
Wire Wire Line
	9400 5100 9400 5250
Wire Wire Line
	9400 5250 9650 5250
Wire Wire Line
	9650 5100 9650 5350
Connection ~ 9650 5250
Wire Wire Line
	9400 2200 9400 2100
Wire Wire Line
	9400 2100 9650 2100
Wire Wire Line
	9650 2000 9650 2200
Connection ~ 9650 2100
Wire Wire Line
	10250 2550 10500 2550
Wire Wire Line
	10500 2650 10250 2650
Wire Wire Line
	10250 2750 10500 2750
Wire Wire Line
	10250 2850 10500 2850
Wire Wire Line
	10250 2950 10500 2950
Wire Wire Line
	10250 3050 10500 3050
Wire Wire Line
	10250 3150 10500 3150
Wire Wire Line
	10250 3250 10500 3250
Wire Wire Line
	10500 3350 10250 3350
Wire Wire Line
	10250 3450 10500 3450
Wire Wire Line
	10250 3550 10500 3550
Wire Wire Line
	10250 3650 10500 3650
Wire Wire Line
	10250 3750 10500 3750
Wire Wire Line
	10250 3850 10500 3850
Wire Wire Line
	10250 3950 10500 3950
Wire Wire Line
	10250 4050 10500 4050
Wire Wire Line
	10250 4150 10500 4150
Wire Wire Line
	10250 4250 10500 4250
Wire Wire Line
	10250 4350 10500 4350
Wire Wire Line
	10250 4600 10500 4600
Wire Wire Line
	10250 4700 10500 4700
Wire Wire Line
	10250 4800 10500 4800
Wire Wire Line
	8800 2550 8600 2550
Wire Wire Line
	8600 2650 8800 2650
Wire Wire Line
	8600 2750 8800 2750
Wire Wire Line
	8600 2850 8800 2850
Wire Wire Line
	8600 2950 8800 2950
Wire Wire Line
	8800 3050 8600 3050
Wire Wire Line
	8600 3150 8800 3150
Wire Wire Line
	8800 3250 8600 3250
Wire Wire Line
	7700 1550 7550 1550
Wire Wire Line
	7550 1650 7700 1650
Wire Wire Line
	7700 1750 7550 1750
Wire Wire Line
	7550 1850 7700 1850
Wire Wire Line
	7700 1950 7550 1950
Wire Wire Line
	7550 2050 7700 2050
Wire Wire Line
	7700 2150 7550 2150
Wire Wire Line
	7550 2250 7700 2250
Wire Wire Line
	7700 2350 7550 2350
Wire Wire Line
	7550 2450 7700 2450
Wire Wire Line
	7700 2550 7550 2550
Wire Wire Line
	7550 2650 7700 2650
Wire Wire Line
	7700 2750 7550 2750
Wire Wire Line
	7550 2850 7700 2850
Wire Wire Line
	7700 2950 7550 2950
Wire Wire Line
	7550 3050 7700 3050
Wire Wire Line
	7700 3150 7550 3150
Wire Wire Line
	7550 3250 7700 3250
Wire Wire Line
	7700 3350 7550 3350
Wire Wire Line
	7550 3450 7700 3450
Wire Wire Line
	7700 3550 7550 3550
Wire Wire Line
	7700 3950 7550 3950
Wire Wire Line
	7550 4050 7700 4050
Wire Wire Line
	7700 4150 7550 4150
Wire Wire Line
	7550 4250 7700 4250
Wire Wire Line
	7700 4350 7550 4350
Wire Wire Line
	7550 4450 7700 4450
Wire Wire Line
	7550 4550 7700 4550
Wire Wire Line
	7700 4650 7550 4650
Wire Wire Line
	7550 4750 7700 4750
Wire Wire Line
	7700 4850 7550 4850
Wire Wire Line
	7550 4950 7700 4950
Wire Wire Line
	7700 5050 7550 5050
Wire Wire Line
	7550 5150 7700 5150
Wire Wire Line
	7700 5250 7550 5250
Wire Wire Line
	7550 5350 7700 5350
Wire Wire Line
	7700 5450 7550 5450
Wire Wire Line
	7550 5550 7700 5550
Wire Wire Line
	7700 5650 7550 5650
Wire Wire Line
	7550 5750 7700 5750
Wire Wire Line
	5450 5700 5300 5700
Wire Wire Line
	5300 5400 5450 5400
Wire Wire Line
	5450 3150 5250 3150
Wire Wire Line
	5250 3050 5450 3050
Wire Wire Line
	5250 2950 5450 2950
Wire Wire Line
	5450 2850 5250 2850
Wire Wire Line
	5250 2750 5450 2750
Wire Wire Line
	5450 2650 5250 2650
Wire Wire Line
	5450 2450 5250 2450
Wire Wire Line
	5450 2350 5250 2350
Wire Wire Line
	4550 2250 5450 2250
Wire Wire Line
	5450 2150 5250 2150
Wire Wire Line
	5250 2050 5450 2050
Wire Wire Line
	5450 1950 5250 1950
Wire Wire Line
	4600 1850 5450 1850
Wire Wire Line
	5450 1750 5250 1750
Wire Wire Line
	5250 1650 5450 1650
Wire Wire Line
	5450 1550 5250 1550
Wire Wire Line
	7550 5950 7700 5950
Wire Wire Line
	7700 6050 7550 6050
Wire Wire Line
	7550 6150 7700 6150
Wire Wire Line
	7700 6250 7550 6250
Wire Wire Line
	850  950  850  650 
Wire Wire Line
	2200 650  2200 600 
Wire Wire Line
	1600 650  2200 650 
Wire Wire Line
	850  650  1300 650 
Wire Wire Line
	500  950  850  950 
Wire Wire Line
	500  1250 850  1250
Wire Wire Line
	500  1450 850  1450
Wire Wire Line
	5100 6850 5000 6850
Wire Wire Line
	2200 2900 2200 2750
Wire Wire Line
	5450 2550 5250 2550
Wire Wire Line
	3550 950  3700 950 
Wire Wire Line
	3700 1050 3550 1050
Wire Wire Line
	3550 1150 3700 1150
Wire Wire Line
	3700 1250 3550 1250
Wire Wire Line
	3550 1350 3700 1350
Wire Wire Line
	3700 1450 3550 1450
Wire Wire Line
	3550 1550 3700 1550
Wire Wire Line
	3700 1650 3550 1650
Wire Wire Line
	3550 1850 3700 1850
Wire Wire Line
	3700 1950 3550 1950
Wire Wire Line
	3550 2050 3700 2050
Wire Wire Line
	3700 2150 3550 2150
Wire Wire Line
	3550 2250 3700 2250
Wire Wire Line
	3700 2350 3550 2350
Wire Wire Line
	3550 2450 3700 2450
Wire Wire Line
	3700 6850 3900 6850
Wire Wire Line
	3900 6950 3700 6950
Wire Wire Line
	4600 1850 4600 1450
Wire Wire Line
	4600 1450 4950 1450
Wire Wire Line
	4950 1450 4950 1150
Wire Wire Line
	4700 1150 4700 1350
Wire Wire Line
	4550 2250 4550 1350
Wire Wire Line
	4550 1350 4700 1350
Wire Wire Line
	4700 850  4700 800 
Wire Wire Line
	4950 800  4950 850 
Connection ~ 4950 800 
Wire Wire Line
	5450 5900 5200 5900
Wire Wire Line
	5200 5900 5200 6950
Wire Wire Line
	3250 3300 3400 3300
Wire Wire Line
	3400 3400 3250 3400
Wire Wire Line
	3250 3500 3400 3500
Wire Wire Line
	3400 3600 3250 3600
Wire Wire Line
	3250 3700 3400 3700
Wire Wire Line
	3400 3800 3250 3800
Wire Wire Line
	3250 3900 3400 3900
Wire Wire Line
	3400 4000 3250 4000
Wire Wire Line
	3250 4100 3400 4100
Wire Wire Line
	3400 4200 3250 4200
Wire Wire Line
	3250 4300 3400 4300
Wire Wire Line
	3400 5800 3250 5800
Wire Wire Line
	3250 5900 3400 5900
Wire Wire Line
	3400 4450 3250 4450
Wire Wire Line
	3250 4550 3400 4550
Wire Wire Line
	3400 4650 3250 4650
Wire Wire Line
	3250 4750 3400 4750
Wire Wire Line
	1500 4450 1700 4450
Wire Wire Line
	1700 4550 1500 4550
Wire Wire Line
	1500 4650 1700 4650
Wire Wire Line
	1700 4750 1500 4750
Wire Wire Line
	1500 4850 1700 4850
Wire Wire Line
	1700 4950 1500 4950
Wire Wire Line
	1500 5050 1700 5050
Wire Wire Line
	1700 5150 1500 5150
Wire Wire Line
	1500 5250 1700 5250
Wire Wire Line
	1700 5350 1500 5350
Wire Wire Line
	1500 5450 1700 5450
Wire Wire Line
	1500 5650 1700 5650
Wire Wire Line
	1700 5550 1500 5550
Wire Wire Line
	1700 5850 1500 5850
Wire Wire Line
	1500 5950 1700 5950
Wire Wire Line
	1500 5750 1700 5750
Wire Wire Line
	5250 3450 5450 3450
Wire Wire Line
	5450 3550 5250 3550
Wire Wire Line
	5250 3650 5450 3650
Wire Wire Line
	5450 3750 5250 3750
Wire Wire Line
	5250 3850 5450 3850
Wire Wire Line
	5450 3950 5250 3950
Wire Wire Line
	5450 4050 5250 4050
Wire Wire Line
	5250 4150 5450 4150
Wire Wire Line
	5450 4250 5250 4250
Wire Wire Line
	5250 4350 5450 4350
Wire Wire Line
	5250 4450 5450 4450
Wire Wire Line
	5250 4550 5450 4550
Wire Wire Line
	5450 4650 5250 4650
Wire Wire Line
	5250 4750 5450 4750
Wire Wire Line
	5450 4850 5250 4850
Wire Wire Line
	5250 4950 5450 4950
Wire Wire Line
	5100 6400 5100 6850
Wire Wire Line
	3750 6400 5100 6400
Wire Wire Line
	4450 6400 4450 6350
Connection ~ 4450 6400
Wire Wire Line
	4450 7600 4450 7550
Wire Wire Line
	3450 6400 3250 6400
Wire Wire Line
	3250 6400 3250 7650
Wire Wire Line
	3900 7050 3250 7050
Connection ~ 3250 7050
Wire Wire Line
	5200 6950 5000 6950
Wire Wire Line
	3400 5350 3250 5350
Wire Wire Line
	3250 5450 3400 5450
Wire Wire Line
	3250 5550 3400 5550
Wire Wire Line
	3250 5650 3400 5650
Wire Wire Line
	3250 4900 3400 4900
Wire Wire Line
	3400 5000 3250 5000
Wire Wire Line
	3400 5200 3250 5200
Wire Wire Line
	3250 5100 3400 5100
Wire Wire Line
	1500 3350 1700 3350
Wire Wire Line
	1700 3750 1500 3750
Wire Wire Line
	1500 3850 1700 3850
Wire Wire Line
	1700 3650 1500 3650
Wire Wire Line
	1500 3550 1700 3550
Wire Wire Line
	1700 3450 1500 3450
Text Label 3400 6000 0    60   ~ 0
AVR_LED_1
Text Label 3400 6100 0    60   ~ 0
AVR_LED_2
Wire Wire Line
	3250 6000 3400 6000
Wire Wire Line
	3250 6100 3400 6100
Text Label 1500 4000 2    60   ~ 0
AVR_GPIO_1
Text Label 1500 4100 2    60   ~ 0
AVR_GPIO_2
Text Label 1500 4200 2    60   ~ 0
XTAL1
Text Label 1500 4300 2    60   ~ 0
XTAL2
Wire Wire Line
	1500 4000 1700 4000
Wire Wire Line
	1700 4100 1500 4100
Wire Wire Line
	1500 4200 1700 4200
Wire Wire Line
	1500 4300 1700 4300
Connection ~ 1350 7350
Text Label 1350 7350 2    60   ~ 0
Fiducial1
Text Label 2000 7350 2    60   ~ 0
Fiducial2
Connection ~ 2000 7350
$Comp
L CONN_01X01 FID1
U 1 1 55D9047A
P 1350 7550
F 0 "FID1" H 1300 7650 50  0000 C CNN
F 1 "CONN_01X01" V 1450 7550 50  0000 C CNN
F 2 "Fiducials:Fiducial_1mm_Dia_2.54mm_Outer_CopperTop" H 1350 7550 60  0001 C CNN
F 3 "" H 1350 7550 60  0000 C CNN
	1    1350 7550
	0    1    1    0   
$EndComp
$Comp
L CONN_01X01 FID2
U 1 1 55D90A9C
P 2000 7550
F 0 "FID2" H 1950 7650 50  0000 C CNN
F 1 "CONN_01X01" V 2100 7550 50  0000 C CNN
F 2 "Fiducials:Fiducial_1mm_Dia_2.54mm_Outer_CopperTop" H 2000 7550 60  0001 C CNN
F 3 "" H 2000 7550 60  0000 C CNN
	1    2000 7550
	0    1    1    0   
$EndComp
$EndSCHEMATC
