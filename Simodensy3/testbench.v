
`define StackPointer 32'h000ffff0

// Use the StartAddress to set the start address of the binary
`define StartAddress 32'h000102ec

// Use BINARY to set the path of the binary for simulation
`define BINARY "firmware.bin"

`include "system.v"

`define BMEM_capacity 16*16*16*16*16
`define ReadLatency 5
`define WriteLatency 10 // must be > `DL2subblocks


module MemoryD3 (clk, reset, addr, en, we, din, dout, dready, accR, accW);
	input clk, reset;
	input [`DADDR_bits-1:0] addr;	
    input en;
    input we;    
    input [`DL2block-1:0] din;
    output reg [`DL2block-1:0] dout;
    output reg dready;
    output wire accR;
    output wire accW;
    
    //(* ram_style = "block" *) 
    reg [`DL2block-1:0] block_ram [`BMEM_capacity/(`DL2block/8)-1:0];
    reg [`DL2block-1:0] rdata;


	always @( posedge clk ) begin		
		if (we) begin
			block_ram[addr>>(`DL2block_Log2-3)]<=din;
			//if(i==0) 
			if (`DEB)  $display("DRAMstore %h at waddr %h w %h",din, addr);
		end else begin            
			rdata<=block_ram[addr>>(`DL2block_Log2-3)];
			if(en) if (`DEB)  $display("DRAMload %h from raddr %h index",block_ram[addr>>(`DL2block_Log2-3)], (addr>>(`DL2block_Log2-3))<<(`DL2block_Log2-3),addr>>(`DL2block_Log2-3)); 	
			//$display("DRAM %h",block_ram[1]);
		end
		
	end

	reg [5:0] lat;
	reg [10:0] latw;
	assign accR=(lat==0);
	assign accW=(latw==0);//&!en;

	always @( posedge clk ) begin
		if (reset) begin
			dready<=0;
			lat<=0;latw<=0;
		end else begin
			if (en) lat<=(lat<<1)|en;else lat<=(lat<<1);
			if (we) latw<=(latw<<1)|we;else latw<=(latw<<1);
			
			if (lat[5]) dout<=rdata;
			dready<=lat[5];//en;
		end
	end
		// synthesis translate_off	
	integer fd, byte_address;
	reg [7:0] value;	
	reg [`DL2block-1:0] word;
	
	initial begin 
		//byte_address=32'h00010000;
		byte_address=32'h00010074;
	    fd = $fopen(`BINARY, "rb"); 
	    //fd = $fopen("firmware/firmware.elf", "rb");
	    //fd = $fopen("benchmarks/merge/firmware.bin", "rb");
	    //fd = $fopen("benchmarks/sort/firmware.elf", "rb");	    
	    //fd = $fopen("benchmarks/benchmark-dhrystone/dhrystone", "rb");
	    //fd = $fopen("benchmarks/benchmark-dhrystone/dhrystone.bin", "rb");
	    if (!fd) $error("could not read file");
	    while (!$feof(fd)) begin
		     $fread(value,fd);
		     word[(byte_address%(`DL2block/8))*8+8-1-:8]=value;
		     //$display("[%d][%d] %h",byte_address%4,byte_address/4,value);		     	     
		     if (byte_address%(`DL2block/8)==(`DL2block/8)-1) begin
		     	block_ram[byte_address/(`DL2block/8)]=word;
		     	if (`DEB) $display ("%h at %h %h",word,byte_address/(`DL2block/8),byte_address);
		     	word=0;		     		     	
		     end
		     byte_address=byte_address+1;	
	   end
	   block_ram[byte_address/(`DL2block/8)]=word;
	   if (`DEB) $display ("%h at %h %h",word,byte_address/(`DL2block/8), byte_address);
	   dout=block_ram[0];
	end
	// synthesis translate_on 
	initial begin		
		$dumpvars(0,clk,reset,lat);
	end
endmodule // MemoryD3


// synthesis translate_off
module Top_Level();
	reg clk, reset;	

    wire [`DADDR_bits-1:0] addrD;
    wire [`DL2block-1:0] dinD;
    wire [`DL2block-1:0] doutD;       
    wire enD;
    wire weD;
    wire dreadyD;
    
    wire accR;// assign accR=act&&!(enD);
    wire accW;// assign accW=act&&!(weD);
    //wire act;
    
    reg flush; wire flushed; wire [31:0] debug;
    
    System s0(clk, reset, `StartAddress, `StackPointer,
   	 addrD, dinD, doutD, enD, weD, dreadyD, accR, accW,
     debug, flush, flushed); 
    
    MemoryD3 md(clk, reset, addrD, enD, weD, dinD, doutD, dreadyD, accR, accW);

//wire [31:0] d1; assign d1=32'hfffdffff;
//wire [31:0] d2; assign d2=32'h000000f0;		
	
	integer k;
	initial begin	
		$dumpfile("gtkwSystem.vcd");
		$dumpvars(0, clk, reset, addrD, flush, flushed);

		k=1;
		reset=1;clk=0;flush=0;
		repeat(100) begin		
			clk=1; #10 clk=0; #10;
		end
		reset=0;
		
		repeat(220000/*00*/) begin			
			
			clk=1; #10 clk=0; #10;
			
			k=k+1;	
		end
		
		flush=1; $display("Flushing remaing dirty blocks to DRAMs\n");
		clk=1; #10 clk=0; #10;
		flush=0;
		
		repeat((`DL1sets+`DL2sets)*20*4) begin		
			clk=1; #10 clk=0; #10;
		end		
	end
endmodule //Top_Level
// synthesis translate_on

