   $display("MULT");
    op = 2'b11;
    a = 32'b00101000001001110011001101111111;
    b = 32'b10110010110100100010101000100001;
    correct = 32'b10011011100010010100001111000010;
    #400 //9.281529e-15 * -2.4466376e-08 = -2.2708536e-22
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b00101110000001010110111011001000;
    b = 32'b01001010111100001110100001000000;
    correct = 32'b00111001011110110010000111010011;
    #400 //3.0339092e-11 * 7894048.0 = 0.00023949826
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b01100100010010100100000001110110;
    b = 32'b00010101001000111111100100001001;
    correct = 32'b00111010000000011000101111001011;
    #400 //1.4923549e+22 * 3.3114042e-26 = 0.000494179
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b10011001100110101001001110111110;
    b = 32'b10101010100111110100111011110010;
    correct = 32'b00000100110000000110001011011100;
    #400 //-1.59829e-23 * -2.8298853e-13 = 4.522977e-36
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b00101000010011000111110100110010;
    b = 32'b11101111111010001000111011001101;
    correct = 32'b11011000101110011100001110000111;
    #400 //1.1351422e-14 * -1.4394632e+29 = -1633995500000000.0
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
