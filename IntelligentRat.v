`timescale 1ns/1ns






module IntelRat(input clock,reset,Start,Run,output Fail,Done,output [1:0] Move);

wire Wpush,Wpop,Wload,Wisdone,Wisempty,Wcout,Wdout,Wrst,Wwr,Wrd,Wdin,Wrstqueue,Wrststack,Wqueuedone,Wqshift;
wire [1:0] WS,Wpopedmove;
wire [3:0] Wx,Wy;
datapath rat(Wpush,Wpop,Wqshift,clock,Wrststack,Wrstqueue,Wshowmove,Wload,Wrst,Wrd,WS,Wisdone,Wisempty,Wcout,Wqueuedone,Wx,Wy,Wpopedmove,Move);
controller controll(Run,reset,clock,Wdout,Start,Wisdone,Wisempty,Wcout,Wqueuedone,Wpopedmove,Wrststack,Wrstqueue,Wshowmove,Wrst,Wload,Wwr,Wrd,Wdin,Done,Fail,Wpop,Wqshift,Wpush,WS);
MazeMemory maze(clock,Wdin,Wrd,Wwr,Wx,Wy,Wdout);






endmodule
