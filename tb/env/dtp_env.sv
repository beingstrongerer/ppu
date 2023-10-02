class dtp_env extends uvm_env;
	`uvm_component_utils(dtp_env)
	spt_agent spt_agt;
	mpi_agent mpi_agt;
	dtp_refmodel dtp_rm;
	dtp_scoreboard dtp_sb;
	reg_model reg_md;//为了在rm中使用，那为什么不直接config到rm中去呢？
	//ral_block_blk_dt003	reg_md;
	mpi_adapter adapter;
	//dtp_cov f_cov;
	//数据管道、传输等都要考虑数据类型，也就是在参数化类的时候进行具体数据类型设置
	uvm_tlm_analysis_fifo #(spt_packet) txmon2rm_fifo;
	uvm_tlm_analysis_fifo #(spt_packet) rm2sb_fifo;
	uvm_tlm_analysis_fifo #(spt_packet) rxmon2sb_fifo;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

function dtp_env::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void dtp_env::build_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"build_phase() start...",UVM_LOW);
	super.build_phase(phase);
	//组件创建
	spt_agt = spt_agent::type_id::create("spt_agt", this);
	mpi_agt = mpi_agent::type_id::create("mpi_agt", this);
	dtp_rm = dtp_refmodel::type_id::create("dtp_rm", this);
	dtp_sb = dtp_scoreboard::type_id::create("dtp_sb", this);
	reg_md = reg_model::type_id::create("reg_md", this);//T::type_id::create(name, parent, message),对于regmodel和predictor都可以当成是组件，虽然他们是object类型的，而adapter内部没有使用factory机制，所以只能使用new方法实例化
	//通信端口创建
	reg_md.configure(null, "");//对寄存器模型进行配置
	reg_md.build();//构建reg以及map,使用map绑定vsqr和adapter，需要在test中进行吗？不对，可以在这里的connet中进行，因为test中的vsqr以及build过了，而adapter也是在env中的，所可以在env中的connect进行set_sequencer
	reg_md.lock_model();//名字是lock_model()
	reg_md.reset();
	adapter = new("adapter");
	txmon2rm_fifo = new("txmon2rm_fifo", this);//端口本质是一个uvm_component,但是没有使用factory机制
	rm2sb_fifo = new("rm2sb_fifo", this);
	rxmon2sb_fifo = new("rxmon2sb_fifo", this);
//	f_cov = dtp_cov::type_id::create("f_cov", this);
	`uvm_info(get_type_name(),"build_phase() end...",UVM_LOW);
endfunction

function void dtp_env::connect_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"connect_phase() start...",UVM_LOW);
	super.connect_phase(phase);
	spt_agt.ap.connect(txmon2rm_fifo.analysis_export);
	dtp_rm.port.connect(txmon2rm_fifo.blocking_get_export);

	dtp_rm.ap.connect(rm2sb_fifo.analysis_export);
	dtp_sb.exp_port.connect(rm2sb_fifo.blocking_get_export);

	spt_agt.mon_rx.ap.connect(rxmon2sb_fifo.analysis_export);
	dtp_sb.mon_port.connect(rxmon2sb_fifo.blocking_get_export);
	//env.rm.reg_md使用uvm_config_db配置，而不在env的connect_phase中进行
	reg_md.default_map.set_sequencer(mpi_agt.sqr, adapter);//在reg_md执行build()时,创建了map
	reg_md.default_map.set_auto_predict(1);
	dtp_rm.reg_md = reg_md;
	mpi_agt.sqr.reg_md = reg_md;

//	mpi_agt.mon.ap.connect(f_cov.analysis_export);
	`uvm_info(get_type_name(),"connect_phase() end...",UVM_LOW);
endfunction
