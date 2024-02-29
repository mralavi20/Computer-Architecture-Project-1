`timescale 1ns/1ns



module maze_tb();
    reg cc,rr,SS,RR;
    wire Fai,Don;
    wire [1:0] Mov;
    IntelRat IR(cc,rr,SS,RR,Fai,Don,Mov);

    initial begin
        cc = 0;
        rr = 0;
        SS = 0;
        RR = 0;
    end
    initial begin
        repeat(3500) #20 cc = ~cc;
    end
    initial begin
    #40;
    #20 SS = 1;
    #60 SS = 0;
    end
    initial begin
        #60000 RR = 1'b1;
        #80 RR = 1'b0;
    end

    


endmodule
