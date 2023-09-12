class mpi_sequencer extends uvm_sequencer #(mpi_xaction);
	`uvm_component_utils(mpi_sequencer)

	function new(string name = "mpi_sequencer", uvm_component parent = null);
		super.new(name, parent);	
	endfunction
endclass
