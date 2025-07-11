module router_reg_tb;

  reg clk;
  reg rstn;
  reg pkt_vld;
  reg [7:0] din;
  reg fifo_full;
  reg rst_int_reg;
  reg detect_addr;
  reg ld_state;
  reg laf_state;
  reg lfd_state;
  reg full_state;
  
  wire parity_done;
  wire low_pkt_valid;
  wire err;
  wire [7:0] d_out;
  integer i;
  
  router_register DUT (
    .clk(clk),
    .rstn(rstn),
    .pkt_vld(pkt_vld),
    .din(din),
    .fifo_full(fifo_full),
    .rst_int_reg(rst_int_reg),
    .detect_addr(detect_addr),
    .ld_state(ld_state),
    .laf_state(laf_state),
    .lfd_state(lfd_state),
    .full_state(full_state),
    .parity_done(parity_done),
    .low_pkt_valid(low_pkt_valid),
    .err(err),
    .d_out(d_out)
  );
  
  always begin
    #5 clk = ~clk;
  end
  
  task initialize;
  begin
    clk = 0;
    rstn = 0;
    pkt_vld = 0;
    din = 8'b0;
    fifo_full = 0;
    rst_int_reg = 0;
    detect_addr = 0;
    ld_state = 0;
    laf_state = 0;
    lfd_state = 0;
    full_state = 0;
  end
  endtask

  task reset;
  begin
    @(negedge clk);
    rstn = 0;  
    @(negedge clk);
    rstn = 1;  
  end
  endtask
  
  task pkt1();
    reg[7:0] header, payload_data, parity;
    reg[5:0] payloadlen;
  begin
    @(negedge clk);
    payloadlen = 14;
    parity = 0;
    detect_addr = 1'b1;
    pkt_vld = 1'b1;
    
    header = {payloadlen, 2'b10}; 
    din = header;
    parity = parity ^ din;
    
    @(negedge clk);
    detect_addr = 1'b0;
    lfd_state = 1'b1;
    
    for(i = 0; i < payloadlen; i = i + 1) begin
      @(negedge clk);
      lfd_state = 0;
      ld_state = 1;
      fifo_full = 1'b0;
      payload_data = {$random} % 256;
      din = payload_data;
      parity = parity ^ din;
    end
    
    @(negedge clk);
    pkt_vld = 0;
    ld_state = 1;
    din = parity;
    
    @(negedge clk);
    pkt_vld = 0;
    fifo_full = 1;
  end
  endtask
  


  initial
  begin
  initialize;
  reset;
  pkt1;
  $finish;
  end

endmodule