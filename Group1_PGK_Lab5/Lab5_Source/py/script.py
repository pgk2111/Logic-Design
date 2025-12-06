# coding=utf-8
import sys

if len(sys.argv) != 3:
  sys.exit("number of arguments = " + str(len(sys.argv)))


with open("fpu.v", 'w') as f:
    f.write("//-----------------------------------------------------------\n// File: fpu_tb.v\n// FPU Test Bench\n//-----------------------------------------------------------\n`timescale 1 ns/100 ps\nmodule fpu_tb ();\n //----------------------------------------------------------\n // inputs to the DUT are reg type\n reg clock;\n reg [31:0] a, b;\n reg [1:0] op;\n reg [31:0] correct;\n //----------------------------------------------------------\n // outputs from the DUT are wire type\n wire [31:0] out;\n wire [49:0] pro;\n //----------------------------------------------------------\n // instantiate the Device Under Test (DUT)\n // using named instantiation\n fpu U1 (\n          .clk(clock),\n          .A(a),\n          .B(b),\n          .opcode(op),\n          .O(out)\n        );\n //----------------------------------------------------------\n // create a 10Mhz clock\n always\n #100 clock = ~clock; // every 100 nanoseconds invert\n //----------------------------------------------------------\n // initial blocks are sequential and start at time 0\n initial\n begin\n\n $dumpfile(\"fpu_tb.vcd\");\n $dumpvars(0,clock, a, b, op, out);\n clock = 0;\n")

    NEXP = int(sys.argv[1])
    NSIG = int(sys.argv[2])

    f.write("  parameter NEXP = " + str(NEXP) + ";\n")
    f.write("  parameter NSIG = " + str(NSIG) + ";\n")


    emax = (1 << (NEXP-1)) - 1;
    bias = emax;
    emin = 1 - emax;

    stringWidth = NEXP + NSIG + 1
    # oneString = '%d\'h%04X' % (stringWidth, (bias << NSIG))
    hexFormat = "%d'h%0" + str((stringWidth+3)>>2) + "X"
    oneString = hexFormat % (stringWidth, (bias << NSIG))
    stringPrefix = str(stringWidth) + '\'h'

    # One * {Normal, Subnormal}
    for i in range(emax, -emax, -1):
        f.write('\n    #10 $display("\\n1 * 2**%d:");' % i)
        normalString = hexFormat % (stringWidth, ((i + bias) << NSIG))
        f.write('    #10 assign a = ' + oneString + '; assign b = ' + normalString + ';')

    for i in range(0, NSIG, 1):
        f.write('\n    #10 $display("\\n1 * 2**%d:");' % (-emax-i))
        subnormalString = hexFormat % (stringWidth, (1 << (NSIG-1-i)))
        f.write('    #10 assign a = ' + oneString + '; assign b = ' + subnormalString + ';')

    # {Normal, Subnormal} * One
    for i in range(emax, -emax, -1):
        f.write('\n    #10 $display("\\n2**%d * 1:");' % i)
        normalString = hexFormat % (stringWidth, ((i + bias) << NSIG))
        f.write('    #10 assign b = ' + oneString + '; assign a = ' + normalString + ';')

    for i in range(0, NSIG, 1):
        f.write('\n    #10 $display("\\n2**%d * 1:");' % (-emax-i))
        subnormalString = hexFormat % (stringWidth, (1 << (NSIG-1-i)))
        f.write('    #10 assign b = ' + oneString + '; assign a = ' + subnormalString + ';')

    # Edge of Normal/Infinity boundary:
    for i in range(0, emax+1):
        f.write('\n    #10 $display("\\n2**%d * 2**%d:");' % (i, emax-i))
        aString = hexFormat % (stringWidth, ((i + bias) << NSIG))
        bString = hexFormat % (stringWidth, ((emax - i + bias) << NSIG))
        f.write('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')
        aString = hexFormat % (stringWidth, ((i + bias) << NSIG) + ((1 << NSIG) - 1))
        bString = hexFormat % (stringWidth, ((emax - i + bias) << NSIG) + ((1 << NSIG) - 1))
        f.write('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')

    # Edge of Subnormal/Normal boundary:

    def makeNormal(exp, sig) -> int:
        return ((exp + bias) << NSIG) + (sig & ((1 << NSIG) - 1))

    def makeSubnormal(exp, sig) -> int:
        shiftAmount = emin - exp
        return sig >> shiftAmount

    def makeNumber(exp, sig) -> int:
        if exp < emin:
            return makeSubnormal(exp, sig)
        else:
            return makeNormal(exp, sig)

    minExp = emin - NSIG
    maxExp = NSIG

    for i in range(minExp, maxExp):
        f.write('\n    #10 $display("\\n2**%d * 2**%d:");' % (i, minExp+NSIG-1-i))
        aString = hexFormat % (stringWidth, makeNumber(i, (1 << NSIG)))
        bString = hexFormat % (stringWidth, makeNumber(minExp+NSIG-1-i, (1 << NSIG)))
        f.write('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')
        aString = hexFormat % (stringWidth, makeNumber(i, ((2 << NSIG) - 1)))
        bString = hexFormat % (stringWidth, makeNumber(minExp+NSIG-1-i, ((2 << NSIG) - 1)))
        f.write('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')

    maxExp = -1

    for i in range(minExp, maxExp+1):
        f.write('\n    #10 $display("\\n2**%d * 2**%d:");' % (i, maxExp+minExp-i))
        aString = hexFormat % (stringWidth, makeNumber(i, (1 << NSIG)))
        bString = hexFormat % (stringWidth, makeNumber(maxExp+minExp-i, (1 << NSIG)))
        f.write('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')
        aString = hexFormat % (stringWidth, makeNumber(i, ((2 << NSIG) - 1)))
        bString = hexFormat % (stringWidth, makeNumber(maxExp+minExp-i, ((2 << NSIG) - 1)))
        f.write('    #10 assign a = ' + aString + '; assign b = ' + bString + ';')

    f.write("    $display (\"Done.\");\n    $finish;\n // stop the simulation\n end\n\nendmodule")