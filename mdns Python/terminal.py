from tkinter import *
import os
from sys import platform

root = Tk()
root.title("Searching Devices")
termf = Frame(root, height=1000, width=1000)
termf.pack(fill=BOTH, expand=YES)
wid = termf.winfo_id()


if platform == "linux":
    os.system('xterm -into %d -geometry 1000x1000 -e python3 mdns.py &' % wid )

elif platform == "win32":
    os.system('start cmd.exe /K "python mdns.py"')

root.mainloop()

