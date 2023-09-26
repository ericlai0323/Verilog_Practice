module alu(
    input clk,
    input rst_n,
    input flag_n,
    input [3:0] a, 
    input [3:0] b, 
    input [1:0] mode,
    output reg [7:0] result
);

    parameter ADD = 2'b00;
    parameter SUB = 2'b01;
    parameter MTP = 2'b10;
    parameter DVI = 2'b11;

    reg [3:0] temp_a;
    reg [3:0] temp_b;
    reg [3:0] quotient;
    reg [3:0] remainder;
    reg [3:0] iteration;

    always @(posedge clk)  // Use posedge of clk to control the frequency
    begin
        temp_a <= a;
        temp_b <= b;    
        
        if (flag_n)
        begin
            result <= 8'd0;
        end
        else
        begin
            case (mode)
                ADD: result <= temp_a + temp_b;
                SUB: result <= temp_a - temp_b;
                MTP: result <= temp_a * temp_b;
                // DVI:
                // begin
                //     // Manual division without division operator
                //     if (temp_b != 0)
                //     begin
                //         quotient <= 4'd0;
                //         remainder <= temp_a;
                //         iteration <= 4'd0; // Initialize the iteration counter
                        
                //         while ((remainder >= temp_b) && (iteration < 10)) // Restrict to 10 iterations
                //         begin
                //             remainder <= remainder - temp_b;
                //             quotient <= quotient + 1;
                //             iteration <= iteration + 1;
                //         end

                //         if (iteration >= 10)
                //         begin
                //             // Handle maximum iteration limit reached
                //             result <= 8'd0; // You can set the result to an error code or any suitable value.
                //         end
                //         else
                //         begin
                //             result <= quotient;
                //         end
                //     end
                //     else
                //         result <= 8'd0; // Handle division by zero as you see fit
                // end
                default: result <= 8'd0;
            endcase
        end
    end
endmodule
