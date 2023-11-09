module s2p(
    input clk_2megahz, // For input data
    input clk_1megahz, // For output data
    input rst_n,
    input binary_data,
    output reg s2p_i,
    output reg s2p_q
);

parameter IDLE = 2'b00;
parameter RECV_I = 2'b01;
parameter RECV_Q = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

reg s2p_i_temp;
reg s2p_q_temp;
reg counter;

always @(posedge clk_2megahz or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        s2p_i_temp <= 1'b0;
        s2p_q_temp <= 1'b0;
    end else begin
        state <= next_state;
        s2p_i_temp <= (state == RECV_I) ? binary_data : s2p_i_temp;
        s2p_q_temp <= (state == RECV_Q) ? binary_data : s2p_q_temp;
    end
end

always @(posedge clk_2megahz or negedge rst_n) begin
    if (!rst_n) begin
        next_state <= IDLE;
        counter <= 1'b0;
    end else begin
        // Increment the counter and check if the input data is odd or even
        counter <= counter + 1'b1;
        case(state)
            IDLE: next_state <= counter ? RECV_Q : RECV_I;
            RECV_I: next_state <= counter ? RECV_Q : RECV_I;
            RECV_Q: next_state <= counter ? RECV_Q : RECV_I;
        endcase
    end
end

always @(posedge clk_1megahz or negedge rst_n) begin
    if (!rst_n) begin
        s2p_i <= 1'b0;
        s2p_q <= 1'b0;
    end else begin
        s2p_i <= s2p_i_temp;
        s2p_q <= s2p_q_temp;
    end
end

endmodule
