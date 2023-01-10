from tkinter import *
import subprocess
#import os

win = Tk()

def runScript():
    result = "Result"
    #sos = os.system("lua -v")
    print("\n")
    #sos=subprocess.check_output("lua -v", shell=True)
    sos=subprocess.check_output("avahi-browse -kat", shell=True)
    
    outputLabel = Label(win)
    outputLabel.grid(row=1, column=0)
    result=Label(win, text=sos, justify="center").grid(row=1, column=0)

# Button 
submitButton = Button(win, text="Submit", command=runScript)

quit=Button(win,text='Quit', fg='Red', command=win.destroy).grid(row=10, column=0)
# Implementing 
submitButton.grid(row=0, column=0)

#Set the geometry of tkinter frame
win.geometry("250x250")

win.mainloop()