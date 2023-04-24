
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE10_LITE_SDRAM_RTL_Test(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire  [15:0]  writedata;
wire  [15:0]  readdata;
wire          write;
wire          read;
wire          clk_test;

wire  test_software_reset_n;
wire  test_global_reset_n;
wire  test_start_n;

wire  sdram_test_pass;
wire  sdram_test_fail;
wire  sdram_test_complete;



//=======================================================
//  Structural coding
//=======================================================

//	SDRAM frame buffer
Sdram_Control	u1	(	//	HOST Side
						   .REF_CLK(MAX10_CLK1_50),
					      .RESET_N(test_software_reset_n),
							//	FIFO Write Side 
						   .WR_DATA(writedata),
							.WR(write),
							.WR_ADDR(0),
							.WR_MAX_ADDR(25'h1ffffff),		//	
							.WR_LENGTH(9'h80),
							.WR_LOAD(!test_global_reset_n ),
							.WR_CLK(clk_test),
							//	FIFO Read Side 
						   .RD_DATA(readdata),
				        	.RD(read),
				        	.RD_ADDR(0),			//	Read odd field and bypess blanking
							.RD_MAX_ADDR(25'h1ffffff),
							.RD_LENGTH(9'h80),
				        	.RD_LOAD(!test_global_reset_n ),
							.RD_CLK(clk_test),
                     //	SDRAM Side
						   .SA(DRAM_ADDR),
						   .BA(DRAM_BA),
						   .CS_N(DRAM_CS_N),
						   .CKE(DRAM_CKE),
						   .RAS_N(DRAM_RAS_N),
				         .CAS_N(DRAM_CAS_N),
				         .WE_N(DRAM_WE_N),
						   .DQ(DRAM_DQ),
				         .DQM({DRAM_UDQM,DRAM_LDQM}),
							.SDR_CLK(DRAM_CLK)	);


pll_test u2(
	.areset(),
	.inclk0(MAX10_CLK2_50),
	.c0(clk_test),
	.locked());

	
	
 RW_Test u3(
      .iCLK(clk_test),
		.iRST_n(test_software_reset_n),
		.iBUTTON(test_start_n),
      .write(write),
		.writedata(writedata),
	   .read(read),
		.readdata(readdata),
      .drv_status_pass(sdram_test_pass),
		.drv_status_fail(sdram_test_fail),
		.drv_status_test_complete(sdram_test_complete)
		
);			
	
	
	

endmodule