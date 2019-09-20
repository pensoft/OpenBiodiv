import re
import os

def upper(match):
        str = match.group().upper()
        #we don't remove hyphens now
        #str = re.sub(r'(-)', '', str)
        return(str)

rootdir = "."
for filename in os.listdir(rootdir):
    if filename.endswith(".trig"):
        count = 0
        fileroot = re.sub(r'\.trig', '', filename )
        new_filepath = "../upperCase/" + fileroot + "_" + str(count) + ".trig"
        f = open(filename, "r")
        new_f = open(new_filepath, "a")    
        string = f.read()
        new_string = re.sub(r'(?<=<http:\/\/openbiodiv.net\/)\S*(?=>)',upper, string)
        new_string = re.sub(r'LABEL','-label', new_string)  
        new_string = re.sub(r'SCNAME','-scName', new_string)
        new_f.write(new_string)
        count += 1
        new_f.close()
        f.close()