class mpi_driver extends uvm_driver #(mpi_xaction);
	
	`uvm_component_utils(mpi_driver)
	virtual mpi_interface vif;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive_one_packet(mpi_xaction tr);//遵循时序要求
	extern task drv_reset();
	extern virtual task mpi_write(mpi_xaction tr);
	extern virtual task mpi_read(mpi_xaction tr);
	
endclass

function mpi_driver::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void mpi_driver::build_phase(uvm_phase phase);
	`uvm_info(get_full_name(), "build_phase() starts", UVM_LOW)
	super.build_phase(phase);
	if(!uvm_config_db#(virtual mpi_interface)::get(this, "", "vif", vif))
		`uvm_error(get_type_name(), $sformatf("vif is not built in %s", get_type_name()))
	`uvm_info(get_full_name(), "build_phase() ends", UVM_LOW)
endfunction

task mpi_driver::run_phase(uvm_phase phase);
	`uvm_info(get_full_name(), "run_phase() starts", UVM_LOW)
	@(posedge vif.rst_n);
	drv_reset();
	while(1) begin
		seq_item_port.get_next_item(req);//来自sequencer,如果是寄存器模型，那么可以是寄存器模型的read或write任务传来的tr
		drive_one_packet(req);
		seq_item_port.item_done();
	end
	#10ns;
	`uvm_info(get_full_name(), "run_phase() ends", UVM_LOW)
endtask

task mpi_driver::drv_reset();
	
	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_cs_n <= 1'b1;//接口信号一定要用"<="赋值
	vif.drv_cb.cpu_rd_n <= 1'b1;
	vif.drv_cb.cpu_we_n <= 1'b1;

endtask

task mpi_driver::drive_one_packet(mpi_xaction tr);//寄存器模型的read函数是怎么读的
	case(tr.cmd)
		1'b0:mpi_write(tr);
		1'b1:mpi_read(tr);//如果要修改传入task的值,无论是不是句柄类型都建议使用ref，通过driver，无论是read还是write一个tr，都需要这个tr，不过在寄存器使用read的api时，还会将driver中read的tr传给adapter，具体什么方式不知道
	endcase
endtask

task mpi_driver::mpi_write(mpi_xaction tr);//串行执行,考虑和并行执行中的时延的不同
	//4.3.1cpu接口时序图4
	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_addr <= tr.cpu_addr;
	vif.drv_cb.cpu_cs_n <= 1'b0;
	vif.drv_cb.cpu_data <= tr.cpu_data;
	#tr.tcas;

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_we_n <= 1'b0;
	vif.drv_cb.cpu_rd_n <= 1'b1;
	#(tr.tcdrd + tr.tcrw);

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_we_n <= 1'b1;
	#tr.tcas;

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_cs_n <= 1'b1;
	#(tr.tcwh - tr.tcas);
	
endtask

task mpi_driver::mpi_read(mpi_xaction tr);
	//4.3.1cpu接口时序，图3
	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_addr <= tr.cpu_addr;
	vif.drv_cb.cpu_cs_n <= 1'b0;
	#tr.tcas;//延时控制信号单独起一行

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_rd_n <= 1'b0;
	vif.drv_cb.cpu_we_n <= 1'b1;
	#(tr.tcdrd + tr.tcrr);

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_rd_n <= 1'b1;
	tr.cpu_data <= vif.drv_cb.cpu_data;
	#(tr.tcas);

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_cs_n <= 1'b1;
	#(tr.tcrh - tr.tcas);	
	
endtask
