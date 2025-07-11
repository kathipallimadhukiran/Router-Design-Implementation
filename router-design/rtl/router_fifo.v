module router_fifo(clk,rstn,din,rd_enb,wr_enb,d_out,lfd_state,sft_rst,full,empty);
parameter width=9,depth=16; 
input [width-2:0]din;
input lfd_state;
input clk,rstn,rd_enb,sft_rst,wr_enb;
output reg [width-2:0]d_out;
output full,empty;
reg [4:0]wr_pntr,rd_pntr;
reg [6:0]count;
reg [width-1:0]mem[depth-1:0];
integer i;
reg temp;
assign full=((wr_pntr[4]!=rd_pntr[4])&&(wr_pntr[3:0]==rd_pntr[3:0]));
assign empty=(wr_pntr==rd_pntr);
always@(posedge clk)
begin
if(!rstn)
begin
temp<=0;
end
else
temp<=lfd_state;


end
always@(posedge clk)
begin
if(!rstn)
begin
for(i=0;i<16;i=i+1)

mem[i]<=0;
wr_pntr<=0;
end
else if(sft_rst)
begin
for(i=0;i<16;i=i+1)
mem[i]<=0;
wr_pntr<=0;
end
else if(wr_enb&&!full)
begin
{mem[wr_pntr[3:0]][8],mem[wr_pntr[3:0]][7:0]}<={temp,din};
wr_pntr<=wr_pntr+1'b1;
end
end
always@(posedge clk)
begin
if(!rstn)
begin
d_out<=0;
rd_pntr<=0;
end
else if(sft_rst)
begin
d_out<=8'bz;
end
else if(count==0)
begin
d_out<=8'bz;
end
else if(rd_enb&&!empty)
begin
d_out<=mem[rd_pntr[3:0]][7:0];
rd_pntr<=rd_pntr+1'b1;
end
else
d_out<=8'bz;
end


always@(posedge clk)
begin
if(!rstn)
count<=0;
else if(sft_rst)
count<=0;
else if(mem[rd_pntr[3:0]][8]==1)
begin
count<=mem[rd_pntr[3:0]][7:2]+1'b1;

end
else if(rd_enb&&!empty)
count<=count-1'b1;
else
count<=count;
end
endmodule