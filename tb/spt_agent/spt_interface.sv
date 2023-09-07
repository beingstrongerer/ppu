interface spt_interface(input clk100m,
						input rst_core_n);

	logic 		  vld;
	logic [15:0] data;
	
	modport PTU(output vld, data);
	modport PRU(input  vld, data);
	
endinterface
