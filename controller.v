`timescale 1ns/1ns




module controller(input run,rst,clk,dout, start, isdone, isempty,cout,queuedone, input [1:0] popedmove, output reg rststack,rstqueue,showmove,rstxy,ld,WR,RD,din,done,fail,pop,qshift,push,output reg[1:0] S);
    parameter [5:0] A=0,B=1,C=2,D=3,E=4,F=5,G=6,H=7,I=8,J=9,K=10,L=11,M=12,N=13,O=14,P=15,Q=16,R=17,T=18,U=19,V=20,C1=21,S1=22,R1 = 23, R2=24,R3=25,R4 = 26,R5=27,R6 = 28;
    reg [5:0] ns,ps;
    assign S = 2'b0;
    assign din = 1'b0;
    assign fail = 1'b0;
    assign done = 1'b0;
    assign rststack = 1'b0;
    assign rstqueue = 1'b0;
    assign showmove = 1'b0;
    always @(ps,start,isdone,cout,dout,popedmove,run,queuedone) begin
        ns = A;
        case (ps)
            A: ns = (start)?B:((run)?R1:A);
            B: ns = (start)?B:C;
            C: ns = (cout)?I:C1;
            C1: ns =(dout)?I:D;
            D: ns = E;
            E: ns = F;
            F: ns = (isdone)?S1:G;
            G: ns = (cout)?I:H;
            H: ns = (dout)?I:D;
            I: ns = (cout)?K:J;
            J: ns = (dout)?K:D;
            K: ns = (cout)?M:L;
            L: ns = (dout)?M:D;
            M: ns = (cout)?O:N;
            N: ns = (dout)?O:D;
            O: ns = (isempty)?T:P;
            P: ns = Q;
            Q: ns = R;
            R: ns = (popedmove[1])?(popedmove[0]?O:M):(popedmove[0]?K:I);
            S1: ns = A;
            R1: ns = (queuedone)?A:R2;
            R2: ns = R3;
            R3: ns = R4;
            R4: ns = (queuedone)?R5:R2;
            R5: ns= R6;
            R6: ns = A;

        endcase
    end
    always @(ps,start,isdone,cout,dout,popedmove,run,queuedone) begin
        rstxy = 1'b0;ld=1'b0;WR=1'b0;RD=1'b0;pop=1'b0;push=1'b0;rstqueue = 1'b0;rststack=1'b0;qshift = 1'b0;showmove = 1'b0;
        case(ps)
            B: begin
                rstxy = 1'b1;
                rststack = 1'b1;
                fail = 1'b0;
                done = 1'b0;
            end
            C: begin
                S = 2'b00;
            end
            C1: begin
                RD = 1'b1;
            end
            D: begin
                push = 1'b1;
                din = 1'b1;
                WR = 1'b1;
            end
            E: begin
                ld = 1'b1;
            end
            G:begin
                S = 2'b00;
            end
            H: begin
                RD = 1'b1;
            end
            I: begin
                S = 2'b01;
            end
            J: begin
                RD = 1'b1;
            end
            K: begin
                S = 2'b10;
            end
            L:begin
                RD = 1'b1;
            end
            M: begin
                S = 2'b11;
            end
            N:begin
                RD = 1'b1;
            end
            T:begin
                fail = 1'b1;
            end
            P:begin
                pop = 1'b1;
            end
            Q: begin
                ld = 1'b1;
                S = 3 - popedmove;
            end
            R:begin
                WR = 1'b1;
                din = 1'b0;
            end
            S1: begin
                done = 1'b1;
            end 
            R1: begin
                rstqueue = 1'b1;
            end
            R2: begin
                showmove = 1'b1;
            end
            R3: begin
                qshift = 1'b1;
            end
            R5:begin
                showmove = 1'b1;
            end
            R6:begin
                qshift = 1'b1;
            end
        endcase
    end
    always @(posedge clk,posedge rst) begin
        if (rst == 1'b1)
            ps <= A;
        else
            ps <= ns;
    end
endmodule
