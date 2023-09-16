`timescale 1ns / 1ps
module state_control(light, start, clk, clk_2Hz, rst);

input clk, clk_2Hz, rst;
input start;
output reg [2:0]light;

reg [1:0]current_state;
reg [1:0]next_state;
reg [2:0]count;

initial 
begin
    current_state <= 2'd0;
    next_state <= 2'd0;
    count <= 3'd0;
end

always@(posedge clk)
    current_state <= next_state;

always@(posedge clk_2Hz or negedge rst)
begin
    count <= count + 3'd1;
    if(!rst)
        next_state <= 2'd0;
    else
    begin
        case(current_state)
            2'd0:
            begin
                if (!start)
                    next_state <= 2'd1;
                else
                    next_state <= 2'd0;
            end
            2'd1:
            begin
                if (count == 3'd4)
                begin
                    next_state <= 2'd2;
                    count <= 3'd0;
                end
            end
            2'd2:
            begin
                if (count == 3'd4) 
                begin
                    next_state <= 2'd3;
                    count <= 3'd0;
                end
            end
            2'd3:
            begin
                if (count == 3'd4) 
                begin
                    next_state <= 2'd1;
                    count <= 3'd0;
                end
            end
            default:
                next_state <= 2'd0;
        endcase
    end
end

always@(current_state)
begin
    case(current_state)
        2'd0:   light <= 3'b000;
        2'd1:   light <= 3'b001;
        2'd2: light <= 3'b010;
        2'd3: light <= 3'b100;
        default: light <= 3'b111;
    endcase
end
endmodule
