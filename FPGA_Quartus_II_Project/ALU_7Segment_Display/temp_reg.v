module temp_reg(
    input clk,
    input rst_n,
    input [3:0]sw_a,
    input [3:0]sw_b,
    input [7:0]alu_result,
    output reg [3:0]reg_a,
    output reg [3:0]reg_b,
    output reg [7:0]reg_result
    );

    always @(posedge clk)
    begin
        if(rst_n)
        begin
            reg_a <= sw_a;
            reg_b <= sw_b;
            reg_result <= alu_result;
        end
        else
        begin
            reg_a <= 4'd0;
            reg_b <= 4'd0;
            reg_result <= 7'd0;            
        end         
    end

endmodule