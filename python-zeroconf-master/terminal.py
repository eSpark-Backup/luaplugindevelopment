from tkinter import *
import os
import tkinter.font as font


root = Tk()
root.title("Searching Devices")
myFont = font.Font(size=20, weight="bold")

termf = Frame(root, height=900, width=1400)
termf.pack(fill=BOTH, expand=YES)
wid = termf.winfo_id()
#os.system('xterm -into %d -geometry 400x400 -sb &' % wid)

termf['font'] = myFont
os.system('xterm -into %d -geometry 900x1400 -e python3 mdns.py &' % wid )

root.mainloop()