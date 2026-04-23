`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2025 08:21:01 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
input[7:0] A, 
input[7:0] B, 
input[2:0] opcode,
output reg [7:0] result,
output reg carry,
output wire zero

    );
reg [8:0] sum;
assign zero = (result == 8'd0);

always @(*) begin


    // default values
    result = 8'd0;
    carry  = 1'b0;
    sum    = 9'd0;

    case(opcode)
        3'b000: begin              // ADD
            sum    = A + B;
            result = sum[7:0];
            carry  = sum[8];
        end

        3'b001: result = A - B;    // SUB
        3'b010: result = A & B;    // AND
        3'b011: result = A | B;    // OR
        3'b100: result = A ^ B;    // XOR
        3'b101: result = A << 1;   // SHL
        3'b110: result = A >> 1;   // SHR
        default: result = 8'd0;
    endcase
end
endmodule