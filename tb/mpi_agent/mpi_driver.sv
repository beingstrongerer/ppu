class mpi_driver extends uvm_driver #(mpi_xaction);
	
	`uvm_component_utils(mpi_driver)
	virtual mpi_interface vif;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive_one_packet(REQ tr);//遵循时序要求
	extern task drv_idel();
	extern virtual task mpi_write(input REQ tr);
	extern virtual task mpi_read(ref REQ tr);
	
endclass

function mpi_driver::new(string name = "mpi_driver", uvm_component parent = null);
	super.new(name, parent);
endfunction

function void mpi_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db::get(this, "", "vif", vif))
		`uvm_error(get_type_name(), $sformatf("vif is not built in %s", get_type_name()))
endfunction

task mpi_driver::run_phase(uvm_phase phase);
	vif.cpu_cs_n <= 1'b1;//接口信号一定要用"<="赋值
	vif.cpu_rd_n <= 1'b1;
	vif.cpu_we_n <= 1'b1;
	vif.cpu_addr <= 16'h0000;
	vif.drv_cb.cpu_data <= 32'h0000;
	while(!vif.rst_n)
		@(posedge vif.clk_100m);
	while(1) begin
		seq_item_port.get_next_item(req);
		drive_one_packet(req);
		seq_item_port.item_done();
	end
	
endtask

task mpi_driver::drv_idel();
	
	@(posedge vif.clk_100m);
	vif.cpu_cs_n <= 1'b1;//接口信号一定要用"<="赋值
	vif.cpu_rd_n <= 1'b1;
	vif.cpu_we_n <= 1'b1;
	vif.cpu_addr <= 16'hx;
	vif.drv_cb.cpu_data <= 32'hx;

endtask

task mpi_driver::drive_one_packet(REQ tr);
	
	case(tr.cmd)
		WRITE:mpi_write(tr);
		READ:mpi_read(tr);//如果要修改传入task的值,无论是不是句柄类型都建议使用ref
	endcase

endtask

task mpi_driver::mpi_write(REQ tr);//串行执行,考虑和并行执行中的时延的不同
	//4.3.1cpu接口时序图4
	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_addr <= tr.cpu_addr;
	vif.drv_cb.cpu_cs_n <= 1'b0;
	vif.drv_cb.cpu_data <= tr.cpu_data;
	#tr.tcas;

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_we_n <= 1'b0;
	#(tr.tcdrd + tcrw);

	@(posedge vif.clk_100m);
	while(1)begin
		if(!vif.drv_cb.cpu_rdy_n)
			break;
		else
			@(posedge vif.clk_100m);
	end
	vif.drv_cb.cpu_we_n <= 1'b1;
	#tr.tcas;

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_cs_n <= 1'b1;
	this.drv_idel();
	#(tcwh - tcas);
	
endtask

task mpi_driver::mpi_read(REQ tr);
	//4.3.1cpu接口时序，图3
	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_addr <= tr.cpu_addr;
	vif.drv_cb.cpu_cs_n <= 1'b0;
	#tr.tcas;//延时控制信号单独起一行

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_rd_n <= 1'b0;
	#(tr.tcdrs + tr.tcrr);

	@(posedge vif.clk_100m);
	while(1)begin
		if(!vif.drv_cb.cpu_rdy_n)
			break;
		else
			@(posedge vif.clk_100m);
	end
	tr.cpu_data <= vif.drv_cb.cpu_data;
	vif.drv_cb.cpu_rd_n <= 1'b1;
	#(tr.tcas);

	@(posedge vif.clk_100m);
	vif.drv_cb.cpu_cs_n <= 1'b1;
	this.drv_ieal();
	#(tr.tcrh - tr.tcas);
	
endtask
