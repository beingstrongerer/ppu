class spt_base_sequence extends uvm_sequence#(spt_packet);
	extern function new(string name);
	extern task body();
	
endclass

function spt_base_sequence::new(string name);
	super.new(name);
endfunction

task spt_base_sequence::body();
endtask
