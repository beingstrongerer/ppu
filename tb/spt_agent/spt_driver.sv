class spt_driver extends uvm_driver;
	`uvm_component_utils(spt_driver)

	extern function new(string name, uvm_component parent);
	extern void function build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
endclass

