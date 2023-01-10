import tkinter
from tkinter import *
import subprocess
import os
from os import system as cmd

WINDOW_SIZE = "600x400"
top = tkinter.Tk()
top.geometry(WINDOW_SIZE)


def BasicCovTests():
   print ("Below is the output from the shell script in terminal")
   #subprocess.call('perl /projects/tfs/users/$USER/basic_coverage_tests.pl', shell=True)
   os.system('xterm -into %d -geometry 100x20 -sb -e command &' % wid)
   os.system("lua -v")

Basic_coverage_tests  = tkinter.Button(top, text ="Basic Coverage Tests", command = BasicCovTests)
#quit=Button(top,text='Quit', fg='Red', command=top.destroy).grid(row=5, column=0)
Basic_coverage_tests.pack()


termf = Frame(top, height=100, width=500)

termf.pack(fill=BOTH, expand=YES)
wid = termf.winfo_id()

os.system('xterm -into %d -geometry 100x20 -sb &' % wid)
os.system("lua -v")

def send_entry_to_terminal(*args):
    """*args needed since callback may be called from no arg (button)
   or one arg (entry)
   """
    cmd("%s" % (BasicCovTests))

top.mainloop()