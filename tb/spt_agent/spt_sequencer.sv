`ifndef SPT_SEQUENCER_SV
`define SPT_SEQUENCER_SV
class spt_sequencer extends uvm_sequencer #(spt_packet);
	
	`uvm_component_utils(spt_sequencer)

	extern function new(string name, uvm_component parent);

endclass

function spt_sequencer::new(string name, uvm_component parent);
	super.new(name, parent);
	`uvm_info(get_full_name(), "spt_sequencer has been created!", UVM_LOW)
endfunction
`endif
