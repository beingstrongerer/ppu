class reg_model extends uvm_reg_block;
	`uvm_object_utils(reg_model)

	reg_port_mode_blk port_mode_blk;
	reg_spt_cnt_blk spt_cnt_blk;
	reg_test_data_blk test_data_blk;
	reg_test_status test_status;
	reg_test_alarm test_alarm;

	extern function new(string name = "reg_model");
	extern function void build();

endclass

function reg_model::new(string name = "reg_model");
	super.new(name, UVM_NO_COVERAGE);
endfunction

function void reg_model::build();
	default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN, 0);//内部函数，创建一个map，如果是第一个map则也为该blk内默认map变量的值，最后一个表示字地址或者字节地址

	port_mode_blk = reg_port_mode_blk::type_id::create("port_mode_blk");
	port_mode_blk.configure(this, "");
	port_mode_blk.build();
	port_mode_blk.lock_model();
	default_map.add_submap(port_mode_blk.default_map, 16'h4000);//添加基地址

	spt_cnt_blk = reg_spt_cnt_blk::type_id::create("spt_cnt_blk");
	spt_cnt_blk.configure(this, "");
	spt_cnt_blk.build();
	spt_cnt_blk.lock_model();
	default_map.add_submap(spt_cnt_blk.default_map, 16'h4100);//添加基地址，并且是字地址，而不是字节地址

	test_data_blk = reg_test_data_blk::type_id::create("test_data_blk");
	test_data_blk.configure(this, "");
	test_data_blk.build();
	test_data_blk.lock_model();
	default_map.add_submap(test_data_blk.default_map, 16'h8000);

	test_status = reg_test_status::type_id::create("test_status");
	test_status.configure(this, null, "");
	test_status.build();
	default_map.add_reg(test_status, 16'h8100, "RO"); 	

	test_alarm = reg_test_alarm::type_id::create("test_alarm");
	test_alarm.configure(this, null, "");
	test_alarm.build();
	default_map.add_reg(test_alarm, 16'h8200, "RW");

endfunction
