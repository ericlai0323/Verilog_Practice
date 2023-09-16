module ALU(total, start_alu, a, b, sel);

//ALU
output reg[7:0] total; 
input [3:0] a, b;
input [1:0] sel;
input start_alu;

reg [3:0]tempa, tempb;
reg [7:0]tempa1, tempb1;
reg [7:0]temp_total;
integer i;

always@(a or b)
begin 
    tempa <= a;
    tempb <= b;
end

always@(tempa or tempb or sel)
begin
    if (!start_alu)
    begin
        total = 8'd0;
        temp_total = 8'd0;
    end
    else
    begin
        case(sel)
            2'b00:  total = tempa+tempb;     
            2'b01:  total = tempa-tempb;
            2'b10:  total = tempa*tempb;
            //2'b11:    total = tempa/tempb;
            2'b11:
            begin
                tempa1 = {4'h0, tempa};
                tempb1 = {tempb, 4'h0};
                for (i=0; i<4; i=i+1)
                begin   
                    tempa1 = {tempa1[6:0], 1'b0};
                    if(tempa1[7:4] >= tempb)
                        tempa1 = tempa1 - tempb1 + 1'b1;
                    else
                        tempa1 = tempa1;
                end
                total  = {4'h0, tempa1[3:0]};
            end
            //default:  total <= 'd0;
            
        endcase
    end
        
end 

endmodule
