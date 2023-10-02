module cpu_if(
input clk_50m,
input rst_core_n,
input scan_en,
input test_mode,

output reg cpuif_mode,
output reg cpuif_port_sel,
input spt_cpuif_head_err,
input spt_cpuif_tail_err,
input spt_cpuif_short_pkt,
input spt_cpuif_long_pkt,
input spt_cpuif_ok_pkt,

output reg cpuif_core_test_start,
output cpuif_core_test_end,
output reg[31:0]ok_pkt_cnt,
input core_cpuif_d_err,
input core_cpuif_a_err,
input core_cpuif_s_end,
input core_cpuif_s_busy,
output reg[23:0]cpuif_core_test_00,
output reg[23:0]cpuif_core_test_01,
output reg[23:0]cpuif_core_test_02,
output reg[23:0]cpuif_core_test_03,
output reg[23:0]cpuif_core_test_04,
output reg[23:0]cpuif_core_test_05,
output reg[23:0]cpuif_core_test_06,
output reg[23:0]cpuif_core_test_07,
output reg[23:0]cpuif_core_test_08,
output reg[23:0]cpuif_core_test_09,
output reg[23:0]cpuif_core_test_10,
output reg[23:0]cpuif_core_test_11,
output reg[23:0]cpuif_core_test_12,
output reg[23:0]cpuif_core_test_13,
output reg[23:0]cpuif_core_test_14,
output reg[23:0]cpuif_core_test_15,

input CPU_CS_N,
input CPU_RD_N,
input CPU_WE_N,
input [15:0]CPU_ADDR,
output reg [31:0]CPU_RDATA,
output reg CPU_RDATA_OE_N,
input [31:0]CPU_WDATA,
output CPU_RDY_N,
output CPU_RDY_OE_N
);
wire reb_posedge;
//assign WEB=~CPU_CS_N & CPU_WE_N  /*&~CPU_RDY_N*/;
//assign REB=~CPU_CS_N & CPU_RD_N  /*&~CPU_RDY_N*/;
reg WEB;
always@(*)
if(~CPU_CS_N)
WEB<=CPU_WE_N;
reg REB;
always@(*)
if(~CPU_CS_N)
REB<=CPU_RD_N;

wire [31:0]cpuif_addr=CPU_ADDR;
/*always @(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_addr<=16'h0000;
else 
cpuif_addr<=CPU_ADDR;*/
//reg[31:0]cpuif_data;
wire [23:0]cpuif_data=CPU_WDATA;

/*always @(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_data<=16'h0000;
else 
cpuif_data<=CPU_WDATA;*/

always @(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_port_sel<=1'b0;
else if(cpuif_addr==16'h4000&(~cpuif_mode|~core_cpuif_s_busy)&~core_cpuif_s_busy)
cpuif_port_sel<=cpuif_data[0];
wire cpuif_mode_rst; 
always @(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_mode<=1'b0;
else if(cpuif_addr==16'h4004&cpuif_data[7:0]==8'h55)
cpuif_mode<=1'b1;
else if(cpuif_addr==16'h4004&cpuif_data[7:0]==8'hAA)
cpuif_mode<=1'b0;
wire rst_exit;
assign rst_exit=rst_core_n&~cpuif_core_test_start;
reg exit;
always @(posedge WEB or negedge rst_exit)
if(!rst_exit)
exit<=1'b0;
else if(cpuif_addr==16'h4004&(cpuif_data[7:0]==8'h55|cpuif_data[7:0]==8'hAA))
exit<=1'b1;
reg exit_d1,exit_d2;
always @(posedge clk_50m)
if(!rst_core_n)begin
exit_d1<=1'b0;
exit_d2<=1'b0;
end
else begin
exit_d1<=exit;
exit_d2<=exit_d1;
end
assign cpuif_core_test_end=exit_d1&~exit_d2;
always @(posedge clk_50m)
if(!rst_core_n)
cpuif_core_test_start<=1'b0;
else if(cpuif_addr==16'h4004&(cpuif_data[7:0]==8'h55))
cpuif_core_test_start<=cpuif_core_test_end;




/*reg scan_mode_enter;
always @(posedge WEB or negedge cpuif_mode_rst)
if(!cpuif_mode_rst)
scan_mode_enter<=1'b0;
else if(cpuif_addr==16'h4004&cpuif_data[7:0]==8'h55)
scan_mode_enter<=1'b1;
reg cpuif_mode_d1,cpuif_mode_d2;
always @(posedge clk_50m)
if(!rst_core_n)begin
cpuif_mode_d1<=1'b0;
cpuif_mode_d2<=1'b0;
end
else begin
cpuif_mode_d1<=cpuif_mode;
cpuif_mode_d2<=cpuif_mode_d1;
end


//assign cpuif_core_test_end=~cpuif_mode_d1&cpuif_mode_d2;
reg scan_mode_enter_d1,scan_mode_enter_d2;
always @(posedge clk_50m)
if(!rst_core_n)begin
scan_mode_enter_d1<=1'b0;
scan_mode_enter_d2<=1'b0;
end
else begin
scan_mode_enter_d1<=scan_mode_enter;
scan_mode_enter_d2<=scan_mode_enter_d1;
end
assign cpuif_core_test_end=scan_mode_enter_d1&~scan_mode_enter_d2;


reg cpuif_core_test_start_d1;
always @(posedge clk_50m)
if(!rst_core_n)
cpuif_core_test_start_d1<=1'b0;
else
cpuif_core_test_start_d1<=cpuif_core_test_start;
assign cpuif_mode_rst=rst_core_n&~cpuif_core_test_start_d1;*/
always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_00<=24'h00_0000;
else if(cpuif_addr==16'h8000&(~cpuif_mode|~core_cpuif_s_busy))
cpuif_core_test_00<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_01<=24'hFF_FFFF;
else if(cpuif_addr==16'h8004& (~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_01<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_02<=24'h0F_0F0F;
else if(cpuif_addr==16'h8008&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_02<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_03<=24'hF0_F0F0;
else if(cpuif_addr==16'h800C&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_03<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_04<=24'h55_5555;
else if(cpuif_addr==16'h8010&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_04<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_05<=24'hAA_AAAA;
else if(cpuif_addr==16'h8014&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_05<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_06<=24'h5A_5A5A;
else if(cpuif_addr==16'h8018&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_06<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_07<=24'hA5_A5A5;
else if(cpuif_addr==16'h801C&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_07<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_08<=24'h0A_0A0A;
else if(cpuif_addr==16'h8020&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_08<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_09<=24'hA0_A0A0;
else if(cpuif_addr==16'h8024&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_09<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_10<=24'h05_0505;
else if(cpuif_addr==16'h8028&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_10<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_11<=24'h50_5050;
else if(cpuif_addr==16'h802C&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_11<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_12<=24'hAF_AFAF;
else if(cpuif_addr==16'h8030&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_12<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_13<=24'hF5_F5F5;
else if(cpuif_addr==16'h8034&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_13<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_14<=24'hFA_FAFA;
else if(cpuif_addr==16'h8038&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_14<=cpuif_data[23:0];

always@(posedge WEB or negedge rst_core_n)
if(!rst_core_n)
cpuif_core_test_15<=24'h5F_5F5F;
else if(cpuif_addr==16'h803C&(~cpuif_mode| ~core_cpuif_s_busy))
cpuif_core_test_15<=cpuif_data[23:0];

reg[1:0]tus_a,tus_b;
always@(posedge clk_50m)
if(!rst_core_n)
tus_a<=2'b00;
else if(cpuif_port_sel==1'b0)
tus_a<={core_cpuif_s_end,core_cpuif_s_busy};

always@(posedge clk_50m)
if(!rst_core_n)
tus_b<=2'b00;
else if(cpuif_port_sel==1'b1)
tus_b<={core_cpuif_s_end,core_cpuif_s_busy};
reg core_cpuif_a_err_reg1,core_cpuif_a_err_reg2;
always @(posedge clk_50m)
if(!rst_core_n)
begin
core_cpuif_a_err_reg1<=1'b0;
core_cpuif_a_err_reg2<=1'b0;
end
else begin
core_cpuif_a_err_reg1<=core_cpuif_a_err;
core_cpuif_a_err_reg2<=core_cpuif_a_err_reg1;
end
assign core_cpuif_a_err_posedge=core_cpuif_a_err_reg1&~core_cpuif_a_err_reg2;

reg core_cpuif_d_err_reg1,core_cpuif_d_err_reg2;
always @(posedge clk_50m)
if(!rst_core_n)
begin
core_cpuif_d_err_reg1<=1'b0;
core_cpuif_d_err_reg2<=1'b0;
end
else begin
core_cpuif_d_err_reg1<=core_cpuif_d_err;
core_cpuif_d_err_reg2<=core_cpuif_d_err_reg1;
end
assign core_cpuif_d_err_posedge=core_cpuif_d_err_reg1&~core_cpuif_d_err_reg2;

reg addr_err_b,addr_err_a,data_err_b,data_err_a;
always @(clk_50m)
if(!rst_core_n)
addr_err_b<=1'b0;
else if(~(reb_posedge&cpuif_port_sel==1'b1&core_cpuif_a_err_posedge&cpuif_mode))
addr_err_b<=1'b0;
else if(cpuif_port_sel==1'b1&core_cpuif_a_err_posedge&cpuif_mode)
addr_err_b<=1'b1;

always @(clk_50m)
if(!rst_core_n)
addr_err_a<=1'b0;
else if(~(cpuif_port_sel==1'b0&reb_posedge&core_cpuif_a_err_posedge&cpuif_mode))
addr_err_a<=1'b0;
else if(cpuif_port_sel==1'b0&core_cpuif_a_err_posedge&cpuif_mode)
addr_err_a<=1'b1;

always @(clk_50m)
if(!rst_core_n)
data_err_b<=1'b0;
else if(~(cpuif_port_sel==1'b1&reb_posedge&core_cpuif_d_err_posedge&cpuif_mode))
addr_err_b<=1'b0;
else if(cpuif_port_sel==1'b1&core_cpuif_d_err_posedge&cpuif_mode)
data_err_b<=1'b1;

always @(clk_50m)
if(!rst_core_n)
data_err_a<=1'b0;
else if(~(cpuif_port_sel==1'b0&reb_posedge&core_cpuif_d_err_posedge&cpuif_mode))
addr_err_a<=1'b0;
else if(cpuif_port_sel==1'b0&core_cpuif_d_err_posedge&cpuif_mode)
data_err_a<=1'b1;

reg spt_cpuif_head_err_reg1,spt_cpuif_head_err_reg2;
always @(posedge clk_50m)
if(!rst_core_n)begin
spt_cpuif_head_err_reg1<=1'b0;
spt_cpuif_head_err_reg2<=1'b0;
end
else begin
spt_cpuif_head_err_reg1<=spt_cpuif_head_err;
spt_cpuif_head_err_reg2<=spt_cpuif_head_err_reg1;
end

assign spt_cpuif_head_err_posedge=spt_cpuif_head_err_reg1&~spt_cpuif_head_err_reg2;

reg spt_cpuif_tail_err_reg1,spt_cpuif_tail_err_reg2;
always @(posedge clk_50m)
if(!rst_core_n)begin
spt_cpuif_tail_err_reg1<=1'b0;
spt_cpuif_tail_err_reg2<=1'b0;
end
else begin
spt_cpuif_tail_err_reg1<=spt_cpuif_tail_err;
spt_cpuif_tail_err_reg2<=spt_cpuif_tail_err_reg1;
end

assign spt_cpuif_tail_err_posedge=spt_cpuif_tail_err_reg1&~spt_cpuif_tail_err_reg2;

reg spt_cpuif_short_pkt_reg1,spt_cpuif_short_pkt_reg2;
always @(posedge clk_50m)
if(!rst_core_n)begin
spt_cpuif_short_pkt_reg1<=1'b0;
spt_cpuif_short_pkt_reg2<=1'b0;
end
else begin
spt_cpuif_short_pkt_reg1<=spt_cpuif_short_pkt;
spt_cpuif_short_pkt_reg2<=spt_cpuif_short_pkt_reg1;
end

assign spt_cpuif_short_pkt_posedge=spt_cpuif_short_pkt_reg1&~spt_cpuif_short_pkt_reg2;

reg spt_cpuif_long_pkt_reg1,spt_cpuif_long_pkt_reg2;
always @(posedge clk_50m)
if(!rst_core_n)begin
spt_cpuif_long_pkt_reg1<=1'b0;
spt_cpuif_long_pkt_reg2<=1'b0;
end
else begin
spt_cpuif_long_pkt_reg1<=spt_cpuif_long_pkt;
spt_cpuif_long_pkt_reg2<=spt_cpuif_long_pkt_reg1;
end

assign spt_cpuif_long_pkt_posedge=spt_cpuif_long_pkt_reg1&~spt_cpuif_long_pkt_reg2;

reg spt_cpuif_ok_pkt_reg1,spt_cpuif_ok_pkt_reg2;
always @(posedge clk_50m)
if(!rst_core_n)begin
spt_cpuif_ok_pkt_reg1<=1'b0;
spt_cpuif_ok_pkt_reg2<=1'b0;
end
else begin
spt_cpuif_ok_pkt_reg1<=spt_cpuif_ok_pkt;
spt_cpuif_ok_pkt_reg2<=spt_cpuif_ok_pkt_reg1;
end

assign spt_cpuif_ok_pkt_posedge=spt_cpuif_ok_pkt_reg1&~spt_cpuif_ok_pkt_reg2;
reg reb_reg1,reb_reg2;
always@(posedge clk_50m)
if(!rst_core_n)begin
reb_reg1<=1'b0;
reb_reg2<=1'b0;
end
else begin
reb_reg1<=REB;
reb_reg2<=reb_reg1;
end
assign reb_posedge = reb_reg1&~reb_reg2;
reg [31:0]head_err_cnt;
always@(posedge clk_50m)
if(!rst_core_n)
head_err_cnt<=32'h0000_0000;
else if(~reb_posedge&head_err_cnt==2**32-1)
head_err_cnt<=head_err_cnt;
else if(reb_posedge&~spt_cpuif_head_err_posedge)
head_err_cnt<=32'h0000_0000;
else if(reb_posedge&spt_cpuif_head_err_posedge)
head_err_cnt<=32'h0000_0001;
else if(spt_cpuif_head_err_posedge)
head_err_cnt<=head_err_cnt+1;

reg [31:0]tail_err_cnt;
always@(posedge clk_50m)
if(!rst_core_n)
tail_err_cnt<=32'h0000_0000;
else if(~reb_posedge&tail_err_cnt==2**32-1)
tail_err_cnt<=tail_err_cnt;
else if(reb_posedge&~spt_cpuif_tail_err_posedge)
tail_err_cnt<=32'h0000_0000;
else if(reb_posedge&spt_cpuif_tail_err_posedge)
tail_err_cnt<=32'h0000_0001;
else if(spt_cpuif_tail_err_posedge)
tail_err_cnt<=tail_err_cnt+1;

reg [31:0]short_pkt_cnt;
always@(posedge clk_50m)
if(!rst_core_n)
short_pkt_cnt<=32'h0000_0000;
else if( ~reb_posedge& short_pkt_cnt==2**32-1)
short_pkt_cnt<=short_pkt_cnt;
else if(reb_posedge&~spt_cpuif_short_pkt_posedge)
short_pkt_cnt<=32'h0000_0000;
else if(reb_posedge&spt_cpuif_short_pkt_posedge)
short_pkt_cnt<=32'h0000_0001;
else if(spt_cpuif_short_pkt_posedge)
short_pkt_cnt<=short_pkt_cnt+1;

reg [31:0]long_pkt_cnt;
always@(posedge clk_50m)
if(!rst_core_n)
long_pkt_cnt<=32'h0000_0000;
else if(~reb_posedge& long_pkt_cnt==2**32-1)
long_pkt_cnt<=long_pkt_cnt;
else if(reb_posedge&~spt_cpuif_long_pkt_posedge)
long_pkt_cnt<=32'h0000_0000;
else if(reb_posedge&spt_cpuif_long_pkt_posedge)
long_pkt_cnt<=32'h0000_0001;
else if(spt_cpuif_long_pkt_posedge)
long_pkt_cnt<=long_pkt_cnt+1;


always@(posedge clk_50m)
if(!rst_core_n)
ok_pkt_cnt<=32'h0000_0000;
else if(~reb_posedge& ok_pkt_cnt==2**32-1)
ok_pkt_cnt<=ok_pkt_cnt;
else if(reb_posedge&~spt_cpuif_ok_pkt_posedge)
ok_pkt_cnt<=32'h0000_0000;
else if(reb_posedge&spt_cpuif_ok_pkt_posedge)
ok_pkt_cnt<=32'h0000_0001;
else if(spt_cpuif_ok_pkt_posedge)
ok_pkt_cnt<=ok_pkt_cnt+1;
reg[31:0]register_out;
always@(*)
case(cpuif_addr)
16'h4000:register_out<={31'h0000_0000,cpuif_port_sel};
16'h4004:register_out<={31'h0000_0000,cpuif_mode};
16'h4100:register_out<=head_err_cnt;
16'h4104:register_out<=tail_err_cnt;
16'h4108:register_out<=short_pkt_cnt;
16'h410C:register_out<=long_pkt_cnt;
16'h4110:register_out<=ok_pkt_cnt;
16'h8000:register_out<=cpuif_core_test_00;
16'h8004:register_out<=cpuif_core_test_01;
16'h8008:register_out<=cpuif_core_test_02;
16'h800C:register_out<=cpuif_core_test_03;
16'h8010:register_out<=cpuif_core_test_04;
16'h8014:register_out<=cpuif_core_test_05;
16'h8018:register_out<=cpuif_core_test_06;
16'h801C:register_out<=cpuif_core_test_07;
16'h8020:register_out<=cpuif_core_test_08;
16'h8024:register_out<=cpuif_core_test_09;
16'h8028:register_out<=cpuif_core_test_10;
16'h802C:register_out<=cpuif_core_test_11;
16'h8030:register_out<=cpuif_core_test_12;
16'h8034:register_out<=cpuif_core_test_13;
16'h8038:register_out<=cpuif_core_test_14;
16'h803C:register_out<=cpuif_core_test_15;
16'h8100:register_out<={28'h000_0000,tus_a,tus_b};
16'h8200:register_out<={28'h000_0000,addr_err_b,data_err_b,addr_err_a,data_err_a};
endcase
//assign CPU_RDATA_OE_N=~CPU_RDY_N ? 1'b0:1'b1;
always@(negedge REB or negedge WEB or posedge CPU_CS_N)
if(~WEB|CPU_CS_N)
CPU_RDATA_OE_N<=1'b1;
else
CPU_RDATA_OE_N<=1'b0;
assign CPU_RDY_N=core_cpuif_s_busy;
assign CPU_RDY_OE_N=1'b0;
always @(posedge REB or negedge rst_core_n)
if(!rst_core_n)
CPU_RDATA<=32'hz;
else if(~CPU_RDATA_OE_N)
CPU_RDATA<=register_out;
endmodule
