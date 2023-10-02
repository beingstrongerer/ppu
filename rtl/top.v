module top(
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
output [15:0]data_out


);
wire [9:0]SRAM_ADDR_A;
wire [9:0]SRAM_ADDR_B;

//wire [23:0]SRAM_DATA_A;
//wire [23:0]SRAM_DATA_B;
wire [23:0]SRAM_WDATA_A;
wire [23:0]SRAM_WDATA_B;
wire [23:0]SRAM_RDATA_A;
wire [23:0]SRAM_RDATA_B;





pp pp_0(
.rst_n(rst_n),
.clk_100m(clk_100m),
.scan_en(scan_en),
.test_mode(test_mode),

.CPU_CS_N(CPU_CS_N),
.CPU_RD_N(CPU_RD_N),
.CPU_WE_N(CPU_WE_N),
.CPU_ADDR(CPU_ADDR),
.CPU_DATA(CPU_DATA),
.CPU_RDY_N(CPU_RDY_N),

.vid_in(vid_in),
.data_in(data_in),
.vid_out(vid_out),
.data_out(data_out),
.sram_clk(sram_clk),
.SRAM_CS_A_N(SRAM_CS_A_N),
.SRAM_WE_A_N(SRAM_WE_A_N),
.SRAM_ADDR_A(SRAM_ADDR_A),
.SRAM_RDATA_A(SRAM_RDATA_A),
.SRAM_WDATA_A(SRAM_WDATA_A),
.SRAM_CS_B_N(SRAM_CS_B_N),
.SRAM_WE_B_N(SRAM_WE_B_N),
.SRAM_ADDR_B(SRAM_ADDR_B),
.SRAM_RDATA_B(SRAM_RDATA_B),
.SRAM_WDATA_B(SRAM_WDATA_B));

sram sram_0(
.sram_clk(sram_clk),
.SRAM_CS_A_N(SRAM_CS_A_N),
.SRAM_WE_A_N(SRAM_WE_A_N),
.SRAM_ADDR_A(SRAM_ADDR_A),
.SRAM_WDATA_A(SRAM_WDATA_A),
.SRAM_RDATA_A(SRAM_RDATA_A),

.SRAM_CS_B_N(SRAM_CS_B_N),
.SRAM_WE_B_N(SRAM_WE_B_N),
.SRAM_ADDR_B(SRAM_ADDR_B),
.SRAM_WDATA_B(SRAM_WDATA_B),
.SRAM_RDATA_B(SRAM_RDATA_B));

/*reg [23:0]SRAM_DATA_B_temp;
assign SRAM_DATA_A=SRAM_WE_A_N ? SRAM_RDATA_A:24'hz;
assign SRAM_WDATA_A=~SRAM_WE_A_N ? SRAM_DATA_A :24'hz;
assign SRAM_DATA_B=SRAM_DATA_B_temp;
assign SRAM_WDATA_B=~SRAM_WE_B_N ? SRAM_DATA_B :24'hz;
always@(posedge clk_100m)
if(!rst_n)
SRAM_DATA_B_temp<=24'h0;
else 
SRAM_DATA_B_temp<=SRAM_WE_B_N ? SRAM_RDATA_B:24'hz;*/
endmodule

