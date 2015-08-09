This code runs on an Intel Galileo modified as mentioned in this post:

http://hackaday.io/project/1943/log/8757-the-project-deadline-limbo

Once you increase the allowed sketch size your Galileo should have no problem running this code.

Pins needed:
13: SCK
11: MOSI
10: CS

Optional:
5v
GND

Steps:
1) Get the python script in this directory, edit the line which refers to picture name
2) Find a way to install the PIL, Python Imaging Library, http://www.pythonware.com/products/pil/
3) Format your picture as 640x480.  Optional: use Photoshop or similar to limit the color palette.
4) Copy guitars.h / doge3.h with the output of the script.
5) Upload, be wowed!

We'll do Linux next.

License: See main directory, still MIT.
