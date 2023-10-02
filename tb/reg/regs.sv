class reg_port_sel extends uvm_reg;

	`uvm_object_utils(reg_port_sel)
	uvm_reg_field port_sel;
 
	function new(string name = "reg_port_sel");//这不是继承，这是自己的new函数
		super.new(name, 32, UVM_NO_COVERAGE);//uvm_reg的new函数有三个参数(strng, int unsigned nbits, int has_coverage)
	endfunction
	
	function void build();//build阶段：create实例化
		port_sel = uvm_reg_field::type_id::create("port_sel", , get_full_name());
		port_sel.configure(this, 1, 0, "RW", 1, 0, 1, 1, 0);//offset is set in map
	endfunction
	
endclass

class reg_mode_sel extends uvm_reg;
	`uvm_object_utils(reg_mode_sel)//注册后，就可以使用T::type_id::create(string name, uvm_component parent, string massage)的方式进行创建，只是对于object类型默认只使用第一个参数
	uvm_reg_field mode_sel;

	function new(string name = "reg_mode_sel");//在继承类中的new函数中只使用一个参数，但是其父类uvm_reg中的new函数却有三个参数，是不是很奇怪，哈哈
		super.new(name, 32, UVM_NO_COVERAGE);//三个参数，第二个必须填写，否则默认reg宽度为0，第三个参数默认不收集覆盖率，所以第三个参数如果默认不采集也可以不填写
	endfunction

	function void build();
		mode_sel = uvm_reg_field::type_id::create("mode_sel");
		mode_sel.configure(this, 8, 0, "RW", 1, 8'h00, 1, 1, 0);
		
	endfunction
endclass

class reg_spt_head_err_cnt extends uvm_reg; 
	`uvm_object_utils(reg_spt_head_err_cnt)
	
	uvm_reg_field spt_head_err_cnt;
	function new(string name = "spt_head_err_cnt");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();//field和reg是在configure中添加层次信息，而对于block是在creat时添加
		spt_head_err_cnt = uvm_reg_field::type_id::create("spt_head_err_cnt");//虽有三个参数
		spt_head_err_cnt.configure(this, 32, 0 , "RC", 1, 32'h0000_0000, 1, 1, 0);//在configure中添加层次结构信息
	endfunction
	
endclass

class reg_spt_tail_err_cnt extends uvm_reg;
	`uvm_object_utils(reg_spt_tail_err_cnt)

	uvm_reg_field spt_tail_err_cnt;
	function new(string name = "reg_spt_tail_err_cnt");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();
		spt_tail_err_cnt = uvm_reg_field::type_id::create("spt_tail_err_cnt");
		spt_tail_err_cnt.configure(this, 32, 0, "RC", 1, 32'h0000_0000, 1, 1, 0);
	endfunction
endclass

class reg_spt_sht_pkt_cnt extends uvm_reg;
	`uvm_object_utils(reg_spt_sht_pkt_cnt)
	
	uvm_reg_field spt_sht_pkt_cnt;
	function new(string name = "reg_spt_sht_cnt");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();
		spt_sht_pkt_cnt = uvm_reg_field::type_id::create("spt_sht_pkt_cnt");
		spt_sht_pkt_cnt.configure(this, 32, 0, "RC", 1, 32'h0000_0000, 1 ,1, 0);	
	endfunction
endclass

class reg_spt_lng_pkt_cnt extends uvm_reg;
	`uvm_object_utils(reg_spt_lng_pkt_cnt)
	uvm_reg_field spt_lng_pkt_cnt;
	function new(string name = "spt_lng_pkt_cnt");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();
		spt_lng_pkt_cnt = uvm_reg_field::type_id::create("spt_lng_pkt_cnt");
		spt_lng_pkt_cnt.configure(this, 32, 0, "RC", 1, 32'h0000_0000, 1, 1, 0);
	endfunction

endclass

class reg_spt_ok_pkt_cnt extends uvm_reg;
	`uvm_object_utils(reg_spt_ok_pkt_cnt)
	uvm_reg_field spt_ok_pkt_cnt;
	function new(string name = "spt_ok_pkt_cnt");
		super.new(name, 32, UVM_NO_COVERAGE);//初始化寄存器的总长度
	endfunction
	
	function void build();
		spt_ok_pkt_cnt = uvm_reg_field::type_id::create("spt_ok_pkt_cnt");//实例化一个域
		spt_ok_pkt_cnt.configure(this, 32, 0, "RC", 1, 32'h0000_0000, 1, 1, 0);//配置一个域，包括归属于那个寄存器、长度、在当前寄存器的起始位置、模式、初始值等信息
	endfunction
endclass

class reg_test_data0 extends uvm_reg;//测试数据表中存放的是什么数据，随机数据吗？测试这些寄存器有什么作用？完成自动扫描？扫描的是外部所有SRAM。那么是对所有的SRAM都进行读写检测吗？对某个寄存器功能来说，是外部条件发生时，该寄存器的值是否会改变，改变的前提是读写正常，所以这两者不冲突。相当于这个测试数据表完成了对SRAM读写功能的自动扫描，是测试其他寄存器功能是否正常的前提，因为只有寄存器能正常读入和写出，才能去测试功能与对应写入或读出的寄存器值是否正确。要先保证正常，才能保证是否正确。
	`uvm_object_utils(reg_test_data0);
	uvm_reg_field test_data0;
	function new(string name = "reg_test_data0");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data0 = uvm_reg_field::type_id::create("test_data0");
		test_data0.configure(this, 24, 0, "RW", 1 , 24'h00_0000, 1, 1, 0);
	endfunction
endclass

class reg_test_data1 extends uvm_reg;
	`uvm_object_utils(reg_test_data1);
	uvm_reg_field test_data1;
	function new(string name = "reg_test_data1");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data1 = uvm_reg_field::type_id::create("test_data1");
		test_data1.configure(this, 24, 0, "RW", 1, 24'hFF_FFFF, 1, 1, 0);
	endfunction
endclass

class reg_test_data2 extends uvm_reg;
	`uvm_object_utils(reg_test_data2);
	uvm_reg_field test_data2;
	function new(string name = "reg_test_data2");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data2 = uvm_reg_field::type_id::create("test_data2");
		test_data2.configure(this, 24, 0, "RW", 1, 24'h0F_0F0F, 1, 1, 0);
	endfunction
endclass

class reg_test_data3 extends uvm_reg;
	`uvm_object_utils(reg_test_data3);
	uvm_reg_field test_data3;
	function new(string name = "reg_test_data3");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data3 = uvm_reg_field::type_id::create("test_data3");
		test_data3.configure(this, 24, 0, "RW", 1, 24'hF0_F0F0, 1, 1, 0);
	endfunction
endclass

class reg_test_data4 extends uvm_reg;
	`uvm_object_utils(reg_test_data4);
	uvm_reg_field test_data4;
	function new(string name = "reg_test_data4");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data4 = uvm_reg_field::type_id::create("test_data4");
		test_data4.configure(this, 24, 0, "RW", 1, 24'h55_5555, 1, 1, 0);
	endfunction
endclass

class reg_test_data5 extends uvm_reg;
	`uvm_object_utils(reg_test_data5);
	uvm_reg_field test_data5;
	function new(string name = "reg_test_data5");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data5 = uvm_reg_field::type_id::create("test_data5");
		test_data5.configure(this, 24, 0, "RW", 1, 24'hAA_AAAA, 1, 1, 0);
	endfunction
endclass

class reg_test_data6 extends uvm_reg;
	`uvm_object_utils(reg_test_data6);
	uvm_reg_field test_data6;
	function new(string name = "reg_test_data6");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data6 = uvm_reg_field::type_id::create("test_data6");
		test_data6.configure(this, 24, 0, "RW", 1, 24'h5A_5A5A, 1, 1, 0);
	endfunction
endclass

class reg_test_data7 extends uvm_reg;
	`uvm_object_utils(reg_test_data7);
	uvm_reg_field test_data7;
	function new(string name = "reg_test_data7");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data7 = uvm_reg_field::type_id::create("test_data7");
		test_data7.configure(this, 24, 0, "RW", 1, 24'hA5_A5A5, 1, 1, 0);
	endfunction
endclass

class reg_test_data8 extends uvm_reg;
	`uvm_object_utils(reg_test_data8);
	uvm_reg_field test_data8;
	function new(string name = "reg_test_data8");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data8 = uvm_reg_field::type_id::create("test_data8");
		test_data8.configure(this, 24, 0, "RW", 1, 24'h0A_0A0A, 1, 1, 0);
	endfunction
endclass

class reg_test_data9 extends uvm_reg;
	`uvm_object_utils(reg_test_data9);
	uvm_reg_field test_data9;
	function new(string name = "reg_test_data9");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data9 = uvm_reg_field::type_id::create("test_data9");
		test_data9.configure(this, 24, 0, "RW", 1, 24'h0A_0A0A, 1, 1, 0);
	endfunction
endclass

class reg_test_data10 extends uvm_reg;
	`uvm_object_utils(reg_test_data10);
	uvm_reg_field test_data10;
	function new(string name = "reg_test_data10");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data10 = uvm_reg_field::type_id::create("test_data10");
		test_data10.configure(this, 24, 0, "RW", 1, 24'hA0_A0A0, 1, 1, 0);
	endfunction
endclass

class reg_test_data11 extends uvm_reg;
	`uvm_object_utils(reg_test_data11);
	uvm_reg_field test_data11;
	function new(string name = "reg_test_data11");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data11 = uvm_reg_field::type_id::create("test_data11");
		test_data11.configure(this, 24, 0, "RW", 1, 24'h05_0505, 1, 1, 0);
	endfunction
endclass

class reg_test_data12 extends uvm_reg;
	`uvm_object_utils(reg_test_data12);
	uvm_reg_field test_data12;
	function new(string name = "reg_test_data12");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data12 = uvm_reg_field::type_id::create("test_data12");
		test_data12.configure(this, 24, 0, "RW", 1, 24'h50_5050, 1, 1, 0);
	endfunction
endclass

class reg_test_data13 extends uvm_reg;
	`uvm_object_utils(reg_test_data13);
	uvm_reg_field test_data13;
	function new(string name = "reg_test_data13");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data13 = uvm_reg_field::type_id::create("test_data13");
		test_data13.configure(this, 24, 0, "RW", 1, 24'hAF_AFAF, 1, 1, 0);
	endfunction
endclass

class reg_test_data14 extends uvm_reg;
	`uvm_object_utils(reg_test_data14);
	uvm_reg_field test_data14;
	function new(string name = "reg_test_data14");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data14 = uvm_reg_field::type_id::create("test_data14");
		test_data14.configure(this, 24, 0, "RW", 1, 24'hF5_F5F5, 1, 1, 0);
	endfunction
endclass

class reg_test_data15 extends uvm_reg;
	`uvm_object_utils(reg_test_data15);
	uvm_reg_field test_data15;
	function new(string name = "reg_test_data15");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_data15 = uvm_reg_field::type_id::create("test_data15");
		test_data15.configure(this, 24, 0, "RW", 1, 24'hFA_FAFA, 1, 1, 0);
	endfunction
endclass

class reg_test_status extends uvm_reg;
	`uvm_object_utils(reg_test_status);
	uvm_reg_field test_status_b;
	uvm_reg_field test_status_a;
	function new(string name = "reg_test_status");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_status_b = uvm_reg_field::type_id::create("test_status_b");
		test_status_b.configure(this, 2, 0, "RO", 1, 2'b00, 1, 1, 0);

		test_status_a = uvm_reg_field::type_id::create("test_status_a");
		test_status_a.configure(this, 2, 2, "RO", 1, 2'b00, 1, 1, 0);
	endfunction
endclass

class reg_test_alarm extends uvm_reg;
	`uvm_object_utils(reg_test_alarm);
	uvm_reg_field test_alarm_data_err_a;
	uvm_reg_field test_alarm_addr_err_a;
	uvm_reg_field test_alarm_data_err_b;
	uvm_reg_field test_alarm_addr_err_b;
	
	function new(string name = "reg_test_status");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	
	function void build();
		test_alarm_data_err_a = uvm_reg_field::type_id::create("test_alarm_data_err_a");
		test_alarm_data_err_a.configure(this, 1, 0, "RC", 1, 1'b0, 1, 1, 0);

		test_alarm_addr_err_a = uvm_reg_field::type_id::create("test_alarm_data_err_a");
		test_alarm_addr_err_a.configure(this, 1, 1, "RC", 1, 1'b0, 1, 1, 0);

		test_alarm_data_err_b = uvm_reg_field::type_id::create("test_alarm_data_err_a");
		test_alarm_data_err_b.configure(this, 1, 2, "RC", 1, 1'b0, 1, 1, 0);

		test_alarm_addr_err_b = uvm_reg_field::type_id::create("test_alarm_data_err_a");
		test_alarm_addr_err_b.configure(this, 1, 3, "RC", 1, 1'b0, 1, 1, 0);

	endfunction
endclass

