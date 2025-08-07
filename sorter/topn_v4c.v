// Philippos Papaphilippou

`define N 16 // sorter size
`define Width 8

//Modes
`define IDLE 0
`define DESCENDING 1
`define ASCENDING  2
`define FLUSH 3


module Topn_module(clk, nreset, invalidate, mode, data_new, data_new_delayed, shift_in, data_in, valid_in, was_valid_in, shift_out, data_out, valid_out, was_valid_out);

	input clk, nreset, invalidate;
	input [1:0] mode;
	input[`Width-1:0] data_new;
	input[`Width-1:0] data_new_delayed;
	
	input shift_in;	
	input[`Width-1:0] data_in;
	input valid_in;
	input was_valid_in;
	
	output reg shift_out;
	output reg[`Width-1:0] data_out;
	output reg valid_out;
	output reg was_valid_out;

	reg bubble;
	reg pending_flush;
		
	reg [`Width-1:0] current_local;
	reg valid_local;	
	
	always @(posedge clk) begin
	
		if (!nreset) begin
				valid_out<=0;
				was_valid_out<=0;
		
				shift_out<=0;
				valid_local<=0;
				bubble=0;
				pending_flush=0;
				
		end else begin		

			if (invalidate)	begin
				was_valid_out<=valid_out;
			end
			
			current_local=data_out;
			valid_out <= valid_out & !invalidate/*d*/;// & (bubble==0);		
			
			if ((shift_out==1) /*&& (bubble==0)*/) begin 
				
				if ((shift_in==1)) begin
					if ((valid_in==1)/*|invalidated*//*& !invalidated*//*|| (mode==`FLUSH)*/) begin	
						current_local = data_in;
						valid_local = valid_in;//1
						//invalidated=0;
						data_out <= data_in;
						was_valid_out <= invalidate;//was_valid_in;//0
						valid_out <= !invalidate;
						//if(data_in==32'h250)
						//$display("%h %h %h",current_local, data_in, invalidated);
						/*if ((valid_in==0)&&(valid_out==1)) begin 
							bubble<=1;
						end*/
					end	else begin
						valid_local = 0;						
						data_out <= data_in;
						valid_out <= valid_in;
						was_valid_out <= was_valid_in;						
					end				
				end	else begin			 
					current_local = data_new_delayed;
					valid_local = !invalidate/*d*/;//1
					//invalidated=0;
					was_valid_out <=invalidate;//;0;
					data_out <= data_new_delayed;
					//if(data_new_delayed==32'h250)
					//	$display("%h %h",current_local, data_new_delayed, invalidated);
					valid_out <= /*1 &*/ /*(mode!=`FLUSH) &??? just removed*/ !invalidate/*d*/;// nreset;
				end										
			end	else begin
				if (pending_flush|(valid_out==0)) begin
					data_out <= data_in;
					
					valid_out <= valid_in;
					was_valid_out <= was_valid_in;
					if ((valid_in==0) && (valid_out==1) && (was_valid_out==0)) begin 
						bubble=1;					
						//$display("%h", data_out);
						//shift_out<=0;
					end	
					current_local=data_in;
					valid_local=valid_in;
						
					if ((valid_in==1) && (valid_out==0) /*&& (was_valid_out==1)*/ && (!pending_flush)) begin
						valid_out <=0;
						valid_local=0;
						if (data_in==32'h11 && data_out==32'h979)
						$display("%h %h %h",valid_in, valid_out, was_valid_out);
					end		
				end else begin 
					valid_local=valid_out;
				end
				
				//valid_local=valid_out;	
				//$display("WHAAAAT?");
			end			
		

			if (((mode==`ASCENDING)|(mode==`DESCENDING)) && (bubble==0) /*&&(was_valid_out==0)&& !invalidate*/) begin				
				if (valid_local && !invalidate/*nreset !invalidated*/ ) begin																		
					shift_out <= /*invalidated|*/((mode==`ASCENDING) & (data_new<=current_local)) | ((mode==`DESCENDING) & (data_new>=current_local));
				end else begin					
					shift_out <=1;//!bubble;//1;
				end					
			end else begin
				shift_out <=0;

			end
			pending_flush<=(mode==`FLUSH);			
		end				
	end
		
endmodule //Topn_module

module sorter(clk, rst, flush, data_i, data_i_v, data_o, data_o_v);
	input clk, rst, flush;
	//input [1:0] mode;
	input [`Width-1:0] data_i;
	input data_i_v;
	output reg [`Width-1:0] data_o;
	output data_o_v;

	wire [`Width-1:0] data_out[`N-1:0];
	wire shift_out[`N-1:0];
	wire valid_out[`N-1:0];
	wire was_valid_out[`N-1:0];
		
	reg[`Width-1:0] data_new_delayed;
	
	assign data_o_v=(was_valid_out[`N-1]);//|valid_out[`N-1]);
	
	wire [1:0] mode = data_i_v?`DESCENDING:`IDLE;
		
	always @(mode, valid_out[`N-1],was_valid_out[`N-1], data_out[`N-1], shift_out[`N-1], data_i) begin
		if (was_valid_out[`N-1]|shift_out[`N-1]|(mode==`FLUSH))
			data_o=data_out[`N-1];
		else
			data_o=data_i;				
	end

	genvar i;
	
	//reg [1:0] mode=data_i_v?`DESCENDING:`IDLE;

	generate
		Topn_module module0(clk, !rst, flush, mode, data_i, data_new_delayed, 1'b0, 0, 1'b0, 1'b0, shift_out[0], data_out[0], valid_out[0], was_valid_out[0]);
    	for (i=1; i<`N; i=i+1) begin
        	Topn_module modules(clk, !rst, flush, mode, data_i, data_new_delayed, shift_out[i-1], data_out[i-1], valid_out[i-1], was_valid_out[i-1], shift_out[i], data_out[i], valid_out[i], was_valid_out[i]);
    	end
	endgenerate
	
	always @(posedge clk) begin
		if (data_i_v)
			data_new_delayed <= data_i;		
	end

endmodule


module Top_Level();
	reg clk, flush, valid, rst;
	//reg [1:0] mode;
	reg [`Width-1:0] data_new;
	
	wire [`Width-1:0] data_o;
	wire data_o_v;

	sorter s (clk, rst, flush, data_new, valid, data_o, data_o_v);
	
	always @(posedge clk) begin
		if (data_o_v) begin
			$display(data_o);
		end		
	end
	
	
integer k;
	initial begin

		flush=0;
		rst=1;
		valid=0;
		//mode=`IDLE;

		
		clk=1; #10 clk=0; #10 
		valid=1;
		rst=0;
		//reset=0;
		//mode=	`DESCENDING;//`ASCENDING; //
		
		k=1;//`N;		
		repeat(`N)
		begin
			data_new=(k*97)%13;//`N-k;//
			$display("inserting ",data_new);
		    clk=1; #10 clk=0; #10 

		    
		    k=k+1;
		end
		//k=1;//`N;
		
		//data_new=-1;
		valid=0;
		//mode=`IDLE;
		flush=1;
				
		
		k=k+1;
		repeat(`N*2)
		begin
			clk=1; #10 clk=0; #10 ;
		end
		
		$display("End of Testbench\n");

		
	end
endmodule //Top_Level
