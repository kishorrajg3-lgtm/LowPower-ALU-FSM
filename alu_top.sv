`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2025 10:09:22 PM
// Design Name: 
// Module Name: alu_top
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


module alu_top (
    input  logic        clk,
    input  logic        reset,
    input  logic        start,
    input  logic [7:0]  A,
    input  logic [7:0]  B,
    input  logic [2:0]  opcode,
    output logic [7:0]  result,
    output logic        carry,
    output logic        zero,
    output logic        alu_en
);

    // ----------------------------------
    // Internal ALU signals (before gating)
    // ----------------------------------
    logic [7:0] alu_result_int;
    logic       carry_int;
    logic       zero_int;

    // ----------------------------------
    // FSM instance (Self-Calibrating)
    // ----------------------------------
    alu_fsm u_fsm (
        .clk    (clk),
        .reset  (reset),
        .start  (start),
        .alu_en (alu_en)
    );

    // ----------------------------------
    // ALU instance
    // ----------------------------------
    ALU u_alu (
        .A      (A),
        .B      (B),
        .opcode (opcode),
        .result (alu_result_int),
        .carry  (carry_int),
        .zero   (zero_int)
    );



    assign result = (alu_en) ? alu_result_int : 8'd0;
    assign carry  = (alu_en) ? carry_int      : 1'b0;
    assign zero   = (alu_en) ? zero_int       : 1'b1;

endmodule
