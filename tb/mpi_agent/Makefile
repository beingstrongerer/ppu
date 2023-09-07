#-------------------------------------------------------------------------------------------------------
comp  : clean vcs sim verdi
#-------------------------------------------------------------------------------------------------------
vcs   :
	vcs     \
              -timescale=1ns/1ps \
              -full64  +vc  +v2k  -sverilog  -debug_acc+all \
			  +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv \
			  -P $(VERDI_HOME)/share/PLI/VCS/LINUXAMD64/novas.tab \
			  $(VERDI_HOME)/share/PLI/VCS/LINUXAMD64/pli.a \
			  $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS \
			  -f filelist.f &
#-------------------------------------------------------------------------------------------------------
sim :
	./simv -l sim.log & #sim指令定义为执行simv文件，然后输出sim.log
#------------------------------------------------------------------------------------------------------
verdi  :
	verdi -f filelist.f -ssf tb.fsdb -nologo &
#-------------------------------------------------------------------------------------------------------
clean  :
	 rm  -rf  *~  core  csrc  simv*  vc_hdrs.h  ucli.key  urg* *.log  novas.* *.fsdb* verdiLog  64* DVEfiles *.vpd
#-------------------------------------------------------------------------------------------------------
# 	vcs -cpp g++-4.8 -cc gcc-4.8
# -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-neede
