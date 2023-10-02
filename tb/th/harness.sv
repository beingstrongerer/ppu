module harness;
//系统接口定义
	logic clk_100m;
	logic rst_n;
	logic scan_en;
	logic test_mode;
//接口实例化 .端口名(外部信号名)
spt_interface u_spt_if(.clk_100m(clk_100m),
					   .rst_core_n(rst_n));
mpi_interface u_mpi_if(.clk_100m(clk_100m),
					   .rst_n(rst_n));

//DUT实例化
top dut(
	.clk_100m(clk_100m),
	.rst_n(rst_n),
	.scan_en(1'b1),
	.test_mode(1'b0),
	
	.CPU_CS_N(u_mpi_if.cpu_cs_n),
	.CPU_RD_N(u_mpi_if.cpu_rd_n),
	.CPU_WE_N(u_mpi_if.cpu_we_n),
	.CPU_ADDR(u_mpi_if.cpu_addr),
	.CPU_DATA(u_mpi_if.cpu_data),
	.CPU_RDY_N(u_mpi_if.cpu_rdy_n),

	.vid_in(u_spt_if.vld_in),
	.data_in(u_spt_if.data_in),
	.vid_out(u_spt_if.vld_out),
	.data_out(u_spt_if.data_out)
);

//initial clk and rst
initial begin//clk
	clk_100m = 1'b0;
	forever begin
		#5 clk_100m = ~clk_100m;
	end
end

initial begin//rst
	rst_n = 1'b1;
	# 10 rst_n = 1'b0;
	# 200 rst_n = 1'b1;
end

//接口配置并进入到test环境中
initial begin
	//新建虚拟接口放置在DUT和testbench之间，，这个虚拟接口指向DUT中的接口实例，这样就完成了虚拟接口与DUT物理接口的连接。接口是同一个接口，只不过一端是DUT而另一端的testbench，并且在testbench侧需要使用虚拟的接口
	virtual spt_interface v_spt_if;
	virtual mpi_interface v_mpi_if;
	//将虚拟接口连接在物理接口上
	v_spt_if = u_spt_if;
	v_mpi_if = u_mpi_if;
	//为TESTBENCH配置虚拟接口
	uvm_config_db #(int) ::set(null, "*spt_agt*", "i", 999);
	uvm_config_db #(virtual spt_interface)::set(null, "*spt_agt*", "vif", v_spt_if);
	uvm_config_db #(virtual mpi_interface)::set(null, "*mpi_agt*", "vif", v_mpi_if);
	
	run_test("tc_sanity");
	end

// fsdb wave
initial begin
	$fsdbDumpfile("ppu.fsdb");
	$fsdbDumpvars;
end
endmodule
