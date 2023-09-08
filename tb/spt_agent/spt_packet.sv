import uvm_pkg::*;
`include "uvm_macros.svh" 

class spt_packet extends uvm_sequence_item;
	
	rand bit[15:0] header;
	rand bit[15:0] payload[$];
	rand bit[15:0] tailer;

	rand int       pkt_len;
	rand bit       tailer_err;
	rand bit       header_err;
	rand bit[1:0]  err_type;//00:normal;01:head_err;10:tail_err;11:head_tail_err;
	rand bit[1:0]  payload_type;//00:normal;01:glitch;10:short;11:long
	rand bit[15:0] pkt_data[];

	`uvm_object_utils_begin(spt_packet)
		`uvm_field_int(header, UVM_ALL_ON)
		`uvm_field_queue_int(payload, UVM_ALL_ON)
		`uvm_field_int(tailer, UVM_ALL_ON)
		`uvm_field_int(pkt_len, UVM_ALL_ON)
		`uvm_field_int(tailer_err, UVM_ALL_ON)
		`uvm_field_int(header_err, UVM_ALL_ON)
		`uvm_field_int(err_type, UVM_ALL_ON)
  		`uvm_field_int(payload_type, UVM_ALL_ON)
  		`uvm_field_array_int(pkt_data, UVM_ALL_ON)
	`uvm_object_utils_end
	
	constraint 	err_type_cons{
		err_type inside {[0:3]};
	}

	constraint payload_type_cons{
		payload_type inside {[0:3]};
	}

	constraint pkt_len_cons{
		pkt_len > 0;
		if(payload_type == 0)//normal packet
			pkt_len inside{[22:602]};
		else if(payload_type == 1)//glitch packet
			pkt_len inside{[1:2]};
		else if(payload_type == 2)//short packet
			pkt_len inside{[3:21]};
		else//long packet
			pkt_len inside{[603:999]}; 
	}

	constraint header_err_cons{
		if(err_type[0] == 1)
			header_err == 1'b1;
		else
			header_err == 1'b0;	
	}
	
	constraint tailer_err_cons{
		if(err_type[1] == 1)
			tailer_err == 1'b1;                       
		else
  			tailer_err == 1'b0;	
	}

	constraint header_cons{
		if(header_err==1)
			header != 16'h55d5;
		else
			header == 16'h55d5;
	}

	constraint payload_cons{
		if(pkt_len <= 2)
			payload.size == 0;
		else
			payload.size == pkt_len - 2;
	}

	function new(string name = "spt_packet");
		super.new(name);
	endfunction
	
	function bit[15:0] tailer_clc(bit[15:0] payload[]);
		
		bit[15:0] sum_16;
		bit[16:0] sum_17;
		
		sum_16 = 0;
		sum_17 = 0;
		foreach(payload[i]) begin
			sum_17 = payload[i] + sum_16;
			sum_16 = sum_17[16] + sum_17[15:0];
		end
		if(sum_16 == 16'hFFFF)
			tailer_clc = sum_16;
		else
			tailer_clc = ~sum_16;
	endfunction
	
	function void do_pack(uvm_packer packer);
		bit[15:0] tailer_result;	
		super.do_pack(packer);

		pkt_data = new[pkt_len];
		pkt_data[0] = header;
		tailer_result = tailer_clc(payload);
		if(tailer_err == 1)
			randomize(tailer) with {tailer != tailer_result;};
		else
			tailer_result = tailer_result;
		foreach(payload[i])
			pkt_data[i+1] = payload[i];
	endfunction:do_pack

	function void do_unpack(uvm_packer packer);
		super.do_unpack(packer);
	endfunction:do_unpack

	function void pre_randomize();
	endfunction:pre_randomize
	
	function void post_randomize();
	endfunction:post_randomize
endclass
