module clk_generator(
    input clk_8megahz,  // 8MHz input clock
    input rst_n,       // Active-low reset signal
    output reg clk_2megahz,  // 2MHz output clock
    output reg clk_1megahz   // 1MHz output clock
);

    reg [1:0] counter2; // 2-bit counter for 2MHz
    reg [2:0] counter1; // 3-bit counter for 1MHz

    always @(posedge clk_8megahz or negedge rst_n) begin
        if (!rst_n) begin
            counter2 <= 3'b0;  // Reset the counter for 2MHz
            counter1 <= 4'b0;  // Reset the counter for 1MHz
            clk_2megahz <= 1'b0;  // Initialize the 2MHz clock to 0
            clk_1megahz <= 1'b0;  // Initialize the 1MHz clock to 0
        end else begin
            // Increment counters
            counter2 <= counter2 + 1'b1;
            counter1 <= counter1 + 1'b1;

            // Generate the 2MHz clock by toggling every fourth rising edge
            clk_2megahz <= (counter2 == 2'b0);

            // Generate the 1MHz clock by toggling every eighth rising edge
            clk_1megahz <= (counter1 == 3'b0);
        end
    end

endmodule
