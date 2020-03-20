 //-------------------------------------------------------------------------------------------------//
//  File name	: SHA256_Memory_Pipeline.v									                       //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based SHA512 Memory for Blockchain 			    		   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module sha256_w_mem_for_pipeline_30_3(
									input 	wire			CLK,
									input	wire			RST,
									input	wire			write_en,
									input	wire	[447:0] block_in,
									output	wire	[479:0] block_out
);
	wire [479:0] block_out_wire;
	
	mem_save_block_480 mem_b(
							.CLK(CLK),
							.RST(RST),
							.write_en(write_en),
							.block_in(block_out_wire),
							.block_out(block_out)
	);
	
	parameter [31:0] w15_const = 32'h00000100;
	
	wire [31:0] d0_256;
	wire [31:0] d1_256;
	
	wire 	[31:0]  w_i;
	
	wire 	[31:0]  w1;
	wire 	[31:0]  w2;
	wire 	[31:0]  w3;
	wire 	[31:0]  w4;
	wire 	[31:0]  w5;
	wire 	[31:0]  w6;
	wire 	[31:0]  w7;
	wire 	[31:0]  w8;
	wire 	[31:0]  w9;
	wire 	[31:0]  w10;
	wire 	[31:0]  w11;
	wire 	[31:0]  w12;
	wire 	[31:0]  w13;
	wire 	[31:0]  w14;
	
	assign w1 = block_in[447:416];
	assign w2 = block_in[415:384];
	assign w3 = block_in[383:352];
	assign w4 = block_in[351:320];
	assign w5 = block_in[319:288];
	assign w6 = block_in[287:256];
	assign w7 = block_in[255:224];
	assign w8 = block_in[223:192];
	assign w9 = block_in[191:160];
	assign w10 = block_in[159:128];
	assign w11 = block_in[127:96];
	assign w12 = block_in[95:64];
	assign w13 = block_in[63:32];
	assign w14 = block_in[31:0];
	
	
	assign d0_256 = {w15_const[6:0],w15_const[31:7],w15_const[6:0],w15_const[31:7]}^{w15_const[17:0],w15_const[31:18],w15_const[17:0],w15_const[31:18]}^{3'b000,w15_const[31:3],3'b000,w15_const[31:3]};
	assign d1_256 = {w13[16:0],w13[31:17],w13[16:0],w13[31:17]}^{w13[18:0],w13[31:19],w13[18:0],w13[31:19]}^{10'b0000000000,w13[31:10],10'b0000000000,w13[31:10]};

	
//////

	assign w_i = d1_256 + d0_256 + w8;  

//////
	assign block_out_wire = {w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w_i};
	
endmodule
