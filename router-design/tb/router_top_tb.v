module router_top_tb();
reg clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2;
reg [7:0]din;
reg pkt_valid,ld_state;
wire [7:0]d_out_0,d_out_1,d_out_2;
wire vld_out_0,vld_out_1,vld_out_2;
wire err,busy;
integer i;
router_top dut(clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2,din,pkt_valid,d_out_0,d_out_1,d_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);
always
begin
#10
clk=~clk;
end

task initialize;
begin
{clk,rd_enb_0,rd_enb_1,rd_enb_2,din,pkt_valid}=0;
rstn=1'b1;

end
endtask
task reset;
begin
@(negedge clk)
rstn=1'b0;
@(negedge clk)
rstn=1'b1;
end
endtask

task packet_gen_10;
reg [5:0]payload_len;
reg [1:0]address;
reg [7:0]header;
reg [7:0]payload_data;
reg [7:0]parity_byte;
begin
payload_len=6'd2;
address=2'b00;
@(negedge clk)
wait(~busy)
parity_byte=8'b0;
header={payload_len,address};
//@(negedge clk)
din=header;
pkt_valid=1'b1;
parity_byte=header^parity_byte;
@(negedge clk)
wait(~busy)
@(negedge clk)
for(i=0;i<payload_len;i=i+1)
begin
@(negedge clk)
wait(~busy)
payload_data={$random%256};
din=payload_data;
parity_byte=parity_byte^din;
end
@(negedge clk)
wait(~busy)
pkt_valid=1'b0;
din=parity_byte;
end
endtask
task packet_gen_14;
reg [5:0]payload_len;
reg [1:0]address;
reg [7:0]header;
reg [7:0]payload_data;
reg [7:0]parity_byte;
begin
payload_len=6'd4;
address=2'b01;
@(negedge clk)
wait(~busy)
parity_byte=8'b0;
header={payload_len,address};
@(negedge clk)
din=header;
pkt_valid=1'b1;
parity_byte=header^parity_byte;
@(negedge clk)
wait(~busy)
for(i=0;i<payload_len;i=i+1)
begin
@(negedge clk)
wait(~busy)
payload_data={$random%256};
din=payload_data;
parity_byte=parity_byte^din;
end
@(negedge clk)
wait(~busy)
pkt_valid=1'b0;

din=parity_byte;
end
endtask
task packet_gen_16;
reg [5:0]payload_len;
reg [1:0]address;
reg [7:0]header;
reg [7:0]payload_data;
reg [7:0]parity_byte;
begin
payload_len=6'd6;
address=2'b10;
@(negedge clk)
wait(~busy)
parity_byte=8'b0;
header={payload_len,address};
@(negedge clk)
din=header;
pkt_valid=1'b1;
parity_byte=header^parity_byte;
@(negedge clk)
wait(~busy)
for(i=0;i<payload_len;i=i+1)
begin
@(negedge clk)
wait(~busy)
payload_data={$random%256};
din=payload_data;
parity_byte=parity_byte^din;
end
@(negedge clk)
wait(~busy)
pkt_valid=1'b0;

din=parity_byte;
end
endtask
initial
begin
initialize;
reset;

packet_gen_10;
@(negedge clk)
wait(~busy);
rd_enb_0=1'b1;
wait(~vld_out_0)
rd_enb_0=1'b0;


packet_gen_14;
@(negedge clk)
wait(~busy);
rd_enb_1=1;
wait(~vld_out_1)
rd_enb_1=1'b0;

packet_gen_16;
@(negedge clk)
wait(~busy);
rd_enb_2=1'b1;
wait(~vld_out_2)
rd_enb_2=1'b0;


end
endmodule