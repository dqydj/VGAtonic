import sys
import Image


im = Image.open("guitars.bmp")
rgb_im = im.convert('RGB')

for y in xrange(0,im.size[1]):
	for x in xrange(0,im.size[0]):
		r, g, b = rgb_im.getpixel((x, y))
		pixel = (32*int(round(r/32))) + (4*int(round(g/32))) + int(round(b/64));
		print pixel , ","

