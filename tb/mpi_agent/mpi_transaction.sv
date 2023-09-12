typedef enum bit{
	READ = 1'b0;
	WRITE = 1'b1;
} act_type_enum;
class mpi_xaction extends uvm_sequence_item;
	
	act_type_enum	cmd;
	bit[15:0]		cpu_addr;
	bit[31:0]		cpu_data;
	


	//table 2
	rand bit[7:0]	tcas;
	rand bit[7:0]	tcah;
	rand bit[7:0]	tcrh;
	rand bit[7:0]	tcdrs;
	rand bit[7:0]	tcdrh;
	rand bit[7:0]	tcdch;
	rand bit[7:0]	tcdrd;
	rand bit[7:0]	tcrr;
	rand bit[7:0]	trdrh;
	rand bit[7:0]	tcdrt;
	rand bit[7:0] 	tcwh;
	rand bit[7:0]	tcdwd;
	rand bit[7:0]	tcrw;
	rand bit[7:0]	twdrh;
	
	`uvm_object_utils_begin(mpi_xaction)
		`uvm_int_filed(tcas,  UVM_ALL_ON)
		`uvm_int_filed(tcah,  UVM_ALL_ON)
		`uvm_int_filed(tcrh,  UVM_ALL_ON)
		`uvm_int_filed(tcdrs, UVM_ALL_ON)
		`uvm_int_filed(tcdrh, UVM_ALL_ON)
		`uvm_int_filed(tcdch, UVM_ALL_ON)
		`uvm_int_filed(tcdrd, UVM_ALL_ON)
		`uvm_int_filed(tcrr,  UVM_ALL_ON)
    	`uvm_int_filed(trdrh, UVM_ALL_ON)
    	`uvm_int_filed(tcdrt, UVM_ALL_ON)
    	`uvm_int_filed(tcwh,  UVM_ALL_ON)
    	`uvm_int_filed(tcdwd, UVM_ALL_ON)
    	`uvm_int_filed(tcrw,  UVM_ALL_ON)
    	`uvm_int_filed(twdrh, UVM_ALL_ON)
	`uvm_object_utils_end
	
	constraint cpu_interface_cons{
		tcas  inside {[10:20]};
		tcah  inside {[10:20]};
		tcrh  inside {[200:300]};
		tcdrs inside {[10:20]};
		tchrh inside {[30:120]};
		tcdch inside {[0:60]};
		tcdrd inside {[80:200]};
	    tcrr  inside {[10:20]};
        trdrh inside {[10:80]};
        tcdrt inside {[0:100]};
        tcwh  inside {[200:300]};
        tcdwd inside {[80:200]};
        tcrw  inside {[10:20]};
        twdrh inside {[0:80]};
	};
	
	function new(string name);
		super.new(name);
	endfunction

endclass
