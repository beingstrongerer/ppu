class mpi_sequencer extends uvm_sequencer #(mpi_xaction);
	`uvm_component_utils(mpi_sequencer)
	reg_model reg_md;
	function new(string name, uvm_component parent);
		super.new(name, parent);	
	endfunction
	
	function void build_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "build_phase() starts", UVM_LOW)
		super.build_phase(phase);
		`uvm_info(get_full_name(), "build_phase() ends", UVM_LOW)	
	endfunction
endclass
