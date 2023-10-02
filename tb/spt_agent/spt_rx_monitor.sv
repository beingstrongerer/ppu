`ifndef SPT_RX_MONITOR_SV
`define SPT_RX_MONITOR_SV
class spt_rx_monitor extends uvm_monitor;

	`uvm_component_utils(spt_rx_monitor);
	virtual spt_interface vif;
	uvm_analysis_port#(spt_packet) ap;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_one_pkt(spt_packet tr);
endclass

function spt_rx_monitor::new(string name, uvm_component parent);
	super.new(name,parent);
	ap = new("ap", this);
endfunction

function void spt_rx_monitor::build_phase(uvm_phase phase);
	`uvm_info(get_full_name(), "build_phase starts", UVM_LOW)
	super.build_phase(phase);
	if(!uvm_config_db #(virtual spt_interface)::get(this, "", "vif", vif))
		`uvm_error(get_full_name(), "The vif is not set in spt_rx_monitor!")
	`uvm_info(get_full_name(), "build_phase ends", UVM_LOW)
endfunction

task spt_rx_monitor::run_phase(uvm_phase phase);
	spt_packet tr;//monitor interface data and sent transaction lever data to rm
	`uvm_info(get_full_name(), "run_phase() starts", UVM_LOW)
	@(posedge vif.rst_core_n);
	while(1)begin
		tr = new("tr");		//"get_next_item"
		collect_one_pkt(tr);//callback
		ap.write(tr);//"item_done()"
	end
	`uvm_info(get_full_name(), "run_phase ends", UVM_LOW)
endtask

task spt_rx_monitor::collect_one_pkt(spt_packet tr);
	
	bit[15:0] collect_data[$];//collect interface data and store in this queue thensend to transaction level data "tr"
	
	@(posedge vif.vld_out);
	while(vif.vld_out) begin
		@(posedge vif.clk_100m);
		if(vif.vld_out)
			collect_data.push_back(vif.data_out);//payload
		else
			break;
	end
	for(int i=0; i<collect_data.size; i++) begin
		tr.payload.push_back(collect_data[i]);//real interface data only pkt_data
	end
	
endtask
`endif
