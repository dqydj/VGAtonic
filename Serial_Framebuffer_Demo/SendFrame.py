# License: MIT
# Please see license file in directory for details.

from __future__ import division

import sys
from PIL import Image, ImageOps
import serial
import time
import sys
import math


from optparse import OptionParser
class switch(object):
    def __init__(self, value):
        self.value = value
        self.fall = False

    def __iter__(self):
        """Return the match method once, then stop"""
        yield self.match
        raise StopIteration
    
    def match(self, *args):
        """Indicate whether or not to enter a case suite"""
        if self.fall or not args:
            return True
        elif self.value in args:
            self.fall = True
            return True
        else:
            return False



print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

def main(argv=None):
	parser = OptionParser()
	parser.add_option('-i', action="store", dest="inputfile")
	parser.add_option('-b', action="store", dest="baudrate", type="int")
	parser.add_option('-p', action="store", dest="port")
	parser.add_option('-t', action="store", dest="timeout", type="float")
	parser.add_option('-x', action="store", dest="width", type="int")
	parser.add_option('-y', action="store", dest="height", type="int")
	parser.add_option('-c', action="store", dest="colordepth", type="int")
	parser.add_option('-v', action="store", dest="verbosity", type="int")
	parser.add_option('-d', action="store", dest="dither", type="int")
	parser.add_option('-r', action="store", dest="rotate", type="int")
	parser.add_option('-m', action="store", dest="movie", type="int")



	inputfile   = ''
	baudrate    = 38400
	port        = '/dev/tty.usbmodem1411'
	timeout     = .2
	width       = 320
	height      = 240
	colordepth  = 8
	verbosity   = 0
	depthtest   = 0
	inputfile 	= "ground.jpg"
	rotate 		= 0
	dither 		= 0
	movie 		= 0

	
	(opts, args) = parser.parse_args()
	
	

	if opts.inputfile  != None:
		inputfile   = opts.inputfile
	if opts.baudrate   != None:
		baudrate    = opts.baudrate
	if opts.port       != None:
		port        = opts.port 
	if opts.timeout    != None:
		timeout     = opts.timeout
	if opts.width      != None:
		width       = opts.width 
	if opts.height     != None:
		height      = opts.height
	if opts.colordepth != None:
		colordepth  = opts.colordepth
	if opts.verbosity != None:
		verbosity  = opts.verbosity
	if opts.dither != None:
		dither  = opts.dither
	if opts.rotate != None:
		rotate  = opts.rotate
	if opts.movie != None:
		movie  = opts.movie


	if (colordepth != 8 and colordepth != 4 and colordepth != 2 and colordepth != 1):
		print "Illegal colordepth: ",colordepth,".  Must be 8, 4, 2, or 1."
		sys.exit(2)

	if (height > 480 or width > 640):
		print "Maximum size for VGAtonic is 640x480.  Changing your inputs."
		height = 480
		width = 640

	im = Image.open(inputfile)

	if (verbosity >= 1):
		print 'Input file is ', inputfile
		print 'Serial port is ', port
		print 'Timeout is ', timeout
		print 'Baudrate is ', baudrate
		print 'Width is ', width
		print 'Height is ', height
		print (sys.version)



	if (baudrate == 38400):
		# if we are still in 9600 it'll hang - so just connect at 9600 and tell it to go to 38400
		ser = serial.Serial(port=port, baudrate=9600, timeout = timeout)
		# Esc % >
		ser.write( chr(27) )
		reply = ser.read(1)
		ser.write( chr(37) )
		reply = ser.read(1)
		ser.write( chr(62) )
		reply = ser.read(1)

		ser.close()


	if (baudrate == 9600):
		# if we are still in 38400 it'll hang - so just connect at 38400 and tell it to go to 9600
		ser = serial.Serial(port=port, baudrate=38400, timeout = timeout)
		# Esc % <
		ser.write( chr(27) )
		reply = ser.read(1)
		ser.write( chr(37) )
		reply = ser.read(1)
		ser.write( chr(60) )
		reply = ser.read(1)

		ser.close()



	s = serial.Serial(port=port, baudrate=baudrate, timeout = timeout)
	initializeAndSetMode (s, height, width, colordepth, verbosity)

	while True:
		im2 = manipulateImage( im, width, height, rotate, dither, colordepth )
		myPixels = getPixels(im2, colordepth)
		sendImageOverSerial( s, myPixels, height, width, colordepth, baudrate, verbosity )
		if (movie == 0):
			break
		else:
			rotate = rotate+5
			movie = movie-1


	giveUpBusToSPI ( s, verbosity )
	s.close()

	print "Done!"

def getSinglePixel( r, g, b, colordepth, pixelCount ):

	for case in switch(colordepth):
	    if case(8): # B its per color
	        return (32*int(round(r//32))) + (4*int(round(g//32))) + int(round(b//64));
	    if case(4): # B its per color
	    	pixel = 0
	        if (r > 63): 
	        	pixel += 8
	        if (g > 63):
	        	pixel += 4
	       	if (b > 63):
	        	pixel += 2
	        if (r > 127 or g > 127 or b > 127):
	        	pixel += 1


	        if (pixelCount == 0):
	        	return pixel << 4
	        else:
	        	return pixel
	    if case(2): # 2 bits its per color
	    	pixel = 0

	        if (r > 191 or g > 191 or b > 191): 
	        	pixel = 3
	        elif (r > 127 or g > 127 or b > 127):
	        	pixel = 2
	       	elif (r > 63 or g > 63 or b > 63):
	        	pixel = 1
	        

	        if (pixelCount == 0):
	        	return pixel << 6
	        if (pixelCount == 2):
	        	return pixel << 4
	        if (pixelCount == 4):
	        	return pixel << 2
	        else:
	        	return pixel
	    if case(): # B&W
	        if (r > 127 or g > 127 or b > 127): 
	        	return 1 << (7 - pixelCount)
	        else:
	        	return 0

def getPixels ( inputimage, colordepth):
	myList = []
	rgb_im = inputimage.convert('RGB')
	for y in xrange(0,inputimage.size[1]):
		pixelCount = 0
		pixel = 0
		for x in xrange(0,inputimage.size[0]):
			r, g, b = rgb_im.getpixel((x, y))
			pixel += getSinglePixel(r, g, b, colordepth, pixelCount)
			pixelCount += colordepth
			if (pixelCount == 8):
				myList.append(pixel)
				pixel = 0
				pixelCount = 0
			
	return myList

def sendCommand( ser, code, responseExpected ):
	ser.write( chr(27) )
	reply = ser.read(1)
	i = 0
	while (reply != '>' and i != 10):
		ser.write( chr(27) )
		reply = ser.read(1)
		++i
	#print "WAS: ",reply
	ser.write( chr(code) )
	reply = ser.read(1)
	# Todo: Check reply, etc.
	return reply

def manipulateImage( inputimage, width, height, rotate, dither, colordepth ):

	inputimage = inputimage.rotate(rotate)
	inputimage.thumbnail((width,height), Image.ANTIALIAS)
	# If the size doesn't match, create a black background
	if (width != inputimage.size[0] or height != inputimage.size[1]):
		background = Image.new(inputimage.mode, (width,height), 0)


		img_w, img_h = inputimage.size
		bg_w, bg_h = background.size
		offset_n = (int((bg_w - img_w) / 2), int((bg_h - img_h) / 2) )


		background.paste( inputimage, offset_n)
		inputimage = background

	#inputimage.show()
	inputimage = ImageOps.fit(inputimage, (width, height), Image.ANTIALIAS)      # use nearest neighbour


	# If we want dithering, load our color palettes so PIL knows what to work with.
	if (dither == 1 and colordepth != 1):
		if (colordepth == 8):
			paletteIMG = Image.open("Palettes/256Colors.png")
			ourpalette = paletteIMG.getdata()
			inputimage = inputimage.convert("P", dither=Image.FLOYDSTEINBERG, palette=ourpalette)
		if (colordepth == 4):
			paletteIMG = Image.open("Palettes/16Colors.png")
			ourpalette = paletteIMG.getdata()
			inputimage = inputimage.convert("P", dither=Image.FLOYDSTEINBERG, palette=ourpalette)
		if (colordepth == 2):
			paletteIMG = Image.open("Palettes/4Colors.png")
			ourpalette = paletteIMG.getdata()
			inputimage = inputimage.convert("P", dither=Image.FLOYDSTEINBERG, palette=ourpalette)


	return inputimage

def changeMode( ser, width, height, depth, verbosity ):
	toSend = getMode(height, width, depth, verbosity)

	# Send 'Z'
	reply1 = sendCommand( ser, 90, 6 )
	ser.write( chr(toSend) )

def getMode ( width, height, depth, verbosity ):
	modeChange = 0;

	if   (height <= 80 and width <= 60):
		modeChange += 3
	elif (height <= 160 and width <= 120):
		modeChange += 2
	elif (height <= 320 and width <= 240):
		modeChange += 1

	if   (depth == 1):
		modeChange += 12
	elif (depth == 2):
		modeChange += 8
	elif (depth == 4):
		modeChange += 4
	if (verbosity >= 2):
		print "MC will be ",modeChange
	return modeChange

def ensureResponse ( ser ):
	# Lower the timeout, set a maximum counter, try to get a response
	# ser.timeout = .005;
	counter = 0
	ser.read(1)
	return
	while(len(ser.read(1)) < 1 and counter < 256):
		++counter

def initializeAndSetMode ( ser, height, width, colordepth, verbosity ) :
	reply = sendCommand( ser, 109, 6 ) # Send lowercase 'm' for master mode
	if (verbosity >= 2):
		print "Master Mode Set Reply: ",ord(reply)

	changeMode( ser, width, height, colordepth, verbosity )

	# Toggle the CPLD a couple times to reset to 0,0
	reply = sendCommand( ser, 115, 6 ) # Send lowercase 's' to select the CPLD
	if (verbosity >= 2):
		print "Chip Select Reply: ",ord(reply)

	reply = sendCommand( ser, 117, 6 ) # Send lowercase 'u' to unselect the CPLD
	if (verbosity >= 2):
		print "Chip Unselect Reply: ",ord(reply)

	reply = sendCommand( ser, 115, 6 ) # Send lowercase 's' to select the CPLD
	if (verbosity >= 2):
		print "Chip Select Reply: ",ord(reply)

def giveUpBusToSPI ( ser, verbosity ):

	reply = sendCommand( ser, 117, 6 ) # Send lowercase 'u' to unselect the CPLD
	if (verbosity >= 1):
		print "Chip Unselect Reply: ",ord(reply)
	reply = sendCommand( ser, 114, 6 ) # Send lowercase 'r' to release the CPLD to whomever wants it
	if (verbosity >= 1):
		print "Chip Release Reply: ",ord(reply)

def sendImageOverSerial( ser, myList, height, width, colordepth, baudrate, verbosity ) :

	# Grab the serial port - in case we exited in the middle of a command, write nulls until we get it back.
	#ensureResponse ( ser )

	
	bytesLeft = len(myList)
	totalBytes = bytesLeft	

	if (verbosity >= 2):
		print "Preparing to send ",bytesLeft, " bytes."

	# Timer
	startTimer = time.time()

	reply = sendCommand( ser, 115, 6 ) # Send lowercase 's' to select the CPLD
	if (verbosity >= 2):
		print "Chip Select Reply: ",ord(reply)

	while bytesLeft > 0:
		if (bytesLeft > 150):
			reply = sendCommand( ser, 87, 6 ) # Send uppercase 'W' to tell the ATTiny a write is coming
			#print "New write reply: ",ord(reply)
			#reply = sendCommand( ser, 255, 6 ) # Maximum write size is 255, tell the 2313 to get ready
			#ser.write( chr(255) )
			#reply = ser.read(1)
			#print "Size reply (should be 255): ",ord(reply)

			# Just in case there is a mixup, use what they gave us
			for i in xrange(0,150):
				ser.write( chr( myList[totalBytes-bytesLeft+i] ) )
						
			bytesLeft -= 150
			ensureResponse ( ser )

		else:
			extrajunk = 150 - bytesLeft
			reply = sendCommand( ser, 87, 6 ) # Send lowercase 'w' to tell the ATTiny a write is coming
			#print "New write reply: ",ord(reply)
			#reply = sendCommand( ser, bytesLeft, 6 ) # Write size is whatever bits are left over
			#ser.write( chr(bytesLeft) )
			#reply = ser.read(1)
			#print "Size reply (should be ",bytesLeft,"): ",ord(reply)

			# Just in case there is a mixup, use what they gave us
			for i in xrange(0,bytesLeft):
				ser.write( chr( myList[totalBytes-bytesLeft+i] ) )

			# Pad it with black.
			for i in xrange(bytesLeft, 150):
				ser.write( chr(0) )
						
			bytesLeft -= bytesLeft
			ensureResponse ( ser )

	
	reply = sendCommand( ser, 117, 6 ) # Send lowercase 'u' to unselect the CPLD
	if (verbosity >= 1):
		print "Chip Unselect Reply: ",ord(reply)

	endTimer = time.time()
	if (verbosity >= 1):
		print "Elapsed serial image write time: ",endTimer - startTimer

	totalBits = totalBytes*8
	totalThroughput = baudrate*(8/10)
	totalThroughput = totalThroughput*(150/155)
	theoreticalSeconds = totalBits/totalThroughput
	if (verbosity >= 1):
		print "Theoretical transfer time (with no tx/rx latency or waiting on code): ",theoreticalSeconds




if __name__ == "__main__":
    sys.exit(main())





