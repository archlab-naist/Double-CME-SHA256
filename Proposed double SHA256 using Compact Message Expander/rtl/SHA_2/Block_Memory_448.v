//-------------------------------------------------------------------------------------------------//
//  File name	: Block_Memory.v									                               //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Block Memory for SHA256 			    		                                   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module mem_save_block_448(
						input	wire				CLK,
						input	wire				RST,
						input	wire				write_en,
						input	wire 	[447:0]		block_in,
						output	wire	[447:0]		block_out
						);

	reg [447:0] block_out_reg;
	
	assign block_out = block_out_reg;
	always @(posedge CLK or negedge RST) 
	begin: update_event
		if(RST == 1'b0) begin
			block_out_reg <= 448'b0;
		end
		else begin
			if(write_en == 1'b1) begin
				block_out_reg <= block_in;
			end
		end
	end
endmodule
