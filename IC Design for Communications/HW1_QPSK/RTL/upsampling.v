module upsampling(
    input clk_8megahz,
    input rst_n,
    input wire signed[1:0] diff_remapped_data,
    output reg signed[1:0] usp_data
);

reg [2:0]counter; // For 8

always @(posedge clk_8megahz or negedge rst_n)begin
    if(!rst_n) begin
        usp_data <= 2'b00;
    end else begin
        if(counter == 3'd0)
            usp_data <= diff_remapped_data;
        else
            usp_data <= 2'd0;
            
        counter <= counter + 3'd1;
    end
end

endmodule