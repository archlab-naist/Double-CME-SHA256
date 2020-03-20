//-------------------------------------------------------------------------------------------------//
//  File name	: Main_Loop_Pipeline.v									                           //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based Main Loop for SHA 256                                   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module main_loop_for_pipeline_4to63(
								input 	wire 			CLK,
								input	wire			RST,
								input	wire			write_en,
								input	wire	[31:0]	k_i,
								input	wire	[255:0]	digest_in,
								input	wire	[31:0]	w_i,
								output	wire	[255:0]	digest_out
);	
	wire 	[255:0] digest_out_wire;
	
	wire 	[31:0]  a;
	wire 	[31:0]  b;
	wire 	[31:0]  c;
	wire 	[31:0]  d;
	wire 	[31:0]  e;
	wire 	[31:0]  f;
	wire 	[31:0]  g;
	wire 	[31:0]  h;
	
	wire 	[31:0]  updated_a;
	wire 	[31:0]  updated_b;
	wire 	[31:0]  updated_c;
	wire 	[31:0]  updated_d;
	wire 	[31:0]  updated_e;
	wire 	[31:0]  updated_f;
	wire 	[31:0]  updated_g;
	wire 	[31:0]  updated_h;
	
	wire 	[31:0]  sum_0;
	wire 	[31:0]  sum_1;
	wire	[31:0]  ch;
	wire	[31:0]  maj;
	wire	[31:0]  T1;
	wire	[31:0]  T2;

	
	mem_save_digest mem_d_2 (
		.CLK(CLK),
		.RST(RST),
		.write_en(write_en),
		.digest_in(digest_out_wire),
		.digest_out(digest_out)
	);
	
////////

	assign a = digest_in[255:224];
	assign b = digest_in[223:192];
	assign c = digest_in[191:160];
	assign d = digest_in[159:128];
	assign e = digest_in[127:96];
	assign f = digest_in[95:64];
	assign g = digest_in[63:32];
	assign h = digest_in[31:0];
	
/////////

	assign sum_1 = {e[5:0],e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};
	assign sum_0 = {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
	assign ch    = (e & f) ^ ((~e) & g);
	assign maj	 = (a & b) ^ (a & c) ^ (b & c);
		
/////////
	
	assign T1 = h + sum_1 + ch + k_i + w_i;
	assign T2 = sum_0 + maj;  

/////////
	assign updated_a = T1 + T2;  
	assign updated_e = d + T1;  
	assign updated_b = a;
	assign updated_c = b;
	assign updated_d = c;
	assign updated_f = e;
	assign updated_g = f;
	assign updated_h = g;

////////

	assign digest_out_wire = {updated_a,updated_b,updated_c,updated_d,updated_e,updated_f,updated_g,updated_h};

endmodule
