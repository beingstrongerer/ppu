interface mpi_interface(input clk_100m,
						input rst_n);
	
	logic 	  	 cpu_cs_n;
	logic 		 cpu_rd_n;
	logic 		 cpu_we_n;
	logic [15:0] cpu_addr;
	logic [31:0] cpu_data;
	logic 		 cpu_rdy_n;

	parameter SETUP_TIME = 1ns;
	parameter HOLD_TIME = 1ns;

	clocking drv_cb @(posedge clk_100m);
		default input SETUP_TIME output HOLD_TIME;

		output  cpu_cs_n;
		output  cpu_rd_n;
		output  cpu_we_n;
		output  cpu_addr;
		inout   cpu_data;
		input   cpu_rdy_n;

	endclocking	

	clocking mon_cb @(posedge clk_100m);
		default input SETUP_TIME output HOLD_TIME;
		
		input  cpu_cs_n;
		input  cpu_rd_n;
		input  cpu_we_n;
		input  cpu_addr;
		inout  cpu_data;
		input  cpu_rdy_n;
	
	endclocking
	
	
endinterface
