class mpi_rw_sequence extends uvm_sequence #(mpi_xaction);
	`uvm_object_utils(mpi_rw_sequence)
	`uvm_declare_p_sequencer(mpi_sequencer)
	extern function new(string name = "mpi_rw_sequence");
	extern virtual task body();
endclass
function mpi_rw_sequence::new(string name = "mpi_rw_sequence");
	super.new(name);
endfunction

task mpi_rw_sequence::body();
	uvm_status_e rw_status;
	uvm_reg_data_t rw_data;

	/*p_sequencer.reg_md.port_mode_blk.mode_sel.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.port_sel.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'h55, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.port_sel.write(rw_status, 1'b1, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'h55, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'h11, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'hAA, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.port_sel.read(rw_status, rw_data, UVM_FRONTDOOR);*/
	p_sequencer.reg_md.test_data_blk.test_data0.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data1.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data2.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data3.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data4.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data5.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data6.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data7.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data8.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data9.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data10.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data11.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data12.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data13.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data14.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data15.read(rw_status, rw_data, UVM_FRONTDOOR);
	/*p_sequencer.reg_md.test_data_blk.test_data0.write(rw_status, 'h0, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data1.write(rw_status, 'h1, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data2.write(rw_status, 'h2, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data3.write(rw_status, 'h3, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data4.write(rw_status, 'h4, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data5.write(rw_status, 'h5, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data6.write(rw_status, 'h6, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data7.write(rw_status, 'h7, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data8.write(rw_status, 'h8, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data9.write(rw_status, 'h9, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data10.write(rw_status, 'ha, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data11.write(rw_status, 'hb, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data12.write(rw_status, 'hc, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data13.write(rw_status, 'hd, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data14.write(rw_status, 'he, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data15.write(rw_status, 'hd, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data0.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data1.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data2.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data3.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data4.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data5.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data6.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data7.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data8.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data9.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data10.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data11.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data12.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data13.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data14.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_data_blk.test_data15.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.spt_cnt_blk.spt_head_err_cnt.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.spt_cnt_blk.spt_tail_err_cnt.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.spt_cnt_blk.spt_sht_pkt_cnt.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.spt_cnt_blk.spt_lng_pkt_cnt.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.spt_cnt_blk.spt_ok_pkt_cnt.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'hAA, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'h55, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'h55, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'hAA, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);
	p_sequencer.reg_md.port_mode_blk.mode_sel.read(rw_status, rw_data, UVM_FRONTDOOR);

	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'h55, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);	
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'h55, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);	
	p_sequencer.reg_md.port_mode_blk.mode_sel.write(rw_status, 8'hAA, UVM_FRONTDOOR);
    p_sequencer.reg_md.port_mode_blk.port_sel.write(rw_status, 1'b1, UVM_FRONTDOOR);
	p_sequencer.reg_md.test_status.read(rw_status, rw_data, UVM_FRONTDOOR);*/
endtask
