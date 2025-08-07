// Template for custom instruction 
// (just increments by 1, no pipeline, with busy signal)

module C3_custom_instruction (clk, reset, 
	in_v, rd, in_data,
	out_v, out_rd, out_data, busy);
	
	input clk, reset;	
	input in_v;
	input [4:0] rd;
	input [32-1:0] in_data;
		
	output reg out_v;
	output reg [4:0] out_rd;
	output reg [32-1:0] out_data;
	output busy;
	 
	assign busy = 0;
	
	////// USER CODE HERE //////	
	always @(posedge clk) begin
		if (reset) begin
			out_v<=0; out_rd<=0; out_data<=0;
		end else begin
			out_v<=0;
			if (in_v) begin
				out_v<=1;
				out_rd<=rd;
				out_data<=in_data+1;
			end				
		end
	end
			
endmodule // C3_custom_instruction


