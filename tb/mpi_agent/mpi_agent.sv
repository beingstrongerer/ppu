class mpi_agent extends uvm_agent;
	`uvm_component_utils(mpi_agent)
	
	mpi_driver drv;
	mpi_sequencer sqr;
	mpi_monitor mon;
	uvm_analysis_port #(mpi_xaction) ap;//巨大的错误，对于port类都要加具体的参数,因为默认为int类型，如果不加以说明。现实情况中，传递的都是transaction级别的数据，但也存在传递int类型的情况，所以还是要多看原代码加深理解。

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

function mpi_agent::new(string name = "mpi_agent", uvm_component parent = null);
	super.new(name, parent);
endfunction

function void mpi_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(is_active == UVM_ACTIVE) begin
		drv = mpi_driver::type_id::create("drv", this);
		sqr = mpi_sequencer::type_id::create("sqr", this);
	end
	mon = mpi_monitor::type_id::create("mon", this);

endfunction

function void mpi_agent::connect_phase(uvm_phase phase);
	
	if(is_active == UVM_ACTIVE) begin
		drv.seq_item_port.connect(sqr.seq_item_export);
	end
	ap = mon.ap;//第三种用法，将实例化后的mon.ap直接传给agent.ap
endfunction
