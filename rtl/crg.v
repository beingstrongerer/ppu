module crg(
input clk_100m,
input rst_n,
input cpuif_mode,
output sram_clk,
output reg clk_50m=0,
output reg rst_core_n,
output reg rst_spt_n
);


always @(posedge clk_100m)
clk_50m<=~clk_50m;

assign sram_clk=cpuif_mode?clk_50m:clk_100m;

reg rstnreg1_100m,rstnreg2_100m,rstnreg3_100m;
always @(posedge clk_100m)
begin
rstnreg1_100m<=rst_n;
rstnreg2_100m<=rstnreg1_100m;
end
wire clr_vcnt_100m=rstnreg1_100m&~rstnreg2_100m|~rstnreg1_100m&rstnreg2_100m;
wire vcnt_en_100m=~rstnreg2_100m;
reg [3:0]vcnt_100m;
always@(posedge clk_100m)
if(clr_vcnt_100m)
vcnt_100m<=4'h0;
else if(vcnt_en_100m)
vcnt_100m<=vcnt_100m+1;


always@(posedge clk_100m)
rst_spt_n<=vcnt_en_100m& vcnt_100m>=4'd9 ? 1'b0:1'b1;

reg rstnreg1_50m,rstnreg2_50m,rstnreg3_50m;
always @(posedge clk_50m)
begin
rstnreg1_50m<=rst_n;
rstnreg2_50m<=rstnreg1_50m;
end
wire clr_vcnt_50m=rstnreg1_50m&~rstnreg2_50m|~rstnreg1_50m&rstnreg2_50m;
wire vcnt_en_50m=~rstnreg2_50m;
reg [2:0]vcnt_50m;
always@(posedge clk_50m)
if(clr_vcnt_50m)
vcnt_50m<=3'h0;
else if(vcnt_en_50m)
vcnt_50m<=vcnt_50m+1;


always@(posedge clk_50m)
rst_core_n<=vcnt_en_50m& vcnt_50m>=3'd4 ? 1'b0:1'b1;

endmodule
