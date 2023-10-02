class tc_sanity extends tc_base;//这是冒烟测试吗？
	`uvm_component_utils(tc_sanity)
	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task main_phase(uvm_phase phase);
endclass
function tc_sanity::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void tc_sanity::build_phase(uvm_phase phase);
	super.build_phase(phase);//build env环境 vsqr组件
	
	//配置具体参数以及启动相关的sequence，这个sequence与uvm_test之间是独立的，只是在这里启动，但是在具体那里实现sequence是没有限制的，可以写一个sequence文件夹存放这些seqeunce并用不同的test启动，这样可以通过改变UVM_TESTNAME实现启动不同的sequence
	uvm_config_db #(int)::set(null, "*spt_optional_pkt_seq*", "seq_item_max_num", 3);//5个参数！！！，不要忘记参数化的使用，因为config机制也类似于数据管道，所以也有这个，类似的还有sequence、sequencer、driver、port、export、ap、fifo
	uvm_config_db #(bit[1:0])::set(null, "*spt_optional_pkt_seq*", "err_type", 2'b00);//00正常,01头错,10尾错,11都错
	uvm_config_db #(bit[1:0])::set(null, "*spt_optional_pkt_seq*", "payload_type", 2'b00);//00正常,01毛刺,10短包，11长包
	//启动sequence并挂载sequencer, 在vseq中通过uvm_do_on的方式挂载
endfunction

task tc_sanity::main_phase(uvm_phase phase);
	virtual_sequence vseq;
	vseq = new("vseq");
	phase.raise_objection(this);
		vseq.start(vsqr);//自动启动vseq中的body任务
	phase.drop_objection(this);
endtask
