module pp(
input rst_n,
input clk_100m,
input scan_en,
input test_mode,

input CPU_CS_N,
input CPU_RD_N,
input CPU_WE_N,
input [15:0]CPU_ADDR,
inout [31:0]CPU_DATA,
output CPU_RDY_N,

input vid_in,
input [15:0]data_in,
output vid_out, 
output [15:0]data_out,
output sram_clk,
output SRAM_CS_A_N,
output SRAM_WE_A_N,
output [9:0]SRAM_ADDR_A,
input [23:0]SRAM_RDATA_A,
output [23:0]SRAM_WDATA_A,
output SRAM_CS_B_N,
output SRAM_WE_B_N,
output [9:0]SRAM_ADDR_B,
input [23:0]SRAM_RDATA_B,
output [23:0]SRAM_WDATA_B


);
wire[23:0]cpuif_core_test_00;
wire[23:0]cpuif_core_test_01;
wire[23:0]cpuif_core_test_02;
wire[23:0]cpuif_core_test_03;
wire[23:0]cpuif_core_test_04;
wire[23:0]cpuif_core_test_05;
wire[23:0]cpuif_core_test_06;
wire[23:0]cpuif_core_test_07;
wire[23:0]cpuif_core_test_08;
wire[23:0]cpuif_core_test_09;
wire[23:0]cpuif_core_test_10;
wire[23:0]cpuif_core_test_11;
wire[23:0]cpuif_core_test_12;
wire[23:0]cpuif_core_test_13;
wire[23:0]cpuif_core_test_14;
wire[23:0]cpuif_core_test_15;

wire[31:0]ok_pkt_cnt;

wire[23:0]spt_core_rdata;
wire[23:0]core_spt_wdata;
wire[9:0]core_spt_addr;
//wire[23:0]SRAM_WDATA_B;
//wire[23:0]SRAM_RDATA_B;
//wire[23:0]SRAM_WDATA_A;
//wire[23:0]SRAM_RDATA_A;


wire[31:0]CPU_RDATA;
wire[31:0]CPU_WDATA;

spt spt_0(
.clk_100m(clk_100m),
.rst_spt_n(rst_spt_n),

.cpuif_mode(cpuif_mode),
.cpuif_port_sel(cpuif_port_sel),

.spt_cpuif_head_err(spt_cpuif_head_err),
.spt_cpuif_tail_err(spt_cpuif_tail_err),
.spt_cpuif_short_pkt(spt_cpuif_short_pkt),
.spt_cpuif_long_pkt(spt_cpuif_long_pkt),
.spt_cpuif_ok_pkt(spt_cpuif_ok_pkt),
.ok_pkt_cnt(ok_pkt_cnt),

.core_spt_cs_n(core_spt_cs_n),
.core_spt_we_n(core_spt_we_n),
.core_spt_addr(core_spt_addr),
.spt_core_rdata(spt_core_rdata),
.core_spt_wdata(core_spt_wdata),
.core_spt_wdata_oe_n(core_spt_wdata_oe_n),

.vid_in(vid_in),
.data_in(data_in),
.vid_out(vid_out),
.data_out(data_out),

.SRAM_CS_A_N(SRAM_CS_A_N),
.SRAM_WE_A_N(SRAM_WE_A_N),
.SRAM_ADDR_A(SRAM_ADDR_A),
.SRAM_RDATA_A(SRAM_RDATA_A),
.SRAM_WDATA_A(SRAM_WDATA_A),
.SRAM_WDATA_OEA_N(SRAM_WDATA_OEA_N),

.SRAM_CS_B_N(SRAM_CS_B_N),
.SRAM_WE_B_N(SRAM_WE_B_N),
.SRAM_ADDR_B(SRAM_ADDR_B),
.SRAM_RDATA_B(SRAM_RDATA_B),
.SRAM_WDATA_B(SRAM_WDATA_B),
.SRAM_WDATA_OEB_N(SRAM_WDATA_OEB_N)); 

test_core test_core_0(
.clk_50m(clk_50m),
.rst_core_n(rst_core_n),
.cpuif_core_test_start(cpuif_core_test_start),
.cpuif_core_test_end(cpuif_core_test_end),
.core_cpuif_d_err(core_cpuif_d_err),
.core_cpuif_a_err(core_cpuif_a_err),
.core_cpuif_s_end(core_cpuif_s_end),
.core_cpuif_s_busy(core_cpuif_s_busy),
.cpuif_core_test_00(cpuif_core_test_00),
.cpuif_core_test_01(cpuif_core_test_01),
.cpuif_core_test_02(cpuif_core_test_02),
.cpuif_core_test_03(cpuif_core_test_03),
.cpuif_core_test_04(cpuif_core_test_04),
.cpuif_core_test_05(cpuif_core_test_05),
.cpuif_core_test_06(cpuif_core_test_06),
.cpuif_core_test_07(cpuif_core_test_07),
.cpuif_core_test_08(cpuif_core_test_08),
.cpuif_core_test_09(cpuif_core_test_09),
.cpuif_core_test_10(cpuif_core_test_10),
.cpuif_core_test_11(cpuif_core_test_11),
.cpuif_core_test_12(cpuif_core_test_12),
.cpuif_core_test_13(cpuif_core_test_13),
.cpuif_core_test_14(cpuif_core_test_14),
.cpuif_core_test_15(cpuif_core_test_15),

.core_spt_cs_n(core_spt_cs_n),
.core_spt_we_n(core_spt_we_n),
.core_spt_addr(core_spt_addr),
.spt_core_rdata(spt_core_rdata),
.core_spt_wdata(core_spt_wdata),
.core_spt_wdata_oe_n(core_spt_wdata_oe_n));

cpu_if cpu_if_0(
.clk_50m(clk_50m),
.rst_core_n(rst_core_n),
.scan_en(scan_en),
.test_mode(test_mode),
.cpuif_mode(cpuif_mode),
.cpuif_port_sel(cpuif_port_sel),
.spt_cpuif_head_err(spt_cpuif_head_err),
.spt_cpuif_tail_err(spt_cpuif_tail_err),
.spt_cpuif_short_pkt(spt_cpuif_short_pkt),
.spt_cpuif_long_pkt(spt_cpuif_long_pkt),
.spt_cpuif_ok_pkt(spt_cpuif_ok_pkt),

.cpuif_core_test_start(cpuif_core_test_start),
.cpuif_core_test_end(cpuif_core_test_end),
.ok_pkt_cnt(ok_pkt_cnt),
.core_cpuif_d_err(core_cpuif_d_err),
.core_cpuif_a_err(core_cpuif_a_err),
.core_cpuif_s_end(core_cpuif_s_end),
.core_cpuif_s_busy(core_cpuif_s_busy),
.cpuif_core_test_00(cpuif_core_test_00),
.cpuif_core_test_01(cpuif_core_test_01),
.cpuif_core_test_02(cpuif_core_test_02),
.cpuif_core_test_03(cpuif_core_test_03),
.cpuif_core_test_04(cpuif_core_test_04),
.cpuif_core_test_05(cpuif_core_test_05),
.cpuif_core_test_06(cpuif_core_test_06),
.cpuif_core_test_07(cpuif_core_test_07),
.cpuif_core_test_08(cpuif_core_test_08),
.cpuif_core_test_09(cpuif_core_test_09),
.cpuif_core_test_10(cpuif_core_test_10),
.cpuif_core_test_11(cpuif_core_test_11),
.cpuif_core_test_12(cpuif_core_test_12),
.cpuif_core_test_13(cpuif_core_test_13),
.cpuif_core_test_14(cpuif_core_test_14),
.cpuif_core_test_15(cpuif_core_test_15),

.CPU_CS_N(CPU_CS_N),
.CPU_RD_N(CPU_RD_N),
.CPU_WE_N(CPU_WE_N),
.CPU_ADDR(CPU_ADDR),
.CPU_RDATA(CPU_RDATA),
.CPU_RDATA_OE_N(CPU_RDATA_OE_N),
.CPU_WDATA(CPU_WDATA),
.CPU_RDY_N(CPU_RDY_N),
.CPU_RDY_OE_N(CPU_RDY_OE_N));

crg crg_0(
.clk_100m(clk_100m),
.rst_n(rst_n),
.cpuif_mode(cpuif_mode),
.sram_clk(sram_clk),
.clk_50m(clk_50m),
.rst_core_n(rst_core_n),
.rst_spt_n(rst_spt_n));
//reg [23:0]SRAM_RDATA_B_temp; 
assign CPU_WDATA=CPU_RDATA_OE_N ? CPU_DATA :32'hz;
assign CPU_DATA=~CPU_RDATA_OE_N ? CPU_RDATA :32'hz;

//assign SRAM_WDATA_A=SRAM_WDATA_A;
//assign SRAM_WDATA_B=SRAM_WDATA_B;
/*assign SRAM_RDATA_A=SRAM_WE_A_N ? SRAM_DATA_A:24'hz;
assign SRAM_RDATA_B=SRAM_RDATA_B_temp;

always@(posedge clk_100m)
if(!rst_n)
SRAM_RDATA_B_temp<=24'h0;
else 
SRAM_RDATA_B_temp<=SRAM_WE_B_N ? SRAM_DATA_B:24'hz;*/
endmodule
