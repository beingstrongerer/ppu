class mpi_xaction extends uvm_sequence_item;
	
	bit			cmd;
	bit[15:0]	cpu_addr;
	bit[31:0]	cpu_data;

	
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
		`uvm_field_int(cmd, UVM_ALL_ON | UVM_NOPACK)
		`uvm_field_int(cpu_addr, UVM_ALL_ON | UVM_NOPACK)
		`uvm_field_int(cpu_data, UVM_ALL_ON | UVM_NOPACK)
		`uvm_field_int(tcas,  UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
		`uvm_field_int(tcah,  UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
		`uvm_field_int(tcrh,  UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
		`uvm_field_int(tcdrs, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
		`uvm_field_int(tcdrh, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
		`uvm_field_int(tcdch, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
		`uvm_field_int(tcdrd, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
		`uvm_field_int(tcrr,  UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
    	`uvm_field_int(trdrh, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
    	`uvm_field_int(tcdrt, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
    	`uvm_field_int(tcwh,  UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
    	`uvm_field_int(tcdwd, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
    	`uvm_field_int(tcrw,  UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
    	`uvm_field_int(twdrh, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
	`uvm_object_utils_end
	
	constraint cpu_interface_cons{
		tcas  >= 10;
		tcah  >= 10;
		tcrh  >= 200;
		tcdrs >= 10;
		tcdrh inside {[30:120]};
		tcdch inside {[0:60]};
		tcdrd inside {[80:200]};
	    tcrr  >= 10;
        trdrh inside {[10:80]};
        tcdrt inside {[0:100]};
        tcwh  >= 200;
        tcdwd inside {[80:200]};
        tcrw  >= 10;
        twdrh inside {[0:80]};
	};
	
	function new(string name = "mpi_xaction");
		super.new(name);
	endfunction

endclass
