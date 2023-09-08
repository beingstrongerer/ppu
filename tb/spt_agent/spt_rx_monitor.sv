`ifndef SPT_RX_MONITOR_SV
`define SPT_RX_MONITOR_SV
class spt_rx_monitor extends uvm_monitor;

	`uvm_component_utils(spt_rx_monitor);
	virtual spt_interface vif;
	uvm_analysis_port#(spt_packet) ap;

	extern function new(string name, uvm_component parent);
	extern void function build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern void function collect_one_pkt(spt_packet tr);
endclass

function spt_rx_monitor::new(string name = "spt_rx_monitor", uvm_component parent = null);
	super.new(name,parent);
endfunction

function void spt_rx_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db::get(this, "", "vif", vif))
		`uvm_error(get_full_name(), "The vif is not set in spt_rx_monitor!")
endfunction

task spt_rx_monitor::run_phase(uvm_phase phase);
	
	spt_packet tr;//monitor interface data and sent transaction lever data to rm
	while(1)begin
		tr = spt_packet::type_id::create("tr");		//"get_next_item"
		this.collect_one_pkt(tr);//callback
		ap.write(tr);//"item_done()"
	end
endtask

function void spt_rx_monitor::collect_one_pkt(spt_packet tr);
	
	bit[15:0] collect_data[$];//collect interface data and store in this queue thensend to transaction level data "tr"
	
	while(1)begin
		@(posedeg vif.clk100m);
		if(vif.vld_out)
			break	
	end
	while(vif.vld_out)begin
		collect_data.push_back(vif.data_out);//payload
		@(posedeg vif.clk100m);
	end
	tr.pkt_data = new[collect_data.size];//dynamic
	for(int i=0; i<collect_data; i++)begin
		tr.payload[i].push_back(collect_data[i]);//real interface data only pkt_data
	end
	
endfunction
`endif
