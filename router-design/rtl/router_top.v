module router_top(clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2,din,pkt_valid,d_out_0,d_out_1,d_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);
input clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2;
output [7:0]d_out_0,d_out_1,d_out_2;
input pkt_valid;
input [7:0]din;
output vld_out_0,vld_out_1,vld_out_2;
output err,busy;
wire [2:0]wr_enb;
wire [7:0]dout;
wire fifo_full,
empty_0,empty_1,
empty_2,sft_rst_0, 
sft_rst_1,sft_rst_2,parity_done,wr_enb_reg,detect_addr,ld_state,laf_state,
lfd_state,full_state,low_pkt_vld,rst_int_reg,full_0,full_1,full_2,d_out,sft_rst,full;

router_fsm f(clk,rstn,pkt_valid,din[1:0],fifo_full,empty_0,empty_1,empty_2,sft_rst_0, sft_rst_1,sft_rst_2,parity_done,
wr_enb_reg,detect_addr,ld_state,laf_state,lfd_state,full_state,low_pkt_vld,rst_int_reg,busy);
router_synchronizer syn(detect_addr,wr_enb_reg,clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2,empty_0,empty_1,empty_2,
full_0,full_1,full_2,din[1:0],vld_out_0,vld_out_1,vld_out_2,fifo_full,sft_rst_0,sft_rst_1,sft_rst_2,wr_enb);
router_register register(clk, rstn, pkt_valid,din, fifo_full,rst_int_reg, detect_addr, ld_state, laf_state,
                lfd_state,full_state, parity_done, low_pkt_vld, err, dout[7:0]);
router_fifo f0(clk,rstn,dout,rd_enb_0,wr_enb[0],d_out_0[7:0],lfd_state,sft_rst_0,full_0,empty_0);
router_fifo f1(clk,rstn,dout,rd_enb_1,wr_enb[1],d_out_1[7:0],lfd_state,sft_rst_1,full_1,empty_1);
router_fifo f2(clk,rstn,dout,rd_enb_2,wr_enb[2],d_out_2[7:0],lfd_state,sft_rst_2,full_2,empty_2);
endmodule