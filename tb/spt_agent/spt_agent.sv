`ifndef SPT_AGENT_SV
`define SPT_AGENT_SV
class spt_agent extends uvm_agent;
	
	`uvm_component_utils(spt_agent)
	spt_driver drv;
	spt_sequencer sqr;
	spt_tx_monitor mon_tx;
	spt_rx_monitor mon_rx;
	uvm_analysis_port #(spt_packet) ap;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
endclass

function spt_agent::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void spt_agent::build_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"build_phase() start...",UVM_LOW);
	super.build_phase(phase);
	if(is_active == UVM_ACTIVE) begin//transaction inside var
		drv = spt_driver::type_id::create("drv", this);
		sqr = spt_sequencer::type_id::create("sqr", this);
	end
	mon_tx = spt_tx_monitor::type_id::create("mon_tx", this);
	mon_rx = spt_rx_monitor::type_id::create("mon_rx", this);
	`uvm_info(get_type_name(),"build_phase() end...",UVM_LOW);
endfunction

function void spt_agent::connect_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"connect_phase() start...",UVM_LOW);
	super.connect_phase(phase);
	if(is_active == UVM_ACTIVE)begin
		drv.seq_item_port.connect(sqr.seq_item_export);	
	end
	ap = mon_tx.ap;//mon_rx直接与env中的scoreboard相连，mon_tx通过agent与env中的refmod相连
	`uvm_info(get_type_name(),"connect_phase() end...",UVM_LOW);
endfunction
`endif
