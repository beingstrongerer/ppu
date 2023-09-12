class mpi_adapter extends uvm_reg_adapter;
	`uvm_object_utils(mpi_adapter)
	function new(string name = "mpi_adapter");
		super.new(name);
	endfunction
	function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		mpi_xaction tr;
		tr = new("tr");
		tr.cmd = (tr.kind == UVM_READ) ? 1'b0 : 1'b1;
		tr.cpu_addr = rw.addr;
		tr.cpu_data = rw.data;
		return tr;
	endfunction
	function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		mpi_xaction tr;
		if(!$cast(tr, bus_item))
			`uvm_error(get_type_name(), "In the bus2reg, the transaction is fail")
		rw.kind = (tr.cmd == 1'b0) ? UVM_READ : UVM_WRITE;//如果使用WRITE或者READ是否可行？
		rw.addr = tr.cpu_addr;
		rw.data = tr.cpu_data;
		rw.status = UVM_IS_OK;
	endfunction
endclass

