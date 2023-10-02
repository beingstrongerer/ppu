############# user variables #############
##########################################
TB=harness
SEED=1
TESTNAME=tc_sanity

######### environmental variables ########
##########################################
COMP = vcs -full64 -debug_acc+dmptf\
	   -ntb_opts uvm-1.2\
	   -sverilog\
	   -debug_acess+all\
	   -timescale=1ns/1ns\
	   -f filelist.f\
	   -l com.log\
	   -cm line+tgl+branch\
	   -cm_name mpi_test_name1\
	   #-R 
	   
RUN = ./simv\
	  -l sim.log\
	  +ntb_random_seed=$(SEED)\
	  +UVM_TESTNAME=$(TESTNAME)\
	  #+UVM_VERBOSITY=UVM_HIGH



#-------------------------------------------------------------------------------------------------------
all  : 	clean vcs sim &
vcs:
	$(COMP) -top $(TB) -R
sim :
	$(RUN)

verdi  :
	verdi -f filelist.f -ssf ppu.fsdb -nologo&
	

cov:
	urg -full64 -format both -dir $(TB).simv.vdb
clean  :
	 rm  -rf  *~  core  csrc  simv*  vc_hdrs.h  ucli.key  urg* *.log  novas.* *.fsdb* verdiLog  64* DVEfiles *.vpd *.vdb
#-------------------------------------------------------------------------------------------------------
# 	vcs -cpp g++-4.8 -cc gcc-4.8
# -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-neede
