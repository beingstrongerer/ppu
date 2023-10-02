interface spt_interface(input clk_100m,
						input rst_core_n);

	logic 		 vld_in;
	logic [15:0] data_in;
	logic 		 vld_out;
	logic [15:0] data_out;
	
endinterface
