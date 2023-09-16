module clk_generator(clk_1kHz, mode, pattern, clk, rst);

output reg clk_1kHz;
output reg [1:0]mode;
output reg [2:0]pattern;
input clk, rst;

//1kHz
reg [31:0] clk_1kHz_count;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin 
        clk_1kHz_count <= 32'd0;
        clk_1kHz <= 0;
    end
    else
    begin
        if (clk_1kHz_count < 32'd20000)
            clk_1kHz_count <= clk_1kHz_count + 32'd1;
        else
        begin
            clk_1kHz_count <= 32'd0;
            clk_1kHz <= ~clk_1kHz;
        end
    end
end

//walk 8Hz
reg [31:0] clk_walk_count;
reg clk_walk;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin 
        clk_walk_count <= 32'd0;
        clk_walk <= 0;
    end
    else
    begin
        if (clk_walk_count < 32'd2500000)
            clk_walk_count <= clk_walk_count + 32'd1;
        else
        begin
            clk_walk_count <= 32'd0;
            clk_walk <= ~clk_walk;
        end
    end
end
//run 32Hz
reg [31:0] clk_run_count;
reg clk_run;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin 
        clk_run_count <= 32'd0;
        clk_run <= 0;
    end
    else
    begin
        if (clk_run_count < 32'd625000)
            clk_run_count <= clk_run_count + 32'd1;
        else
        begin
            clk_run_count <= 32'd0;
            clk_run <= ~clk_run;
        end
    end
end
//change mode clk: walk -> run -> stop 0.4Hz
reg [31:0] mode_change_count;
reg mode_change_clk;
always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin 
        mode_change_count <= 32'd0;
        mode_change_clk <= 0;
    end
    else
    begin
        if (mode_change_count < 32'd100000000)
            mode_change_count <= mode_change_count + 32'd1;
        else
        begin
            mode_change_count <= 32'd0;
            mode_change_clk <= ~mode_change_clk;
        end
    end
end
//change mode
always@(posedge mode_change_clk or negedge rst)
begin
    if (!rst)
        mode <= 2'd0;
    else 
    begin
        if (mode < 2'd2)
            mode <= mode + 2'd1;
        else
            mode <= 2'd0;
    end 
end
//change clk
reg mode_clk;
always@(*)
begin
    case(mode)
        //walk
        2'd0: mode_clk <= clk_walk; 
        //run
        2'd1: mode_clk <= clk_run;
        //stop
        2'd2: mode_clk <= clk_walk;
    endcase
end
//change map clk
always@(posedge mode_clk or negedge rst)
begin
    if(!rst)
        pattern <= 4'd0;
    else
        case(mode)
            2'd2:   pattern <= 4'd0;
            default: pattern <= pattern + 4'd1;
        endcase
end

endmodule
