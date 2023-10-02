../../rtl/cpu_if.v
../../rtl/crg.v
../../rtl/spt.v 
../../rtl/test_core.v
../../rtl/pp.v
../../rtl/sram.v
../../rtl/top.v

/*../../rtl/rc_field.v
../../rtl/ro_field.v
../../rtl/rw_field.v
../../rtl/rc_cnt_field.v
../../rtl/bit_widen.v
../../rtl/cpu_if.v
../../rtl/crg.v
../../rtl/ppu_core.v
../../rtl/spt_core.v
../../rtl/spt.v
../../rtl/sram.v
../../rtl/test_core.v
../../rtl/ppu_top.v*/


+incdir+$UVM_HOME/src
$UVM_HOME/src/uvm_pkg.sv
./uvm_pkt_1.2.sv

../reg/regs.sv
../reg/reg_blks.sv
../reg/reg_model.sv

../mpi_agent/mpi_transaction.sv 
../mpi_agent/mpi_interface.sv
../mpi_agent/mpi_driver.sv
../mpi_agent/mpi_monitor.sv
../mpi_agent/mpi_sequencer.sv 
../mpi_agent/mpi_rw_sequence.sv
../mpi_agent/mpi_adapter.sv
../mpi_agent/mpi_agent.sv 

../spt_agent/spt_packet.sv
../spt_agent/spt_interface.sv
../spt_agent/spt_driver.sv
../spt_agent/spt_tx_monitor.sv
../spt_agent/spt_rx_monitor.sv 
../spt_agent/spt_sequencer.sv 
../spt_agent/spt_base_sequence.sv
../spt_agent/spt_optional_pkt_sequence.sv
../spt_agent/spt_agent.sv

../env/dtp_cov.sv 
../env/dtp_scoreboard.sv 
../env/dtp_refmodel.sv 
../env/dtp_env.sv 

../tc/virtual_sequencer.sv
../tc/virtual_sequence.sv
../tc/tc_base.sv
../tc/tc_sanity.sv

../th/harness.sv
