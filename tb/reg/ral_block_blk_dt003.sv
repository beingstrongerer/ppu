import uvm_pkg::*;
`include "uvm_macros.svh"

class ral_reg_blk_dt003_port_sel extends uvm_reg;
	rand uvm_reg_field port_sel;
	
	function new(string name = "ral_reg_blk_dt003_port_sel");
		super.new(name,8,UVM_NO_COVERAGE);
	endfunction: new
	
	virtual function void build();
		this.port_sel = uvm_reg_field::type_id::create("port_sel",,get_full_name());
		this.port_sel.configure(this,1,0,"RW",0,1'h0,1,0,1);
	endfunction: build
	
	`uvm_object_utils(ral_reg_blk_dt003_port_sel)
endclass: ral_reg_blk_dt003_port_sel

class ral_block_blk_dt003 extends uvm_reg_block;
	rand ral_reg_blk_dt003_port_sel port_sel;
	rand uvm_reg_field port_sel_port_sel;
	
	function new(string name = "blk_dt003");
		super.new(name,build_coverage(UVM_NO_COVERAGE));	
	endfunction: new
	
	virtual function void build();
		this.default_map = create_map("",0,4,UVM_LITTLE_ENDIAN,0);
		
		this.port_sel = ral_reg_blk_dt003_port_sel::type_id::create("port_sel",,get_full_name);
		this.port_sel.configure(this,null,"");
		this.port_sel.build();
			this.port_sel.add_hdl_path('{
			'{"U_CPU_IF.U_CPU_IF_REG.port_sel",0,1}
			});
		this.default_map.add_reg(this.port_sel,16'h4000,"RW",0);
		this.port_sel_port_sel = this.port_sel.port_sel;
	endfunction: build
	
	`uvm_object_utils(ral_block_blk_dt003);
endclass: ral_block_blk_dt003
