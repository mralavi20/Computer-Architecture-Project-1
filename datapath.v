`timescale 1ns/1ns




module reg_4b (input [3:0] din, input cl, rst, ld, output reg [3:0] dout);
	always @(posedge cl) begin
		if (rst)
			dout <= 4'b0000;
		else if (ld)
			dout <= din;
	end
endmodule



module inc_1 (input [3:0] din, output cout, output [3:0] dout);
	assign {cout, dout} = din + 1;
endmodule

module sub_1 (input [3:0] din, output cout, output [3:0] dout);
	assign {cout, dout} = din - 1;
endmodule


module mux_2_to_1(input [3:0] d1, [3:0] d2, input sel, output reg [3:0] dout);
	always @* begin
		case(sel)
			1'b0: dout = d1;
			1'b1: dout = d2;
		endcase
	end
endmodule

module mux_2_to_1_2bit(input [1:0] d1, [1:0] d2, input sel, output reg [1:0] dout);
	always @* begin
		case(sel)
			1'b0: dout = d1;
			1'b1: dout = d2;
		endcase
	end
endmodule


module mux_4_to_1 (input [3:0] d1, [3:0] d2, [3:0] d3, [3:0] d4, input [1:0] sel, output [3:0] dout);
	assign dout = (sel == 2'b00) ? d1:
		(sel == 2'b01) ? d2:
		(sel == 2'b10) ? d3:
		(sel == 2'b11) ? d4:
		4'b0000;
endmodule
module mux_4to1_onebit (input d1,d2,d3,d4, input [1:0] s, output reg y);
always @* begin
    case(s)
        2'b00: y = d1;
        2'b01: y = d2;
        2'b10: y = d3;
        2'b11: y = d4;
    endcase
end
endmodule

module stack (input push, pop,qshift, cl,rst,rstqueue,showmove, input [1:0] din, output empty, output reg [1:0] dout,output [1:0] queueout,output done);
	reg [1:0] s [0:255];
	reg [7:0] c = 0;
	reg [7:0] qcount = 0;
	reg [1:0] current;
	
	integer i;
	always @(posedge cl) begin
		if (rst)
			c <= 0;
		else if (push) begin
			s[c] <= din;
			c <= c + 1;
		end
		else if (pop) begin
			c <= c - 1;
			dout <= s[c];
		end
		else if (qshift)begin
			for(i = c - 2 ;i >= 0; i=i-1)begin
				s[i] <= s[i+1];
			end
			s[c-1] = current;
			qcount <= qcount + 1;
		end
		else if (showmove)begin
			current <= s[0];
		end
		else if (rstqueue) begin
			qcount <= 0;
		end
	end
	assign empty = ~(|c);
	assign dout = s[c];
	assign count = c;
	assign done = (qcount == c)?1'b1:1'b0;
	assign queueout = current;




endmodule

module comparator (input [3:0] x, [3:0] y, output eq);
	assign eq = (x == 4'b1111 && y == 4'b1111) ? 1'b1 : 1'b0;
endmodule




module datapath (input push, pop,qshift, cl, rststack, rstqueue,showmove, ld,rstxy,rd, input [1:0] sel, output end_pos, s_empty, cout, queuedone, output [3:0] x_pos, [3:0] y_pos, output [1:0] dir_out, [1:0] move);
	wire [3:0] x_reg, y_reg, x_inc, x_sub, y_inc, y_sub, x_sel, y_sel,x_mem,y_mem;
	wire [1:0] Wmove;
	wire addxc, subxc, addyc, subyc;
	reg_4b X (x_sel, cl, rstxy, ld, x_reg);
	reg_4b Y (y_sel, cl, rstxy, ld, y_reg);
	inc_1 Xinc (x_reg, addxc, x_inc);
	sub_1 Xsub (x_reg, subxc, x_sub);
	inc_1 Yinc (y_reg, addyc, y_inc);
	sub_1 Ysub (y_reg, subyc, y_sub);
	mux_4_to_1 Xmux (x_reg, x_inc, x_sub, x_reg, sel, x_sel);
	mux_4_to_1 Ymux (y_sub, y_reg, y_reg, y_inc, sel, y_sel);
	mux_4to1_onebit Cmux (subyc, addxc, subxc, addyc, sel, cout);
	stack S (push, pop,qshift, cl, rststack, rstqueue,showmove, sel, s_empty, dir_out,Wmove,queuedone);
	comparator C (x_reg, y_reg, end_pos);
	mux_2_to_1 XMemSel(x_reg,x_sel,rd,x_mem);
	mux_2_to_1 YMemSel(y_reg,y_sel,rd,y_mem);
	mux_2_to_1_2bit Showmux(2'bz,Wmove,showmove,move);
	assign x_pos = x_mem;
	assign y_pos = y_mem;
endmodule


