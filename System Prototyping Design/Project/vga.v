module vga(
            input CLK,
            input RST,
            
            output reg[7:0]R_out,
            output reg[7:0]G_out,
            output reg[7:0]B_out,
            output V_SYNC,
            output H_SYNC,
            output Active_Flag,
            output psave,
            output sync,
            output reg VGA_CLK,
            
            input floor_down_n,
            input repeat_signal_n
);
reg [9:0]H_CNT; // VGA行(水平)同步信號
reg [9:0]V_CNT; // VGA列(垂直)同步信號

assign psave = 1;
assign sync = 1;

wire floor_down;
wire repeat_signal;
assign floor_down = !floor_down_n;
assign repeat_signal = !repeat_signal_n;

//------------------------------------------
//              PARAMETER
//------------------------------------------
parameter H_SYNC_PULSE  = 10'd96,
          H_BACK_PORCH  = 10'd48,
          H_ACTIVE_TIME = 10'd640,  //640*480@60Hz
          H_FRONT_PORCH = 10'd16,
          H_LINE_PERIOD = 10'd800;
parameter V_SYNC_PULSE   = 10'd2,
          V_BACK_PORCH   = 10'd33,
          V_ACTIVE_TIME  = 10'd480, //640*480@60Hz
          V_FRONT_PORCH  = 10'd10,
          V_FRAME_PERIOD = 10'd525;

integer x=0;    //圖的x座標
integer y=0;    //圖的y座標

reg X_color=0;  //X=1時，表輸出藍色
reg Y_color=0;  //Y=1時，表輸出灰色
reg Z_color=0;  //Z=1時，表輸出黑色
reg W_color=0;  //X=1時，表輸出藍色
reg V_color=0;  //X=1時，表輸出藍色

reg color_closs_1=1;    //關閉food_1顏色(吃掉)
reg color_closs_2=1;
reg color_closs_3=1;
reg color_closs_4=1;
reg color_closs_5=1;
reg color_closs_6=1;
reg color_closs_7=1;

reg color_closs_top=1;  //floor_top圖像開關
reg color_closs_hook=0;
reg color_closs_FLOOR=0;
reg color_closs_SCORE=0;
reg add_score_100=1;
reg add_score_50=1;
reg color_closs_GameOver=1;
reg color_closs_YouWin=1;
reg color_closs_cloud=1;

integer H_coordinate_hook = H_ACTIVE_TIME/2-25; //吊鉤水平位置座標，50*160(寬*高)
integer V_coordinate_hook = 0;  //吊鉤垂直位置座標

integer H_coordinate_floor_1;   //樓層1水平位置座標
integer V_coordinate_floor_1;   //樓層1垂直位置座標
integer H_coordinate_floor_2;   //樓層2水平位置座標
integer V_coordinate_floor_2;   //樓層2垂直位置座標
integer H_coordinate_floor_3;   //樓層3水平位置座標
integer V_coordinate_floor_3;   //樓層3垂直位置座標
integer H_coordinate_floor_4;   //樓層4水平位置座標
integer V_coordinate_floor_4;   //樓層4垂直位置座標
integer H_coordinate_floor_5;   //樓層5水平位置座標
integer V_coordinate_floor_5;   //樓層5垂直位置座標
integer H_coordinate_floor_6;   //樓層6水平位置座標
integer V_coordinate_floor_6;   //樓層6垂直位置座標
integer H_coordinate_floor_7;   //樓層7水平位置座標
integer V_coordinate_floor_7;   //樓層7垂直位置座標

//-------------------------------------------
//              CLK_25M
//-------------------------------------------
always@(posedge CLK or negedge RST)
begin
    if(!RST)
        VGA_CLK <= 1'b0;
    else 
        VGA_CLK <= ~VGA_CLK;
end 

//-------------------------------------------
//              H_TIMING
//-------------------------------------------
always@(posedge VGA_CLK or negedge RST)
begin
    if(!RST)
        H_CNT <= 10'd0;
    else if(H_CNT == H_LINE_PERIOD-1'b1)    //50MHz轉25MHz來計數H_CNT，H_CNT計數到(800-1)，H_CNT為0~799
        H_CNT <= 10'd0;
    else 
        H_CNT <= H_CNT + 1'b1;
end
assign H_SYNC = (H_CNT < H_SYNC_PULSE) ? 1'b0 : 1'b1;   //H_SYNC訊號為，計數H_CNT<96時為0，H_CNT>96時為1

//-------------------------------------------
//              V_TIMING
//-------------------------------------------
always@(posedge VGA_CLK or negedge RST)
begin
    if(!RST)
        V_CNT <= 10'd0;
    else if(H_CNT == H_LINE_PERIOD-1'b1)    //當H_CNT數道(800-1)時，V_CNT才開始計數+1
    begin
        if(V_CNT == V_FRAME_PERIOD-1'b1)    //25MHz計數V_CNT，當H_CNT=799時，V_CNT+1，
                                            //接著H_CNT從0->799，V_CNT再+1，重複之，V_CNT為0~524
            V_CNT <= 10'd0;
        else 
            V_CNT <= V_CNT + 1'b1;
    end
end
assign V_SYNC = (V_CNT < V_SYNC_PULSE) ? 1'b0 : 1'b1;   //V_SYNC為當計數V_CNT<2時為0，V_CNT>2時為1

//-------------------------------------------
//              ACTIVE RGB
//-------------------------------------------
assign Active_Flag = (H_CNT >= (H_SYNC_PULSE + H_BACK_PORCH - 1'b1))&&
                     (H_CNT <  (H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_TIME - 1'b1))&&
                     (V_CNT >= (V_SYNC_PULSE + V_BACK_PORCH - 1'b1))&&
                     (V_CNT <  (V_SYNC_PULSE + V_BACK_PORCH + V_ACTIVE_TIME - 1'b1));//Active_Flag為1時表輸出，Blank(Active)為(c)and(h)交集

//--------------------------------------------
//              圖像陣列宣告
//--------------------------------------------
reg [15:0]dataX_floor_1[0:30],  //R143/G51/B52  //垂直0~15，水平0~30
          dataY_floor_1[0:30],  //222/108/108   //floor_1圖像顏色暫存
          dataZ_floor_1[0:30],  //255/255/255
          dataW_floor_1[0:30],  //167/195/235
          dataV_floor_1[0:30];  //180/70/71
reg [10:0]dataX_floor_2[0:28],  //180/70/71     //垂直0~10，水平0~28
          dataY_floor_2[0:28],  //222/108/108   //floor_2圖像顏色暫存
          dataZ_floor_2[0:28],  //255/255/255
          dataW_floor_2[0:28];  //167/195/235
reg [13:0]dataX_floor_top[0:26],    //180/70/71     //垂直0~13，水平0~26
          dataY_floor_top[0:26],    //222/108/108   //floor_top圖像顏色暫存
          dataZ_floor_top[0:26],    //255/255/255
          dataW_floor_top[0:26];    //167/195/235
reg [31:0]dataX_hook[0:9],  //84/84/84      //垂直0~31，水平0~9
          dataY_hook[0:9],  //0/0/0         //hook圖像顏色暫存
          dataZ_hook[0:9];  //233/189/30
reg [4:0]dataX_FLOOR[0:18]; //0/0/0 //垂直0~4，水平0~18    //FLOOR圖像顏色暫存
reg [4:0]dataX_SCORE[0:18]; //0/0/0 //垂直0~4，水平0~18    //SCORE圖像顏色暫存
reg [4:0]dataX_0[0:2];  //0/0/0 //垂直0~4，水平0~2 //0圖像顏色暫存
reg [4:0]dataX_1[0:2];  //0/0/0 //垂直0~4，水平0~2 //1圖像顏色暫存
reg [4:0]dataX_2[0:2];  //0/0/0 //垂直0~4，水平0~2 //2圖像顏色暫存
reg [4:0]dataX_3[0:2];  //0/0/0 //垂直0~4，水平0~2 //3圖像顏色暫存
reg [4:0]dataX_4[0:2];  //0/0/0 //垂直0~4，水平0~2 //4圖像顏色暫存
reg [4:0]dataX_5[0:2];  //0/0/0 //垂直0~4，水平0~2 //5圖像顏色暫存
reg [4:0]dataX_6[0:2];  //0/0/0 //垂直0~4，水平0~2 //6圖像顏色暫存
reg [4:0]dataX_7[0:2];  //0/0/0 //垂直0~4，水平0~2 //7圖像顏色暫存
reg [4:0]dataX_8[0:2];  //0/0/0 //垂直0~4，水平0~2 //8圖像顏色暫存
reg [4:0]dataX_9[0:2];  //0/0/0 //垂直0~4，水平0~2 //9圖像顏色暫存
reg [4:0]dataX_add_50[0:10];    //0/255/0   //垂直0~4，水平0~10    //+50圖像顏色暫存
reg [4:0]dataX_add_100[0:14];   //0/255/0   //垂直0~4，水平0~14    //+100圖像顏色暫存
reg [13:0]dataX_life[0:14]; //255/0/0   //垂直0~13，水平0~14   //life圖像顏色暫存
reg [27:0]dataX_YouWin[0:15],   //255/255/255       //垂直0~27，水平0~15
          dataY_YouWin[0:15],   //128/113/19            //YouWin圖像顏色暫存
          dataZ_YouWin[0:15],   //176/156/26
          dataW_YouWin[0:15];   //255/226/38
reg [5:0]dataX_cloud[0:13], //175/223/245       //垂直0~5，水平0~13
         dataY_cloud[0:13], //215/237/251           //cloud圖像顏色暫存
         dataZ_cloud[0:13]; //255/255/255
reg [34:0]dataX_GAME_OVER[0:20];//game_over 畫面

always@(posedge CLK or negedge RST)begin
    //floor_1
    //R143/G51/B52
    dataX_floor_1[0]=16'b1000_0000_0000_0000;
    dataX_floor_1[1]=16'b1000_0000_0000_0000;
    dataX_floor_1[2]=16'b1000_0000_0000_0000;
    dataX_floor_1[3]=16'b1000_0000_0000_0000;
    dataX_floor_1[4]=16'b1000_0000_0000_0000;
    dataX_floor_1[5]=16'b1000_0000_0000_0000;
    dataX_floor_1[6]=16'b1000_0000_0000_0000;
    dataX_floor_1[7]=16'b1000_0000_0000_0000;
    dataX_floor_1[8]=16'b1000_0000_0000_0000;
    dataX_floor_1[9]=16'b1000_0000_0000_0000;
    dataX_floor_1[10]=16'b1000_0000_0000_0000;
    dataX_floor_1[11]=16'b1000_0000_0000_0000;
    dataX_floor_1[12]=16'b1111_1111_1111_1000;
    dataX_floor_1[13]=16'b1000_0000_0000_0000;
    dataX_floor_1[14]=16'b1000_0000_0000_0000;
    dataX_floor_1[15]=16'b1000_0000_0000_0000;
    dataX_floor_1[16]=16'b1000_0000_0000_0000;
    dataX_floor_1[17]=16'b1000_0000_0000_0000;
    dataX_floor_1[18]=16'b1000_0000_0000_0000;
    dataX_floor_1[19]=16'b1000_0000_0000_0000;
    dataX_floor_1[20]=16'b1000_0000_0000_0000;
    dataX_floor_1[21]=16'b1000_0000_0000_0000;
    dataX_floor_1[22]=16'b1000_0000_0000_0000;
    dataX_floor_1[23]=16'b1000_0000_0000_0000;
    dataX_floor_1[24]=16'b1000_0000_0000_0000;
    dataX_floor_1[25]=16'b1000_0000_0000_0000;
    dataX_floor_1[26]=16'b1000_0000_0000_0000;
    dataX_floor_1[27]=16'b1000_0000_0000_0000;
    dataX_floor_1[28]=16'b1000_0000_0000_0000;
    dataX_floor_1[29]=16'b1000_0000_0000_0000;
    dataX_floor_1[30]=16'b1000_0000_0000_0000;
    //222/108/108
    dataY_floor_1[0]=16'b0;
    dataY_floor_1[1]=16'b0;
    dataY_floor_1[2]=16'b0111_1111_1111_1110;
    dataY_floor_1[3]=16'b0111_1111_1111_1110;
    dataY_floor_1[4]=16'b0111_1111_1111_1110;
    dataY_floor_1[5]=16'b0111_1110_0000_0010;
    dataY_floor_1[6]=16'b0111_1110_0000_0010;
    dataY_floor_1[7]=16'b0111_1110_0000_0010;
    dataY_floor_1[8]=16'b0111_1110_0000_0010;
    dataY_floor_1[9]=16'b0111_1110_0000_0010;
    dataY_floor_1[10]=16'b0111_1111_1111_1110;
    dataY_floor_1[11]=16'b0111_1111_1111_1110;
    dataY_floor_1[12]=16'b0000_0000_0000_0110;
    dataY_floor_1[13]=16'b0000_0000_0000_0110;
    dataY_floor_1[14]=16'b0000_0000_0000_0110;
    dataY_floor_1[15]=16'b0000_0000_0000_0110;
    dataY_floor_1[16]=16'b0000_0000_0000_0110;
    dataY_floor_1[17]=16'b0000_0000_0000_0110;
    dataY_floor_1[18]=16'b0111_1111_1111_1110;
    dataY_floor_1[19]=16'b0111_1111_1111_1110;
    dataY_floor_1[20]=16'b0111_1111_1111_1110;
    dataY_floor_1[21]=16'b0111_1110_0000_0010;
    dataY_floor_1[22]=16'b0111_1110_0000_0010;
    dataY_floor_1[23]=16'b0111_1110_0000_0010;
    dataY_floor_1[24]=16'b0111_1110_0000_0010;
    dataY_floor_1[25]=16'b0111_1110_0000_0010;
    dataY_floor_1[26]=16'b0111_1111_1111_1110;
    dataY_floor_1[27]=16'b0111_1111_1111_1110;
    dataY_floor_1[28]=16'b0111_1111_1111_1110;
    dataY_floor_1[29]=16'b0;
    dataY_floor_1[30]=16'b0;
    //255/255/255
    dataZ_floor_1[0]=16'b0;
    dataZ_floor_1[1]=16'b0;
    dataZ_floor_1[2]=16'b0;
    dataZ_floor_1[3]=16'b0;
    dataZ_floor_1[4]=16'b0;
    dataZ_floor_1[5]=16'b0000_0001_1111_1100;
    dataZ_floor_1[6]=16'b0000_0001_0001_0100;
    dataZ_floor_1[7]=16'b0000_0001_1111_0100;
    dataZ_floor_1[8]=16'b0000_0001_0001_0100;
    dataZ_floor_1[9]=16'b0000_0001_1111_1100;
    dataZ_floor_1[10]=16'b0;
    dataZ_floor_1[11]=16'b0;
    dataZ_floor_1[12]=16'b0;
    dataZ_floor_1[13]=16'b0;
    dataZ_floor_1[14]=16'b0;
    dataZ_floor_1[15]=16'b0;
    dataZ_floor_1[16]=16'b0000_0011_1000_0000;
    dataZ_floor_1[17]=16'b0;
    dataZ_floor_1[18]=16'b0;
    dataZ_floor_1[19]=16'b0;
    dataZ_floor_1[20]=16'b0;
    dataZ_floor_1[21]=16'b0000_0001_1111_1100;
    dataZ_floor_1[22]=16'b0000_0001_0001_0100;
    dataZ_floor_1[23]=16'b0000_0001_1111_0100;
    dataZ_floor_1[24]=16'b0000_0001_0001_0100;
    dataZ_floor_1[25]=16'b0000_0001_1111_1100;
    dataZ_floor_1[26]=16'b0;
    dataZ_floor_1[27]=16'b0;
    dataZ_floor_1[28]=16'b0;
    dataZ_floor_1[29]=16'b0;
    dataZ_floor_1[30]=16'b0;
    //167/195/235
    dataW_floor_1[0]=16'b0;
    dataW_floor_1[1]=16'b0;
    dataW_floor_1[2]=16'b0;
    dataW_floor_1[3]=16'b0;
    dataW_floor_1[4]=16'b0;
    dataW_floor_1[5]=16'b0;
    dataW_floor_1[6]=16'b0000_0000_1110_1000;
    dataW_floor_1[7]=16'b0000_0000_0000_1000;
    dataW_floor_1[8]=16'b0000_0000_1110_1000;
    dataW_floor_1[9]=16'b0;
    dataW_floor_1[10]=16'b0;
    dataW_floor_1[11]=16'b0;
    dataW_floor_1[12]=16'b0;
    dataW_floor_1[13]=16'b0;
    dataW_floor_1[14]=16'b0;
    dataW_floor_1[15]=16'b0;
    dataW_floor_1[16]=16'b0;
    dataW_floor_1[17]=16'b0;
    dataW_floor_1[18]=16'b0;
    dataW_floor_1[19]=16'b0;
    dataW_floor_1[20]=16'b0;
    dataW_floor_1[21]=16'b0;
    dataW_floor_1[22]=16'b0000_0000_1110_1000;
    dataW_floor_1[23]=16'b0000_0000_0000_1000;
    dataW_floor_1[24]=16'b0000_0000_1110_1000;
    dataW_floor_1[25]=16'b0;
    dataW_floor_1[26]=16'b0;
    dataW_floor_1[27]=16'b0;
    dataW_floor_1[28]=16'b0;
    dataW_floor_1[29]=16'b0;
    dataW_floor_1[30]=16'b0;
    //180/70/71
    dataV_floor_1[0]=16'b0;
    dataV_floor_1[1]=16'b0000_0000_0000_0001;
    dataV_floor_1[2]=16'b0000_0000_0000_0001;
    dataV_floor_1[3]=16'b0000_0000_0000_0001;
    dataV_floor_1[4]=16'b0000_0000_0000_0001;
    dataV_floor_1[5]=16'b0000_0000_0000_0001;
    dataV_floor_1[6]=16'b0000_0000_0000_0001;
    dataV_floor_1[7]=16'b0000_0000_0000_0001;
    dataV_floor_1[8]=16'b0000_0000_0000_0001;
    dataV_floor_1[9]=16'b0000_0000_0000_0001;
    dataV_floor_1[10]=16'b0000_0000_0000_0001;
    dataV_floor_1[11]=16'b0000_0000_0000_0001;
    dataV_floor_1[12]=16'b0000_0000_0000_0001;
    dataV_floor_1[13]=16'b0111_1111_1111_1001;
    dataV_floor_1[14]=16'b0111_1111_1111_1001;
    dataV_floor_1[15]=16'b0111_1111_1111_1001;
    dataV_floor_1[16]=16'b0111_1100_0111_1001;
    dataV_floor_1[17]=16'b0111_1111_1111_1001;
    dataV_floor_1[18]=16'b0000_0000_0000_0001;
    dataV_floor_1[19]=16'b0000_0000_0000_0001;
    dataV_floor_1[20]=16'b0000_0000_0000_0001;
    dataV_floor_1[21]=16'b0000_0000_0000_0001;
    dataV_floor_1[22]=16'b0000_0000_0000_0001;
    dataV_floor_1[23]=16'b0000_0000_0000_0001;
    dataV_floor_1[24]=16'b0000_0000_0000_0001;
    dataV_floor_1[25]=16'b0000_0000_0000_0001;
    dataV_floor_1[26]=16'b0000_0000_0000_0001;
    dataV_floor_1[27]=16'b0000_0000_0000_0001;
    dataV_floor_1[28]=16'b0000_0000_0000_0001;
    dataV_floor_1[29]=16'b0000_0000_0000_0001;
    dataV_floor_1[30]=16'b0;
    
    //floor_2
    //180/70/71
    dataX_floor_2[0]=11'b1;
    dataX_floor_2[1]=11'b1;
    dataX_floor_2[2]=11'b1;
    dataX_floor_2[3]=11'b1;
    dataX_floor_2[4]=11'b1;
    dataX_floor_2[5]=11'b1;
    dataX_floor_2[6]=11'b1;
    dataX_floor_2[7]=11'b1;
    dataX_floor_2[8]=11'b1;
    dataX_floor_2[9]=11'b1;
    dataX_floor_2[10]=11'b1;
    dataX_floor_2[11]=11'b1;
    dataX_floor_2[12]=11'b1;
    dataX_floor_2[13]=11'b1;
    dataX_floor_2[14]=11'b1;
    dataX_floor_2[15]=11'b1;
    dataX_floor_2[16]=11'b1;
    dataX_floor_2[17]=11'b1;
    dataX_floor_2[18]=11'b1;
    dataX_floor_2[19]=11'b1;
    dataX_floor_2[20]=11'b1;
    dataX_floor_2[21]=11'b1;
    dataX_floor_2[22]=11'b1;
    dataX_floor_2[23]=11'b1;
    dataX_floor_2[24]=11'b1;
    dataX_floor_2[25]=11'b1;
    dataX_floor_2[26]=11'b1;
    dataX_floor_2[27]=11'b1;
    dataX_floor_2[28]=11'b1;
    //222/108/108
    dataY_floor_2[0]=11'b0;
    dataY_floor_2[1]=11'b111_1111_1110;
    dataY_floor_2[2]=11'b111_1111_1110;
    dataY_floor_2[3]=11'b111_1111_1110;
    dataY_floor_2[4]=11'b110_0000_0010;
    dataY_floor_2[5]=11'b110_0000_0010;
    dataY_floor_2[6]=11'b110_0000_0010;
    dataY_floor_2[7]=11'b110_0000_0010;
    dataY_floor_2[8]=11'b110_0000_0010;
    dataY_floor_2[9]=11'b111_1111_1110;
    dataY_floor_2[10]=11'b111_1111_1110;
    dataY_floor_2[11]=11'b111_1111_1110;
    dataY_floor_2[12]=11'b110_0000_0010;
    dataY_floor_2[13]=11'b110_0000_0010;
    dataY_floor_2[14]=11'b110_0000_0010;
    dataY_floor_2[15]=11'b110_0000_0010;
    dataY_floor_2[16]=11'b110_0000_0010;
    dataY_floor_2[17]=11'b111_1111_1110;
    dataY_floor_2[18]=11'b111_1111_1110;
    dataY_floor_2[19]=11'b111_1111_1110;
    dataY_floor_2[20]=11'b110_0000_0010;
    dataY_floor_2[21]=11'b110_0000_0010;
    dataY_floor_2[22]=11'b110_0000_0010;
    dataY_floor_2[23]=11'b110_0000_0010;
    dataY_floor_2[24]=11'b110_0000_0010;
    dataY_floor_2[25]=11'b111_1111_1110;
    dataY_floor_2[26]=11'b111_1111_1110;
    dataY_floor_2[27]=11'b111_1111_1110;
    dataY_floor_2[28]=11'b0;
    //255/255/255
    dataZ_floor_2[0]=11'b0;
    dataZ_floor_2[1]=11'b0;
    dataZ_floor_2[2]=11'b0;
    dataZ_floor_2[3]=11'b0;
    dataZ_floor_2[4]=11'h1fc;
    dataZ_floor_2[5]=11'h114;
    dataZ_floor_2[6]=11'h1f4;
    dataZ_floor_2[7]=11'h114;
    dataZ_floor_2[8]=11'h1fc;
    dataZ_floor_2[9]=11'b0;
    dataZ_floor_2[10]=11'b0;
    dataZ_floor_2[11]=11'b0;
    dataZ_floor_2[12]=11'h1fc;
    dataZ_floor_2[13]=11'h114;
    dataZ_floor_2[14]=11'h1f4;
    dataZ_floor_2[15]=11'h114;
    dataZ_floor_2[16]=11'h1fc;
    dataZ_floor_2[17]=11'b0;
    dataZ_floor_2[18]=11'b0;
    dataZ_floor_2[19]=11'b0;
    dataZ_floor_2[20]=11'h1fc;
    dataZ_floor_2[21]=11'h114;
    dataZ_floor_2[22]=11'h1f4;
    dataZ_floor_2[23]=11'h114;
    dataZ_floor_2[24]=11'h1fc;
    dataZ_floor_2[25]=11'b0;
    dataZ_floor_2[26]=11'b0;
    dataZ_floor_2[27]=11'b0;
    dataZ_floor_2[28]=11'b0;
    //167/195/235
    dataW_floor_2[0]=11'b0;
    dataW_floor_2[1]=11'b0;
    dataW_floor_2[2]=11'b0;
    dataW_floor_2[3]=11'b0;
    dataW_floor_2[4]=11'b0;
    dataW_floor_2[5]=11'h0e8;
    dataW_floor_2[6]=11'h008;
    dataW_floor_2[7]=11'h0e8;
    dataW_floor_2[8]=11'b0;
    dataW_floor_2[9]=11'b0;
    dataW_floor_2[10]=11'b0;
    dataW_floor_2[11]=11'b0;
    dataW_floor_2[12]=11'b0;
    dataW_floor_2[13]=11'h0e8;
    dataW_floor_2[14]=11'h008;
    dataW_floor_2[15]=11'h0e8;
    dataW_floor_2[16]=11'b0;
    dataW_floor_2[17]=11'b0;
    dataW_floor_2[18]=11'b0;
    dataW_floor_2[19]=11'b0;
    dataW_floor_2[20]=11'b0;
    dataW_floor_2[21]=11'h0e8;
    dataW_floor_2[22]=11'h008;
    dataW_floor_2[23]=11'h0e8;
    dataW_floor_2[24]=11'b0;
    dataW_floor_2[25]=11'b0;
    dataW_floor_2[26]=11'b0;
    dataW_floor_2[27]=11'b0;
    dataW_floor_2[28]=11'b0;
    
    //floor_top
    //180/70/71
    dataX_floor_top[0]=14'b1;
    dataX_floor_top[1]=14'b1;
    dataX_floor_top[2]=14'h2;
    dataX_floor_top[3]=14'h3;
    dataX_floor_top[4]=14'b1;
    dataX_floor_top[5]=14'h2;
    dataX_floor_top[6]=14'h2;
    dataX_floor_top[7]=14'b1;
    dataX_floor_top[8]=14'b1;
    dataX_floor_top[9]=14'h2;
    dataX_floor_top[10]=14'h2;
    dataX_floor_top[11]=14'b1;
    dataX_floor_top[12]=14'h3;
    dataX_floor_top[13]=14'h2;
    dataX_floor_top[14]=14'b1;
    dataX_floor_top[15]=14'b1;
    dataX_floor_top[16]=14'h2;
    dataX_floor_top[17]=14'h2;
    dataX_floor_top[18]=14'b1;
    dataX_floor_top[19]=14'b1;
    dataX_floor_top[20]=14'h2;
    dataX_floor_top[21]=14'h3;
    dataX_floor_top[22]=14'b1;
    dataX_floor_top[23]=14'h2;
    dataX_floor_top[24]=14'h2;
    dataX_floor_top[25]=14'b1;
    dataX_floor_top[26]=14'b1;
    //222/108/108
    dataY_floor_top[0]=14'h3ffe;
    dataY_floor_top[1]=14'h3ffe;
    dataY_floor_top[2]=14'h3ffc;
    dataY_floor_top[3]=14'h203c;
    dataY_floor_top[4]=14'h203e;
    dataY_floor_top[5]=14'h203c;
    dataY_floor_top[6]=14'h203c;
    dataY_floor_top[7]=14'h203e;
    dataY_floor_top[8]=14'h3ffe;
    dataY_floor_top[9]=14'h3ffc;
    dataY_floor_top[10]=14'h3ffc;
    dataY_floor_top[11]=14'h203e;
    dataY_floor_top[12]=14'h203c;
    dataY_floor_top[13]=14'h203c;
    dataY_floor_top[14]=14'h203e;
    dataY_floor_top[15]=14'h203e;
    dataY_floor_top[16]=14'h3ffc;
    dataY_floor_top[17]=14'h3ffc;
    dataY_floor_top[18]=14'h3ffe;
    dataY_floor_top[19]=14'h203e;
    dataY_floor_top[20]=14'h203c;
    dataY_floor_top[21]=14'h203c;
    dataY_floor_top[22]=14'h203e;
    dataY_floor_top[23]=14'h203c;
    dataY_floor_top[24]=14'h3ffc;
    dataY_floor_top[25]=14'h3ffe;
    dataY_floor_top[26]=14'h3ffe;
    //255/255/255
    dataZ_floor_top[0]=14'h0;
    dataZ_floor_top[1]=14'h0;
    dataZ_floor_top[2]=14'h0;
    dataZ_floor_top[3]=14'h1fc0;
    dataZ_floor_top[4]=14'h1140;
    dataZ_floor_top[5]=14'h1f40;
    dataZ_floor_top[6]=14'h1140;
    dataZ_floor_top[7]=14'h1fc0;
    dataZ_floor_top[8]=14'h0;
    dataZ_floor_top[9]=14'h0;
    dataZ_floor_top[10]=14'h0;
    dataZ_floor_top[11]=14'h1fc0;
    dataZ_floor_top[12]=14'h1140;
    dataZ_floor_top[13]=14'h1f40;
    dataZ_floor_top[14]=14'h1140;
    dataZ_floor_top[15]=14'h1fc0;
    dataZ_floor_top[16]=14'h0;
    dataZ_floor_top[17]=14'h0;
    dataZ_floor_top[18]=14'h0;
    dataZ_floor_top[19]=14'h1fc0;
    dataZ_floor_top[20]=14'h1140;
    dataZ_floor_top[21]=14'h1f40;
    dataZ_floor_top[22]=14'h1140;
    dataZ_floor_top[23]=14'h1fc0;
    dataZ_floor_top[24]=14'h0;
    dataZ_floor_top[25]=14'h0;
    dataZ_floor_top[26]=14'h0;
    //167/195/235
    dataW_floor_top[0]=14'h0;
    dataW_floor_top[1]=14'h0;
    dataW_floor_top[2]=14'h0;
    dataW_floor_top[3]=14'h0;
    dataW_floor_top[4]=14'h0e80;
    dataW_floor_top[5]=14'h0080;
    dataW_floor_top[6]=14'h0e80;
    dataW_floor_top[7]=14'h0;
    dataW_floor_top[8]=14'h0;
    dataW_floor_top[9]=14'h0;
    dataW_floor_top[10]=14'h0;
    dataW_floor_top[11]=14'h0;
    dataW_floor_top[12]=14'h0e80;
    dataW_floor_top[13]=14'h0080;
    dataW_floor_top[14]=14'h0e80;
    dataW_floor_top[15]=14'h0;
    dataW_floor_top[16]=14'h0;
    dataW_floor_top[17]=14'h0;
    dataW_floor_top[18]=14'h0;
    dataW_floor_top[19]=14'h0;
    dataW_floor_top[20]=14'h0e80;
    dataW_floor_top[21]=14'h0080;
    dataW_floor_top[22]=14'h0e80;
    dataW_floor_top[23]=14'h0;
    dataW_floor_top[24]=14'h0;
    dataW_floor_top[25]=14'h0;
    dataW_floor_top[26]=14'h0;
    
    //hook
    //84/84/84
    dataX_hook[0]=32'h1c000000;
    dataX_hook[1]=32'h7f000000;
    dataX_hook[2]=32'h7f000000;
    dataX_hook[3]=32'hf7a00000;
    dataX_hook[4]=32'he1e00000;
    dataX_hook[5]=32'he0e00000;
    dataX_hook[6]=32'he0200000;
    dataX_hook[7]=32'h78000000;
    dataX_hook[8]=32'h3e000000;
    dataX_hook[9]=32'h07000000;
    //0/0/0
    dataY_hook[0]=32'h00003000;
    dataY_hook[1]=32'h00031bff;
    dataY_hook[2]=32'h00018e00;
    dataY_hook[3]=32'h0018c700;
    dataY_hook[4]=32'h001c6300;
    dataY_hook[5]=32'h00163300;
    dataY_hook[6]=32'h00131b00;
    dataY_hook[7]=32'h00018e00;
    dataY_hook[8]=32'h0000c7ff;
    dataY_hook[9]=32'h00006000;
    //233/189/30
    dataZ_hook[0]=32'h0001cc00;
    dataZ_hook[1]=32'h0000e400;
    dataZ_hook[2]=32'h00067000;
    dataZ_hook[3]=32'h00073800;
    dataZ_hook[4]=32'h00039c00;
    dataZ_hook[5]=32'h0009cc00;
    dataZ_hook[6]=32'h000ce400;
    dataZ_hook[7]=32'h00067000;
    dataZ_hook[8]=32'h00033800;
    dataZ_hook[9]=32'h00019c00;
    
    //FLOOR圖像顏色暫存
    //0/0/0
    dataX_SCORE[0]=5'h17;
    dataX_SCORE[1]=5'h15;
    dataX_SCORE[2]=5'h1d;
    dataX_SCORE[3]=5'h0;
    dataX_SCORE[4]=5'h1f;
    dataX_SCORE[5]=5'h11;
    dataX_SCORE[6]=5'h11;
    dataX_SCORE[7]=5'h0;
    dataX_SCORE[8]=5'h1f;
    dataX_SCORE[9]=5'h11;
    dataX_SCORE[10]=5'h1f;
    dataX_SCORE[11]=5'h0;
    dataX_SCORE[12]=5'h1f;
    dataX_SCORE[13]=5'h0d;
    dataX_SCORE[14]=5'h17;
    dataX_SCORE[15]=5'h0;
    dataX_SCORE[16]=5'h1f;
    dataX_SCORE[17]=5'h15;
    dataX_SCORE[18]=5'h15;
    
    //SCORE圖像顏色暫存
    //0/0/0
    dataX_FLOOR[0]=5'h1f;
    dataX_FLOOR[1]=5'h05;
    dataX_FLOOR[2]=5'h05;
    dataX_FLOOR[3]=5'h0;
    dataX_FLOOR[4]=5'h1f;
    dataX_FLOOR[5]=5'h10;
    dataX_FLOOR[6]=5'h10;
    dataX_FLOOR[7]=5'h0;
    dataX_FLOOR[8]=5'h1f;
    dataX_FLOOR[9]=5'h11;
    dataX_FLOOR[10]=5'h1f;
    dataX_FLOOR[11]=5'h0;
    dataX_FLOOR[12]=5'h1f;
    dataX_FLOOR[13]=5'h11;
    dataX_FLOOR[14]=5'h1f;
    dataX_FLOOR[15]=5'h0;
    dataX_FLOOR[16]=5'h1f;
    dataX_FLOOR[17]=5'h0d;
    dataX_FLOOR[18]=5'h17;
    
    //0圖像顏色暫存
    //0/0/0
    dataX_0[0]=5'b11111;
    dataX_0[1]=5'b10001;
    dataX_0[2]=5'b11111;
    //1圖像顏色暫存
    //0/0/0
    dataX_1[0]=5'b10001;
    dataX_1[1]=5'b11111;
    dataX_1[2]=5'b10000;
    //2圖像顏色暫存
    //0/0/0
    dataX_2[0]=5'b11101;
    dataX_2[1]=5'b10101;
    dataX_2[2]=5'b10111;
    //3圖像顏色暫存
    //0/0/0
    dataX_3[0]=5'b10101;
    dataX_3[1]=5'b10101;
    dataX_3[2]=5'b11111;
    //4圖像顏色暫存
    //0/0/0
    dataX_4[0]=5'b00111;
    dataX_4[1]=5'b00100;
    dataX_4[2]=5'b11111;
    //5圖像顏色暫存
    //0/0/0
    dataX_5[0]=5'b10111;
    dataX_5[1]=5'b10101;
    dataX_5[2]=5'b11101;
    //6圖像顏色暫存
    //0/0/0
    dataX_6[0]=5'b11111;
    dataX_6[1]=5'b10101;
    dataX_6[2]=5'b11101;
    //7圖像顏色暫存
    //0/0/0
    dataX_7[0]=5'b00011;
    dataX_7[1]=5'b00001;
    dataX_7[2]=5'b11111;
    //8圖像顏色暫存
    //0/0/0
    dataX_8[0]=5'b11111;
    dataX_8[1]=5'b10101;
    dataX_8[2]=5'b11111;
    //9圖像顏色暫存
    //0/0/0
    dataX_9[0]=5'b00111;
    dataX_9[1]=5'b00101;
    dataX_9[2]=5'b11111;
    
    //+50圖像顏色暫存
    //0/255/0
    dataX_add_50[0]=5'h04;
    dataX_add_50[1]=5'h0e;
    dataX_add_50[2]=5'h04;
    dataX_add_50[3]=5'h00;
    dataX_add_50[4]=5'h17;
    dataX_add_50[5]=5'h15;
    dataX_add_50[6]=5'h1d;
    dataX_add_50[7]=5'h0;
    dataX_add_50[8]=5'h1f;
    dataX_add_50[9]=5'h11;
    dataX_add_50[10]=5'h1f;
    
    //+100圖像顏色暫存
    //0/255/0
    dataX_add_100[0]=5'h04;
    dataX_add_100[1]=5'h0e;
    dataX_add_100[2]=5'h04;
    dataX_add_100[3]=5'h00;
    dataX_add_100[4]=5'h11;
    dataX_add_100[5]=5'h1f;
    dataX_add_100[6]=5'h10;
    dataX_add_100[7]=5'h0;
    dataX_add_100[8]=5'h1f;
    dataX_add_100[9]=5'h11;
    dataX_add_100[10]=5'h1f;
    dataX_add_100[11]=5'h0;
    dataX_add_100[12]=5'h1f;
    dataX_add_100[13]=5'h11;
    dataX_add_100[14]=5'h1f;
    
    //life圖像顏色暫存
    //255/0/0
    dataX_life[0]=14'h0078;
    dataX_life[1]=14'h00fc;
    dataX_life[2]=14'h01fe;
    dataX_life[3]=14'h03ff;
    dataX_life[4]=14'h07ff;
    dataX_life[5]=14'h0ffe;
    dataX_life[6]=14'h1ffc;
    dataX_life[7]=14'h3ff8;
    dataX_life[8]=14'h1ffc;
    dataX_life[9]=14'h0ffe;
    dataX_life[10]=14'h07ff;
    dataX_life[11]=14'h03ff;
    dataX_life[12]=14'h01fe;
    dataX_life[13]=14'h00fc;
    dataX_life[14]=14'h0078;
    
    //YouWin圖像顏色暫存
    //255/255/255
    dataX_YouWin[0]=28'h0;
    dataX_YouWin[1]=28'h0000027;
    dataX_YouWin[2]=28'h7000024;
    dataX_YouWin[3]=28'h8000024;
    dataX_YouWin[4]=28'h600003f;
    dataX_YouWin[5]=28'h8000000;
    dataX_YouWin[6]=28'h700003e;
    dataX_YouWin[7]=28'h0000022;
    dataX_YouWin[8]=28'hf000022;
    dataX_YouWin[9]=28'h000003e;
    dataX_YouWin[10]=28'hf000000;
    dataX_YouWin[11]=28'h100003f;
    dataX_YouWin[12]=28'h6000020;
    dataX_YouWin[13]=28'hf000020;
    dataX_YouWin[14]=28'h000003f;
    dataX_YouWin[15]=28'h0;
    //128/113/19
    dataY_YouWin[0]=28'h0;
    dataY_YouWin[1]=28'h0;
    dataY_YouWin[2]=28'h0;
    dataY_YouWin[3]=28'h0600000;
    dataY_YouWin[4]=28'h0500000;
    dataY_YouWin[5]=28'h0500000;
    dataY_YouWin[6]=28'h0700000;
    dataY_YouWin[7]=28'h0500000;
    dataY_YouWin[8]=28'h0500000;
    dataY_YouWin[9]=28'h0700000;
    dataY_YouWin[10]=28'h0500000;
    dataY_YouWin[11]=28'h0500000;
    dataY_YouWin[12]=28'h0600000;
    dataY_YouWin[13]=28'h0;
    dataY_YouWin[14]=28'h0;
    dataY_YouWin[15]=28'h0;
    //176/156/26
    dataZ_YouWin[0]=28'h0;
    dataZ_YouWin[1]=28'h0;
    dataZ_YouWin[2]=28'h0000680;
    dataZ_YouWin[3]=28'h0003880;
    dataZ_YouWin[4]=28'h0002080;
    dataZ_YouWin[5]=28'h0000080;
    dataZ_YouWin[6]=28'h0060080;
    dataZ_YouWin[7]=28'h0040080;
    dataZ_YouWin[8]=28'h0058080;
    dataZ_YouWin[9]=28'h0066080;
    dataZ_YouWin[10]=28'h0001880;
    dataZ_YouWin[11]=28'h0000680;
    dataZ_YouWin[12]=28'h0000180;
    dataZ_YouWin[13]=28'h0002280;
    dataZ_YouWin[14]=28'h0002200;
    dataZ_YouWin[15]=28'h0001c00;
    //255/226/38
    dataW_YouWin[0]=28'h0001c00;
    dataW_YouWin[1]=28'h0003600;
    dataW_YouWin[2]=28'h0002000;
    dataW_YouWin[3]=28'h0000100;
    dataW_YouWin[4]=28'h0000700;
    dataW_YouWin[5]=28'h0001f00;
    dataW_YouWin[6]=28'h0007f00;
    dataW_YouWin[7]=28'h003ff00;
    dataW_YouWin[8]=28'h0027f00;
    dataW_YouWin[9]=28'h0001f00;
    dataW_YouWin[10]=28'h0000700;
    dataW_YouWin[11]=28'h0002100;
    dataW_YouWin[12]=28'h0003800;
    dataW_YouWin[13]=28'h0000400;
    dataW_YouWin[14]=28'h0001400;
    dataW_YouWin[15]=28'h0;
    
    //cloud圖像
    //175/223/245
    dataX_cloud[0]=6'h18;
    dataX_cloud[1]=6'h30;
    dataX_cloud[2]=6'h20;
    dataX_cloud[3]=6'h20;
    dataX_cloud[4]=6'h20;
    dataX_cloud[5]=6'h20;
    dataX_cloud[6]=6'h30;
    dataX_cloud[7]=6'h30;
    dataX_cloud[8]=6'h30;
    dataX_cloud[9]=6'h30;
    dataX_cloud[10]=6'h20;
    dataX_cloud[11]=6'h30;
    dataX_cloud[12]=6'h30;
    dataX_cloud[13]=6'h20;
    //215/237/251
    dataY_cloud[0]=6'h00;
    dataY_cloud[1]=6'h08;
    dataY_cloud[2]=6'h18;
    dataY_cloud[3]=6'h18;
    dataY_cloud[4]=6'h18;
    dataY_cloud[5]=6'h1c;
    dataY_cloud[6]=6'h0c;
    dataY_cloud[7]=6'h0c;
    dataY_cloud[8]=6'h08;
    dataY_cloud[9]=6'h00;
    dataY_cloud[10]=6'h18;
    dataY_cloud[11]=6'h08;
    dataY_cloud[12]=6'h00;
    dataY_cloud[13]=6'h00;
    //255/255/255
    dataZ_cloud[0]=6'h0;
    dataZ_cloud[1]=6'h0;
    dataZ_cloud[2]=6'h04;
    dataZ_cloud[3]=6'h04;
    dataZ_cloud[4]=6'h06;
    dataZ_cloud[5]=6'h03;
    dataZ_cloud[6]=6'h03;
    dataZ_cloud[7]=6'h02;
    dataZ_cloud[8]=6'h04;
    dataZ_cloud[9]=6'h08;
    dataZ_cloud[10]=6'h04;
    dataZ_cloud[11]=6'h04;
    dataZ_cloud[12]=6'h08;
    dataZ_cloud[13]=6'h10;
    
    //GAME_OVER 圖像顏色暫存
    dataX_GAME_OVER[0] =35'b00111000000011000001000010011111111;
    dataX_GAME_OVER[1] =35'b01000100000111100011100111010000000;
    dataX_GAME_OVER[2] =35'b10000010000100100010100101010000000;
    dataX_GAME_OVER[3] =35'b10000000001100110010100101010000000;
    dataX_GAME_OVER[4] =35'b10000000001000010010111101011111110;
    dataX_GAME_OVER[5] =35'b10001111001111110010111101010000000;
    dataX_GAME_OVER[6] =35'b10000011011000011010111101010000000;
    dataX_GAME_OVER[7] =35'b01000101011000011010011001010000000;
    dataX_GAME_OVER[8] =35'b00111001010000001010011001011111111;
    dataX_GAME_OVER[9] =35'd0;
    dataX_GAME_OVER[10]=35'd0;
    dataX_GAME_OVER[11]=35'd0;
    dataX_GAME_OVER[12]=35'b00011000010000001011111111011111100;
    dataX_GAME_OVER[13]=35'b00100100010000001010000000010000010;
    dataX_GAME_OVER[14]=35'b01000010010000001010000000010000001;
    dataX_GAME_OVER[15]=35'b10000001011000011010000000010000001;
    dataX_GAME_OVER[16]=35'b10000001001000010011111110010000010;
    dataX_GAME_OVER[17]=35'b10000001001100110010000000011111100;
    dataX_GAME_OVER[18]=35'b01000010000100100010000000010001000;
    dataX_GAME_OVER[19]=35'b00100100000111100010000000010000100;
    dataX_GAME_OVER[20]=35'b00011000000011000011111111010000010;
end


//--------------------------------------------------
//              vga_display
//--------------------------------------------------
always@(posedge VGA_CLK or negedge RST)
begin
    if(!RST) begin
        R_out <= 8'h00;
        G_out <= 8'h00;
        B_out <= 8'h00;
        
    end
    else if(Active_Flag) begin      //Active_Flag為1時表輸出
        
        
        //-------------------------------------------
        //              螢幕底色(背景)
        //-------------------------------------------
        R_out <= 8'd76;
        G_out <= 8'd152;
        B_out <= 8'd204;
        
        //顯示cloud圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_cloud_move))     //H_CNT大於值顯示圖案
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_cloud_move))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_cloud==0)begin   //=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_cloud_move+1))/3;         //x=15*3=45
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_cloud_move+1))/3; //y=14*3=42
                                                //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                //圖案座標x->0~(799-...)，y->0~(524-...)
                                                //畫圖起始座標(x=100,y=100)
                                                //Figure_distance圖案與圖案間距
                X_color=dataX_cloud[x][y];
                Y_color=dataY_cloud[x][y];
                Z_color=dataZ_cloud[x][y];
                
                if((x>13)||(y>5))begin  //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                end
                
                if(X_color==1)begin //175/223/245
                    R_out <= 8'd175;
                    G_out <= 8'd223;
                    B_out <= 8'd245;
                end
                if(Y_color==1)begin //215/237/251
                    R_out <= 8'd215;
                    G_out <= 8'd237;
                    B_out <= 8'd251;
                end
                if(Z_color==1)begin //255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
            end
        end
        //顯示life_bar->左，綠
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH))      //H_CNT大於值顯示圖案
        &&(H_CNT<(H_SYNC_PULSE+H_BACK_PORCH+20))    //小精靈放大4倍，x=11*4=44，y=11*4=48
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH))
        &&(V_CNT<(V_SYNC_PULSE+V_BACK_PORCH+life_bar))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(life_bar>=160*2)begin
                R_out <= 8'd0;
                G_out <= 8'd255;
                B_out <= 8'd0;
            end
        end
        //顯示life_bar->左，黃
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH))      //H_CNT大於值顯示圖案
        &&(H_CNT<(H_SYNC_PULSE+H_BACK_PORCH+20))    //小精靈放大4倍，x=11*4=44，y=11*4=48
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH))
        &&(V_CNT<(V_SYNC_PULSE+V_BACK_PORCH+life_bar))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(life_bar<160*2)begin
                R_out <= 8'd255;
                G_out <= 8'd255;
                B_out <= 8'd0;
            end
        end
        //顯示life_bar->左，紅
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH))      //H_CNT大於值顯示圖案
        &&(H_CNT<(H_SYNC_PULSE+H_BACK_PORCH+20))    //小精靈放大4倍，x=11*4=44，y=11*4=48
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH))
        &&(V_CNT<(V_SYNC_PULSE+V_BACK_PORCH+life_bar))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(life_bar<160)begin
                R_out <= 8'd255;
                G_out <= 8'd0;
                B_out <= 8'd0;
            end
        end
        
        //顯示life_1圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+20+10))        //H_CNT大於值顯示圖案
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(life>=1)begin    //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+20+10+1))/3;    //x=15*3=45
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+10+1))/3;       //y=14*3=42
                                                //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                //圖案座標x->0~(799-...)，y->0~(524-...)
                                                //畫圖起始座標(x=100,y=100)
                                                //Figure_distance圖案與圖案間距
                X_color=dataX_life[x][y];
                
                if((x>14)||(y>13))begin //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //red
                    R_out <= 8'd255;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示life_2圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+20+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+10+42+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(life>=2)begin    //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+20+10+1))/3;    //x=15*3=45
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+10+42+10+1))/3; //y=14*3=42
                                                //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                //圖案座標x->0~(799-...)，y->0~(524-...)
                                                //畫圖起始座標(x=100,y=100)
                                                //Figure_distance圖案與圖案間距
                X_color=dataX_life[x][y];
                
                if((x>14)||(y>13))begin //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //red
                    R_out <= 8'd255;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示life_3圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+20+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+10+42+10+42+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(life==3)begin    //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+20+10+1))/3;            //x=15*3=45
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+10+42+10+42+10+1))/3;   //y=14*3=42
                                                //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                //圖案座標x->0~(799-...)，y->0~(524-...)
                                                //畫圖起始座標(x=100,y=100)
                                                //Figure_distance圖案與圖案間距
                X_color=dataX_life[x][y];
                
                if((x>14)||(y>13))begin //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //red
                    R_out <= 8'd255;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              上層圖案顯示
        //-------------------------------------------
        
        //顯示floor_1圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_1))     //H_CNT大於值顯示圖案
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_1))
        )begin
            if(color_closs_1==0)begin   //color_closs_1=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_1+1))/5; //x=31*5=155
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_1+1))/5; //y=16*5=80
                                                    //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                    //圖案座標x->0~(799-...)，y->0~(524-...)
                                                    //畫圖起始座標(x=100,y=100)
                                                    //Figure_distance圖案與圖案間距
                X_color=dataX_floor_1[x][y];
                Y_color=dataY_floor_1[x][y];
                Z_color=dataZ_floor_1[x][y];
                W_color=dataW_floor_1[x][y];
                V_color=dataV_floor_1[x][y];
                
                if((x>30)||(y>15))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                    V_color=0;
                end
                
                if(X_color==1)begin //R143/G51/B52
                    R_out <= 8'd143;
                    G_out <= 8'd51;
                    B_out <= 8'd52;
                end
                if(Y_color==1)begin //222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin //255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin //167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
                if(V_color==1)begin //180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
            end
        end
        //顯示floor_2圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_2+H_floor_shake_2))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_2))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_2==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_2+H_floor_shake_2+1))/5; //x=29*5=145
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_2+1))/5; //y=11*5=55
                                                        //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                        //圖案座標x->0~(799-...)，y->0~(524-...)
                                                        //畫圖起始座標(x=100,y=100)
                                                        //Figure_distance圖案與圖案間距
                X_color=dataX_floor_2[x][y];
                Y_color=dataY_floor_2[x][y];
                Z_color=dataZ_floor_2[x][y];
                W_color=dataW_floor_2[x][y];
                
                if((x>28)||(y>10))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin//180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
                if(Y_color==1)begin//222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin//255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin//167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
            end
        end
        //顯示floor_3圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_3+H_floor_shake_3))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_3))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_3==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_3+H_floor_shake_3+1))/5; //x=29*5=145
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_3+1))/5; //y=11*5=55
                                                        //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                        //圖案座標x->0~(799-...)，y->0~(524-...)
                                                        //畫圖起始座標(x=100,y=100)
                                                        //Figure_distance圖案與圖案間距
                X_color=dataX_floor_2[x][y];
                Y_color=dataY_floor_2[x][y];
                Z_color=dataZ_floor_2[x][y];
                W_color=dataW_floor_2[x][y];
                
                if((x>28)||(y>10))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin//180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
                if(Y_color==1)begin//222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin//255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin//167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
            end
        end
        //顯示floor_4圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_4+H_floor_shake_4))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_4))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_4==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_4+H_floor_shake_4+1))/5; //x=29*5=145
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_4+1))/5; //y=11*5=55
                                                        //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                        //圖案座標x->0~(799-...)，y->0~(524-...)
                                                        //畫圖起始座標(x=100,y=100)
                                                        //Figure_distance圖案與圖案間距
                X_color=dataX_floor_2[x][y];
                Y_color=dataY_floor_2[x][y];
                Z_color=dataZ_floor_2[x][y];
                W_color=dataW_floor_2[x][y];
                
                if((x>28)||(y>10))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin//180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
                if(Y_color==1)begin//222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin//255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin//167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
            end
        end
        //顯示floor_5圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_5+H_floor_shake_5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_5))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_5==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_5+H_floor_shake_5+1))/5; //x=29*5=145
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_5+1))/5; //y=11*5=55
                                                    //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                    //圖案座標x->0~(799-...)，y->0~(524-...)
                                                    //畫圖起始座標(x=100,y=100)
                                                    //Figure_distance圖案與圖案間距
                X_color=dataX_floor_2[x][y];
                Y_color=dataY_floor_2[x][y];
                Z_color=dataZ_floor_2[x][y];
                W_color=dataW_floor_2[x][y];
                
                if((x>28)||(y>10))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin//180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
                if(Y_color==1)begin//222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin//255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin//167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
            end
        end
        //顯示floor_6圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_6+H_floor_shake_6))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_6))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_6==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_6+H_floor_shake_6+1))/5; //x=29*5=145
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_6+1))/5; //y=11*5=55
                                                    //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                    //圖案座標x->0~(799-...)，y->0~(524-...)
                                                    //畫圖起始座標(x=100,y=100)
                                                    //Figure_distance圖案與圖案間距
                X_color=dataX_floor_2[x][y];
                Y_color=dataY_floor_2[x][y];
                Z_color=dataZ_floor_2[x][y];
                W_color=dataW_floor_2[x][y];
                
                if((x>28)||(y>10))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin//180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
                if(Y_color==1)begin//222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin//255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin//167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
            end
        end
        //顯示floor_7圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_7+H_floor_shake_7))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_7))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_7==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_7+H_floor_shake_7+1))/5; //x=29*5=145
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_7+1))/5; //y=11*5=55
                                                    //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                    //圖案座標x->0~(799-...)，y->0~(524-...)
                                                    //畫圖起始座標(x=100,y=100)
                                                    //Figure_distance圖案與圖案間距
                X_color=dataX_floor_2[x][y];
                Y_color=dataY_floor_2[x][y];
                Z_color=dataZ_floor_2[x][y];
                W_color=dataW_floor_2[x][y];
                
                if((x>28)||(y>10))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin//180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
                if(Y_color==1)begin//222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin//255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin//167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
            end
        end
        //顯示floor_top圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_2+H_floor_shake_top))   //第20層用到的為 H_coordinate_floor_2
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_2))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_top==0)begin //0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_floor_2+H_floor_shake_top+1))/5;   //x=27*5=135
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_floor_2+1))/5; //y=14*5=70
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_floor_top[x][y];
                Y_color=dataY_floor_top[x][y];
                Z_color=dataZ_floor_top[x][y];
                W_color=dataW_floor_top[x][y];
                
                if((x>26)||(y>13))begin //x只到10，y只到11
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin//180/70/71
                    R_out <= 8'd180;
                    G_out <= 8'd70;
                    B_out <= 8'd71;
                end
                if(Y_color==1)begin//222/108/108
                    R_out <= 8'd222;
                    G_out <= 8'd108;
                    B_out <= 8'd108;
                end
                if(Z_color==1)begin//255/255/255
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd255;
                end
                if(W_color==1)begin//167/195/235
                    R_out <= 8'd167;
                    G_out <= 8'd195;
                    B_out <= 8'd235;
                end
            end
        end
        //顯示hook圖像
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_hook))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_hook))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_hook==0)begin    //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+H_coordinate_hook+1))/5;    //x=10*5=50
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+V_coordinate_hook+1))/5;    //y=32*5=160
                                                    //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                    //圖案座標x->0~(799-...)，y->0~(524-...)
                                                    //畫圖起始座標(x=100,y=100)
                                                    //Figure_distance圖案與圖案間距
                X_color=dataX_hook[x][y];
                Y_color=dataY_hook[x][y];
                Z_color=dataZ_hook[x][y];
                
                if((x>9)||(y>31))begin  //x只到9，y只到31
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                end
                
                if(X_color==1)begin//84/84/84
                    R_out <= 8'd84;
                    G_out <= 8'd84;
                    B_out <= 8'd84;
                end
                if(Y_color==1)begin//0/0/0
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
                if(Z_color==1)begin//233/189/30
                    R_out <= 8'd233;
                    G_out <= 8'd189;
                    B_out <= 8'd30;
                end
            end
        end
        //顯示FLOOR圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_FLOOR==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+1))/5;  //x=19*5=95
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+1))/5;  //y=5*5=25
                                                    //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                    //圖案座標x->0~(799-...)，y->0~(524-...)
                                                    //畫圖起始座標(x=100,y=100)
                                                    //Figure_distance圖案與圖案間距
                X_color=dataX_FLOOR[x][y];
                
                if((x>18)||(y>4))begin  //x只到18，y只到4
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示SCORE圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_SCORE==0)begin   //color_closs_2=0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+1))/5;  //放大圖4倍
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+1))/5;   //圖案座標x and y 從0開始跑，圖座標[x][y]
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_SCORE[x][y];
                
                if((x>18)||(y>4))begin  //x只到18，y只到4
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              FLOOR個位數
        //-------------------------------------------
        
        //顯示0圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==0)||(floor_num==10)||(floor_num==20))begin   //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_0[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示1圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==1)||(floor_num==11))begin    //為1或11才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_1[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示2圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==2)||(floor_num==12))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_2[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示3圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==3)||(floor_num==13))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_3[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示4圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==4)||(floor_num==14))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_4[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示5圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==5)||(floor_num==15))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_5[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示6圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==6)||(floor_num==16))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_6[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示7圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==7)||(floor_num==17))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_7[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示8圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==8)||(floor_num==18))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_8[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示9圖像顏色暫存 //FLOOR個位數
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num==9)||(floor_num==19))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_9[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              FLOOR十位數
        //-------------------------------------------
        
        //顯示0圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(floor_num<10)begin   //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_0[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示1圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num>=10)&&(floor_num<20))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_1[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示2圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+100+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if((floor_num>=20)&&(floor_num<30))begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+100+25+10+1))/5;    //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_2[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              SCORE個位數
        //-------------------------------------------
        //顯示0圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==0)begin  //個位為0顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_0[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示1圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==1)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_1[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示2圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==2)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_2[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示3圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==3)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_3[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示4圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==4)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_4[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示5圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==5)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_5[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示6圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==6)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_6[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示7圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==7)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_7[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示8圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==8)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_8[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示9圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[3:0]==9)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+15+5+1))/5;    //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_9[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              SCORE十位數
        //-------------------------------------------
        //顯示0圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==0)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_0[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示1圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==1)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_1[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示2圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==2)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_2[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示3圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==3)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_3[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示4圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==4)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_4[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示5圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==5)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_5[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示6圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==6)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_6[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示7圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==7)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_7[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示8圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==8)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_8[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示9圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[7:4]==9)begin  //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+15+5+1))/5; //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_9[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              SCORE百位數
        //-------------------------------------------
        //顯示0圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==0)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_0[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示1圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==1)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_1[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示2圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==2)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_2[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示3圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==3)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_3[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示4圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==4)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_4[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示5圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==5)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_5[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示6圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==6)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_6[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示7圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==7)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_7[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示8圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==8)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_8[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示9圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[11:8]==9)begin //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+15+5+1))/5;  //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_9[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              SCORE千位數
        //-------------------------------------------
        //顯示0圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==0)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_0[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示1圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==1)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_1[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示2圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==2)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_2[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示3圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==3)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_3[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示4圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==4)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_4[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示5圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==5)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_5[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示6圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==6)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_6[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示7圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==7)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_7[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示8圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==8)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_8[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示9圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105+10))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(score_num_bcd[15:12]==9)begin    //為0或10才顯示
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105+10+1))/5;   //x=3*5=15
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                            //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                            //圖案座標x->0~(799-...)，y->0~(524-...)
                                                            //畫圖起始座標(x=100,y=100)
                                                            //Figure_distance圖案與圖案間距
                X_color=dataX_9[x][y];
                
                if((x>2)||(y>4))begin   //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //black
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
            end
        end
        
        //-------------------------------------------
        //              加分圖像
        //-------------------------------------------
        
        //顯示+50圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105-10-55))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(add_score_50==0)begin    //0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105-10-55+1))/5;    //x=11*5=55
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                        //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                        //圖案座標x->0~(799-...)，y->0~(524-...)
                                                        //畫圖起始座標(x=100,y=100)
                                                        //Figure_distance圖案與圖案間距
                X_color=dataX_add_50[x][y];
                if((x>10)||(y>4))begin  //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //綠
                    R_out <= 8'd0;
                    G_out <= 8'd200;
                    B_out <= 8'd0;
                end
            end
        end
        //顯示+100圖像顏色暫存
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+640-105-10-70))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+30+25+10))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(add_score_100==0)begin   //0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+640-105-10-70+1))/5;    //x=14*5=70
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+30+25+10+1))/5; //y=5*5=25
                                                        //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                        //圖案座標x->0~(799-...)，y->0~(524-...)
                                                        //畫圖起始座標(x=100,y=100)
                                                        //Figure_distance圖案與圖案間距
                X_color=dataX_add_100[x][y];
                
                if((x>14)||(y>4))begin  //x只到10，y只到11
                    X_color=0;
                end
                
                if(X_color==1)begin //綠
                    R_out <= 8'd0;
                    G_out <= 8'd200;
                    B_out <= 8'd0;
                end
            end
        end
        
        
        //-------------------------------------------
        //              GameOver圖像
        //-------------------------------------------
        
        if(color_closs_GameOver==0)begin    //GameOver底色，為0圖片打開
            R_out <= 8'd0;
            G_out <= 8'd0;
            B_out <= 8'd0;
        end
        
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+250))      //H_CNT大於值顯示圖案
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+198))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_GameOver==0)begin    //0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+250+1))/4;  //x=35*4=140
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+198+1))/4;  //y=21*4=84
                
                if((x>34)||(y>20))begin
                    X_color=0;
                end
                else begin
                    X_color=dataX_GAME_OVER[y][34-x];
                end
                
                if(X_color==1)begin //黃
                    R_out <= 8'd255;
                    G_out <= 8'd255;
                    B_out <= 8'd0;
                end
            end
        end
        
        
        //-------------------------------------------
        //              顯示YouWin的圖片
        //-------------------------------------------
        if((H_CNT>(H_SYNC_PULSE+H_BACK_PORCH+320-37))
        &&(V_CNT>(V_SYNC_PULSE+V_BACK_PORCH+240-70))
        )begin  //V_CNT大於值顯示圖案，給圖案y座標follow
            if(color_closs_YouWin==0)begin  //0為顯示顏色(圖案)，1為closs
                x=(H_CNT-(H_SYNC_PULSE+H_BACK_PORCH+320-37+1))/5;   //x=15*5=75
                y=(V_CNT-(V_SYNC_PULSE+V_BACK_PORCH+240-70+1))/5;   //y=28*5=140
                                                        //先H_CNT->0~799，再V_CNT=V_CNT+1，接著H_CNT->0~799
                                                        //圖案座標x->0~(799-...)，y->0~(524-...)
                                                        //畫圖起始座標(x=100,y=100)
                                                        //Figure_distance圖案與圖案間距
                X_color=dataX_YouWin[x][y];
                Y_color=dataY_YouWin[x][y];
                Z_color=dataZ_YouWin[x][y];
                W_color=dataW_YouWin[x][y];
                
                if((x>15)||(y>27))begin //x只到15，y只到27
                    X_color=0;
                    Y_color=0;
                    Z_color=0;
                    W_color=0;
                end
                
                if(X_color==1)begin //255/255/255
                    R_out <= 8'd0;
                    G_out <= 8'd0;
                    B_out <= 8'd0;
                end
                if(Y_color==1)begin //128/113/19
                    R_out <= 8'd128;
                    G_out <= 8'd113;
                    B_out <= 8'd19;
                end
                if(Z_color==1)begin //176/156/26
                    R_out <= 8'd176;
                    G_out <= 8'd156;
                    B_out <= 8'd26;
                end
                if(W_color==1)begin //255/226/38
                    R_out <= 8'd255;
                    G_out <= 8'd226;
                    B_out <= 8'd38;
                end
            end
        end
        
        
        //^插入其他圖片(最上層)
    end
    else begin  //無作用
        R_out <= 8'd0;
        G_out <= 8'd0;  
        B_out <= 8'd0;
    end
end

//------------------------------------------
//              遊戲主程式
//------------------------------------------

//-----------------------
//      cloud路徑
//-----------------------
integer H_cloud_move=0;
integer V_cloud_move=100;
integer Clk_count_cloud=0;
reg Clk_cloud=0;
always@(posedge CLK)begin   //50MHz-->60Hz
    if(Clk_count_cloud<100_000)//420_000
        Clk_count_cloud=Clk_count_cloud+1;
    else begin
        Clk_cloud=~Clk_cloud;
        Clk_count_cloud=0;
    end
end
reg H_direction_cloud=0;//0為左，1右
reg V_direction_cloud=0;//0為上，1下

always@(posedge Clk_cloud)begin
    if(!RST || color_closs_cloud)begin
        H_cloud_move<=0;    //吊鉤水平位置座標，50*160(寬*高)
        V_cloud_move<=100;                  //吊鉤垂直位置座標
    end
    else begin
        //cloud路徑
        if(H_cloud_move>640)begin
            H_direction_cloud<=0;   //0為左
        end
        if(H_cloud_move<0)begin
            H_direction_cloud<=1;   //1為右
        end
        
        if(H_direction_cloud==0)begin   //0為左
            H_cloud_move<=H_cloud_move-1;
            V_cloud_move<=50;
        end
        if(H_direction_cloud==1)begin   //1為右
            H_cloud_move<=H_cloud_move+1;
            V_cloud_move<=100;
        end
    end
end

//----------------------
//      吊鉤路徑
//----------------------
integer Clk_count=0;
reg Clk_60Hz=0;
always@(posedge CLK)begin   //50MHz-->60Hz
    if(Clk_count<300_000-add_speed*3)//420_000
        Clk_count=Clk_count+1;
    else begin
        Clk_60Hz=~Clk_60Hz;
        Clk_count=0;
    end
end
reg H_direction_hook=0; //0為左，1為右
reg V_direction_hook=0; //吊鉤水平座標
reg V_direction_hook_count=0;   //垂直位置計數除2用
always@(posedge Clk_60Hz)begin
    if(!RST)begin
        H_coordinate_hook<=H_ACTIVE_TIME/2-25;  //吊鉤水平位置座標，50*160(寬*高)
        V_coordinate_hook<=0;                   //吊鉤垂直位置座標
    end
    else begin
        //hook路徑
        if(H_coordinate_hook+50>640-150)begin
            H_direction_hook<=0;    //0為左
        end
        if(H_coordinate_hook<150)begin
            H_direction_hook<=1;    //1為右
        end
        
        if(H_direction_hook==0)begin    //0為左
            H_coordinate_hook<=H_coordinate_hook-1;
        end
        if(H_direction_hook==1)begin    //1為右
            H_coordinate_hook<=H_coordinate_hook+1;
        end
        //----------------------------------------------
        if(V_coordinate_hook>=(-1))begin
            V_direction_hook<=0;    //0為上
        end
        if(V_coordinate_hook<(-33))begin
            V_direction_hook<=1;    //1為下
        end
        
        if(V_direction_hook==0)begin    //0為上
            V_direction_hook_count<=V_direction_hook_count+1;   //計數除2用
            if(V_direction_hook_count==1)begin
                V_coordinate_hook<=V_coordinate_hook-1;
            end
        end
        if(V_direction_hook==1)begin    //1為下
            V_direction_hook_count<=V_direction_hook_count+1;   //計數除2用
            if(V_direction_hook_count==1)begin
                V_coordinate_hook<=V_coordinate_hook+1;
            end
        end
        
    end
end

//---------------------------------
//  高樓層，shake(建築搖晃)路徑
//---------------------------------
integer Clk_count_shake=0;
reg Clk_shake=0;
always@(posedge CLK)begin   //50MHz-->60Hz
    if(Clk_count_shake<800_000+((20-floor_num)*50_000))//搖晃頻率   //((20-floor_num)*50000)
        Clk_count_shake=Clk_count_shake+1;
    else begin
        Clk_shake=~Clk_shake;
        Clk_count_shake=0;
    end
end
reg H_direction_shake=0;    //搖晃方向，0左、1右
reg floor_shake=1;//開始晃開關，0開1關

reg floor_shake_2=1;//樓層搖晃開關，0為開
reg floor_shake_3=1;//樓層搖晃開關，0為開
reg floor_shake_4=1;//樓層搖晃開關，0為開
reg floor_shake_5=1;//樓層搖晃開關，0為開
reg floor_shake_6=1;//樓層搖晃開關，0為開
reg floor_shake_7=1;//樓層搖晃開關，0為開
reg floor_shake_top=1;

integer H_floor_shake_2=0;
integer H_floor_shake_3=0;
integer H_floor_shake_4=0;
integer H_floor_shake_5=0;
integer H_floor_shake_6=0;
integer H_floor_shake_7=0;
integer H_floor_shake_top=0;
integer H_floor_shake=0;    //搖晃位移
integer H_floor_shake_edge=0;
always@(posedge Clk_shake)begin
    H_floor_shake_edge=(floor_num-7)*4;//搖晃邊界
    
    if(!RST || floor_shake)begin
        H_floor_shake<=0;
    end
    else begin
        if(H_floor_shake>H_floor_shake_edge)begin   //>50
            H_direction_shake<=0;   //0為左
        end
        if(H_floor_shake<-H_floor_shake_edge)begin  //<-50
            H_direction_shake<=1;   //1為右
        end
        
        if(H_direction_shake==0)begin   //0為左
            H_floor_shake<=H_floor_shake-1;
        end
        if(H_direction_shake==1)begin   //1為右
            H_floor_shake<=H_floor_shake+1;
        end
    end
end

//-----------------
//▼▼▼遊戲主程式▼▼▼
//-----------------
integer Clk_count_down=0;
reg Clk_down=0;
integer add_speed=0;    //關卡增加，遊戲加速
always@(posedge CLK)begin   //50MHz--> Hz
    if(Clk_count_down<100_000-add_speed/2)//420_000
        Clk_count_down=Clk_count_down+1;
    else begin
        Clk_down=~Clk_down;
        Clk_count_down=0;
    end
end
reg [4:0]state=0;   //0~31
reg [4:0]floor_num=0;   //0~31  //計數樓層
reg [10:0]score_num=0;  //0~2047//計分
reg [9:0]closs_num=0;   //0~1024，計數顯示add_score的時間
reg [8:0]life_bar=480;  //生命條，480~0
reg [2:0]life_bar_count=0;  //0~5，計數生命條之計數器
reg [1:0]life=3;    //生命，只有3次機會

always@(posedge Clk_down)begin
    
    if(!RST || repeat_signal)begin
        state<=0;
        color_closs_1<=1;   //color_closs=0為顯示顏色(圖案)，1為closs
        color_closs_2<=1;
        color_closs_3<=1;
        color_closs_4<=1;
        color_closs_5<=1;
        color_closs_6<=1;
        color_closs_7<=1;
        
        color_closs_top<=1; //floor_top圖像開關
        color_closs_hook<=0;
        color_closs_FLOOR<=0;
        color_closs_SCORE<=0;
        
        add_score_50<=1;
        add_score_100<=1;
        
        floor_num<=0;   //0~31  //計數樓層
        score_num<=0;   //計算分數
        
        closs_num<=0;   //關閉圖案之計數器，0~255
        add_speed<=0;   //關卡增加，遊戲加速
        life_bar<=480;  //生命條
        life<=3;        //生命有3次
        color_closs_GameOver<=1;    //GameOver圖片關閉
        color_closs_YouWin<=1;  //YouWin畫面關閉
        color_closs_cloud<=1;   //雲朵關閉
        
        floor_shake<=1;//開始晃開關，0開1關
        floor_shake_2<=1;//樓層搖晃開關，0為開
        floor_shake_3<=1;//樓層搖晃開關，0為開
        floor_shake_4<=1;//樓層搖晃開關，0為開
        floor_shake_5<=1;//樓層搖晃開關，0為開
        floor_shake_6<=1;//樓層搖晃開關，0為開
        floor_shake_7<=1;//樓層搖晃開關，0為開
        floor_shake_top<=1;
    end
    else begin
        case(state)
            0:begin //吊鉤掛著floor_1
                H_coordinate_floor_1<=H_coordinate_hook+25-78;
                V_coordinate_floor_1<=V_coordinate_hook+160-40;
                
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                if(floor_down==1)begin  //按鈕按下
                    state<=1;
                    H_coordinate_floor_1<=H_coordinate_floor_1;
                    V_coordinate_floor_1<=V_coordinate_floor_1;
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==3)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
            end
            1:begin //floor_1往下掉到底
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                V_coordinate_floor_1<=V_coordinate_floor_1+1;
                if(V_coordinate_floor_1+80>=480)begin   //155*80(寬*高)
                    V_coordinate_floor_1<=V_coordinate_floor_1;
                    state<=2;
                    floor_num<=floor_num+1; //樓層計數+1
                    score_num<=score_num+50;
                    add_score_50<=0;    //顯示+50圖案
                    closs_num<=0;   //圖案關閉計數器歸零
                    add_speed<=add_speed+4_000; //關卡增加，遊戲加速
                    life_bar<=480;
                end
                
            end
            2:begin //吊鉤掛著floor_2
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;
                
                H_coordinate_floor_2<=H_coordinate_hook+25-78;
                V_coordinate_floor_2<=V_coordinate_hook+160-40;
                
                if(floor_down==1)begin
                    state<=3;
                    H_coordinate_floor_2<=H_coordinate_floor_2;
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                closs_num<=closs_num+1; //關閉圖案之計數器，0~127
                if(closs_num==200)begin //delay 100單位，closs
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
            end
            3:begin //floor_2往下掉到floor_1上
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;
                
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                if(
                (V_coordinate_floor_2+55>=V_coordinate_floor_1)
                &&(H_coordinate_floor_2+72<H_coordinate_floor_1+155)    //中心在floor1右邊內
                &&(H_coordinate_floor_2+73>H_coordinate_floor_1)        //中心在floor1左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    state<=4;
                    floor_num<=floor_num+1; //樓層計數+1
                    
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_1-H_coordinate_floor_2<10)
                    &&(H_coordinate_floor_2-H_coordinate_floor_1<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                end
                
                if(V_coordinate_floor_2>=480)begin  //否則回到吊鉤上
                    state<=2;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            4:begin //吊鉤掛著floor_3
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;
                color_closs_3<=0;
                
                H_coordinate_floor_3<=H_coordinate_hook+25-78;
                V_coordinate_floor_3<=V_coordinate_hook+160-40;
                
                if(floor_down==1)begin
                    state<=5;
                    H_coordinate_floor_3<=H_coordinate_floor_3;
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin //delay 100單位
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
            end
            5:begin //floor_3往下掉到floor_2上
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;
                color_closs_3<=0;
                
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                if(
                (V_coordinate_floor_3+55>=V_coordinate_floor_2)
                &&(H_coordinate_floor_3+72<H_coordinate_floor_2+145)    //中心在floor2右邊內
                &&(H_coordinate_floor_3+73>H_coordinate_floor_2)        //中心在floor2左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    state<=6;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_3-H_coordinate_floor_2<10)
                    &&(H_coordinate_floor_2-H_coordinate_floor_3<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                end
                
                if(V_coordinate_floor_3>=480)begin  //否則回到吊鉤上
                    state<=4;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            6:begin //吊鉤掛著floor_4
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;   //floor_2
                color_closs_3<=0;
                color_closs_4<=0;
                
                H_coordinate_floor_4<=H_coordinate_hook+25-78;
                V_coordinate_floor_4<=V_coordinate_hook+160-40;
                
                if(floor_down==1)begin
                    state<=7;
                    H_coordinate_floor_4<=H_coordinate_floor_4;
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
            end
            7:begin //floor_4往下掉到floor_3上
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;
                color_closs_3<=0;
                color_closs_4<=0;
                
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                if(
                (V_coordinate_floor_4+55>=V_coordinate_floor_3)
                &&(H_coordinate_floor_4+72<H_coordinate_floor_3+145)    //中心在floor3右邊內
                &&(H_coordinate_floor_4+73>H_coordinate_floor_3)        //中心在floor3左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    state<=8;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_4-H_coordinate_floor_3<10)
                    &&(H_coordinate_floor_3-H_coordinate_floor_4<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                end
                
                if(V_coordinate_floor_4>=480)begin  //否則回到吊鉤上
                    state<=6;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            8:begin //吊鉤掛著floor_5，房子往下移
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;   //floor_2，open
                color_closs_3<=0;
                color_closs_4<=0;
                color_closs_5<=0;
                
                H_coordinate_floor_5<=H_coordinate_hook+25-78;
                V_coordinate_floor_5<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_1<=V_coordinate_floor_1+1;
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                
                if(V_coordinate_floor_1>=480)begin
                    V_coordinate_floor_1<=V_coordinate_floor_1; //hold at 480
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=9;
                        H_coordinate_floor_5<=H_coordinate_floor_5;
                        V_coordinate_floor_5<=V_coordinate_floor_5;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin //delay 100單位
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
            end
            9:begin //floor_5往下掉到floor_4上
                color_closs_1<=0;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;
                color_closs_3<=0;
                color_closs_4<=0;
                color_closs_5<=0;
                
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                if(
                (V_coordinate_floor_5+55>=V_coordinate_floor_4)
                &&(H_coordinate_floor_5+72<H_coordinate_floor_4+145)    //中心在floor3右邊內
                &&(H_coordinate_floor_5+73>H_coordinate_floor_4)        //中心在floor3左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_5<=V_coordinate_floor_5;
                    state<=10;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_5-H_coordinate_floor_4<10)
                    &&(H_coordinate_floor_4-H_coordinate_floor_5<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                end
                
                if(V_coordinate_floor_5>=480)begin  //否則回到吊鉤上
                    state<=8;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            10:begin    //吊鉤掛著floor_6，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=0;   //floor_2，open
                color_closs_3<=0;
                color_closs_4<=0;
                color_closs_5<=0;
                color_closs_6<=0;   //在鉤子上
                
                H_coordinate_floor_6<=H_coordinate_hook+25-78;
                V_coordinate_floor_6<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                
                if(V_coordinate_floor_2>=480)begin
                    V_coordinate_floor_2<=V_coordinate_floor_2; //hold at 480
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    V_coordinate_floor_5<=V_coordinate_floor_5;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=11;
                        H_coordinate_floor_6<=H_coordinate_floor_6;
                        V_coordinate_floor_6<=V_coordinate_floor_6;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
            end
            11:begin    //floor_6往下掉到floor_5上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=1;   //floor_2，closs
                color_closs_3<=0;
                color_closs_4<=0;
                color_closs_5<=0;
                color_closs_6<=0;   //在鉤子上
                
                V_coordinate_floor_6<=V_coordinate_floor_6+1;
                if(
                (V_coordinate_floor_6+55>=V_coordinate_floor_5)
                &&(H_coordinate_floor_6+72<H_coordinate_floor_5+145)    //中心在floor6右邊內
                &&(H_coordinate_floor_6+73>H_coordinate_floor_5)        //中心在floor6左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_6<=V_coordinate_floor_6;
                    state<=12;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_6-H_coordinate_floor_5<10)
                    &&(H_coordinate_floor_5-H_coordinate_floor_6<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                end
                
                if(V_coordinate_floor_6>=480)begin  //否則回到吊鉤上
                    state<=10;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            12:begin    //吊鉤掛著floor_7，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=1;   
                color_closs_3<=0;
                color_closs_4<=0;
                color_closs_5<=0;
                color_closs_6<=0;
                color_closs_7<=0;   //floor_7，open    //在鉤子上
                
                
                H_coordinate_floor_7<=H_coordinate_hook+25-78;
                V_coordinate_floor_7<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                V_coordinate_floor_6<=V_coordinate_floor_6+1;
                
                if(V_coordinate_floor_3>=480)begin
                    V_coordinate_floor_3<=V_coordinate_floor_3;//hold at 480
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    V_coordinate_floor_5<=V_coordinate_floor_5;
                    V_coordinate_floor_6<=V_coordinate_floor_6;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=13;
                        H_coordinate_floor_7<=H_coordinate_floor_7;
                        V_coordinate_floor_7<=V_coordinate_floor_7;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
                if(floor_shake==0)begin //開始晃開關，0開1關
                    floor_shake_7<=1;   //第7層跟著晃，0開1關
                    floor_shake_6<=0;   //第7層跟著晃，0開1關
                    floor_shake_5<=0;   //第7層跟著晃，0開1關
                    floor_shake_4<=0;   //第7層跟著晃，0開1關
                    floor_shake_3<=0;   //第7層跟著晃，0開1關
                end
            end
            13:begin    //floor_7往下掉到floor_6上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                color_closs_2<=1;   
                color_closs_3<=1;   //floor_3 is closs，下去螢幕了
                color_closs_4<=0;
                color_closs_5<=0;
                color_closs_6<=0;
                color_closs_7<=0;   //floor_7，open//在鉤子上
                
                V_coordinate_floor_7<=V_coordinate_floor_7+1;
                if((V_coordinate_floor_7+55==V_coordinate_floor_6)
                &&(H_coordinate_floor_7+72<H_coordinate_floor_6+H_floor_shake_6+145)    //中心在floor6右邊內
                &&(H_coordinate_floor_7+73>H_coordinate_floor_6+H_floor_shake_6)        //中心在floor6左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_7<=V_coordinate_floor_7;
                    state<=14;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉Delay計數器歸零
                    if((H_coordinate_floor_7-(H_coordinate_floor_6+H_floor_shake_6)<10)
                    &&((H_coordinate_floor_6+H_floor_shake_6)-H_coordinate_floor_7<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                    if(floor_shake==0)begin //開始晃開關，0開1關
                        floor_shake_7<=0;   //第7層跟著晃，0開1關
                        H_coordinate_floor_7<=H_coordinate_floor_7-H_floor_shake;//減去此刻位移量
                        floor_shake_6<=0;   //第7層跟著晃，0開1關
                        floor_shake_5<=0;   //第7層跟著晃，0開1關
                        floor_shake_4<=0;   //第7層跟著晃，0開1關
                        floor_shake_3<=1;   //第7層跟著晃，0開1關
                    end
                    
                end
                
                if(V_coordinate_floor_7>=480)begin  //否則回到吊鉤上
                    state<=12;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            14:begin    //吊鉤掛著floor_8，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_3<=1;
                color_closs_4<=0;
                color_closs_5<=0;
                color_closs_6<=0;
                color_closs_7<=0;
                color_closs_2<=0;   //floor_8，open    //在鉤子上
                
                H_coordinate_floor_2<=H_coordinate_hook+25-78;
                V_coordinate_floor_2<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                V_coordinate_floor_6<=V_coordinate_floor_6+1;
                V_coordinate_floor_7<=V_coordinate_floor_7+1;
                
                if(V_coordinate_floor_4>=480)begin
                    V_coordinate_floor_4<=V_coordinate_floor_4;//hold at 480
                    V_coordinate_floor_5<=V_coordinate_floor_5;
                    V_coordinate_floor_6<=V_coordinate_floor_6;
                    V_coordinate_floor_7<=V_coordinate_floor_7;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=15;
                        H_coordinate_floor_2<=H_coordinate_floor_2;
                        V_coordinate_floor_2<=V_coordinate_floor_2;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
                if(floor_shake==0)begin //開始晃開關，0開1關
                    floor_shake_4<=0;   //第N層跟著晃，0開1關
                    floor_shake_5<=0;   //第N層跟著晃，0開1關
                    floor_shake_6<=0;   //第N層跟著晃，0開1關
                    floor_shake_7<=0;   //第N層跟著晃，0開1關
                    floor_shake_2<=1;   //第N層跟著晃，0開1關
                end
                
            end
            15:begin    //floor_8往下掉到floor_7上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_3<=1;
                color_closs_4<=1;   //floor_4 is closs，下去螢幕了
                color_closs_5<=0;
                color_closs_6<=0;
                color_closs_7<=0;
                color_closs_2<=0;   //floor_8，open    //在鉤子上
                
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                if(
                (V_coordinate_floor_2+55==V_coordinate_floor_7)
                &&(H_coordinate_floor_2+72<H_coordinate_floor_7+H_floor_shake_7+145)    //中心在floor6右邊內
                &&(H_coordinate_floor_2+73>H_coordinate_floor_7+H_floor_shake_7)        //中心在floor6左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    state<=16;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_2-(H_coordinate_floor_7+H_floor_shake_7)<10)
                    &&((H_coordinate_floor_7+H_floor_shake_7)-H_coordinate_floor_2<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                    if(floor_shake==0)begin //開始晃開關，0開1關
                        floor_shake_4<=1;   //第N層跟著晃，0開1關
                        floor_shake_5<=0;   //第N層跟著晃，0開1關
                        floor_shake_6<=0;   //第N層跟著晃，0開1關
                        floor_shake_7<=0;   //第N層跟著晃，0開1關
                        floor_shake_2<=0;   //第N層跟著晃，0開1關
                        H_coordinate_floor_2<=H_coordinate_floor_2-H_floor_shake;//減去此刻位移量
                    end
                end
                
                if(V_coordinate_floor_2>=480)begin  //否則回到吊鉤上
                    state<=14;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
                
                
            end
            16:begin    //吊鉤掛著floor_9，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_4<=1;   //floor_4，closs//下去螢幕了
                color_closs_5<=0;   //floor_5，open    //待下去螢幕
                color_closs_6<=0;   //floor_6，open
                color_closs_7<=0;   //floor_7，open
                color_closs_2<=0;   //2-->floor_8，open
                color_closs_3<=0;   //3-->floor_9，open    //在鉤子上
                
                H_coordinate_floor_3<=H_coordinate_hook+25-78;
                V_coordinate_floor_3<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                V_coordinate_floor_6<=V_coordinate_floor_6+1;
                V_coordinate_floor_7<=V_coordinate_floor_7+1;
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                
                if(V_coordinate_floor_5>=480)begin
                    V_coordinate_floor_5<=V_coordinate_floor_5;//hold at 480
                    V_coordinate_floor_6<=V_coordinate_floor_6;
                    V_coordinate_floor_7<=V_coordinate_floor_7;
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=17;
                        H_coordinate_floor_3<=H_coordinate_floor_3;
                        V_coordinate_floor_3<=V_coordinate_floor_3;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
                if(floor_shake==0)begin //開始晃開關，0開1關
                    floor_shake_5<=0;   //第N層跟著晃，0開1關
                    floor_shake_6<=0;   //第N層跟著晃，0開1關
                    floor_shake_7<=0;   //第N層跟著晃，0開1關
                    floor_shake_2<=0;   //第N層跟著晃，0開1關
                    floor_shake_3<=1;   //第N層跟著晃，0開1關
                end
                
            end
            17:begin    //floor_9往下掉到floor_8上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_4<=1;   //floor_4，closs   //下去螢幕了
                color_closs_5<=1;   //floor_5，closs   //下去螢幕了
                color_closs_6<=0;   //floor_6，open
                color_closs_7<=0;   //floor_7，open
                color_closs_2<=0;   //2-->floor_8，open
                color_closs_3<=0;   //3-->floor_9，open    //在鉤子上
                
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                if(
                (V_coordinate_floor_3+55==V_coordinate_floor_2)
                &&(H_coordinate_floor_3+72<H_coordinate_floor_2+H_floor_shake_2+145)    //中心在floor8右邊內
                &&(H_coordinate_floor_3+73>H_coordinate_floor_2+H_floor_shake_2)        //中心在floor8左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    state<=18;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_3-(H_coordinate_floor_2+H_floor_shake_2)<10)
                    &&((H_coordinate_floor_2+H_floor_shake_2)-H_coordinate_floor_3<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                    if(floor_shake==0)begin //開始晃開關，0開1關
                        floor_shake_5<=1;   //第N層跟著晃，0開1關
                        floor_shake_6<=0;   //第N層跟著晃，0開1關
                        floor_shake_7<=0;   //第N層跟著晃，0開1關
                        floor_shake_2<=0;   //第N層跟著晃，0開1關
                        floor_shake_3<=0;   //第N層跟著晃，0開1關
                        H_coordinate_floor_3<=H_coordinate_floor_3-H_floor_shake;//減去此刻位移量
                    end
                end
                
                if(V_coordinate_floor_3>=480)begin  //否則回到吊鉤上
                    state<=16;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            18:begin    //吊鉤掛著floor_10，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_5<=1;   //floor_5，closs   //下去螢幕了
                color_closs_6<=0;   //floor_6，open        //待下去螢幕
                color_closs_7<=0;   //floor_7，open
                color_closs_2<=0;   //2-->floor_8 ，open
                color_closs_3<=0;   //3-->floor_9 ，open   
                color_closs_4<=0;   //4-->floor_10，open   //在鉤子上
                
                H_coordinate_floor_4<=H_coordinate_hook+25-78;
                V_coordinate_floor_4<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_6<=V_coordinate_floor_6+1;
                V_coordinate_floor_7<=V_coordinate_floor_7+1;
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                
                if(V_coordinate_floor_6>=480)begin
                    V_coordinate_floor_6<=V_coordinate_floor_6;//hold at 480
                    V_coordinate_floor_7<=V_coordinate_floor_7;
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=19;
                        H_coordinate_floor_4<=H_coordinate_floor_4;
                        V_coordinate_floor_4<=V_coordinate_floor_4;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
                if(floor_shake==0)begin //開始晃開關，0開1關
                    floor_shake_6<=0;   //第N層跟著晃，0開1關
                    floor_shake_7<=0;   //第N層跟著晃，0開1關
                    floor_shake_2<=0;   //第N層跟著晃，0開1關
                    floor_shake_3<=0;   //第N層跟著晃，0開1關
                    floor_shake_4<=1;   //第N層跟著晃，0開1關
                end
            end
            19:begin    //floor_10往下掉到floor_9上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_5<=1;   //floor_5，closs   //下去螢幕了
                color_closs_6<=1;   //floor_6，closs   //下去螢幕了
                color_closs_7<=0;   //floor_7，open
                color_closs_2<=0;   //2-->floor_8 ，open
                color_closs_3<=0;   //3-->floor_9 ，open   
                color_closs_4<=0;   //4-->floor_10，open   //在鉤子上
                
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                if(
                (V_coordinate_floor_4+55==V_coordinate_floor_3)
                &&(H_coordinate_floor_4+72<H_coordinate_floor_3+H_floor_shake_3+145)    //中心在floor8右邊內
                &&(H_coordinate_floor_4+73>H_coordinate_floor_3+H_floor_shake_3)        //中心在floor8左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    state<=20;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_4-(H_coordinate_floor_3+H_floor_shake_3)<10)
                    &&((H_coordinate_floor_3+H_floor_shake_3)-H_coordinate_floor_4<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                    if(floor_shake==0)begin //開始晃開關，0開1關
                        floor_shake_6<=1;   //第N層跟著晃，0開1關
                        floor_shake_7<=0;   //第N層跟著晃，0開1關
                        floor_shake_2<=0;   //第N層跟著晃，0開1關
                        floor_shake_3<=0;   //第N層跟著晃，0開1關
                        floor_shake_4<=0;   //第N層跟著晃，0開1關
                        H_coordinate_floor_4<=H_coordinate_floor_4-H_floor_shake;//減去此刻位移量
                    end
                end
                
                if(V_coordinate_floor_4>=480)begin  //否則回到吊鉤上
                    state<=18;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            20:begin    //吊鉤掛著floor_11，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_6<=1;   //floor_6，closs   //下去螢幕了
                color_closs_7<=0;   //floor_7，open        //待下去螢幕
                color_closs_2<=0;   //2-->floor_8 ，open
                color_closs_3<=0;   //3-->floor_9 ，open   
                color_closs_4<=0;   //4-->floor_10，open
                color_closs_5<=0;   //5-->floor_11，open   //在鉤子上
                
                H_coordinate_floor_5<=H_coordinate_hook+25-78;
                V_coordinate_floor_5<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_7<=V_coordinate_floor_7+1;
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                
                if(V_coordinate_floor_7>=480)begin
                    V_coordinate_floor_7<=V_coordinate_floor_7;//hold at 480
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=21;
                        H_coordinate_floor_5<=H_coordinate_floor_5;
                        V_coordinate_floor_5<=V_coordinate_floor_5;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
                if(floor_shake==0)begin //開始晃開關，0開1關
                    floor_shake_7<=0;   //第N層跟著晃，0開1關
                    floor_shake_2<=0;   //第N層跟著晃，0開1關
                    floor_shake_3<=0;   //第N層跟著晃，0開1關
                    floor_shake_4<=0;   //第N層跟著晃，0開1關
                    floor_shake_5<=1;   //第N層跟著晃，0開1關
                end
                
            end
            21:begin    //floor_11往下掉到floor_10上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_6<=1;   //floor_6，closs   //下去螢幕了
                color_closs_7<=1;   //floor_7，closs   //下去螢幕了
                color_closs_2<=0;   //2-->floor_8 ，open
                color_closs_3<=0;   //3-->floor_9 ，open   
                color_closs_4<=0;   //4-->floor_10，open
                color_closs_5<=0;   //5-->floor_11，open   //在鉤子上
                
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                if(
                (V_coordinate_floor_5+55==V_coordinate_floor_4)
                &&(H_coordinate_floor_5+72<H_coordinate_floor_4+H_floor_shake_4+145)    //中心在floor8右邊內
                &&(H_coordinate_floor_5+73>H_coordinate_floor_4+H_floor_shake_4)        //中心在floor8左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_5<=V_coordinate_floor_5;
                    state<=22;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_5-(H_coordinate_floor_4+H_floor_shake_4)<10)
                    &&((H_coordinate_floor_4+H_floor_shake_4)-H_coordinate_floor_5<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                    if(floor_shake==0)begin //開始晃開關，0開1關
                        floor_shake_7<=1;   //第N層跟著晃，0開1關
                        floor_shake_2<=0;   //第N層跟著晃，0開1關
                        floor_shake_3<=0;   //第N層跟著晃，0開1關
                        floor_shake_4<=0;   //第N層跟著晃，0開1關
                        floor_shake_5<=0;   //第N層跟著晃，0開1關
                        H_coordinate_floor_5<=H_coordinate_floor_5-H_floor_shake;//減去此刻位移量
                    end
                end
                
                if(V_coordinate_floor_5>=480)begin  //否則回到吊鉤上
                    state<=20;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            22:begin    //吊鉤掛著floor_12，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_7<=1;   //floor_7，closs   //下去螢幕了
                color_closs_2<=0;   //2-->floor_8 ，open   //待下去螢幕
                color_closs_3<=0;   //3-->floor_9 ，open   
                color_closs_4<=0;   //4-->floor_10，open
                color_closs_5<=0;   //5-->floor_11，open
                color_closs_6<=0;   //6-->floor_12，open   //在鉤子上
                
                H_coordinate_floor_6<=H_coordinate_hook+25-78;
                V_coordinate_floor_6<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                V_coordinate_floor_3<=V_coordinate_floor_3+1;
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                
                if(V_coordinate_floor_2>=480)begin
                    V_coordinate_floor_2<=V_coordinate_floor_2;//hold at 480
                    V_coordinate_floor_3<=V_coordinate_floor_3;
                    V_coordinate_floor_4<=V_coordinate_floor_4;
                    V_coordinate_floor_5<=V_coordinate_floor_5;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=23;
                        H_coordinate_floor_6<=H_coordinate_floor_6;
                        V_coordinate_floor_6<=V_coordinate_floor_6;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
                if(floor_shake==0)begin //開始晃開關，0開1關
                    floor_shake_2<=0;   //第N層跟著晃，0開1關
                    floor_shake_3<=0;   //第N層跟著晃，0開1關
                    floor_shake_4<=0;   //第N層跟著晃，0開1關
                    floor_shake_5<=0;   //第N層跟著晃，0開1關
                    floor_shake_6<=1;   //第N層跟著晃，0開1關
                end
                
            end
            23:begin    //floor_12往下掉到floor_11上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_7<=1;   //floor_7，closs   //下去螢幕了
                color_closs_2<=1;   //2-->floor_8 ，closs  //下去螢幕了
                color_closs_3<=0;   //3-->floor_9 ，open   
                color_closs_4<=0;   //4-->floor_10，open
                color_closs_5<=0;   //5-->floor_11，open
                color_closs_6<=0;   //6-->floor_12，open   //在鉤子上
                
                V_coordinate_floor_6<=V_coordinate_floor_6+1;
                if(
                (V_coordinate_floor_6+55==V_coordinate_floor_5)
                &&(H_coordinate_floor_6+72<H_coordinate_floor_5+H_floor_shake_5+145)    //中心在floor8右邊內
                &&(H_coordinate_floor_6+73>H_coordinate_floor_5+H_floor_shake_5)        //中心在floor8左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_6<=V_coordinate_floor_6;
                    state<=12;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_6-(H_coordinate_floor_5+H_floor_shake_5)<10)
                    &&((H_coordinate_floor_5+H_floor_shake_5)-H_coordinate_floor_6<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                    if(floor_shake==0)begin //開始晃開關，0開1關
                        floor_shake_2<=1;   //第N層跟著晃，0開1關
                        floor_shake_3<=0;   //第N層跟著晃，0開1關
                        floor_shake_4<=0;   //第N層跟著晃，0開1關
                        floor_shake_5<=0;   //第N層跟著晃，0開1關
                        floor_shake_6<=0;   //第N層跟著晃，0開1關
                        H_coordinate_floor_6<=H_coordinate_floor_6-H_floor_shake;//減去此刻位移量
                    end
                end
                
                if(V_coordinate_floor_6>=480)begin  //否則回到吊鉤上
                    state<=22;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
            end
            
            
            
            24:begin    //顯示 you lose 畫面▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_2<=1;   //2-->floor_8 ，closs  //下去螢幕了
                color_closs_3<=1;   //3-->floor_9 ，closs  //待下去螢幕
                color_closs_4<=1;   //4-->floor_10，closs
                color_closs_5<=1;   //5-->floor_11，closs
                color_closs_6<=1;   //6-->floor_12，closs  
                color_closs_7<=1;   //7-->floor_13，closs  //在鉤子上
                
                color_closs_top<=1; //floor_top圖像開關
                color_closs_hook<=1;//closs
                color_closs_FLOOR<=1;//closs
                color_closs_SCORE<=1;//closs
                
                add_score_50<=1;//closs
                add_score_100<=1;//closs
                
                color_closs_GameOver<=0;    //GameOver圖片打開
                
                
            end
            
            //win_state▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
            
            25:begin    //state_14取代floor_20//吊鉤掛著floor_8，房子往下移
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_3<=1;
                color_closs_4<=0;   //待下去螢幕
                color_closs_5<=0;
                color_closs_6<=0;
                color_closs_7<=0;
                color_closs_top<=0; //floor_top，open  //在鉤子上
                color_closs_2<=1;   //floor_8，closs   //原在鉤子上
                
                H_coordinate_floor_2<=H_coordinate_hook+25-78;
                V_coordinate_floor_2<=V_coordinate_hook+160-40;
                
                V_coordinate_floor_4<=V_coordinate_floor_4+1;
                V_coordinate_floor_5<=V_coordinate_floor_5+1;
                V_coordinate_floor_6<=V_coordinate_floor_6+1;
                V_coordinate_floor_7<=V_coordinate_floor_7+1;
                
                if(V_coordinate_floor_4>=480)begin
                    V_coordinate_floor_4<=V_coordinate_floor_4;//hold at 480
                    V_coordinate_floor_5<=V_coordinate_floor_5;
                    V_coordinate_floor_6<=V_coordinate_floor_6;
                    V_coordinate_floor_7<=V_coordinate_floor_7;
                    if(floor_down==1)begin  //完成下移動畫才可執行動作
                        state<=26;
                        H_coordinate_floor_2<=H_coordinate_floor_2;
                        V_coordinate_floor_2<=V_coordinate_floor_2;
                        add_score_100<=1;   //closs +100圖案
                        add_score_50<=1;    //closs +50圖案
                    end
                end
                
                closs_num<=closs_num+1;
                if(closs_num==200)begin
                    add_score_100<=1;   //closs +100圖案
                    add_score_50<=1;    //closs +50圖案
                end
                
                life_bar_count<=life_bar_count+1;//[3bit]，0~7，計數生命條之計數器
                if(life_bar_count==4)begin  //life_bar除頻
                    life_bar<=life_bar-1;
                    if(life_bar==0)begin
                        life_bar<=480;
                        life<=life-1;   //生命-1
                    end
                    life_bar_count<=0;
                end
                
                if(floor_shake==0)begin //開始晃開關，0開1關
                    floor_shake_4<=0;   //第N層跟著晃，0開1關
                    floor_shake_5<=0;   //第N層跟著晃，0開1關
                    floor_shake_6<=0;   //第N層跟著晃，0開1關
                    floor_shake_7<=0;   //第N層跟著晃，0開1關
                    floor_shake_top<=1; //第N層跟著晃，0開1關
                end
                
            end
            26:begin    //floor_top(20)往下掉到floor_19上
                color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                
                color_closs_3<=1;
                color_closs_4<=1;   //floor_4 is closs，下去螢幕了
                color_closs_5<=0;
                color_closs_6<=0;
                color_closs_7<=0;
                color_closs_top<=0; //floor_top，open  //在鉤子上
                
                V_coordinate_floor_2<=V_coordinate_floor_2+1;
                if(
                (V_coordinate_floor_2+70==V_coordinate_floor_7)
                &&(H_coordinate_floor_2+67<H_coordinate_floor_7+H_floor_shake_7+145)    //中心在floor6右邊內
                &&(H_coordinate_floor_2+68>H_coordinate_floor_7+H_floor_shake_7)        //中心在floor6左邊內
                )begin  //145*55(寬*高)
                    V_coordinate_floor_2<=V_coordinate_floor_2;
                    state<=27;
                    floor_num<=floor_num+1; //樓層計數+1
                    closs_num<=0;   //圖案關閉計數器歸零
                    if((H_coordinate_floor_2-(H_coordinate_floor_7+H_floor_shake_7)<10)
                    &&((H_coordinate_floor_7+H_floor_shake_7)-H_coordinate_floor_2<10))begin//分數加成
                        score_num<=score_num+100;
                        add_score_100<=0;   //顯示+100圖案
                    end
                    else begin
                        score_num<=score_num+50;    //分數+50分
                        add_score_50<=0;    //顯示+50圖案
                    end
                    //add_speed<=add_speed+4_000;
                    life_bar<=480;
                    
                    if(floor_shake==0)begin //開始晃開關，0開1關
                        floor_shake_4<=1;   //第N層跟著晃，0開1關
                        floor_shake_5<=0;   //第N層跟著晃，0開1關
                        floor_shake_6<=0;   //第N層跟著晃，0開1關
                        floor_shake_7<=0;   //第N層跟著晃，0開1關
                        floor_shake_top<=0; //第N層跟著晃，0開1關
                        H_coordinate_floor_2<=H_coordinate_floor_2-H_floor_shake;//減去此刻位移量
                    end
                end
                
                if(V_coordinate_floor_2>=480)begin  //否則回到吊鉤上
                    state<=25;
                    life_bar<=480;
                    life<=life-1;   //生命-1
                end
                
                
            end
            27:begin    //win畫面
                closs_num<=closs_num+1;
                if(closs_num==1000)begin    //此時delay畫面用，(原為 圖案關閉計數器歸零)
                    color_closs_1<=1;   //color_closs_1=0為顯示顏色(圖案)，1為closs
                    
                    color_closs_2<=1;   //2-->floor_8 ，closs  //下去螢幕了
                    color_closs_3<=1;   //3-->floor_9 ，closs  //待下去螢幕
                    color_closs_4<=1;   //4-->floor_10，closs
                    color_closs_5<=0;   //5-->floor_11，closs
                    color_closs_6<=0;   //6-->floor_12，closs  
                    color_closs_7<=0;   //7-->floor_13，closs  //在鉤子上
                    
                    color_closs_top<=0; //floor_top圖像開關
                    color_closs_hook<=1;//closs
                    color_closs_FLOOR<=0;//open
                    color_closs_SCORE<=0;//open
                    
                    add_score_50<=1;//closs
                    add_score_100<=1;//closs
                    
                    color_closs_GameOver<=1;    //GameOver圖片打開
                    color_closs_YouWin<=0;  //YouWin畫面打開
                    
                end
                
            end
            
            
            
            
        endcase
        
        if(life==0)begin
            state<=24;  //顯示 you lose 畫面
        end
        
        if(floor_num==19 && state==14)begin //加到19樓時，狀態同時走到state_14
            state<=25;  //吊鉤上出現 floor_top
        end
        
        if(floor_num==10)begin      //到達10樓
            color_closs_cloud<=0;   //雲圖片打開
        end
        
        if(floor_num==8)begin//到達8樓
            floor_shake<=0; //搖晃打開
        end
        
        //高樓晃動開關
        if(floor_shake_top==0)begin
            H_floor_shake_top=H_floor_shake;
        end
        else begin
            H_floor_shake_top=0;
        end
        
        if(floor_shake_7==0)begin
            H_floor_shake_7=H_floor_shake;
        end
        else begin
            H_floor_shake_7=0;
        end
        
        if(floor_shake_6==0)begin
            H_floor_shake_6=H_floor_shake;
        end
        else begin
            H_floor_shake_6=0;
        end
        
        if(floor_shake_5==0)begin
            H_floor_shake_5=H_floor_shake;
        end
        else begin
            H_floor_shake_5=0;
        end
        
        if(floor_shake_4==0)begin
            H_floor_shake_4=H_floor_shake;
        end
        else begin
            H_floor_shake_4=0;
        end
        
        if(floor_shake_3==0)begin
            H_floor_shake_3=H_floor_shake;
        end
        else begin
            H_floor_shake_3=0;
        end
        
        if(floor_shake_2==0)begin
            H_floor_shake_2=H_floor_shake;
        end
        else begin
            H_floor_shake_2=0;
        end
        
        
        
    end
end

wire [15:0]score_num_bcd;
assign score_num_bcd=bcd(score_num);    //將score_num轉為4位數BCD碼

//--------------------------
//  2進制轉BCD(4位數)
//  bcd=bcd(n_in)
//--------------------------
function [15:0]bcd;
    input [10:0] n_in;
    reg [3:0] j ;
    
    begin
        for(j=0; j < 11; j=j+1)begin
            bcd = {bcd[14:0] , n_in[10-j]};
            if( j<10 && bcd[3:0] > 4'd4) 
                bcd[3:0] = bcd[3:0] + 3;
            if( j<10 && bcd[7:4] > 4'd4) 
                bcd[7:4] = bcd[7:4] + 3;
            if( j<10 && bcd[11:8] > 4'd4) 
                bcd[11:8] = bcd[11:8] + 3;
            if( j<10 && bcd[15:12] > 4'd4) 
                bcd[15:12] = bcd[15:12] + 3;
        end
    end
endfunction     

endmodule
