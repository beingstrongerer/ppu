module spt(
input clk_100m,
input rst_spt_n,

input cpuif_mode,
input cpuif_port_sel,

output reg spt_cpuif_head_err,
output reg spt_cpuif_tail_err,
output reg spt_cpuif_short_pkt,
output reg spt_cpuif_long_pkt,
output reg spt_cpuif_ok_pkt,
input [31:0]ok_pkt_cnt,

input core_spt_cs_n,
input core_spt_we_n,
input [9:0]core_spt_addr,
output [23:0]spt_core_rdata,
input [23:0]core_spt_wdata,
input core_spt_wdata_oe_n,

input vid_in,
input [15:0]data_in,
output reg vid_out,
output [15:0]data_out,

output  SRAM_CS_A_N,
output SRAM_WE_A_N,
output  [9:0]SRAM_ADDR_A,
input [23:0]SRAM_RDATA_A,
output [23:0]SRAM_WDATA_A,
output SRAM_WDATA_OEA_N,

output  SRAM_CS_B_N,
output SRAM_WE_B_N,
output  [9:0]SRAM_ADDR_B,
input [23:0]SRAM_RDATA_B,
output [23:0]SRAM_WDATA_B,
output SRAM_WDATA_OEB_N);

wire [15:0]payload_data_sum1;
reg vid_in_d0,vid_in_d1,vid_in_d2,vid_in_d3,vid_in_d4;
reg [9:0]data_cnt;
reg [16:0]payload_data_sum;


always@(posedge clk_100m)
if (!rst_spt_n)begin
vid_in_d0<=1'b0;
vid_in_d1<=1'b0;
vid_in_d2<=1'b0;
vid_in_d3<=1'b0;
vid_in_d4<=1'b0;
end
else begin
vid_in_d0<=vid_in&~cpuif_mode;
vid_in_d1<=vid_in_d0;
vid_in_d2<=vid_in_d1;
vid_in_d3<=vid_in_d2;
vid_in_d4<=vid_in_d3;
end

assign vid_in_posedge=vid_in_d2&~vid_in_d3;
assign vid_in_negedge=~vid_in_d0&vid_in_d1;

assign payload_flag=vid_in_d2&vid_in_d3;

reg [15:0]data_1,data_2,data_3,data_reg;
always@(posedge clk_100m)
if(!rst_spt_n)begin
data_1<=16'h0000;
data_2<=16'h0000;
data_3<=16'h0000;
data_reg<=16'h0000;
end
else if(vid_in&~cpuif_mode|vid_in_d0|vid_in_d1|vid_in_d2)begin
data_1<=data_in;
data_2<=data_1;
data_3<=data_2;
data_reg<=data_3;
end

reg[1:0]cs,nxst;
parameter [1:0]
INIT=2'b00,
HEAD=2'b01,
LOAD=2'b11,
TAIL=2'b10;

wire init_st=cs==INIT;
wire head_st=cs==HEAD;
wire load_st=cs==LOAD;
wire tail_st=cs==TAIL;

always @(posedge clk_100m)
if(!rst_spt_n)
cs<=INIT;
else
cs<=nxst;

always @(*)
case(cs)
INIT:
if(vid_in_posedge)
nxst=HEAD;
else 
nxst=cs;

HEAD:
if(vid_in_d1)
nxst=LOAD;
else
nxst=INIT;

LOAD:
if(vid_in_d1)
nxst=LOAD;
else
nxst=TAIL;

TAIL:
nxst=INIT;
endcase

always@(posedge clk_100m)
if(!rst_spt_n)
data_cnt<=10'h000;
else if(head_st)
data_cnt<=10'h000;
else if(load_st)
data_cnt<=data_cnt+1;

always @(posedge clk_100m)
if(!rst_spt_n)
payload_data_sum<=17'h0_0000;
else if(head_st)
payload_data_sum<=17'h0_0000;
else if(payload_flag)
payload_data_sum<=data_reg+payload_data_sum1;

wire[15:0]tail_expect=(payload_data_sum1==16'hffff) ? payload_data_sum1:~payload_data_sum1;
assign payload_data_sum1=payload_data_sum[16]+payload_data_sum[15:0];

always@(posedge clk_100m)
if(!rst_spt_n)
spt_cpuif_head_err<=1'b0;
else if(tail_st)
spt_cpuif_head_err<=1'b0;
else if(head_st)
spt_cpuif_head_err<=data_reg!=16'h55d5;


always@(posedge clk_100m)
if(!rst_spt_n)
spt_cpuif_tail_err<=1'b0;
else if(head_st)
spt_cpuif_tail_err<=1'b0;
else if(tail_st)
spt_cpuif_tail_err<=data_reg!=tail_expect & data_cnt>=20 & data_cnt<=600;


always@(posedge clk_100m)
if(!rst_spt_n)
spt_cpuif_short_pkt<=1'b0;
else if(head_st)
spt_cpuif_short_pkt<=1'b0;
else if (tail_st)
spt_cpuif_short_pkt<=data_cnt<=20&data_cnt>3;


always@(posedge clk_100m)
if(!rst_spt_n)
spt_cpuif_long_pkt<=1'b0;
else if(head_st)
spt_cpuif_long_pkt<=1'b0;
else if(tail_st)
spt_cpuif_long_pkt<=data_cnt>601;


always@(posedge clk_100m)
if(!rst_spt_n)
spt_cpuif_ok_pkt<=1'b0;
else if(head_st)
spt_cpuif_ok_pkt<=1'b0;
else if(tail_st)
spt_cpuif_ok_pkt<=data_cnt>20 & data_cnt<=601 & data_reg==tail_expect &~spt_cpuif_head_err;

reg [9:0]last_addr;
reg [9:0]last_addr_1;
reg back_flag;
reg confirm_flag;
//reg empty;
//reg full;

reg spt_cs_a_n;
always@(posedge clk_100m)
if(!rst_spt_n)
spt_cs_a_n<=1'b1;
//else if(!vid_in_d3&vid_in_d4|full)
else if(!vid_in_d3&vid_in_d4)
spt_cs_a_n<=1'b1;
else if(vid_in_d3&!vid_in_d4)
spt_cs_a_n<=data_reg!=16'h55d5;
reg [9:0]spt_addr_a;
reg wrap_flag;
always @(posedge clk_100m)
if(!rst_spt_n)
wrap_flag<=1'b0;
else if((spt_addr_a==0)&ok_pkt_cnt!=0)
wrap_flag<=1'b1;
else if(spt_addr_a==1023&wrap_flag)
wrap_flag<=1'b0;
reg [9:0]spt_addr_b;
reg spt_cs_b_n;
always @(posedge clk_100m)
if(!rst_spt_n)
spt_cs_b_n<=1'b1;
//else if((spt_addr_b>=last_addr-1)| empty|SRAM_RDATA_B[16])
else if((spt_addr_b+1==last_addr)| SRAM_RDATA_B[16])
spt_cs_b_n<=1'b1;
else if(spt_addr_b<last_addr|wrap_flag&last_addr<spt_addr_b)
spt_cs_b_n<=1'b0;
 
//assign spt_cs_b_n = SRAM_RDATA_B[16];
assign SRAM_CS_A_N=cpuif_mode ? ~cpuif_port_sel ? core_spt_cs_n : 1'b1 :spt_cs_a_n;

assign SRAM_CS_B_N=cpuif_mode ? cpuif_port_sel ? core_spt_cs_n : 1'b1 :spt_cs_b_n;

assign SRAM_WE_B_N=~cpuif_mode ? ~spt_cs_b_n: cpuif_port_sel ?(core_spt_we_n|core_spt_wdata_oe_n):1'b1;

assign SRAM_WE_A_N=~cpuif_mode ? spt_cs_a_n: cpuif_port_sel  ? 1'b1:( core_spt_we_n|core_spt_wdata_oe_n);


always@(posedge clk_100m)
if(!rst_spt_n)
spt_addr_b<=10'h000;
else if(SRAM_RDATA_B[16]|ok_pkt_cnt==0&spt_cs_b_n|spt_addr_b+1==last_addr)
spt_addr_b<= spt_addr_b;
else if(spt_addr_b<last_addr|wrap_flag&last_addr<spt_addr_b)
spt_addr_b<=spt_addr_b+1;


assign SRAM_ADDR_B=cpuif_mode ? cpuif_port_sel ? core_spt_addr : 10'hz : spt_addr_b;

always@(posedge clk_100m)
if(!rst_spt_n)begin
vid_out<=1'b0;
end
else if(~cpuif_mode)begin
vid_out<=~spt_cs_b_n;
end

assign data_out=cpuif_mode? 16'hz:SRAM_RDATA_B;
assign spt_core_rdata=~cpuif_mode ? SRAM_RDATA_B:16'hz;

assign SRAM_WDATA_A=cpuif_mode ? (cpuif_port_sel ? 24'hz : core_spt_wdata):{vid_in_negedge,data_reg[7:0],data_reg[15:8]};
assign SRAM_WDATA_B=cpuif_mode ? (cpuif_port_sel ? core_spt_wdata:24'h00_0000 ):24'h00_0000;
assign SRAM_WDATA_OEA_N=cpuif_mode ? (~cpuif_port_sel ? core_spt_wdata_oe_n : 1'bz) : 1'bz;
assign SRAM_WDATA_OEB_N=cpuif_mode ? (~cpuif_port_sel ? 1'bz : core_spt_wdata_oe_n) : spt_cs_a_n;


always@(posedge clk_100m)
if(!rst_spt_n)
spt_addr_a<=10'h000;
else if (head_st)
spt_addr_a<=spt_cpuif_ok_pkt? spt_addr_a : last_addr;
else if(vid_in_d2&vid_in_d3)
spt_addr_a<=spt_addr_a+1;

assign SRAM_ADDR_A=cpuif_mode ? ~cpuif_port_sel ? core_spt_addr :10'hz : spt_addr_a;
always@(posedge clk_100m)
if(!rst_spt_n)
last_addr<=10'h000;
else if(spt_cpuif_ok_pkt)
last_addr<=spt_addr_a;

/*always@(posedge clk_100m)
if(!rst_spt_n)
empty<=1'b0;
else
empty<=spt_addr_a==10'h000;

always@(posedge clk_100m)
if(!rst_spt_n)
full<=1'b0;
else if(spt_addr_a==10'h3fe)
full<=1'b1;*/

endmodule


