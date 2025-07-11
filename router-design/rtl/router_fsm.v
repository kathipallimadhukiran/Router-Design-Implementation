module router_fsm(clk,rstn,pkt_valid,din,fifo_full,
fifo_empty_0,fifo_empty_1,
fifo_empty_2,sft_rst_0, 
sft_rst_1,sft_rst_2,parity_done,
wr_enb_reg,detect_add,ld_state,laf_state,
lfd_state,full_state,low_pkt_vld,rst_int_reg,busy);

input clk,rstn,pkt_valid;
input [7:0]din;
input fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,sft_rst_0,sft_rst_1,
sft_rst_2,parity_done,low_pkt_vld;
output wr_enb_reg,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,busy;
parameter decode_address=3'b000;
parameter wait_till_empty=3'b001;
parameter load_first_data=3'b010;
parameter load_data=3'b011;
parameter load_parity=3'b100;
parameter fifo_full_state=3'b101;
parameter load_after_full=3'b110;
parameter check_parity_error=3'b111;

reg [2:0]ps,ns;
reg [1:0]addr;
always@(posedge clk)
begin
if(~rstn)
addr<=2'b0;
else if(detect_add)
addr<=din[1:0];
end
always@(posedge clk)
begin
if(!rstn)
ps<=decode_address;
else if((sft_rst_0)&&(din[1:0]==2'b00)||(sft_rst_1)&&(din[1:0]==2'b01)||(sft_rst_2)&&(din[1:0]==2'b10))
ps<=decode_address;
else
ps<=ns;
end
always@(*)
begin
case(ps)
decode_address:
begin
if((pkt_valid&&(din[1:0]==2'b00)&&fifo_empty_0)||(pkt_valid&&(din[1:0]==2'b01)&&fifo_empty_1)||(pkt_valid&&(din[1:0]==2'b10)&&fifo_empty_2))
ns=load_first_data;
else if((pkt_valid&&(din==2'b00)&&!fifo_empty_0)||(pkt_valid&&(din==2'b01)&&!fifo_empty_1)||(pkt_valid&&(din==2'b10)&&!fifo_empty_2))
ns=wait_till_empty;
else
ns=decode_address;
end
load_first_data:
begin
ns=load_data;
end
wait_till_empty:
begin
if((fifo_empty_0&&(addr==2'b00))||(fifo_empty_1&&(addr==2'b01))||(fifo_empty_2&&(addr==2'b10)))
ns=load_first_data;
else
ns=wait_till_empty;
end
load_data:
begin
if(fifo_full==1'b1)
ns=fifo_full_state;
else if(!fifo_full&&!pkt_valid)
ns=load_parity;
else
ns=load_data;
end
fifo_full_state:
begin
if(fifo_full==1'b1)
ns=fifo_full_state;
else if(!fifo_full)
ns=load_after_full;
else
ns=fifo_full_state;
end
load_after_full:
begin
   if(!parity_done&&low_pkt_vld)
   ns=load_parity;
   else if(!parity_done&&!low_pkt_vld)
   ns=load_data;
   else if(parity_done==1'b1)
   ns=decode_address;
   else
   ns=load_after_full;
end
load_parity:
begin
   ns=check_parity_error;
end
check_parity_error:
begin
if(!fifo_full)
ns=decode_address;
else
ns=fifo_full_state;

end
default :ns=decode_address;
endcase
end
assign busy = ((ps == load_first_data) || (ps == load_parity) || (ps == fifo_full_state) || (ps == load_after_full) ||(ps == wait_till_empty) ||(ps == check_parity_error)) ? 1'b1 : 1'b0;

assign detect_add=((ps==decode_address))?1'b1:1'b0;

assign lfd_state=((ps==load_first_data))?1'b1:1'b0;
assign ld_state=((ps==load_data))?1'b1:1'b0;
assign wr_enb_reg=((ps==load_data)||(ps==load_after_full)||(ps==load_parity))?1'b1:1'b0;
assign full_state=((ps==fifo_full_state))?1'b1:1'b0;
assign laf_state=((ps==load_after_full))?1'b1:1'b0;
assign rst_int_reg=((ps==check_parity_error))?1'b1:1'b0;

endmodule