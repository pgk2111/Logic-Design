import struct
import sys
import numpy as np

np.seterr(all='raise')

def binary(num):
    return ''.join(bin(c).replace('0b', '').rjust(8, '0') for c in struct.pack('!f', num))

if len(sys.argv) < 3:
    print("Usage: script.py <op> <numTests>")
    sys.exit(1)

op = str(sys.argv[1])
numTests = int(sys.argv[2])

with open("fpu_tb.v", 'w') as f:
    if(op == "ADD"):
        f.write("   $display(\"ADD\");\n")
        f.write("    op = 2'b00;\n")    
    elif(op == "SUB"):
        f.write("   $display(\"SUB\");\n")
        f.write("    op = 2'b01;\n")
    elif(op == "DIV"):
        f.write("   $display(\"DIV\");\n")
        f.write("    op = 2'b10;\n")
    elif(op == "MULT"):
        f.write("   $display(\"MULT\");\n")
        f.write("    op = 2'b11;\n")

    n = 0
    while n < numTests:
        try:
            byte = np.random.bytes(4)
            a = np.frombuffer(byte, dtype=np.float32)
            byte = np.random.bytes(4)
            b = np.frombuffer(byte, dtype=np.float32)
            if(op == "ADD"):
                result = a + b
            elif(op == "SUB"):
                result = a - b
            elif(op == "DIV"):
                result = a / b
            elif(op == "MULT"): 
                result = a * b
                
            f.write("    a = 32'b" + binary(a[0]) + ";\n")
            f.write("    b = 32'b" + binary(b[0]) + ";\n")
            f.write("    correct = 32'b" + binary(result[0]) + ";\n")
            f.write("    #400 //" + str(a[0]) + " * " + str(b[0]) + " = " + str(result[0]) + "\n")
            f.write("        $display (\"Output : %b %b %b %h\", out[18], out[17:10], out[9:0], out);\n")
            f.write("        $display (\"Correct: %b %b %b %h\",correct[31], correct[30:23], correct[22:0], correct);\n")
            f.write("        $display();\n")
            n += 1  # only count if success
        except:
            pass  # retry

   
