//-------------------------------------------------------------------------------------------------//
//  File name	: SHA256_Core_Pipeline.v									                       //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based SHA256 Core for Blockchain 				    		   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module sha256_1(
						input 	wire 			CLK,
						input	wire			RST,
						input	wire			write_en,
						input	wire	[511:0]	block_in,
						input	wire	[255:0]	digest_in,
						output	wire	[255:0]	digest_out,
						output  wire            valid_out
);

	
	//////Expander
	
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
	wire 	[31:0]  w15;
	wire 	[31:0]  w16;
	
	reg  [31:0] K;
	wire [31:0] K_i;
	wire [511:0] block_out_wire;
	wire [255:0] digest_out_wire;
	
	reg [255:0] digest_out_reg;
	reg [511:0] block_in_reg;
	reg [6:0] counter_reg;
	reg [255:0] digest_in_reg;
	reg [255:0] digest_initial_reg;
	reg        valid_out_reg;
	
	assign w1 = block_in_reg[511:480];
	assign w2 = block_in_reg[479:448];
	assign w3 = block_in_reg[447:416];
	assign w4 = block_in_reg[415:384];
	assign w5 = block_in_reg[383:352];
	assign w6 = block_in_reg[351:320];
	assign w7 = block_in_reg[319:288];
	assign w8 = block_in_reg[287:256];
	assign w9 = block_in_reg[255:224];
	assign w10 = block_in_reg[223:192];
	assign w11 = block_in_reg[191:160];
	assign w12 = block_in_reg[159:128];
	assign w13 = block_in_reg[127:96];
	assign w14 = block_in_reg[95:64];
	assign w15 = block_in_reg[63:32];
	assign w16 = block_in_reg[31:0];
	
	
	assign d0_256 = {w2[6:0],w2[31:7],w2[6:0],w2[31:7]}^{w2[17:0],w2[31:18],w2[17:0],w2[31:18]}^{3'b000,w2[31:3],3'b000,w2[31:3]};
	assign d1_256 = {w15[16:0],w15[31:17],w15[16:0],w15[31:17]}^{w15[18:0],w15[31:19],w15[18:0],w15[31:19]}^{10'b0000000000,w15[31:10],10'b0000000000,w15[31:10]};

	
	//////

	assign w_i = 	(counter_reg==0) ?   0:
	                (counter_reg==1) ?   w1: 
					(counter_reg==2) ?   w2:
					(counter_reg==3) ?   w3:
					(counter_reg==4) ?   w4:
					(counter_reg==5) ?   w5:
					(counter_reg==6) ?   w6:
					(counter_reg==7) ?   w7:
					(counter_reg==8) ?   w8:
					(counter_reg==9) ?   w9:
					(counter_reg==10) ?   w10:
					(counter_reg==11) ?   w11:
					(counter_reg==12) ?   w12:
					(counter_reg==13) ?   w13:
					(counter_reg==14) ?   w14:
					(counter_reg==15) ?   w15:
					(counter_reg==16) ?   w16: d0_256 + w10 + d1_256 + w1;  

	//////
	assign block_out_wire = {w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w_i};
	

	
	always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			block_in_reg <= 512'b0;
		end
		else begin
			if(write_en == 1'b1 && counter_reg== 0) begin
				block_in_reg <= block_in;
			end
			else if(write_en == 1'b1 && counter_reg > 16) begin
				block_in_reg <= block_out_wire;
			end
			else begin
				block_in_reg <= block_in_reg;
			end
		end
	end
	
	///// Compressor
	
	
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
	
	assign a = digest_in_reg[255:224];
	assign b = digest_in_reg[223:192];
	assign c = digest_in_reg[191:160];
	assign d = digest_in_reg[159:128];
	assign e = digest_in_reg[127:96];
	assign f = digest_in_reg[95:64];
	assign g = digest_in_reg[63:32];
	assign h = digest_in_reg[31:0];
	
	/////////
	
	assign sum_1 = {e[5:0],e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};
	assign sum_0 = {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
	assign ch    = (e & f) ^ ((~e) & g);
	assign maj	 = (a & b) ^ (a & c) ^ (b & c);
	
	/////////
	
	assign T1 = h + sum_1 + ch + K_i + w_i;
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

	assign digest_out_wire = (counter_reg ==0)?0:{updated_a,updated_b,updated_c,updated_d,updated_e,updated_f,updated_g,updated_h};
	

	
  	always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			counter_reg <= 6'b0;
			valid_out_reg <= 1'b0;
			digest_out_reg <= 256'b0;
		end
		else begin
			if(write_en == 1'b1 && counter_reg == 65) begin
                        counter_reg <= 0;
                        valid_out_reg <= 1'b1;
						digest_out_reg[255:224] <=  digest_initial_reg[255:224] +a;
						digest_out_reg[223:192] <= digest_initial_reg[223:192] + b;
						digest_out_reg[191:160] <= digest_initial_reg[191:160] + c;
						digest_out_reg[159:128] <= digest_initial_reg[159:128] + d;
						digest_out_reg[127:96] <= digest_initial_reg[127:96] + e;
						digest_out_reg[95:64] <= digest_initial_reg[95:64] + f;
						digest_out_reg[63:32] <= digest_initial_reg[63:32] + g;
						digest_out_reg[31:0] <= digest_initial_reg[31:0] + h;
					
            end
			else if(write_en == 1'b1) begin
				counter_reg <= counter_reg + 1;
				valid_out_reg <= 1'b0;
				digest_out_reg <= digest_out_reg;
			end
            else begin
                counter_reg <= 0;
                valid_out_reg <= valid_out_reg;
                digest_out_reg <= digest_out_reg;
            end
		end
	end
	
    assign valid_out = valid_out_reg;
    assign digest_out = digest_out_reg;
	
	always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			digest_in_reg <= 256'b0;
			digest_initial_reg<= 256'b0;
		end
		else begin
			if(write_en == 1'b1 && counter_reg== 0) begin
				digest_in_reg <= digest_in;
				digest_initial_reg<= digest_in;
			end
			else begin
				digest_in_reg <= digest_out_wire;
			end
		end
	end
	

	
	assign K_i = (counter_reg==0)? 0: K;
	
	always @*

    begin 

      case(counter_reg-1)

        00: K = 32'h428a2f98;
        01: K = 32'h71374491;
        02: K = 32'hb5c0fbcf;
        03: K = 32'he9b5dba5;
        04: K = 32'h3956c25b;
        05: K = 32'h59f111f1;
        06: K = 32'h923f82a4;
        07: K = 32'hab1c5ed5;
        08: K = 32'hd807aa98;
        09: K = 32'h12835b01;
        10: K = 32'h243185be;
        11: K = 32'h550c7dc3;
        12: K = 32'h72be5d74;
        13: K = 32'h80deb1fe;
        14: K = 32'h9bdc06a7;
        15: K = 32'hc19bf174;
        16: K = 32'he49b69c1;
        17: K = 32'hefbe4786;
        18: K = 32'h0fc19dc6;
        19: K = 32'h240ca1cc;
        20: K = 32'h2de92c6f;
        21: K = 32'h4a7484aa;
        22: K = 32'h5cb0a9dc;
        23: K = 32'h76f988da;
        24: K = 32'h983e5152;
        25: K = 32'ha831c66d;
        26: K = 32'hb00327c8;
        27: K = 32'hbf597fc7;
        28: K = 32'hc6e00bf3;
        29: K = 32'hd5a79147;
        30: K = 32'h06ca6351;
        31: K = 32'h14292967;
        32: K = 32'h27b70a85;
        33: K = 32'h2e1b2138;
        34: K = 32'h4d2c6dfc;
        35: K = 32'h53380d13;
        36: K = 32'h650a7354;
        37: K = 32'h766a0abb;
        38: K = 32'h81c2c92e;
        39: K = 32'h92722c85;
        40: K = 32'ha2bfe8a1;
        41: K = 32'ha81a664b;
        42: K = 32'hc24b8b70;
        43: K = 32'hc76c51a3;
        44: K = 32'hd192e819;
        45: K = 32'hd6990624;
        46: K = 32'hf40e3585;
        47: K = 32'h106aa070;
        48: K = 32'h19a4c116;
        49: K = 32'h1e376c08;
        50: K = 32'h2748774c;
        51: K = 32'h34b0bcb5;
        52: K = 32'h391c0cb3;
        53: K = 32'h4ed8aa4a;
        54: K = 32'h5b9cca4f;
        55: K = 32'h682e6ff3;
        56: K = 32'h748f82ee;
        57: K = 32'h78a5636f;
        58: K = 32'h84c87814;
        59: K = 32'h8cc70208;
        60: K = 32'h90befffa;
        61: K = 32'ha4506ceb;
        62: K = 32'hbef9a3f7;
        63: K = 32'hc67178f2;
		
      endcase
    end




endmodule
