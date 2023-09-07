class spt_driver extends uvm_driver#(spt_packet);
	`uvm_component_utils(spt_driver)
	virtual spt_interface spt_itf;
	extern function new(string name, uvm_component parent);
	extern void function build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task do_reset();
endclass

function spt_driver::new(string name, uvm_component parent);
endfunction

function spt_driver::build_phase(uvm_phase phase);
endfunction

task spt_driver::run_phase(uvm_phase phase);
endtask

task spt_driver::do_reset();
endtask
