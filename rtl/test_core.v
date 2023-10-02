module test_core(
input clk_50m,
input rst_core_n,
input cpuif_core_test_start,
input cpuif_core_test_end,
output reg core_cpuif_d_err,
output reg core_cpuif_a_err,
output reg core_cpuif_s_end,
output reg core_cpuif_s_busy,
input [23:0]cpuif_core_test_00,
input [23:0]cpuif_core_test_01,
input [23:0]cpuif_core_test_02,
input [23:0]cpuif_core_test_03,
input [23:0]cpuif_core_test_04,
input [23:0]cpuif_core_test_05,
input [23:0]cpuif_core_test_06,
input [23:0]cpuif_core_test_07,
input [23:0]cpuif_core_test_08,
input [23:0]cpuif_core_test_09,
input [23:0]cpuif_core_test_10,
input [23:0]cpuif_core_test_11,
input [23:0]cpuif_core_test_12,
input [23:0]cpuif_core_test_13,
input [23:0]cpuif_core_test_14,
input [23:0]cpuif_core_test_15,

output reg core_spt_cs_n,
output reg core_spt_we_n,
output reg [9:0]core_spt_addr,
input [23:0]spt_core_rdata,
output reg[23:0]core_spt_wdata,
output reg core_spt_wdata_oe_n
);

reg data_bus_scan_end;
reg addr_bus_scan_end;
reg[1:0]cs,nxst;
parameter[1:0]
INIT=2'b00,
DATA_BUS_SCAN=2'b01,
ADDR_BUS_SCAN=2'b11;

wire init_st=cs==INIT;
wire data_bus_scan_st=cs==DATA_BUS_SCAN;
wire addr_bus_scan_st=cs==ADDR_BUS_SCAN;

always @(posedge clk_50m)
if(!rst_core_n)
cs<=INIT;
else
cs<=nxst;

always @(*)
case(cs)
INIT:
if(cpuif_core_test_start)
nxst=DATA_BUS_SCAN;
else 
nxst=cs;

DATA_BUS_SCAN:
if(data_bus_scan_end)
nxst=ADDR_BUS_SCAN;
else if(cpuif_core_test_end)
nxst=INIT;
else if(cpuif_core_test_start)
nxst=DATA_BUS_SCAN;
else
nxst=cs;

ADDR_BUS_SCAN:
if(addr_bus_scan_end|cpuif_core_test_end)
nxst=INIT;
else if(cpuif_core_test_start)
nxst=DATA_BUS_SCAN;
else
nxst=cs;
endcase


always @(posedge clk_50m)
if(!rst_core_n)
core_spt_cs_n=1'b1;
else if(cpuif_core_test_start)
core_spt_cs_n<=1'b0;

reg cnt;
always @(posedge clk_50m)
if(!rst_core_n)
cnt<=1'b0;
else if(cpuif_core_test_start)
cnt<=1'b0;
else if(data_bus_scan_st&core_spt_addr==10'h3ff&cnt==0)
cnt<=1'b1;
else
cnt<=1'b0;


always @(posedge clk_50m)
if(!rst_core_n)
core_spt_addr<=10'h000;
else if(cpuif_core_test_start)
core_spt_addr<=10'h000;
else if(data_bus_scan_st&core_spt_addr==10'h3ff&cnt==0&~core_spt_we_n)
core_spt_addr<=10'h3ff;
else if(data_bus_scan_st|addr_bus_scan_st)
core_spt_addr<=core_spt_addr+1;


always @(posedge clk_50m)
if(!rst_core_n)
core_spt_we_n<=1'b1;
else if(cpuif_core_test_start|data_bus_scan_end)
core_spt_we_n<=1'b0;
else if(data_bus_scan_st&core_spt_addr==10'h3ff&(cnt==1&~core_spt_we_n|cnt==0&core_spt_we_n))
core_spt_we_n<=~core_spt_we_n;
else if(addr_bus_scan_st&core_spt_addr==10'h3ff)
core_spt_we_n<=~core_spt_we_n;


always@(posedge clk_50m)
if(!rst_core_n)
core_spt_wdata_oe_n<=1'b1;
else if(cpuif_core_test_start|data_bus_scan_end)
core_spt_wdata_oe_n<=1'b0;
else if(data_bus_scan_st&core_spt_addr==10'h3ff&cnt==0)
core_spt_wdata_oe_n<=~core_spt_wdata_oe_n;
else if (addr_bus_scan_st&core_spt_addr==10'h3ff)
core_spt_wdata_oe_n<=~core_spt_wdata_oe_n;

reg [3:0]num;
always @(posedge clk_50m)
if(!rst_core_n)
num<=4'h0;
else if(cpuif_core_test_start)
num<=4'h0;
else if(core_spt_we_n&core_spt_addr==10'h3fe)
num<=num+1;

reg[23:0]core_spt_wdata_data;
always @(*)
case(num)
00:core_spt_wdata_data<=cpuif_core_test_00;
01:core_spt_wdata_data<=cpuif_core_test_01;
02:core_spt_wdata_data<=cpuif_core_test_02;
03:core_spt_wdata_data<=cpuif_core_test_03;
04:core_spt_wdata_data<=cpuif_core_test_04;
05:core_spt_wdata_data<=cpuif_core_test_05;
06:core_spt_wdata_data<=cpuif_core_test_06;
07:core_spt_wdata_data<=cpuif_core_test_07;
08:core_spt_wdata_data<=cpuif_core_test_08;
09:core_spt_wdata_data<=cpuif_core_test_09;
10:core_spt_wdata_data<=cpuif_core_test_10;
11:core_spt_wdata_data<=cpuif_core_test_11;
12:core_spt_wdata_data<=cpuif_core_test_12;
13:core_spt_wdata_data<=cpuif_core_test_13;
14:core_spt_wdata_data<=cpuif_core_test_14;
15:core_spt_wdata_data<=cpuif_core_test_15;
endcase
reg d_err;
always @(*)
case(num)
00:d_err<=spt_core_rdata!=cpuif_core_test_00;
01:d_err<=spt_core_rdata!=cpuif_core_test_01;
02:d_err<=spt_core_rdata!=cpuif_core_test_02;
03:d_err<=spt_core_rdata!=cpuif_core_test_03;
04:d_err<=spt_core_rdata!=cpuif_core_test_04;
05:d_err<=spt_core_rdata!=cpuif_core_test_05;
06:d_err<=spt_core_rdata!=cpuif_core_test_06;
07:d_err<=spt_core_rdata!=cpuif_core_test_07;
08:d_err<=spt_core_rdata!=cpuif_core_test_08;
09:d_err<=spt_core_rdata!=cpuif_core_test_09;
10:d_err<=spt_core_rdata!=cpuif_core_test_10;
11:d_err<=spt_core_rdata!=cpuif_core_test_11;
12:d_err<=spt_core_rdata!=cpuif_core_test_12;
13:d_err<=spt_core_rdata!=cpuif_core_test_13;
14:d_err<=spt_core_rdata!=cpuif_core_test_14;
15:d_err<=spt_core_rdata!=cpuif_core_test_15;
endcase
assign a_err=addr_bus_scan_st&(spt_core_rdata!=core_spt_addr);
always @(posedge clk_50m)
if(!rst_core_n)
core_cpuif_d_err<=1'b0;
else if(cpuif_core_test_start)
core_cpuif_d_err<=1'b0;
else if(data_bus_scan_st&d_err)
core_cpuif_d_err<=1'b1;

always @(posedge clk_50m)
if(!rst_core_n)
core_cpuif_a_err<=1'b0;
else if(cpuif_core_test_start)
core_cpuif_a_err<=1'b0;
else if(addr_bus_scan_st&a_err)
core_cpuif_a_err<=1'b1;

always @(posedge clk_50m)
if(!rst_core_n)
core_cpuif_s_end<=1'b0;
else if(cpuif_core_test_start)
core_cpuif_s_end<=1'b0;
else if(addr_bus_scan_end)
core_cpuif_s_end<=1'b1;

always @(posedge clk_50m)
if(!rst_core_n)
core_cpuif_s_busy<=1'b0;
else if(cpuif_core_test_start)
core_cpuif_s_busy<=1'b1;
else if(addr_bus_scan_end|cpuif_core_test_end)
core_cpuif_s_busy<=1'b0;
wire[23:0]core_spt_wdata_addr;
assign core_spt_wdata_addr=core_spt_addr+1;

always @(posedge clk_50m)
if(!rst_core_n)
core_spt_wdata<=24'h00_0000;
else if(data_bus_scan_end|cpuif_core_test_start)
core_spt_wdata<=24'h00_0000;
else if(data_bus_scan_st)
if(core_spt_addr==10'h3ff&cnt==0&~core_spt_we_n)
core_spt_wdata<=~core_spt_wdata_data;
else
core_spt_wdata<=core_spt_wdata_data;
else if(addr_bus_scan_st)
core_spt_wdata<=core_spt_wdata_addr;

always@(posedge clk_50m)
if(!rst_core_n)
data_bus_scan_end<=1'b0;
else if(data_bus_scan_st&num==15&core_spt_addr==10'h3fe&core_spt_we_n)
data_bus_scan_end<=1'b1;
else
data_bus_scan_end<=1'b0;


always@(posedge clk_50m)
if(!rst_core_n)
addr_bus_scan_end<=1'b0;
else if(addr_bus_scan_st&core_spt_addr==10'h3fe&core_spt_we_n)
addr_bus_scan_end<=1'b1;
else
addr_bus_scan_end<=1'b0;
endmodule
