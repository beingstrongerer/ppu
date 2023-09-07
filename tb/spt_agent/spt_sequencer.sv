`ifndef SPT_SEQUENCER_SV
`define SPT_SEQUENCER_SV
class spt_sequencer extends uvm_sequencer;
	
	`uvm_component_utils(spt_sequencer)

	extern function new(string name, uvm_component parent);

endclass

function spt_sequencer::new(string name, uvm_component parent);
endfunction
`endif
