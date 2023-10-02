class virtual_sequencer extends uvm_sequencer;
	`uvm_component_utils(virtual_sequencer)
	spt_sequencer spt_sqr;//spt_agt.sqr
	mpi_sequencer mpi_sqr;//mpi_agt.sqr

	function new(string name = "virtual_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass
