module sram (
input sram_clk,
input SRAM_CS_A_N,
input SRAM_WE_A_N,
input [9:0]SRAM_ADDR_A,
input [23:0]SRAM_WDATA_A,
output reg [23:0]SRAM_RDATA_A,


input SRAM_CS_B_N,
input SRAM_WE_B_N,
input [9:0]SRAM_ADDR_B,
input [23:0]SRAM_WDATA_B,
output reg [23:0]SRAM_RDATA_B);


reg[23:0] Mem[1023:0];

always@(posedge sram_clk)
if(!SRAM_CS_A_N&!SRAM_WE_A_N)
Mem[SRAM_ADDR_A] <= SRAM_WDATA_A;
always@(posedge sram_clk)
if(!SRAM_CS_A_N&SRAM_WE_A_N)
SRAM_RDATA_A <= Mem[SRAM_ADDR_A];

always@(posedge sram_clk)
if(!SRAM_CS_B_N&!SRAM_WE_B_N)
Mem[SRAM_ADDR_B] <= SRAM_WDATA_B;
reg [23:0]SRAM_DATA_B_REG;
always@(posedge sram_clk)
if(!SRAM_CS_B_N&SRAM_WE_B_N)
SRAM_RDATA_B <= Mem[SRAM_ADDR_B];



endmodule



