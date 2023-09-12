class spt_driver extends uvm_driver#(spt_packet);
	`uvm_component_utils(spt_driver)
	virtual spt_interface vif;
	extern function new(string name, uvm_component parent);
	extern void function build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task do_reset();
	extern task drive_one_pkt(REQ req);
endclass

function spt_driver::new(string name = "spt_driver", uvm_component parent = null);
	super.new(name, parent);
endfunction

function spt_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual spt_interface)::get(this, "", "vif", vif))
		`uvm_error(get_full_name(), "spt_interface is not set!")
endfunction

task spt_driver::run_phase(uvm_phase phase);

	vif.vld_in <= 1'b0;
	vif.data_in <= 32'h0;
	while(!vif.rst_core_n)
		@(posedge vif.clk_100m);	
	while(1) begin //until sequence drop_objection
		seq_item_port.get_next_item(req);//req is spt_packet class since #(REQ)	
		this.drive_one_pkt(req);	
		seq_item_port.item_done();
	end

endtask

task spt_driver::do_reset();

	for(int i=0; i<3; i++)begin
		@(posedge vif.clk100m);
		vif.vld_in <= 1'b0;
		vif.data_in <= $urandom();
	end

endtask

task spt_driver::drive_one_pkt(REQ req);

	req.do_pack();
	`uvm_info(get_full_name(), "one spt_packet begins to send...", UVM_HIGH);
	for(int i=0; i<req.pkt_len; i++)begin
		@(posedge vif.clk100m);
		vif.rst_in <= 1'b1;	//iterface signal must be used by non-blocking
		vif.data_in <= req.pkt_data[i];
	end
	`uvm_info(get_full_name(), "one spt_packet has been sent...", UVM_HIGH);

	this.do_reset();

endtask
