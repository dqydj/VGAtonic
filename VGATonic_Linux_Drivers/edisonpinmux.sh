#Pins
echo 49 > /sys/class/gpio/export
echo 115 > /sys/class/gpio/export
echo 114 > /sys/class/gpio/export
echo 109 > /sys/class/gpio/export
echo 111 > /sys/class/gpio/export

#Muxes
echo 262 > /sys/class/gpio/export
echo 240 > /sys/class/gpio/export
echo 241 > /sys/class/gpio/export
echo 242 > /sys/class/gpio/export
echo 243 > /sys/class/gpio/export

#Output vs Input
echo 256 > /sys/class/gpio/export
echo 258 > /sys/class/gpio/export
echo 259 > /sys/class/gpio/export
echo 260 > /sys/class/gpio/export
echo 261 > /sys/class/gpio/export

#Pullup Resistors
echo 224 > /sys/class/gpio/export
echo 226 > /sys/class/gpio/export
echo 227 > /sys/class/gpio/export
echo 228 > /sys/class/gpio/export
echo 229 > /sys/class/gpio/export

#Tri-State
echo 214 > /sys/class/gpio/export

echo low > /sys/class/gpio/gpio214/direction 


# Make changes - Set Modes
echo high > /sys/class/gpio/gpio262/direction
echo high > /sys/class/gpio/gpio240/direction
echo high > /sys/class/gpio/gpio241/direction
echo high > /sys/class/gpio/gpio242/direction
echo high > /sys/class/gpio/gpio243/direction

# Set Directions
echo high > /sys/class/gpio/gpio49/direction 
echo high > /sys/class/gpio/gpio256/direction
echo high > /sys/class/gpio/gpio258/direction 
echo high > /sys/class/gpio/gpio259/direction
echo low > /sys/class/gpio/gpio260/direction 
echo high > /sys/class/gpio/gpio261/direction 

# Disable Pullups
echo in >  /sys/class/gpio/gpio224/direction
echo in > /sys/class/gpio/gpio226/direction
echo in >  /sys/class/gpio/gpio227/direction
echo in >  /sys/class/gpio/gpio228/direction
echo in >  /sys/class/gpio/gpio229/direction

# Set Modes (finally) of the pins
echo mode0 > /sys/kernel/debug/gpio_debug/gpio49/current_pinmux
echo mode1 > /sys/kernel/debug/gpio_debug/gpio115/current_pinmux 
echo mode1 > /sys/kernel/debug/gpio_debug/gpio114/current_pinmux 
echo mode1 > /sys/kernel/debug/gpio_debug/gpio109/current_pinmux 

# SPI Power Mode

echo on >/sys/devices//pci0000\:00/0000\:00\:07.1/power/control

echo high > /sys/class/gpio/gpio214/direction

# Release pin for VGATonic (retaining all the muxes we just worked so hard on!)
echo 49 > /sys/class/gpio/unexport
