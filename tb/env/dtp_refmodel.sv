class dtp_refmodel extends uvm_component;
	`uvm_component_utils(dtp_refmodel)

	uvm_blocking_get_port #(spt_packet) port;
	uvm_analysis_port #(spt_packet) ap;
	reg_model reg_md;
	//ral_block_blk_dt003 reg_md;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function bit tailer_error(spt_packet tr);

endclass

function dtp_refmodel::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void dtp_refmodel::build_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"build_phase() starts...",UVM_LOW);
	super.build_phase(phase);
   	port = new("port", this);//本质是一个uvm_component，但是没有注册，所是使用new()实例化
	ap = new("ap", this); 
	`uvm_info(get_type_name(),"build_phase() ends...",UVM_LOW);
endfunction

task dtp_refmodel::run_phase(uvm_phase phase);
	//定义输入变量和输出变量
	spt_packet in_tr, out_tr;
	int header_err_cnt = 0;
	int tailer_err_cnt = 0;
	int short_pkt_cnt = 0;
	int long_pkt_cnt = 0;
	int normal_pky_cnt = 0;

	//模仿DUT功能，得到transaction级输出变量
	while(1) begin
		port.get(in_tr);
		in_tr.unpack();//pkt_data->header,payload,hailer
		//包处理功能
		if(in_tr.pkt_len <= 2) 
			break;
		else if(in_tr.header != 16'h55d5) begin
			header_err_cnt++;
			break;
		end
		else if( (in_tr.pkt_len - 2) < 20) begin
			short_pkt_cnt++;
			break;
		end
		else if( (in_tr.pkt_len - 2) > 600) begin
			long_pkt_cnt++;
			break;
		end		
		else if( tailer_error(in_tr) ) begin
			tailer_err_cnt++;
			break;
		end
		else begin
			//包转发功能:剥离头域和尾域，并进行字节序转换输出
			normal_pky_cnt++;
			out_tr = new("out_tr");
			foreach(in_tr.payload[i])//这个需要先去掉头和尾域后再字节反转
				out_tr.payload.push_back({in_tr.payload[i][7:0], in_tr.payload[i][15:8]});
			ap.write(out_tr);
		end
						
	end
	
endtask

function bit dtp_refmodel::tailer_error(spt_packet tr);
	
	bit error;
	bit[15:0] tailer_result;
	tailer_result = tr.tailer_clc();
	if(tailer_result != tr.tailer )
		error = 1'b1;
	else
		error = 1'b0;
	return 1'b0;
	
endfunction
