# THIS SCRIPT RENDERS AN IMAGE WITH DRAWBOT: http://www.drawbot.com
from drawBot import *
import math

# CONSTANTS
W = 1024  # Width
H = 512   # Height
M = 32    # Margin
U = 32    # Unit (Grid Unit)
F = 0     # Frames (Animation)

# DRAWS A GRID
def grid():
    strokeWidth(1)
    stroke(0.1)
    step_X = 0
    step_Y = 0
    increment_X = U
    increment_Y = U
    for x in range(31):
        polygon( (M+step_X, M), (M+step_X, H-M) )
        step_X += increment_X
    for y in range(15):
        polygon( (M, M+step_Y), (W-M, M+step_Y) )
        step_Y += increment_Y
    fill(None)
    rect(M, M, W-(2*M), H-(2*M))

# NEW PAGE
def new_page():
    newPage(W, H)
    fill(0)
    rect(-2, -2, W+2, H+2)

# SET FONT
font("../../fonts/MicroGrotesk.ttf")
for axis, data in listFontVariations().items():
    print((axis, data))
varWght = 0
step = -1

# MAIN
new_page()
fontSize((M*2))
grid() # Toggle for grid view
font("../../fonts/MicroGrotesk.ttf")
fill(1)
stroke(None)
text("Micro Grotesk",(M*1, M*13))
text("ABCDEFGHIJKLMNOPQRSTUV",(M*1, M*9))
text("WXYZabcdefghijklmnopqrstuv",(M*1, M*7))
text("wxyz",(M*1, M*5))
text("5k",(M*1, M*1))

# SAVE THE OUTPUT IN THIS SCRIPT'S DIRECTORY LOCATION
saveImage("basic-specimen.gif")
