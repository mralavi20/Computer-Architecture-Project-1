`timescale  1ns/1ns



module MazeMemory(input clk,Din, RD,WR,input [3:0] X,Y,output reg Dout);


reg [0:15] memblocks[0:15];
reg [0:15] temp;

initial begin
    $readmemh ("Mem.txt", memblocks);
end


always @(posedge clk,X,Y,RD) begin
    if(WR) begin
        temp <= memblocks[Y];
        temp[X] <= Din;
        memblocks[Y] <= temp;
    end
end
assign temp = memblocks[Y];
assign Dout = (RD)?temp[X]:1'bz;
endmodule

