`timescale 1ns/1ns
module testbench();
reg clk_100m;
reg rst_n;
reg scan_en;
reg test_mode;

reg vid_in;
reg[15:0]data_in;
reg CPU_CS_N;
reg CPU_WE_N;
reg CPU_RD_N;
reg[15:0]CPU_ADDR;
reg[31:0]CPU_DATA_reg;
reg[9:0] i;
reg[16:0]temp;
reg[15:0]sum;
reg[15:0]tail_data;

initial begin
vid_in=0;
rst_n=1;
scan_en=0;
test_mode=0;
data_in=16'h0000;
clk_100m=0;
CPU_CS_N=1;
CPU_RD_N=1;
#8 rst_n=0;
#110 rst_n=1;
#8
/*CPU_CS_N=0;
CPU_ADDR=16'h4000;
CPU_DATA_reg=32'h0000_0001;
#10
CPU_WE_N=0;
#90 CPU_WE_N=1;
#10 CPU_CS_N=1;
#300

CPU_CS_N=0;
CPU_ADDR=16'h4004;
CPU_DATA_reg=32'h0000_0001;
#10
CPU_WE_N=0;
#90 CPU_WE_N=1;
#10 CPU_CS_N=1;
#300

CPU_CS_N=0;
CPU_ADDR=16'h4004;
CPU_DATA_reg=32'h0000_0055;
#10
CPU_WE_N=0;
#90 CPU_WE_N=1;
#10 CPU_CS_N=1;
//#50000
#300

CPU_CS_N=0;
CPU_ADDR=16'h4004;
CPU_DATA_reg=32'h0000_0055;
#10
CPU_WE_N=0;
#90 CPU_WE_N=1;
#10 CPU_CS_N=1;
#300

CPU_CS_N=0;
CPU_ADDR=16'h4004;
CPU_DATA_reg=32'h0000_00AA;
#10
CPU_WE_N=0;
#90 CPU_WE_N=1;
#10 CPU_CS_N=1;*/
#300
i=0;

while(i<10)begin
//while(i<12)begin
vid_in=1;
if(i==0|i==5)
data_in=16'h55d4;
else
data_in=16'h55d5;

temp=0;

if(i==3)begin
repeat(10)begin
#10 data_in=$urandom_range(0,16'hffff);
temp=temp[16]+temp[15:0]+data_in;
end
end
else if(i==6)begin
repeat(1)begin
#10 data_in=$urandom_range(0,16'hffff);
temp=temp[16]+temp[15:0]+data_in;
end
end
else if(i==9)begin
repeat(622)begin
#10 data_in=$urandom_range(0,16'hffff);
temp=temp[16]+temp[15:0]+data_in;
end
end
else begin
repeat($urandom_range(550,599))begin
#10 data_in=$urandom_range(0,16'hffff);
temp=temp[16]+temp[15:0]+data_in;
end
end
//end
/*else begin
repeat(3)begin
#10 data_in=$urandom_range(0,16'hffff);
temp=temp[16]+temp[15:0]+data_in;
end
end*/

sum=(temp[16]+temp[15:0])==16'hffff ?16'hffff:~(temp[16]+temp[15:0]);

if(i==1)
#10 data_in=sum+1;
else
#10 data_in=sum;
#10 vid_in=0;
data_in=$urandom_range(0,16'hffff);
repeat(3)
#10 data_in=$urandom_range(0,16'hffff);
i=i+1;

end

end
always #5 clk_100m=~clk_100m;

wire [9:0]SRAM_ADDR_A;
wire [9:0]SRAM_ADDR_B;
wire [23:0]SRAM_DATA_A;
wire [23:0]SRAM_WDATA_B;
wire [23:0]SRAM_WDATA_A;
wire [23:0]SRAM_RDATA_B;
wire [23:0]SRAM_RDATA_A;


wire [15:0]data_out;

wire [31:0]CPU_DATA=CPU_DATA_reg;
top top_0(
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
.data_out(data_out)
);



endmodule
