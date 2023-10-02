class virtual_sequence extends uvm_sequence;
	`uvm_object_utils(virtual_sequence)
	`uvm_declare_p_sequencer(virtual_sequencer)
	
	function new(string name = "virtual_sequence");
		super.new(name);
	endfunction

	task body();
	spt_optional_pkt_sequence spt_optional_pkt_seq;
	mpi_rw_sequence mpi_rw_seq;
	//`uvm_do_on(spt_optional_pkt_seq, p_sequencer.spt_sqr)//sqr->drv
	`uvm_do_on(mpi_rw_seq, p_sequencer.mpi_sqr)//在vseq中是启动该seq，而不进行实例化
	endtask
endclass
