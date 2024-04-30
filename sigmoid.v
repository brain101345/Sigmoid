module sigmoid (
	input         clk,
	input         rst_n,
	input         i_in_valid,
	input  [ 7:0] i_x,
	output [15:0] o_y,
	output        o_out_valid,
	output [50:0] number
);

// Your design
wire[50:0] n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, 
    n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
    n20, n21, n22;
wire[50:0] nf0, nREGP, nREO0, nREO1, nRIV, nRMUX0, nRMUX1, nRMUX2;
wire [6:0] iv_x, EO_x;
wire [15:0] o0, o1, o2, o3, o4, o5, y_positive, y;
wire ctrl0, ctrl1, ctrl2;
// EO_x
REO#(.BW(7)) U_REO0(.Z(EO_x[6:0]), .A(i_x[6:0]), .B(i_x[7]), .number(nREO0));
// iv_x
RIV#(.BW(4)) U_RIV0(.Z(iv_x[6:3]), .A(EO_x[6:3]), .number(nRIV));
//o0 = 1/4 * ab.cdefg + 1/2 = 0.abcdefg 
//                          + 0.1 
//                          = 0.1bcdefg
//00.00000 ~ 01.00000
assign o0[15] = 0;
assign o0[14] = 1;
assign o0[13] = EO_x[5];
assign o0[12] = EO_x[4];
assign o0[11] = EO_x[3];
assign o0[10] = EO_x[2];
assign o0[9] = EO_x[1];
assign o0[8] = EO_x[0];
assign o0[7] = 0;
assign o0[6] = 0;
assign o0[5] = 0;
//o1 = 1/8 * ab.cdefg + 1/2 + 1/8 + 1/512 + 1/1024 = 0.0abcdefg 
//                                                 + 0.1010000011
//                                                 = 0.11(b')cdefg11
//01.00000 ~ 10.01000
assign o1[15] = 0;
assign o1[14] = 1;
assign o1[13] = 1;
assign o1[12] = iv_x[5];
assign o1[11] = EO_x[4];
assign o1[10] = EO_x[3];
assign o1[9] = EO_x[2];
assign o1[8] = EO_x[1];
assign o1[7] = EO_x[0];
assign o1[6] = 1;
assign o1[5] = 1;
//o2 = 1/16 * ab.cdefg + 1/2 + 1/4 + 1/64 + 1/1024 = 0.00abcdefg
//                                                 + 0.1100010001 
//                                                 = 0.111(cd)(c xor d)(d')efg1
//10.01000 ~ 10.11111
assign o2[15] = 0;
assign o2[14] = 1;
assign o2[13] = 1;
assign o2[12] = 1;
NR2 an100(o2[11], iv_x[4], iv_x[3], n0);
EO e0(o2[10], EO_x[4], EO_x[3], n1);
assign o2[9] = iv_x[3];
assign o2[8] = EO_x[2];
assign o2[7] = EO_x[1];
assign o2[6] = EO_x[0];
assign o2[5] = 1;
//o3 = 1/32 * ab.cdefg + 1/2 + 1/4 + 1/16 +1/32 + 1/64 = 0.000abcdefg
//                                                     + 0.110111
//                                                     = 0.1111(c)(c')defg
//11.00000 ~ 11.11111
assign o3[15] = 0;
assign o3[14] = 1;
assign o3[13] = 1;
assign o3[12] = 1;
assign o3[11] = 1;
assign o3[10] = EO_x[4];
assign o3[9] = iv_x[4];
assign o3[8] = EO_x[3];
assign o3[7] = EO_x[2];
assign o3[6] = EO_x[1];
assign o3[5] = EO_x[0];
// ctrl0 = (a(b+c+d))'= a'+b'c'd'
wire bcd;
ND3 or1(bcd, iv_x[5], iv_x[4], iv_x[3], n2);
ND2 an1(ctrl0, EO_x[6], bcd, n3);
// ctrl1 = a+b
ND2 or2(ctrl1, iv_x[6], iv_x[5], n4);
// ctrl2 = b
assign ctrl2 = EO_x[5];
// MUX0
RMUX#(.BW(11)) U_RMUX0(.Z(y_positive[15:5]), .A(o5[15:5]), .B(o4[15:5]), .CTRL(ctrl0), .number(nRMUX0));
// MUX1
RMUX#(.BW(11)) U_RMUX1(.Z(o4[15:5]), .A(o0[15:5]), .B(o1[15:5]), .CTRL(ctrl1), .number(nRMUX1));
// MUX2
RMUX#(.BW(11)) U_RMUX2(.Z(o5[15:5]), .A(o2[15:5]), .B(o3[15:5]), .CTRL(ctrl2), .number(nRMUX2));
assign y_positive[4] = 0;
assign y_positive[3] = 0;
assign y_positive[2] = 0;
assign y_positive[1] = 0;
assign y_positive[0] = 0;
// y
assign y[15] = y_positive[15];
REO#(.BW(10)) U_REO1(.Z(y[14:5]), .A(y_positive[14:5]), .B(i_x[7]), .number(nREO1));
assign y[4] = y_positive[4];
assign y[3] = y_positive[3];
assign y[2] = y_positive[2];
assign y[1] = y_positive[1];
assign y[0] = y_positive[0];
//o_y
assign o_y[15] = y[15];
REGP#(.BW(10)) U_REGP(.clk(clk), .rst_n(rst_n), .Q(o_y[14:5]), .D(y[14:5]), .number(nREGP));
assign o_y[4] = y[4];
assign o_y[3] = y[3];
assign o_y[2] = y[2];
assign o_y[1] = y[1];
assign o_y[0] = y[0];
// o_out_valid
FD2 f0(o_out_valid, i_in_valid, clk, rst_n, nf0);
// number
assign number = nREO0 + nRIV + 
n0 + n1 + n2 + n3 + n4 +
nRMUX0 + nRMUX1 + nRMUX2 + nREO1 + nREGP + nf0;
endmodule

//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input           clk,
	input           rst_n,
	output [BW-1:0] Q,
	input  [BW-1:0] D,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

//BW-bit MUX
module RMUX#(
	parameter BW = 2
)(
	output [BW-1:0] Z,
	input  [BW-1:0] A,
	input  [BW-1:0] B,
	input CTRL,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		MUX21H m0(Z[i], A[i], B[i], CTRL, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module REO#(
	parameter BW = 2
)(
	output [BW-1:0] Z,
	input  [BW-1:0] A,
	input B,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		EO e0(Z[i], B, A[i], numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module RIV#(
	parameter BW = 2
)(
	output [BW-1:0] Z,
	input  [BW-1:0] A,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		IV i0(Z[i], A[i], numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule