`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/23/2024 01:11:21 PM
// Module Name: Sig_ROM
// Description: Design of Sigmoid Function Behavior with prestored values based on x
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module Sig_ROM #(parameter inWidth=10, dataWidth=16)
    (
    input logic clk,
    input logic [inWidth-1:0] x,
    output logic [dataWidth-1:0] out
    );
    //create ROM memory - 16 bits for each row, 2^inWidth bits total
    logic [dataWidth-1:0] mem [2**inWidth-1:0];
    logic [inWidth-1:0] y;
    
    //fetch precalculated values
    initial begin
        $readmemb("sigContent.mif", mem);
    end
    
    //x is a signed number so we cannot directly address the ROM with x but must use variable y
    always_ff @(posedge clk) begin
        //This method reads values following the direct behavior of the sigmoid function
        //->negative inputs yield smaller values approaching 0
        //->positive values yields greater values approaching 1
        if($signed(x) >= 0) //if x is a positive number
            //if x == 0 2**inWidth-1 points to the middle entry of the ROM and so with x values greater than 0 
            //-> we index forward from the middle to get our values
            y <= x+(2**(inWidth-1)); //alone 
        else //negative number
            //if x values < 0, we index backwards from the middle to get proper values
            y <= x-(2**(inWidth-1));
    end
    //blockRAM
    assign out = mem[y];
endmodule
