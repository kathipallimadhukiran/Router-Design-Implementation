module router_synchronizer_tb();
reg detect_addr, wr_enb_reg, clk, rstn;
reg rd_enb_0, rd_enb_1, rd_enb_2;
reg empty_0, empty_1, empty_2;
reg full_0, full_1, full_2;
reg [1:0] din;
wire vld_out_0, vld_out_1, vld_out_2;
wire sft_rst_0, sft_rst_1, sft_rst_2;
wire [2:0]wr_enb;
router_synchronizer DUT ( detect_addr,wr_enb_reg,clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,din,vld_out_0,vld_out_1,vld_out_2,
sft_rst_0,sft_rst_1,sft_rst_2,wr_enb);

// Clock Generation
always begin
#10 clk = ~clk;
end

// Task to initialize signals
task initialize;
begin
clk = 0;
rstn = 0;
detect_addr = 0;
wr_enb_reg = 0;
rd_enb_0 = 0;
rd_enb_1 = 0;
rd_enb_2 = 0;
empty_0 = 0;
empty_1 = 0;
empty_2 = 0;
full_0 = 0;
full_1 = 0;
full_2 = 0;
din = 2'b00;
end
endtask
// Task to apply reset
task resetn;
begin
@(negedge clk)
rstn = 0;
@(negedge clk)
rstn = 1;

end
endtask

task softreset;
begin
@(negedge clk)
rstn = 0;
@(negedge clk)
rstn = 1;

end
endtask



//Task for empty
task empty(input en_0, en_1, en_2);
begin
@(negedge clk)
empty_0 = en_0;
empty_1 = en_1;
empty_2 = en_2;
#10;
end
endtask

//task for write
task write_signal;
begin
wr_enb_reg=1'b1;
end
endtask
//Task to detect address

task detect_address(input i);
begin
@(negedge clk)
detect_addr = i;


end
endtask
//task for address
task address(input[1:0]rx_address);
begin
@(negedge clk)
din=rx_address;
end
endtask
//task for full
task fifofull(input a,b,c);
begin
full_0=a;
full_1=b;
full_2=c;

end
endtask
//task for read signal
task read_signal(input r0,r1,r2);
begin
{rd_enb_0,rd_enb_1,rd_enb_2}={r0,r1,r2};
end
endtask
task empty_status(input e0,e1,e2);
begin
empty_0=e0;
empty_1=e1;
empty_2=e2;
end
endtask
task write;
begin
wr_enb_reg=1'b1;

end
endtask
initial
begin
initialize;
resetn;
detect_address(1);
address(2'b10);
write;
empty_status(1,0,1);
read_signal(0,0,0);
repeat(20)
#30;
read_signal(0,0,0);
fifofull(0,1,0);
#500;
$finish;
end
endmodule