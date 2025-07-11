module router_synchronizer(input detect_addr,wr_enb_reg,clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2,empty_0,empty_1,
empty_2,full_0,full_1,full_2,input[7:0] din,
output vld_out_0,vld_out_1,vld_out_2,output reg fifo_full ,sft_rst_0,sft_rst_1,sft_rst_2,output reg [2:0]wr_enb);
 
reg [1:0]temp;
reg [4:0]count0,count1,count2;


//valid out
assign vld_out_0 =~empty_0;
assign vld_out_1 =~empty_1;
assign vld_out_2 =~empty_2;

//for temp
always@(posedge clk)
begin
if(!rstn)
temp<=0;
else if(detect_addr)
temp <= din[1:0];
end

//FIFO full
always@(*)
begin
case(temp)
2'b00:fifo_full=full_0;
2'b01:fifo_full=full_1;
2'b10:fifo_full=full_2;
default fifo_full=0;
endcase
end

//write_enb(one hot encoding)
always@(*)
begin
if(wr_enb_reg)
begin
case(temp)
2'b00:wr_enb=3'b001;
2'b01:wr_enb=3'b010;
2'b10:wr_enb=3'b100;
default:wr_enb=3'b000;
endcase
end
else
wr_enb=3'b000;
end

//counter and read enable
always@(posedge clk)
begin
if(!rstn)
count0<=5'b0;
else if(vld_out_0)
begin
if(!rd_enb_0)
begin
if(count0==29)
begin
sft_rst_0<=1'b1;
count0<=5'b0;
end
else
begin
count0<=count0+5'b1;
sft_rst_0<=1'b0;
end
end
else
count0<=5'b0;
end
else
count0<=5'b0;
end
always@(posedge clk)
begin
if(!rstn)
count1<=5'b0;
else if(vld_out_1)
begin
if(!rd_enb_1)
begin
if(count1==29)
begin
sft_rst_1<=1'b1;
count1<=5'b0;
end
else
begin
count1<=count1+5'b1;
sft_rst_1<=1'b0;
end
end
else
count1<=5'b0;
end
else
count1<=5'b0;
end
always@(posedge clk)
begin
if(!rstn)
count2<=5'b0;
else if(vld_out_2)
begin
if(!rd_enb_2)
begin
if(count2==29)
begin
sft_rst_2<=1'b1;
count2<=5'b0;
end
else
begin
count2<=count2+5'b1;
sft_rst_2<=1'b0;
end
end
else
count2<=5'b0;
end
else
count2<=5'b0;
end
endmodule