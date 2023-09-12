class dtp_refmodel extends uvm_component;
	`uvm_component_utils(dtp_refmodel)

	uvm_blocking_get_port #(spt_packet) in_port;
	uvm_analysis_port #(spt_packet) ap;
	reg_model reg_md;

	extern function new(string name, uvm_component parent);
	extends function void build_phsae(uvm_phase phase);
	extends task run_phase(uvm_phase phase);
	extends function bit tailer_error(spt_packet tr);

endclass

function dtp_refmodel::new(string name = "dtp_refmodel", uvm_component phase = null);
	super.new(name, parent);

endfunction

function void dtp_refmodel::build_phsae(uvm_phase phase);
	super.build_phsae(phase);
   	in_port = new("in_port", this);//本质是一个uvm_component，但是没有注册，所是使用new()实例化
	ap = new("ap", this); 
	if(!uvm_config_db::get(this, "", "reg_md", reg_md));//从test中传递来的寄存器模型句柄
		`uvm_error(get_type_name(), "In the rm, the reg_md is not config!")
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
		in_port.get(in_tr);
		in_tr.do_unpack();//pkt_data->header,payload,hailer
		//包处理功能
		if(in_tr.pkt_data.size <= 4) 
			break;
		else if(in_tr.header != 16'h55d5) begin
			header_err_cnt++
			break;
		end
		else if(in_tr.pkt_data.size-2 < 20) begin
			short_pkt_cnt++;
			break;
		end
		else if(in_tr.pkt_data.size - 2) > 600) begin
			long_pkt_cnt++
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
			foreach(in_tr.pkt_data[i])
				out_tr.payload.push_front(in_tr.pkt_data[i]);
			ap.write(tr);
		end
						
	end
	
endtask

function bit dtp_refmodel::tailer_error(spt_packet tr);
	
	bit error;
	bit[15:0] tailer_result;
	tailer_reselt = tr.tailer_clc(tr.payload);
	if(tailer_result != tr.tailer )
		error = 1'b1;
	else
		error = 1'b0;
	return error;
	
endfunction
