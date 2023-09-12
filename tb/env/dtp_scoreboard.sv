class dtp_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(dtp_scoreboard)
	
	spt_packet expect_pkts[$];
	uvm_blocking_get_port #(spt_packet) exp_port, mon_port;//port、export、ap、driver、sequence、sequencer都要注意这个参数化类的使用
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass

function dtp_scoreboard::new(string name = "dtp_scoreboard", uvm_component parent = null);
	super.new(name, parent);
endfunction

function void dtp_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	exp_port = new("exp_port", this);
	mon_port = new("mon_port", this);
endfunction

task dtp_scoreboard::run_phase(uvm_phase phase);
	super.run_phase(phase);
	spt_packet get_export, get_mon;
	int err = 0;
	fork//两个进程
		while(1) begin//rm进程
			exp_port.get(get_export);
			expect_pkts.push_back(get_export);
		end
		
		while(1) begin//mon进程
			mon_port.get(get_mon);
			if(expect_pkts.size() > 0) begin//动态数组用size？队列用size()?
				foreach(get_mon.payload[i])begin
					if(get_mon.payload[i] != get_expect.payload[i])
						err++;
				end
				if(err!=0)
					`uvm_error(get_type_name(), $sformatf("compare fail,the total errors is %d", err))
				else
					`uvm_info(get_type_name(), "compare success", UVM_HIGH)	
			end
			else
				`uvm_error(get_type_name(), "rm packet is not ready!")
		end
	join
endtask
