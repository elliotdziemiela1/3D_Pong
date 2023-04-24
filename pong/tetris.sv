//
//	// SDRAM Wire Declaractions
//	logic pll_clk;
//	logic write;
//	logic read;
//	logic [15:0] writedata;
//	logic [15:0] readdata;
//	logic [15:0] writeaddr;
//	logic [15:0] readaddr;
//	logic writeld;
//	logic readld;
module tetris ( input clk,
					 input vs, hs,
					 input reset,
					 input [9:0] DrawX, DrawY,
					 input wr_full, rd_empty,
					 input logic [15:0] readdata,
					 output logic write, read,
					 output logic [24:0] writeaddr, readaddr,
					 output logic [15:0] writedata,
					 output [7:0] Red, Green, Blue,
					 output [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0
					 );

// Local Declarations					 
logic [15:0] read_reg1;
logic [15:0] read_reg2;
					 
// State machine for writing to VRAM					 
enum logic [15:0] {Hold, PR1, PR2, WA, WAF, WB, WBF, WC, WCF, WD, WDF, RA, RB, RC, RD} state;

// State machine logic with reset for correct default values of regs
always_ff @(posedge clk or posedge reset)
begin
	if(reset)
		begin	// Default values
		read <= 1'b0;
		readaddr <= 25'b0;
		write <= 1'b0;
		writeaddr <= 25'b0;
		writedata <= 16'b0;
		state <= Hold;
		end
	else
		begin
		unique case (state)
			Hold: if(vs)
						state <= WA; // Perform writes on vertical sync
					else if (DrawX == 10'b0 && DrawY == 10'b0)
						state <= PR1; // Perform reads at top left (For now)
			// Start of the writes
			WA: begin
					 write <= 1'b1; // Send a write request with addr and data
					 writeaddr <= 25'h00;
					 writedata <= 16'h00; 
					 state <= WAF;
				 end
			WAF: begin
					 write <= 1'b0; // Finish write request
					 if(!wr_full) // Checks for the write buffer not being full
							state <= WB; // Go to next write once write buffer empties
				  end
			WB: begin
					 write <= 1'b1; // Send a write request with addr and data
					 writeaddr <= 25'h01; 
					 writedata <= 16'h01;
					 state <= WBF;
				 end
			WBF: begin
					 write <= 1'b0; // Finish write request
					 if(!wr_full)
							state <= WC; // Go to next write once write buffer empties
				  end
			WC: begin
					 write <= 1'b1; // Similar logic to previous writes
					 writeaddr <= 25'h02;
					 writedata <= 16'h02;
					 state <= WCF;
				 end
			WCF: begin
					 write <= 1'b0;
					 if(!wr_full)
							state <= WD;
				  end
			WD: begin
					 write <= 1'b1;
					 writeaddr <= 25'h03; 
					 writedata <= 16'h03;
					 state <= WDF;
				 end
			WDF: begin
					 write <= 1'b0;
					 if(!wr_full)
							state <= Hold;
				 end
			// Start of the reads
			PR1: begin
				  read <= 1'b1; // Send a read request with addr
				  readaddr <= 25'h03;
				  state <= RA;
				  end
			RA:  begin
				  read <= 1'b0; // Finish read request
				  if(!rd_empty)
						begin
						read_reg1 <= readdata; // Capture read data and go to next read
						state <= PR2;
						end
				  end
			PR2: begin
				  read <= 1'b1; // Similar logic to previous read
				  readaddr <= 25'h04;
				  state <= RB;
				  end
			RB:  begin
				  read <= 1'b0;
				  if(!rd_empty)
						begin
						read_reg2 <= readdata;
						state <= Hold;
						end
				  end
			default: ;
			endcase
		end	
end
		 
// Output read registers to the hex displays
always_comb
begin
	hex_num_0 = read_reg1[3:0];
	hex_num_3 = read_reg2[3:0];
end

// BlockX and BlockY assumed to be position of block		 
// Color mapper will decide when to write colors of block to vram					 
//color_mapper colormap (.towrite(writeld), .color(writedata) );



endmodule
