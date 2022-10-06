module pulse_gen_tim
#(parameter WIDTH=25)
 
(
	input clk, enable, reset,
	input tim, //для перенаса к концу строба АЦП
	input [WIDTH-1:0] delay_in,
	input [WIDTH-1:0] duration_in,
	input [WIDTH-1:0] T_in,	
	output reg out_signal=0
);

//	reg[WIDTH-1:0] count=0;//счетчик	
	reg [7:0] count [3:0];
	reg[31:0] value; 
	
	reg		state=0;
	localparam S0 = 1'b0, S1 = 1'b1;
	reg [31:0] duration=0;
	reg [31:0] pulse_time=0;
	reg [31:0] delay=0;
	reg[20:0] count_tim=0;//счетчик
	
	reg equality_delay;
	reg equality_time;
	reg equality_dur;
	reg equality_zero;
	
	reg cout1=0;
	reg cout2=0;
	reg cout3=0;
always @ (posedge clk )//or posedge reset
begin		
	if (reset) begin
		out_signal<=1'b0;
		state <= S0;end			
	else begin
		case (state)
			S0:begin
			  count[0] <= 8'd0;
			  count[1]    <= 8'd0;
			  count[2]    <= 8'd0;
			  count[3]    <= 8'd0; 
			  
			if(tim)count_tim<=count_tim+1'b1;
			else if (enable) begin
//					count_tim_zad<=count_tim;
				state <= S1;						
			end						


				
			end 
			
			S1:begin
		
				if (equality_delay)
					out_signal<=1'b1;					
						
				if (equality_time)
					out_signal<=1'b0;	
			
				
				if (equality_dur)					
				begin
					out_signal<=1'b0;
					state <= S0;
					count_tim<=21'd0;						
				end
						  
			  count[0] <= count[0] + 8'd1;  
			end				
			default:state <= S0;
			endcase
			
			if(cout1)count[1]  <=count[1]+8'd1;
			if(cout2&&cout1)count[2]  <= count[2]+8'd1;
			if(cout3&&cout2&&cout1)count[3] <= count[3]+8'd1;	
			
	end	
end
	
	
always @ (posedge clk )begin			
	 equality_time<=value==pulse_time;
	 equality_delay<=value==delay;
	 equality_dur<=(value>=duration);			
	if(state==S0)	begin						 
		 pulse_time<=T_in;	 
		 delay<=delay_in;	
	end 
	 
	if(count_tim>duration_in)
		duration<=duration_in;
	else duration<=duration_in-count_tim;
	 
	 cout1<=(count[0]==8'hfe);				  
	 cout2<=&count[1];//(==8'hff)
	 cout3<=&count[2];//(count[2]==8'hff)					 

	 value[(7):(0)] <= count[0];
	 value[(15):(8)] <= count[1];
	 value[(23):(16)] <= count[2];
	 value[(31):(24)] <= count[3];
end
endmodule




					
	//(value[7:0]== pulse_time[7:0])&&(value[15:8]== pulse_time[15:8])&&(value[23:16]== pulse_time[23:16])&&(value[31:24]== pulse_time[31:24]);	
	//(value[7:0]==delay[7:0])&&(value[15:8]==delay[15:8])&&(value[23:16]==delay[23:16])&&(value[31:24]==delay[31:24]);
	//(value[7:0]== duration[7:0])&&(value[15:8]== duration[15:8])&&(value[23:16]== duration[23:16])&&(duration[31:24]== duration[31:24]);