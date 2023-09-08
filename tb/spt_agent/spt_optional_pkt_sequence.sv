class spt_optional_pkt_sequence extends spt_base_sequence;
	
	`uvm_object_utlis(spt_optional_pkt_sequence)
	bit[1:0] error_type, payload_type;
	int seq_item_max_num;
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
	`uvm_config_db::get(null, get_full_name(), "seq_item_max_num", seq_item_max_num)
	`uvm_config_db::get(null, get_full_name(), "error_type", error_type)
	`uvm_config_db::get(null, get_full_name(), "payload_type", payload_type)
	repeat(seq_item_max_num)begin
		`uvm_do_with(tr, {tr.error == error_type;
						  tr.payload_type == payload_type;})
	end		
	#100ns;
	if(starting_phase != null)begin
		starting_phase.drop_objection(this);
	end

endtask
