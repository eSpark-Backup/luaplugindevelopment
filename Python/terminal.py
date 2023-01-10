""" 

from tkinter import *
import os

root = Tk()
termf = Frame(root, height=400, width=500)

termf.pack(fill=BOTH, expand=YES)
wid = termf.winfo_id()
os.system('xterm -into %d -geometry 40x20 -sb &' % wid)

root.mainloop()


 """

import tkinter as tk
from tkterminal import Terminal

root = tk.Tk()
terminal = Terminal(pady=5, padx=5)
terminal.pack(expand=True, fill='both')
root.mainloop()