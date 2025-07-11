module router_fsm_tb();
reg clk, rstn, pkt_valid, fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2;
reg sft_rst_0, sft_rst_1, sft_rst_2, parity_done, low_pkt_vld;
reg [7:0] din;
wire wr_enb_reg, detect_add, ld_state, laf_state, full_state, lfd_state, rst_int_reg, busy;

router_fsm dut(
    clk, rstn, pkt_valid, din, fifo_full, fifo_empty_0, fifo_empty_1,
    fifo_empty_2, sft_rst_0, sft_rst_1, sft_rst_2, parity_done,
    wr_enb_reg, detect_add, ld_state, laf_state, lfd_state, full_state,
    low_pkt_vld, rst_int_reg, busy
);

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

task reset();
begin
    @(negedge clk);
    rstn = 1'b0;
    @(negedge clk);
    rstn = 1'b1;
end
endtask

task initialize();
begin
    pkt_valid = 0;
    fifo_full = 0;
    fifo_empty_0 = 0;
    fifo_empty_1 = 0;
    fifo_empty_2 = 0;
    sft_rst_0 = 0;
    sft_rst_1 = 0;
    sft_rst_2 = 0;
    parity_done = 0;
    low_pkt_vld = 0;
    din = 2'b00;
end
endtask

task t1();
begin
    @(negedge clk);
    pkt_valid = 1'b1;
    din = 8'b00100001;
    fifo_empty_1 = 1'b1;
    @(negedge clk);
     @(negedge clk);
    fifo_full = 1'b0;
    pkt_valid = 1'b0;
     @(negedge clk);
     
      fifo_full=1'b0;
end
endtask

task t2();
begin
    @(negedge clk);
    pkt_valid = 1'b1;
    din = 8'b10010001;
    fifo_empty_1 = 1'b1;
    @(negedge clk);
     @(negedge clk);
    fifo_full = 1'b1;
    @(negedge clk);
    fifo_full = 1'b0;
     @(negedge clk);
    parity_done = 1'b0;
    low_pkt_vld = 1'b1;
     @(negedge clk);
      @(negedge clk);
      fifo_full=1'b0;
end
endtask

task t3();
begin
    @(negedge clk);
    pkt_valid = 1'b1;
    din = 8'b00110001;
    fifo_empty_1 = 1'b1;
    @(negedge clk);
    @(negedge clk);
    fifo_full = 1'b1;
     @(negedge clk);
    fifo_full = 1'b0;
    @(negedge clk)
    parity_done = 1'b0;
    low_pkt_vld = 1'b0;
    @(negedge clk)
    fifo_full=1'b0;
    pkt_valid=1'b0;
    @(negedge clk);
     @(negedge clk);
     fifo_full=1'b0;
end
endtask

task t4();
begin
    @(negedge clk);
    pkt_valid = 1'b1;
    din = 8'b01100001;
    fifo_empty_1 = 1'b1;
    @(negedge clk);
    @(negedge clk);
    fifo_full = 1'b0;
    pkt_valid = 1'b0;
    @(negedge clk);
    @(negedge clk);
    fifo_full=1'b1;
    @(negedge clk);
    fifo_full=1'b0;
    @(negedge clk);
    parity_done = 1'b1;
end
endtask

initial begin
    initialize();
    reset();
    t1();
    
    t2();
    
    t3();
    
    t4();
    
  
end

endmodule