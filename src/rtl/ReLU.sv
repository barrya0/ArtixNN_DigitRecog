`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/23/2024 01:11:21 PM
// Module Name: ReLU_Mem
// Description: Design of ReLU function behavior
// Revision:
// Revision 0.01 - File Created
// Additional Comments: if in < 0, out = 0; if in >= 0, out = in.
//////////////////////////////////////////////////////////////////////////////////


module ReLU #(parameter dataWidth=16, weightIntWidth=4)
    (
    input logic clk,
    input logic [2*dataWidth-1:0] x,
    output logic [dataWidth-1:0] out
    );
    //because we are dealing with hardware, we cannot have our output ever increasing as it does in ReLU and must ensure that
    //-> datawidths of output == width of input
    //-> so we must check for over flow in x through it's bit fields
    //-> We know x to have the form {1 <signbit> <weightIntWidth> <inputIntWidth> <inputFrac> <weightFrac>}
    //->so...
    always_ff @(posedge clk) begin
        if($signed(x) >= 0) begin
            //if there are any 1s in the range from signbit <-> weightIntWidth there has been 
            //->overflow to sign bit of integer part
            if(|x[2*dataWidth-1-:weightIntWidth+1])
                out <= {1'b0, {(dataWidth-1){1'b1}}}; //saturate output to maximum possible value
            else //take the fields from our inputIntWidth <-> inputFrac to get our proper input value
                out <= x[2*dataWidth-1-weightIntWidth-:dataWidth];
        end
        else    out <= 0;
    end
endmodule
