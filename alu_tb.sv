`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2025 11:32:47 PM
// Design Name: 
// Module Name: alu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_tb;

    logic clk;
    logic reset;
    logic start;
    logic [7:0] A, B;
    logic [2:0] opcode;
    logic [7:0] result;
    logic carry, zero;
    logic alu_en;

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    // DUT instances
    ALU alu_inst (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .carry(carry),
        .zero(zero)
    );

    alu_fsm fsm_inst (
        .clk(clk),
        .reset(reset),
        .start(start),
        .alu_en(alu_en)
    );

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        start = 0;
        A = 8'd0;
        B = 8'd0;
        opcode = 3'b000;

        #20 reset = 0;

        // LOW power activity
        start = 1;
        A = 8'd10; B = 8'd5; opcode = 3'b000; // ADD
        #20;

        start = 0;
        #20;

        // HIGH power activity
        start = 1;
        repeat(6) begin
            A = A + 1;
            opcode = 3'b001; // SUB
            #10;
        end

        start = 0;
        #40;

        $stop;
    end

endmodule

