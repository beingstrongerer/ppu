class reg_port_mode_blk extends uvm_reg_block;
	`uvm_object_utils(reg_port_mode_blk)
	reg_port_sel port_sel;
	reg_mode_sel mode_sel;

	function new(string name = "reg_port_mode_blk");
		super.new(name, UVM_NO_COVERAGE);
	endfunction

	function void build();
		default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN, 0);
		
		port_sel = reg_port_sel::type_id::create("port_sel");
		port_sel.configure(this, null, "");
		port_sel.build();
		default_map.add_reg(port_sel, 'h0, "RW");//offset
		
		mode_sel = reg_mode_sel::type_id::create("mode_sel");
		mode_sel.configure(this, null, "");
		mode_sel.build();
		default_map.add_reg(mode_sel, 'h4, "RW");//offset

	endfunction
endclass

class reg_spt_cnt_blk extends uvm_reg_block;
	`uvm_object_utils(reg_spt_cnt_blk)
	reg_spt_head_err_cnt spt_head_err_cnt;
	reg_spt_tail_err_cnt spt_tail_err_cnt;
	reg_spt_sht_pkt_cnt spt_sht_pkt_cnt;
	reg_spt_lng_pkt_cnt spt_lng_pkt_cnt;
	reg_spt_ok_pkt_cnt spt_ok_pkt_cnt;

	function new(string name = "reg_spt_cnt_blk");
		super.new(name, UVM_NO_COVERAGE);
	endfunction

	function void build();
		default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN, 0);
		
		spt_head_err_cnt = reg_spt_head_err_cnt::type_id::create("spt_head_err_cnt");
		spt_head_err_cnt.configure(this, null, "");
		spt_head_err_cnt.build();
		default_map.add_reg(spt_head_err_cnt, 'h0, "RW");//offset
		
		spt_tail_err_cnt = reg_spt_tail_err_cnt::type_id::create("spt_tail_err_cnt");
		spt_tail_err_cnt.configure(this, null, "");
		spt_tail_err_cnt.build();
		default_map.add_reg(spt_tail_err_cnt, 'h4, "RW");//offset
	
		spt_sht_pkt_cnt = reg_spt_sht_pkt_cnt::type_id::create("spt_sht_pkt_cnt");
		spt_sht_pkt_cnt.configure(this, null, "");
		spt_sht_pkt_cnt.build();
		default_map.add_reg(spt_sht_pkt_cnt, 'h8, "RW");//offset	

		spt_lng_pkt_cnt = reg_spt_lng_pkt_cnt::type_id::create("spt_lng_pkt_cnt");
		spt_lng_pkt_cnt.configure(this, null, "");
		spt_lng_pkt_cnt.build();
		default_map.add_reg(spt_lng_pkt_cnt, 'hC, "RW");//offset	

		spt_ok_pkt_cnt = reg_spt_ok_pkt_cnt::type_id::create("spt_ok_pkt_cnt");
		spt_ok_pkt_cnt.configure(this, null, "");
		spt_ok_pkt_cnt.build();
		default_map.add_reg(spt_ok_pkt_cnt, 'h10, "RW");//offset	

	endfunction
endclass

class reg_test_data_blk extends uvm_reg_block;
	`uvm_object_utils(reg_test_data_blk)

	reg_test_data0  test_data0;
	reg_test_data1  test_data1;
	reg_test_data2  test_data2;
	reg_test_data3  test_data3;
	reg_test_data4  test_data4;
	reg_test_data5  test_data5;
	reg_test_data6  test_data6;
	reg_test_data7  test_data7;
	reg_test_data8  test_data8;
	reg_test_data9  test_data9;
	reg_test_data10 test_data10;
	reg_test_data11 test_data11;
	reg_test_data12 test_data12;
	reg_test_data13 test_data13;
	reg_test_data14 test_data14;
	reg_test_data15 test_data15;

	function new(string name = "reg_test_data_blk");
		super.new(name, UVM_NO_COVERAGE);
	endfunction

	function void build();
		default_map = create_map("default_map", 16'h8000, 4, UVM_BIG_ENDIAN, 0);//使用字地址, 设置基地址

		test_data0 = reg_test_data0::type_id::create("test_data0");
		test_data0.configure(this, null, "");
		test_data0.build();
		default_map.add_reg(test_data0, 'h0, "RW");

		test_data1 = reg_test_data1::type_id::create("test_data1");
		test_data1.configure(this, null, "");
		test_data1.build();
		default_map.add_reg(test_data1, 'h4, "RW");

		test_data2 = reg_test_data2::type_id::create("test_data2");
		test_data2.configure(this, null, "");
		test_data2.build();
		default_map.add_reg(test_data2, 'h8, "RW");

		test_data3 = reg_test_data3::type_id::create("test_data3");
		test_data3.configure(this, null, "");
		test_data3.build();
		default_map.add_reg(test_data3, 'hC, "RW");

		test_data4 = reg_test_data4::type_id::create("test_data4");
		test_data4.configure(this, null, "");
		test_data4.build();
		default_map.add_reg(test_data4, 'h10, "RW");

		test_data5 = reg_test_data5::type_id::create("test_data5");
		test_data5.configure(this, null, "");
		test_data5.build();
		default_map.add_reg(test_data5, 'h14, "RW");

		test_data6 = reg_test_data6::type_id::create("test_data6");
		test_data6.configure(this, null, "");
		test_data6.build();
		default_map.add_reg(test_data6, 'h18, "RW");


		test_data7 = reg_test_data7::type_id::create("test_data7");
		test_data7.configure(this, null, "");
		test_data7.build();
		default_map.add_reg(test_data7, 'h1C, "RW");

		test_data8 = reg_test_data8::type_id::create("test_data8");
		test_data8.configure(this, null, "");
		test_data8.build();
		default_map.add_reg(test_data8, 'h20, "RW");

		test_data9 = reg_test_data9::type_id::create("test_data9");
		test_data9.configure(this, null, "");
		test_data9.build();
		default_map.add_reg(test_data9, 'h24, "RW");

		test_data10 = reg_test_data10::type_id::create("test_data10");
		test_data10.configure(this, null, "");
		test_data10.build();
		default_map.add_reg(test_data10, 'h28, "RW");

		test_data11 = reg_test_data11::type_id::create("test_data11");
		test_data11.configure(this, null, "");
		test_data11.build();
		default_map.add_reg(test_data11, 'h2C, "RW");

		test_data12 = reg_test_data12::type_id::create("test_data12");
		test_data12.configure(this, null, "");
		test_data12.build();
		default_map.add_reg(test_data12, 'h30, "RW");

		test_data13 = reg_test_data13::type_id::create("test_data13");
		test_data13.configure(this, null, "");
		test_data13.build();
		default_map.add_reg(test_data13, 'h34, "RW");

		test_data14 = reg_test_data14::type_id::create("test_data14");
		test_data14.configure(this, null, "");
		test_data14.build();
		default_map.add_reg(test_data14, 'h38, "RW");

		test_data15 = reg_test_data15::type_id::create("test_data15");
		test_data15.configure(this, null, "");
		test_data15.build();
		default_map.add_reg(test_data15, 'h3C, "RW");

	endfunction
endclass

