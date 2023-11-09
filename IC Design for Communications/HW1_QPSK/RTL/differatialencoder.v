module differential_encoder(
    input clk_8megahz,
    input rst_n,
    input s2p_i,
    input s2p_q,
    output reg signed[1:0] diff_remapped_i,
    output reg signed[1:0] diff_remapped_q
);

reg [1:0]diff_i,diff_q; //[1] is current, [0] is previous

always @(posedge clk_8megahz or negedge rst_n) begin
    if (!rst_n) begin
        diff_i <= 2'b00;
        diff_q <= 2'b00;
    end else begin
        // Differential Encoding Logic
        // Send data to Previous
        diff_i[0] <= diff_i[1];
        diff_q[0] <= diff_q[1];
        
        // Current
        diff_i[1] <= ~(s2p_i^s2p_q)&(s2p_i^diff_i[0]) + (s2p_i^s2p_q)&(s2p_q^diff_q[0]);
        diff_q[1] <= ~(s2p_i^s2p_q)&(s2p_q^diff_q[0]) + (s2p_i^s2p_q)&(s2p_i^diff_i[0]);
    end
end

always @(diff_i[1] or diff_q[1]) begin
    case ({diff_i[1], diff_q[1]})
        2'b00: begin
        diff_remapped_i = 2'b01; // 1
        diff_remapped_q = 2'b01; // 1
        end
        2'b10: begin
        diff_remapped_i = 2'b11; // -1
        diff_remapped_q = 2'b01; // 1
        end
        2'b11: begin
        diff_remapped_i = 2'b11; // -1
        diff_remapped_q = 2'b11; // -1
        end
        2'b01: begin
        diff_remapped_i = 2'b01; // 1
        diff_remapped_q = 2'b11; // -1
        end
        default: begin
        diff_remapped_i = 2'b00; // 0
        diff_remapped_q = 2'b00; // 0
        end
    endcase
end

endmodule
