class spt_base_sequence extends uvm_sequence#(spt_packet);
	
	`uvm_object_utlis(spt_base_sequence)
	spt_packet tr;

	extern function new(string name);
	extern task body();
	
endclass

function spt_base_sequence::new(string name = "spt_base_sequence");
	super.new(name);
endfunction

task spt_base_sequence::body();
	
	if(starting_phase != null)begin
		starting_phase.raise_objection(this);
	end
	repeat(10)begin
		 `uvm_do(tr);
	end
	#100ns;
	if(starting_phase != null)begin
		starting_phase.drop_objection(this);
	end

endtask
