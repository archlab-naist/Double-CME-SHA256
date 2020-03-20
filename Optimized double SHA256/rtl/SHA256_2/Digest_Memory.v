//-------------------------------------------------------------------------------------------------//
//  File name	: Digest_Memory.v									                               //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Digest Memory for SHA256 			    		                                   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module mem_save_digest(
						input	wire				CLK,
						input	wire				RST,
						input	wire				write_en,
						input	wire 	[255:0]		digest_in,
						output	wire	[255:0]		digest_out
						);

	reg [255:0] digest_out_reg;
	
	assign digest_out = digest_out_reg;
	always @(posedge CLK or negedge RST) 
	begin: update_event
		if(RST == 1'b0) begin
			digest_out_reg <= 256'b0;
		end
		else begin
			if(write_en == 1'b1) begin
				digest_out_reg <= digest_in;
			end
		end
	end
endmodule
