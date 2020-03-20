 //-------------------------------------------------------------------------------------------------//
//  File name	: SHA256_Memory_Pipeline.v									                       //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based SHA512 Memory for Blockchain 			    		   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module sha256_w_mem_for_pipeline_19_2(
									input 	wire			CLK,
									input	wire			RST,
									input	wire			write_en,
									input	wire	[127:0] block_in,
									output	wire	[127:0] block_out
);
	wire [127:0] block_out_wire;
	
	mem_save_block_128 mem_b(
							.CLK(CLK),
							.RST(RST),
							.write_en(write_en),
							.block_in(block_out_wire),
							.block_out(block_out)
	);
	
	parameter [31:0] w4_const = 32'h80000000;
	
	wire [31:0] d0_256;
	wire [31:0] d1_256;
	
	wire 	[31:0]  w_i;
	
	wire 	[31:0]  w1;
	wire 	[31:0]  w2;
	wire 	[31:0]  w3;
	wire 	[31:0]  w4;
	
	assign w1 = block_in[127:96];
	assign w2 = block_in[95:64];
	assign w3 = block_in[63:32];
	assign w4 = block_in[31:0];
	
	
	assign d0_256 = {w4_const[6:0],w4_const[31:7],w4_const[6:0],w4_const[31:7]}^{w4_const[17:0],w4_const[31:18],w4_const[17:0],w4_const[31:18]}^{3'b000,w4_const[31:3],3'b000,w4_const[31:3]};
	assign d1_256 = {w3[16:0],w3[31:17],w3[16:0],w3[31:17]}^{w3[18:0],w3[31:19],w3[18:0],w3[31:19]}^{10'b0000000000,w3[31:10],10'b0000000000,w3[31:10]};

	
//////

	assign w_i = d0_256 + d1_256 + w1;  

//////
	assign block_out_wire = {w2,w3,w4,w_i};
	
endmodule
