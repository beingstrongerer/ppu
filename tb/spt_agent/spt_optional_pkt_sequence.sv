class spt_optional_pkt_sequence extends uvm_sequence #(spt_packet);
	
	`uvm_object_utils(spt_optional_pkt_sequence)
	bit[1:0] err_type, payload_type;
	int seq_item_max_num;
	extern function new(string name = "spt_optional_pkt_sequence");
	extern task body();

endclass

function spt_optional_pkt_sequence::new(string name = "spt_optional_pkt_sequence");
	super.new(name);
endfunction

task spt_optional_pkt_sequence::body();
	bit[15:0] real_tailer;
	spt_packet tr;
	`uvm_info(get_full_name(), "body starts", UVM_LOW)

	uvm_config_db #(int)::get(null, get_full_name(), "seq_item_max_num", seq_item_max_num);
	uvm_config_db #(bit[1:0])::get(null, get_full_name(), "err_type", err_type);
	uvm_config_db #(bit[1:0])::get(null, get_full_name(), "payload_type", payload_type);
	`uvm_info(get_full_name(), "sequence config_db is over", UVM_LOW)
	//先得到配置信息，再开始发送数据到sequencer中去，可以理解为该函数在sequencer中的main_phase中被调用，然后所有组件都在main_phase阶段运行，消耗方针时间，直至body函数结束，然后结束所有组件的main_phase包括run_phase，所以在数据发送完毕后，一定要留一些时间在drop_objection。因为刚发出去的数据，在dut、rm和scoreboard中需要时间运行。
	repeat(seq_item_max_num)begin
		`uvm_do_with(tr, {tr.err_type == local::err_type; tr.payload_type == local::payload_type;})
		//`uvm_do(tr)
	end
	`uvm_do_with(tr, {tr.err_type == 2'b01; tr.payload_type == local::payload_type;})
	`uvm_do_with(tr, {tr.err_type == 2'b10; tr.payload_type == local::payload_type;})
	#500;
endtask

