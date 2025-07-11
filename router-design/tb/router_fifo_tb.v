module router_fifo_tb();
    reg lfd_state;
    reg [7:0] din;
    reg clk, rstn, wr_enb, rd_enb, sft_rst;
    wire [7:0] d_out;
    wire full, empty;
    integer i;

    parameter cycle = 10;

    router_fifo dut (.clk(clk),.rstn(rstn), .din(din), .rd_enb(rd_enb),.wr_enb(wr_enb),.d_out(d_out),.lfd_state(lfd_state), .sft_rst(sft_rst),.full(full),.empty(empty));

 
    always begin
    
        #(cycle/2) clk=1'b0;
        #(cycle/2) clk=1'b1;
    end

 
    task sft_reset();
    begin
        @(negedge clk);
        sft_rst = 1'b1;
        @(negedge clk);
        sft_rst = 1'b0;
    end
    endtask

    task initialize();
    begin
 wr_enb=0;
 rd_enb=0;
 
 

end
    endtask

    task resetf();
    begin
        @(negedge clk);
        rstn=1'b0;
        @(negedge clk);
        rstn=1'b1;
    end
    endtask

    task read_enable();
    begin
        @(negedge clk);
        rd_enb=1'b1;
        wr_enb=1'b0;
    end
    endtask

    task pkt_gen();
        reg [7:0] payload_data, parity, header;
        reg [5:0] payload_len;
        reg [1:0] addr;
    begin
        @(negedge clk);
        payload_len =6'd20;
        addr=2'b01;   
        header={payload_len, addr};
        din=header;
        lfd_state=1'b1;
        @(negedge clk);
        lfd_state=1'b0;
        wr_enb=1;

        for (i=0;i<payload_len;i=i+1)
         begin
            @(negedge clk);
            lfd_state=0;
            payload_data ={$random}%256;
            din=payload_data;
            
        end
        @(negedge clk);
        parity={$random}%256;
        din=parity; 
       
    end
    endtask

    initial begin
        initialize;
        
        resetf;
        sft_reset;
        pkt_gen;
    
        read_enable;
        #1000 $finish;
    end

    
    initial
        $monitor(
            " sft_rst=%b , lfd_st=%b, full=%b , empty=%b ,data_in=%h , data_out=%h , rstn=%b , renb=%b , wenb=%b , rd_pntr=%b , count=%b ,wr_pntr=%b",
             sft_rst, lfd_state, full, empty, din, d_out, rstn, rd_enb, wr_enb, dut.rd_pntr, dut.count, dut.wr_pntr
        );
endmodule