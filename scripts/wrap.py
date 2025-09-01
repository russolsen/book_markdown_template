import sys
import re

def wrap(in_f, out_f):
    text = ''
    line = in_f.readline()
    while line:
        #print(f"inside loop line is [{line}] len is {len(line)}")
        #print(f"inside loop text is [{text}]")
        if (line == '\n'):
            #print("Blank line with text")
            out_f.write(text)
            out_f.write('\n')
            text = ''
        elif text:
            #print("Normal line with text")
            text = f'{text} {line.strip()}'
        else:
            #print("First line")
            text = line.strip()
        line = in_f.readline()

    if text:
        out_f.write(text)
    out_f.write("\n")


wrap(sys.stdin, sys.stdout)




