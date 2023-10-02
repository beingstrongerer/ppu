class tc_base extends uvm_test;
	`uvm_component_utils(tc_base)
	dtp_env env;
	virtual_sequencer vsqr;
	//vsqr
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);//在这里进行testbench相关参数的配置以及组建的实例化
	extern function void connect_phase(uvm_phase phase);
endclass

function tc_base::new(string name, uvm_component parent);//这个test的层次为test_top,直接在null(uvm_top下)
	super.new(name, parent);
endfunction

function void tc_base::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_full_name(), "build_phase starts", UVM_LOW)
	//实例化
	env = dtp_env::type_id::create("env", this);//test_top
	vsqr = virtual_sequencer::type_id::create("vsqr", this);
	//配置相关参数，当然也包括启动sequence，可以使用vritual sequence也可以使用普通的sequence
	//uvm_config_db #(uvm_object_wrapper)::set(null, "*vsqr.main_phase*", "default_sequence", virtual_sequence::type_id::get());//完成vsqr和vseq的绑定
	//留给继承类进行

	`uvm_info(get_full_name(), "build_phase is ending", UVM_LOW)
endfunction

function void tc_base::connect_phase(uvm_phase phase);
	`uvm_info(get_full_name(), "connect_phase is starting", UVM_LOW)
	super.connect_phase(phase);
	//vsqr中的sqr连接
	vsqr.spt_sqr = env.spt_agt.sqr;
	vsqr.mpi_sqr = env.mpi_agt.sqr;
	`uvm_info(get_full_name(), "connect_phase is ending", UVM_LOW)
endfunction
