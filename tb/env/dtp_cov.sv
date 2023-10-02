class dtp_cov extends uvm_subscriber#(mpi_xaction);
	`uvm_component_utils(dtp_cov)
	
	covergroup cpuif_core_test_default_value with function sample(mpi_xaction tr);//采样函数需要传递参数，coverfroup的构造函数不用传参数
		addr: coverpoint tr.cpu_addr{
			option.weight = 0;
		}
		cmd: coverpoint tr.cmd{
			option.weight = 0;
			bins read = {1'b1};//read
		}
		data: coverpoint tr.cpu_data{
			option.weight = 0;
		}
		addrXcmdXdata: cross addr, cmd, data{
			bins core_test0 = binsof(addr) intersect{'h8000} && binsof(data) intersect{'h00_0000};
			bins core_test1 = binsof(addr) intersect{'h8004} && binsof(data) intersect{'hFF_FFFF};
		}
	endgroup
	
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void write(mpi_xaction tr);
endclass

function dtp_cov::new(string name, uvm_component parent);
	super.new(name, parent);
	cpuif_core_test_default_value = new();
	cpuif_core_test_default_value.set_inst_name({get_full_name(), "dtp_cov"});
endfunction

function void dtp_cov::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

function void dtp_cov::write(mpi_xaction tr);
	cpuif_core_test_default_value.sample(tr);
endfunction
