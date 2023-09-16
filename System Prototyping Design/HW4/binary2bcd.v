module Binary2BCD(total, BCD_ONE, BCD_TWO, BCD_THREE, BCD_FOUR);

//Binary2BCD
input [7:0] total;
output reg [3:0]BCD_ONE, BCD_TWO, BCD_THREE, BCD_FOUR;

reg [23:0] shift;
integer i=0;

always@(total)
begin 
    shift[7:0] = total;
    shift[23:8] = 0;    //7+16=23
    
    for(i=0; i<8; i=i+1)
    begin
        if(shift[11:8] >= 5)
            shift[11:8] = shift[11:8] + 23'd3;
        
        if(shift[15:12] >= 5)
            shift[15:12] = shift[15:12] + 23'd3;
        
        if(shift[19:16] >= 5)
            shift[19:16] = shift[19:16] + 23'd3;
        
        if(shift[23:20] >= 5)
            shift[23:20] = shift[23:20] + 23'd3;
        shift = shift << 1;
    end
    
    BCD_ONE         = shift[23:20];
    BCD_TWO         = shift[19:16];
    BCD_THREE   = shift[15:12];
    BCD_FOUR        = shift[11:8];
    
end 

endmodule
