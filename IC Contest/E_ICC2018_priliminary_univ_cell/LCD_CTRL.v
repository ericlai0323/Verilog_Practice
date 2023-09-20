module LCD_CTRL (
    clk,
    reset,
    cmd,
    cmd_valid,
    IROM_Q,
    IROM_rd,
    IROM_A,
    IRAM_valid,
    IRAM_D,
    IRAM_A,
    busy,
    done
);
input clk;
input reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;
output IROM_rd;
output [5:0] IROM_A;
output IRAM_valid;
output [7:0] IRAM_D;
output [5:0] IRAM_A;
output busy;
output done;

parameter READ = 2'd0;
parameter IDLE_CMD = 2'd1;
parameter OP = 2'd2;
parameter WRITE = 2'd3;

reg [1:0]state_cs;
reg [1:0]state_ns;
reg [7:0] ImageBuffer[63:0];
reg [5:0]P0;
wire [5:0]P1,P2,P3;

assign P1 = P0 + 6'd1;
assign P2 = P0 + 6'd8;
assign P3 = P0 + 6'd9;

reg [5:0] counter_IROM_A;
reg [5:0] counter_IRAM_A;

reg IROM_rd;
reg [5:0] IROM_A;
reg IRAM_valid;
reg [7:0] IRAM_D;
reg [5:0] IRAM_A;
reg busy;
reg done;
reg [5:0] PMax,PMin;
reg [9:0] PSum;

parameter CMD_WR = 4'b0000, CMD_SU = 4'b0001, CMD_SD = 4'b0010, CMD_SL = 4'b0011, CMD_SR = 4'b0100,
        CMD_Max = 4'b0101, CMD_Min = 4'b0110, CMD_AVG = 4'b0111, CMD_CCR = 4'b1000, CMD_CR = 4'b1001,
        CMD_MX = 4'b1010, CMD_MY = 4'b1011;

// State Switch
always @(posedge clk or posedge reset)
begin
    if(reset) state_cs <= READ;
    else state_cs <= state_ns;
end

// Next State Logic
always @(*)
begin
    case(state_cs)
        READ:
        begin
            if(IROM_A == 6'b11_1111) state_ns = IDLE_CMD;
            else state_ns = READ;
        end
        IDLE_CMD:
        begin
            if(cmd_valid && cmd != 4'd0) state_ns = OP;
            else if (cmd_valid && cmd == 4'd0) state_ns = WRITE;
            else state_ns = IDLE_CMD;
        end
        OP:
        begin
            state_ns = IDLE_CMD;
        end
        WRITE:
        begin
            state_ns = WRITE;
        end
    endcase
end

// Control Signal
always @(*)
begin
    case(state_cs)
        READ:
        begin
            {IROM_rd,IRAM_valid,busy} = 3'b101;
        end

        IDLE_CMD:
        begin
            {IROM_rd,IRAM_valid,busy} = 3'b000;
        end

        OP:
        begin
            {IROM_rd,IRAM_valid,busy} = 3'b001;
        end

        WRITE:
        begin
            {IROM_rd,IRAM_valid,busy} = 3'b011;
        end
    endcase
end



// IROM_A counter
always @(posedge clk)
begin
    if(reset == 1'd1) counter_IROM_A <= 6'd0;
    else if (IROM_rd == 1'd1)
    begin
        if(counter_IROM_A == 6'b11_1111) counter_IROM_A <= 6'd0;
        else counter_IROM_A <= counter_IROM_A + 6'd1;
    end

    IROM_A <= counter_IROM_A;
end

// IRAM_A counter
always @(posedge clk)
begin
    if(reset == 1'd1) counter_IRAM_A <= 6'd0;
    else if (IRAM_valid == 1'd1)
    begin
        if(counter_IRAM_A == 6'b11_1111) counter_IRAM_A <= counter_IRAM_A;
        else counter_IRAM_A <= counter_IRAM_A + 6'd1;
    end
end

// IRAM_A Delay 1 clk
always @(posedge clk)
begin
    IRAM_A <= counter_IRAM_A;
end

// Point Move
always @(posedge clk)
begin
    if(reset == 1'd1) P0 <= 6'b011_011; //Point Need to set at (4,4), but P0 is at (3,3)
    else
    begin
        if(state_cs == IDLE_CMD)
        begin
            case(cmd)
                CMD_SU:
                begin
                    if(P0 > 6'd7) P0 <= P0 - 6'd8;
                    else P0 <= P0;
                end

                CMD_SD:
                begin
                    if(P0 < 6'h30) P0 <= P0 + 6'd8;
                    else P0 <= P0;
                end

                CMD_SL:
                begin
                    if(P0 == 6'h0 || P0 == 6'h8 || P0 == 6'h10 || P0 == 6'h18 || P0 == 6'h20 || P0 == 6'h28 || P0 == 6'h30 || P0 == 6'h38) P0 <= P0;
                    else P0 <= P0 - 6'd1;
                end

                CMD_SR:
                begin
                    if(P0 == 6'h6 || P0 == 6'he || P0 == 6'h16 || P0 == 6'h1e || P0 == 6'h26 || P0 == 6'h2e || P0 == 6'h36 || P0 == 6'h3e) P0 <= P0;
                    else P0 <= P0 + 6'd1;
                end
            endcase

        end
    end
end

// IDLE_CMD
always @(posedge clk)
begin
    case(state_cs)
        READ:
        begin
            if(IROM_rd == 1'd1) ImageBuffer[IROM_A] <= IROM_Q;
        end
        IDLE_CMD:
        begin
            case(cmd)
                CMD_Max:
                begin
                   ImageBuffer[P0] <= ImageBuffer[PMax];
                   ImageBuffer[P1] <= ImageBuffer[PMax]; 
                   ImageBuffer[P2] <= ImageBuffer[PMax]; 
                   ImageBuffer[P3] <= ImageBuffer[PMax];  
                end

                CMD_Min:
                begin
                   ImageBuffer[P0] <= ImageBuffer[PMin];
                   ImageBuffer[P1] <= ImageBuffer[PMin]; 
                   ImageBuffer[P2] <= ImageBuffer[PMin]; 
                   ImageBuffer[P3] <= ImageBuffer[PMin];  
                end   

                CMD_AVG: //>>2 = /4 
                begin
                   ImageBuffer[P0] <= PSum[9:2];
                   ImageBuffer[P1] <= PSum[9:2]; 
                   ImageBuffer[P2] <= PSum[9:2]; 
                   ImageBuffer[P3] <= PSum[9:2];  
                end 

                CMD_CCR:
                begin
                    ImageBuffer[P0] <= ImageBuffer[P1];
                    ImageBuffer[P1] <= ImageBuffer[P3];
                    ImageBuffer[P2] <= ImageBuffer[P0];
                    ImageBuffer[P3] <= ImageBuffer[P2];
                end                            

                CMD_CR:
                begin
                    ImageBuffer[P0] <= ImageBuffer[P2];
                    ImageBuffer[P1] <= ImageBuffer[P0];
                    ImageBuffer[P2] <= ImageBuffer[P3];
                    ImageBuffer[P3] <= ImageBuffer[P1];
                end

                CMD_MX:
                begin
                    ImageBuffer[P0] <= ImageBuffer[P2];
                    ImageBuffer[P1] <= ImageBuffer[P3];
                    ImageBuffer[P2] <= ImageBuffer[P0];
                    ImageBuffer[P3] <= ImageBuffer[P1];
                end
                
                CMD_MY:
                begin
                    ImageBuffer[P0] <= ImageBuffer[P1];
                    ImageBuffer[P1] <= ImageBuffer[P0];
                    ImageBuffer[P2] <= ImageBuffer[P3];
                    ImageBuffer[P3] <= ImageBuffer[P2];
                end

                default:;
            endcase
        end
        WRITE:
        begin
            if(IRAM_valid == 1'd1) IRAM_D <= ImageBuffer[counter_IRAM_A];
        end
        default:;
    endcase
end

// Signal done
always @(posedge clk)
begin
    if(IRAM_A == 6'b11_1111) done <= 1'd1;
    else done <= 1'd0;
end



// Max
always @(*) 
begin
    if((ImageBuffer[P0]>=ImageBuffer[P1])&&(ImageBuffer[P0]>=ImageBuffer[P2])&&(ImageBuffer[P0]>=ImageBuffer[P3])) PMax = ImageBuffer[P0];
    else if((ImageBuffer[P1]>=ImageBuffer[P0])&&(ImageBuffer[P1]>=ImageBuffer[P2])&&(ImageBuffer[P1]>=ImageBuffer[P3])) PMax = ImageBuffer[P1];
    else if((ImageBuffer[P2]>=ImageBuffer[P0])&&(ImageBuffer[P2]>=ImageBuffer[P1])&&(ImageBuffer[P2]>=ImageBuffer[P3])) PMax = ImageBuffer[P2];
    else PMax = ImageBuffer[P3];
end

// Min
always @(*) 
begin
    if((ImageBuffer[P0]<=ImageBuffer[P1])&&(ImageBuffer[P0]<=ImageBuffer[P2])&&(ImageBuffer[P0]<=ImageBuffer[P3])) PMin = ImageBuffer[P0];
    else if((ImageBuffer[P1]<=ImageBuffer[P0])&&(ImageBuffer[P1]<=ImageBuffer[P2])&&(ImageBuffer[P1]<=ImageBuffer[P3])) PMin = ImageBuffer[P1];
    else if((ImageBuffer[P2]<=ImageBuffer[P0])&&(ImageBuffer[P2]<=ImageBuffer[P1])&&(ImageBuffer[P2]<=ImageBuffer[P3])) PMin = ImageBuffer[P2];
    else PMin = ImageBuffer[P3];
end

// Sum
always @(*)
begin
    PSum = ImageBuffer[P0] + ImageBuffer[P1] + ImageBuffer[P2] + ImageBuffer[P3];
end


endmodule