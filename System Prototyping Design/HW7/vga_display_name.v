`timescale 1ns / 1ps
module vga_display_name(
    CLK,//fpga_pin：P9
    RST,//fpga_pin：K5(按下為0)
    SW,//fpga_pin：F10、F9、F7、E6(左0右1)
    R_out,//fpga_pin：M4
    G_out,//fpga_pin：R1
    B_out,//fpga_pin：P2
    V_SYNC,//fpga_pin：P1
    H_SYNC,//fpga_pin：N2
    Active_Flag
    );

input CLK;
input RST;
input [1:0]SW;
output reg R_out;
output reg G_out;
output reg B_out;
output V_SYNC;
output H_SYNC;
output Active_Flag;

reg [10:0]H_CNT=0;  //行(水平)時序計數器
reg [10:0]V_CNT=0;  //列(垂直)時序計數器

/*------------------------------------------------
                PARAMETER：可以宣告bit數，也可不宣告(32bits)
------------------------------------------------*/
parameter H_SYNC_PULSE  = 11'd128,
          H_BACK_PORCH  = 11'd88,
          H_ACTIVE_TIME = 11'd800,
          H_FRONT_PORCH = 11'd40,
          H_LINE_PERIOD = 11'd1056;//800*600@60Hz，VGA_CLK is 40MHz
parameter V_SYNC_PULSE   = 11'd4,
          V_BACK_PORCH   = 11'd23,
          V_ACTIVE_TIME  = 11'd600,
          V_FRONT_PORCH  = 11'd1,
          V_FRAME_PERIOD = 11'd623;//800*600@60Hz，VGA_CLK is 40MHz
parameter H_COLOR_BAR = H_ACTIVE_TIME / 8;
parameter V_COLOR_BAR = V_ACTIVE_TIME / 8;
/*------------------------------------------------
                H_TIMING
------------------------------------------------*/
always@(posedge CLK or negedge RST)
begin
    if(!RST)
        H_CNT <= 11'd0;
    else if(H_CNT == H_LINE_PERIOD-1'b1)//用25MHz計數H_CNT到(800-1)，H_CNT為0~799
        H_CNT <= 11'd0;
    else 
        H_CNT <= H_CNT + 1'b1;
end
assign H_SYNC = (H_CNT < H_SYNC_PULSE) ? 1'b0 : 1'b1;//H_SYNC為VGA行(水平)同步信號，(輸出)，H_CNT小於96時為0，之後為1

/*------------------------------------------------
                V_TIMING
------------------------------------------------*/
always@(posedge CLK or negedge RST)
begin
    if(!RST)
        V_CNT <= 11'd0;
    else if(H_CNT == H_LINE_PERIOD-1'b1)    //用25MHz計數，當H_CNT數到(800-1)，水平做完才讓垂直+1，再進行一次水平，重複之
    begin
        if(V_CNT == V_FRAME_PERIOD-1'b1)    //用25MHz計數H_CNT到799才讓V_CNT+1，重複之，直到(525-1)，H_CNT為0~524
            V_CNT <= 11'd0;
        else 
            V_CNT <= V_CNT + 1'b1;
    end
end
assign V_SYNC = (V_CNT < V_SYNC_PULSE) ? 1'b0 : 1'b1;   //V_SYNC為VGA列(垂直)同步信號，(輸出)，V_CNT小於2時為0，之後為1

/*------------------------------------------------
                ACTIVE RGB
------------------------------------------------*/
assign Active_Flag = (H_CNT >= (H_SYNC_PULSE + H_BACK_PORCH - 1'b1))&&
                     (H_CNT <  (H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_TIME - 1'b1))&&
                     (V_CNT >= (V_SYNC_PULSE + V_BACK_PORCH - 1'b1))&&
                     (V_CNT <  (V_SYNC_PULSE + V_BACK_PORCH + V_ACTIVE_TIME - 1'b1));//Active_Flag為水平及垂直動作(Active)信號(c)and(h)之交集，輸出
reg [9:0]H_coordinate_name = 10'd250;//max=800
reg [9:0]V_coordinate_name = 10'd250;//max=800
reg color_x = 0;
reg [10:0]x = 0;//image的x座標
reg [10:0]y = 0;//image的y座標
reg [2:0]color_temp = 0;//存要輸出的RGB值
reg [75:0]name[0:21];//W*L = 76*22
/*------------------------------------------------
                vga display
------------------------------------------------*/
always@(posedge CLK or negedge RST)
begin
    if(!RST)begin
        {R_out,G_out,B_out} = 3'b000;
    end
    else if(Active_Flag)begin       //Active_Flag為1時，表要輸出值
        
        /*------------------------------------------------
                        圖像資料庫
        ------------------------------------------------*/
        name[0]  = 76'b0000010000000000000000000000000100000000000000000000000000000000000000000000;
        name[1]  = 76'b0000010000001111111110000001000100001011111111110000000111111111111111110000;
        name[2]  = 76'b0000010000000001000010000001000100001000000100000000000000000000000001100000;
        name[3]  = 76'b1111111111100011000010000001000100001000001100000000000000000000000011000000;
        name[4]  = 76'b0000010000000110001110000001111111111000001000000000000000000000000110000000;
        name[5]  = 76'b0000010000000000000000000000000000000001111111100000000000000000001100000000;
        name[6]  = 76'b0111111111000000000000000000000000000001000000100000000000000000011000000000;
        name[7]  = 76'b0100010001001111111110000001111111111001000000100000001111111100010000000000;
        name[8]  = 76'b0100010001001000000010000000000000000001000000100000000000000100011000001100;
        name[9]  = 76'b0100010001001000000010000000000000000001111111100000000000001100011000011000;
        name[10] = 76'b0100010001001111111110000001111111111001000000100000000000001000010100110000;
        name[11] = 76'b0111111111001000000010000001000000011001000000100000000000011000010111100000;
        name[12] = 76'b0000010000001000000010000001000000011001000000100000000000110000010010000000;
        name[13] = 76'b0000110000001111111110000001000000011001111111100000000001100000010001000000;
        name[14] = 76'b0000111000001000000010000001000000011001000000100000000011000000010000100000;
        name[15] = 76'b0001110110001000000010000001111111111001000000100000000110000000010000110000;
        name[16] = 76'b0011010011001111111110000000100000100001000000100000001100000000010000011000;
        name[17] = 76'b0110010001100010000000000000010000100001111111100000001000000000010000001100;
        name[18] = 76'b0100010000000110000000000000001000100000010000000000000000000111110000000111;
        name[19] = 76'b1000010000001100001000000000001001111000110001000000000000000000000000000000;
        name[20] = 76'b0000010000011000000110000000001111100001100001100000000000000000000000000000;
        name[21] = 76'b0000010000110000000001000001111000000011000000110000001111111111111111111111;
        
        /*------------------------------------------------
                        VGA display
        ------------------------------------------------*/
        //背景色
        //{R_out,G_out,B_out} = {1'b1,1'b1,1'b1};
        
        if(color_temp == 3'b111)
            {R_out,G_out,B_out} = 3'b000;
        else 
            {R_out,G_out,B_out} = 3'b111;
        //name
        if((H_CNT > (H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_name)) && 
            (V_CNT > (V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_name)))begin//W*L = 77*22 ，(x4)=>308*88
            
            x = (H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_name+1))/4;//放大4倍
            y = (V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_name+1))/4;
            
            color_x = name[y][x];
            
            if((x>75)||(y>21))begin//image W*L=76*22
                color_x = 0;
            end
            
            if(color_x == 1)begin   //藍
                {R_out, G_out, B_out} = color_temp;
            end
        end
    end
    else begin
        {R_out, G_out, B_out} = 3'b000;
    end
end

/*------------------------------------------------
                CLK_200Hz
------------------------------------------------*/
reg CLK_200Hz = 0;
reg [18:0]count_200Hz = 0;//max=524_287

always@(posedge CLK or negedge RST)begin
    if(!RST)begin
        count_200Hz = 0;
        CLK_200Hz = 0;
    end
    else if(count_200Hz >= 200_000)begin//40M->100Hz
        count_200Hz = 0;
        CLK_200Hz = ~CLK_200Hz;
    end
    else begin
        count_200Hz = count_200Hz + 1;
    end
end
/*------------------------------------------------
                    左右移動
------------------------------------------------*/
reg [2:0]color_change_count = 3'd0;//顏色變換計數
reg [5:0]color_time_count = 6'd0;
reg state_move = 1'b0;//移動狀態

always@(posedge CLK_200Hz or negedge RST)begin
    if(!RST)begin
        H_coordinate_name = 10'd250;
        V_coordinate_name = 10'd250;
        
        state_move = 1'b0;
        color_time_count = 6'd0;
        color_change_count = 3'd0;
    end
    else begin  
        if (SW == 2'd0) begin //0: ?????, 1:????, 2:????, 3:????+????
            H_coordinate_name = 10'd250;
            V_coordinate_name = 10'd250;
            state_move = 1'b0;
            color_change_count = 3'd0;
        end
        else if (SW == 2'd1) begin
            color_change_count = 3'd0;
            case(state_move)
                1'b0:begin//右移
                    H_coordinate_name = H_coordinate_name + 1;
                    if(H_coordinate_name+308 == H_ACTIVE_TIME)
                        state_move = 1'b1;                  
                end
                1'b1:begin//左移
                    H_coordinate_name = H_coordinate_name - 1;
                    if(H_coordinate_name == 0)
                        state_move = 1'b0;
                end
                default:begin
                    H_coordinate_name = 10'd250;
                    V_coordinate_name = 10'd250;
                end
            endcase
        end
        else if (SW == 2'd2) begin
            H_coordinate_name = 10'd250;
            V_coordinate_name = 10'd250;
            state_move = 1'b0;
            color_time_count = color_time_count + 1;
            if (color_time_count == 6'd25) begin
                color_change_count = color_change_count + 1;
                color_time_count = 6'd0;
            end
        end
        else if (SW == 2'd3) begin
            color_time_count = color_time_count + 1;
            if (color_time_count == 6'd25) begin
                color_change_count = color_change_count + 1;
                color_time_count = 6'd0;
            end
            case(state_move)
                1'b0:begin//右移
                    H_coordinate_name = H_coordinate_name + 1;
                    if(H_coordinate_name+308 == H_ACTIVE_TIME)
                        state_move = 1'b1;
                end
                1'b1:begin//左移
                    H_coordinate_name = H_coordinate_name - 1;
                    if(H_coordinate_name == 0)
                        state_move = 1'b0;
                end
                default:begin
                    H_coordinate_name = 10'd250;
                    V_coordinate_name = 10'd250;
                end
            endcase
        end
        else begin
            state_move = 1'b0;
            color_time_count = 6'd0;
            color_change_count = 3'd0;
        end
        
        /*------------------------------------------------
                        顏色變換
        ------------------------------------------------*/
        color_temp = color_change_count;

    end
end
endmodule
