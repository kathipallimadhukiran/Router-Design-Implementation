module router_register(
    input clk,
    input rstn,
    input pkt_vld,
    input [7:0] din,
    input fifo_full,
    input rst_int_reg,
    input detect_addr,
    input ld_state,
    input laf_state,
    input lfd_state,
    input full_state,
    output reg parity_done,
    output low_pkt_valid,
    output reg err,
    
    output reg [7:0] d_out
    
);

    reg [7:0] head_byte, fifo_full_state, internal_parity, packet_parity;
    wire parity_check;

    always @(posedge clk) begin
        if (!rstn) begin
            d_out <= 8'd0;
        end else if (lfd_state) begin
            d_out <= head_byte;
        end else if (pkt_vld&& !fifo_full&&ld_state) begin
            d_out<= din;
            end
        else if (ld_state&&fifo_full)
            begin
            fifo_full_state<=din;
            
        
         if(laf_state)
        
        d_out<=fifo_full_state;
        else
        d_out<=d_out;
        end
        else if (!pkt_vld)
            d_out <=din;
            else
            d_out<=d_out;
         
    end

    always @(posedge clk) begin
        if (!rstn)
            head_byte <= 8'b0;
        else if (detect_addr && pkt_vld && din[1:0] != 2'b11)
           begin head_byte <= din;
           end
        else
            head_byte <= head_byte;
    end
    
    always @(posedge clk) begin
      
        if ((ld_state && fifo_full && !pkt_vld) || (laf_state && pkt_vld)) 
            parity_done <= 1'b1;
        else if (detect_addr)
            parity_done <= 1'b0;
        else
            parity_done <= parity_done;
    end

    always @(posedge clk) begin
        if (!rstn)
            internal_parity <= 8'b0;
        else if (detect_addr)
            internal_parity <= internal_parity ^ head_byte;
        else if (pkt_vld && !fifo_full)
            internal_parity <= internal_parity ^ din;
        /*else
            internal_parity <= internal_parity;*/
    end

    always @(posedge clk) begin
        if (!rstn)
            packet_parity <= 8'b0;
        else if (~pkt_vld)
            packet_parity <= din;
        else
            packet_parity <= packet_parity;
    end

    always @(posedge clk) begin
        if (!rstn)
            err <= 1'b0;
        else if (!pkt_vld && rst_int_reg) begin
            if (!parity_check)
               begin
                err <= 1'b0;
                packet_parity<=1'b0;
                internal_parity<=1'b0;
                end
            else
                err <= 1'b1;
                  packet_parity<=1'b0;
                internal_parity<=1'b0;
        end else begin
            err <= err;
        end
    end

assign low_pkt_valid=(ld_state&&~pkt_vld);
    assign parity_check = (packet_parity == internal_parity) ? 1'b1 : 1'b0;

endmodule