class spt_driver extends uvm_driver#(spt_packet);
	`uvm_component_utils(spt_driver)
	virtual spt_interface vif;
	int i;
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task do_reset();
	extern task drive_one_pkt(spt_packet req);
endclass

function spt_driver::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void spt_driver::build_phase(uvm_phase phase);
	`uvm_info(get_full_name(), "build_phase() starts", UVM_LOW)
	super.build_phase(phase);
	uvm_config_db #(int) ::get(this, "", "i", i);
	`uvm_info(get_full_name(), i, UVM_LOW)
	if(!uvm_config_db #(virtual spt_interface)::get(this, "", "vif", vif))
		`uvm_error(get_full_name(), "spt_interface is not set!")
	`uvm_info(get_full_name(), "build_phase() starts", UVM_LOW)	
endfunction

task spt_driver::run_phase(uvm_phase phase);
	vif.vld_in <= 1'b0;
	vif.data_in <= 32'h0;
	@(posedge vif.rst_core_n);
	do_reset();
	while(1) begin //until sequence drop_objection
		seq_item_port.get_next_item(req);//req is spt_packet class since #(REQ)	
		this.drive_one_pkt(req);	
		seq_item_port.item_done();
	end
	endtask

task spt_driver::do_reset();

	for(int i=0; i<3; i++)begin
		@(posedge vif.clk_100m);
		vif.vld_in <= 1'b0;
		vif.data_in <= 32'h0000_0000;
	end

endtask

task spt_driver::drive_one_pkt(spt_packet req);

	req.pack();//涉及到对尾域进行计算
	for(int i=0; i<req.pkt_len; i++)begin
		@(posedge vif.clk_100m);
		vif.vld_in <= 1'b1;	//iterface signal must be used by non-blocking
		vif.data_in <= req.pkt_data[i];//包内间隔
	end

	this.do_reset();//包间间隔

endtask
