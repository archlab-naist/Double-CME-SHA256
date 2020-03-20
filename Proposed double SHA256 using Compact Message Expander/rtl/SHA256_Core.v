//-------------------------------------------------------------------------------------------------//
//  File name	: SHA512_Core_Pipeline.v									                       //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based SHA256 Core for Blockchain 				    		   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module sha256_core(
						input 	wire 			CLK,
						input	wire			RST,
						input	wire			write_1_en,
						input	wire			write_2_en,
						input	wire			write_3_en,
						input	wire			block_in_1_en,
						input	wire			block_in_2_en,
						input	wire	[255:0]	digest_in,
						input	wire	[511:0] block_in,
						output	wire	[255:0]	digest_out,
						output  wire            valid_1_out,
						output  wire            valid_2_out,
						output  wire            valid_3_out
);
	reg [511:0] block_in_1_reg;
	reg [127:0] block_in_2_reg;
	
	wire [255:0] digest_out_1;
	wire [255:0] digest_out_2;
	wire [255:0] digest_out_3;
	
	reg [255:0] block_in_3_reg;
	reg 		write_1_en_reg;
	always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			block_in_1_reg <= 512'b0;
			block_in_2_reg <= 128'b0;
			write_1_en_reg<=1'b0;
		end
		else begin
			write_1_en_reg<=write_1_en;
			if(block_in_2_en) begin
				block_in_2_reg <= block_in[511:384];
			end 
			else if(block_in_1_en) begin
				block_in_1_reg <= block_in;
			end 
			else begin
				block_in_1_reg <= block_in_1_reg;
				block_in_2_reg <= block_in_2_reg;
			end
		end
	end
	
	always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			block_in_3_reg <= 512'b0;
		end
		else begin
			if(valid_2_out) begin
				block_in_3_reg <= digest_out_3;
			end 
			else begin
				block_in_3_reg <= block_in_3_reg;
			end
		end
	end
	
	sha256 SHA1(.CLK(CLK),.RST(RST),.write_en(write_1_en_reg),.block_in({block_in_1_reg,block_in_2_reg}),.digest_in(digest_in),.digest_out_1(digest_out_1),.digest_out_2(digest_out_2),.valid_out(valid_1_out));
	sha256_2_pipeline SHA2(.CLK(CLK),.RST(RST),.write_en(write_2_en),.block_in(block_in_2_reg),.digest_intial(digest_out_1),.digest_in(digest_out_2),.digest_out(digest_out_3),.valid_out(valid_2_out));
	sha256_3_pipeline SHA3(.CLK(CLK),.RST(RST),.write_en(write_3_en),.block_in(block_in_3_reg),.digest_in(digest_in),.digest_out(digest_out),.valid_out(valid_3_out));

endmodule
