To use:

Edit the code, since we're assuming a 58 MHz SPI device (which isn't common!)

(If you need to build)

gcc raspi_user_spi_test.c -o spitest

(To run: You need a "spidev0.0" device!)

sudo ./spitest

Control-c to exit - but really, insert your code in the loop if you just want to write to the framebuffer!

License:

    VGATonic Linux User Space Code
    Copyright (C) 2015 PK

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 2 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
