class mpi_base_sequence extends uvm_sequence_item #(mpi_xaction);
	`uvm_object_utils(mpi_base_sequence)
	extern function new(string name = "mpi_base_sequence");
	extern virtual task body();
endclass
function mpi_base_sequence::new(string name = "mpi_base_sequence");
	super.new(name);
endfunction

task mpi_base_sequence::body();
	`uvm_info(get_full_name(), "This is reg base sequence", UVM_LOW)
endtask
