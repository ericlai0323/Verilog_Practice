`timescale 1ns / 1ps
module tb_vga_display_name;

    // Inputs
    reg CLK;
    reg RST;
    reg [2:0] SW;

    // Outputs
    wire R_out;
    wire G_out;
    wire B_out;
    wire V_SYNC;
    wire H_SYNC;
    wire Active_Flag;

    // Instantiate the Unit Under Test (UUT)
    vga_display_name uut (
        .CLK(CLK), 
        .RST(RST), 
        .SW(SW), 
        .R_out(R_out), 
        .G_out(G_out), 
        .B_out(B_out), 
        .V_SYNC(V_SYNC), 
        .H_SYNC(H_SYNC), 
        .Active_Flag(Active_Flag)
    );
    always #1 CLK=~CLK;
    initial begin
        // Initialize Inputs
        CLK = 0;
        RST = 1;
        SW = 0;
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
    end
endmodule
