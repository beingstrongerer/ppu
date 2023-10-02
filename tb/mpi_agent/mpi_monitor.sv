class mpi_monitor extends uvm_monitor #(mpi_xaction);

	`uvm_component_utils(mpi_monitor)
	virtual mpi_interface vif;
	uvm_analysis_port #(mpi_xaction) ap;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);	
	extern task collect_one_packet(mpi_xaction tr);

endclass

function mpi_monitor::new(string name, uvm_component parent);
	super.new(name, parent);
	ap = new("ap", this);//ap、port、export、fifo本质属于component，所以需要两个参数
endfunction

function void mpi_monitor::build_phase(uvm_phase phase);
	`uvm_info(get_full_name(), "build_phase() starts", UVM_LOW)
	super.build_phase(phase);
	if(!uvm_config_db #(virtual mpi_interface)::get(this, "", "vif", vif))
		`uvm_error(get_type_name(), "vif is not config!")
	`uvm_info(get_full_name(), "build_phase() ends", UVM_LOW)
endfunction


task mpi_monitor::run_phase(uvm_phase phase);//对于寄存器模型，write和read是通过前门或者后门的方式进行，其比较直接进行，而不是通过monitor、rm和scoreboard的方式进行的比较，所以不写monitor也行，但是如果是predictor的方式则需要写monitor	
	mpi_xaction tr;
	`uvm_info(get_full_name(), "run_phase() starts", UVM_LOW)
	while(1) begin//driver和monitor一定是一个无限循环的，具体结束时间由vseq控制
		tr = new("tr");
		collect_one_packet(tr);
		ap.write(tr);//写给rm以及cov
	end
	#10ns;
	`uvm_info(get_full_name(), "run_phase() ends", UVM_LOW)

endtask

task mpi_monitor::collect_one_packet(mpi_xaction tr);//什么时候采集，采集哪些数据，需要看时序图、接口定义和transaction定义
    //判断什么时候开始收集
	while(1) begin
		@(posedge vif.clk_100m)//一个周期判断一次,先等时钟沿,再判断
		if(!vif.mon_cb.cpu_rdy_n & !vif.mon_cb.cpu_cs_n) break;
	end
	//开始收集
	tr.cpu_addr = vif.mon_cb.cpu_addr;//给接口信号赋值时用"<="
	tr.cmd = (vif.mon_cb.cpu_we_n == 0) ? 1'b0 : 1'b1;//0:w 1:r
	tr.cpu_data = vif.mon_cb.cpu_data;
endtask
