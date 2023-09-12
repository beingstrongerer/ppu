class mpi_monitor extends uvm_driver #(mpi_xaction);
	`uvm_component_utils(mpi_monitor)
	virtual mpi_interface vif;
	uvm_analysis_port #(mpi_xaction) ap;
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_one_packet(ref REQ tr);
endclass

function mpi_monitor::new(string name = "mpi_monitor", uvm_component parent = null);
	super.new(name, parent);
	ap = new("ap");
endfunction

function mpi_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db::get(this, "", "vif", vif))
		`uvm_error(get_type_name(), "vif is not config!")
endfunction

task mpi_monitor::run_phase(uvm_phase phase);
	mpi_xaction tr;
	while(1) begin
		tr = new("tr");
		this.collect_one_packet(tr);
		ap.write(tr);
	end
endtask

task mpi_monitor:collect_one_packet(ref REQ tr);//什么时候采集，采集哪些数据，需要看时序图、接口定义和transaction定义
    //判断什么时候开始收集
	while(1) begin
		@(posedge vif.clk_100m)//一个周期判断一次,先等时钟沿,再判断
		if(!vif.cpu_rdy_n) break;
	end
	//开始收集
	tr.cpu_addr = vif.mon_cb.cpu_addr;//给接口信号赋值时用"<="
	tr.cpu_data = vif.mon_cb.cpu_data;
	tr.cmd = (vif.mon_cn.cpu_rd_n == 0) ? 1'b0 : 1'b1;
		
endtask
