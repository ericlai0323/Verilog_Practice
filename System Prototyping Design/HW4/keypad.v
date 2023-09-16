module keypad(temp, sure, keyin, keyout, clk_50HZ, rst);

parameter NO_KEY_PRESSED = 6'b000_001;  
parameter SCAN0          = 6'b000_010;  
parameter SCAN1              = 6'b000_100;  
parameter SCAN2          = 6'b001_000;  
parameter SCAN3          = 6'b010_000;  
parameter KEY_PRESSED    = 6'b100_000;  

input [3:0]keyout;
input clk_50HZ, rst;
output reg sure;
output reg [3:0]temp;
output reg [2:0]keyin; 

reg [5:0] current_state, next_state;    
always@(posedge clk_50HZ or negedge rst)
  if (!rst)
    current_state <= NO_KEY_PRESSED;
  else
    current_state <= next_state;
     
//????
always@(*)
  case(current_state)
    NO_KEY_PRESSED:                // ??????
        if(keyout != 4'hF)
          next_state <= SCAN0;
        else
          next_state <= NO_KEY_PRESSED;
    SCAN0:                         // ???0? 
        if(keyout != 4'hF)
          next_state <= KEY_PRESSED;
        else
          next_state <= SCAN1;
    SCAN1:                         // ???1? 
        if(keyout != 4'hF)
          next_state <= KEY_PRESSED;
        else
          next_state <= SCAN2;    
    SCAN2:                         // ???2?
        if(keyout != 4'hF)
          next_state <= KEY_PRESSED;
        else
          next_state <= SCAN3;
    SCAN3:                         // ???3?
        if(keyout != 4'hF)
          next_state <= KEY_PRESSED;
        else
          next_state <= NO_KEY_PRESSED;
    KEY_PRESSED:                   // ?????
        if(keyout != 4'hF)
          next_state <= KEY_PRESSED;
        else
          next_state <= NO_KEY_PRESSED;                      
  endcase
 
reg key_pressed_flag;   
        
reg [2:0]in_val;
reg [3:0]out_val; 
always@(posedge clk_50HZ or negedge rst)
    if(!rst)
        begin
            keyin            <= 3'h0;
            key_pressed_flag <=    0;
        end
    else
        case(next_state)
            NO_KEY_PRESSED :                // ??????
                begin
                    keyin            <= 3'h0;
                    key_pressed_flag <=    0;   // ???????
                end
            SCAN0 :                         // ???0?
                keyin <= 3'b110;
            SCAN1 :                         // ???1?
                keyin <= 3'b101;
            SCAN2 :                         // ???2?
                keyin <= 3'b011;
            KEY_PRESSED :                   // ?????
                begin
                    in_val              <= keyin;   // ????
                    out_val             <= keyout;  // ????
                    key_pressed_flag    <= 1;      // ???????  
                end
        endcase

always@(posedge clk_50HZ or negedge rst)
begin 
    if (!rst) 
        temp <= 4'd0;
    else
    begin
        if (key_pressed_flag)
            case({out_val, in_val})
                8'b0111_110 : temp <= 4'd3;
                8'b0111_101 : temp <= 4'd2;
                8'b0111_011 : temp <= 4'd1;
        
                8'b1011_110 : temp <= 4'd6;
                8'b1011_101 : temp <= 4'd5;
                8'b1011_011 : temp <= 4'd4;
        
                8'b1101_110 : temp <= 4'd9;
                8'b1101_101 : temp <= 4'd8;
                8'b1101_011 : temp <= 4'd7;
        
                8'b1110_110 : sure <= 1'd1; 
                8'b1110_101 : temp <= 4'd0;
                8'b1110_011 : sure <= 1'd0;
                //default: temp <= 4'd0;
            endcase
    end 
end

endmodule
