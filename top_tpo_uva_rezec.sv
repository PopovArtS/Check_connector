module top_tpo_uva_rezec
#(
	parameter CLK_1_MHz = 1,
	parameter KOEF_T = 250_000,
	parameter Kol_sign = 8
)
(
	input pin_FPGA_CLK,
	
	input		KONTR1,
	input		KONTR2,
	input		KONTR_DM,
	input		TEMP_UK,
	input		E_VSK,
	input		DATA_VSK,
	
	//for diods
	output		F_PLD_LED1,
	output		F_PLD_LED2,
	output		F_PLD_LED3,
	output		F_PLD_LED4,	
	output		F_PLD_LED5,
	output		F_PLD_LED6,	
	output		F_PLD_LED7,
	output		F_PLD_LED8,	
	
	
	//end diods
	
	//LVDS
	output		IZP1_UK,
	output		IZP2_UK,
	output		IZP,
	output		IM,
	
	//TTL
	output		IM_UK,
	output		VKL_VSK_PRM,
	output		VKL_VSK_PRD,
	output		VKL_VKS


);

logic [7: 0] TEST_out_signal;

pll_50MHz pll_inst
(
	.inclk0 (pin_FPGA_CLK),
	.c0 	  (clk_1MHz)

);
	
//defparam TEST_inst.WIDTH = 8;
genvar i;
generate
	for (i = 0; i < 8; i = i + 1) 
	begin : generator
		pulse_gen_tim TEST_inst
		(
			.clk			(clk_1MHz),		// input  clk_sig
			.enable			(1),			// input  enable_sig
			.reset			(0),		// input  reset_sig
			.delay_in		(0),			// input [WIDTH-1:0] delay_in_sig
			.duration_in	(CLK_1_MHz * ((i + 1) * KOEF_T) * 4),	// input [WIDTH-1:0] duration_in_sig
			.T_in			(CLK_1_MHz * ((i + 1) * KOEF_T)),		// input [WIDTH-1:0] T_in_sig	
			.out_signal		(TEST_out_signal[i]) 	// output  out_signal_sig
		);		
		
	end
endgenerate

assign IZP1_UK 	= TEST_out_signal [0];
assign IZP2_UK 	= TEST_out_signal [1];
assign IZP 		= TEST_out_signal [2];
assign IM 		= TEST_out_signal [3];

assign IM_UK		= TEST_out_signal [4];
assign VKL_VSK_PRM	= TEST_out_signal [5];
assign VKL_VSK_PRD	= TEST_out_signal [6];
assign VKL_VKS		= TEST_out_signal [7];

assign F_PLD_LED1 = KONTR1;
assign F_PLD_LED2 = KONTR2;
assign F_PLD_LED3 = KONTR_DM;
assign F_PLD_LED4 = TEMP_UK;
assign F_PLD_LED5 = E_VSK;
assign F_PLD_LED6 = DATA_VSK;



endmodule