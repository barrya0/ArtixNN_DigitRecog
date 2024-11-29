`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/29/2024 07:05:02 PM
// Design Name: 
// Module Name: maxFind
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Module to find the maximum activation value from final layer output in NN
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//numInput ~ number neurons in last layer
module maxFind #(parameter numInput=10, inputWidth=16)
    (
    input logic clk,
    input logic [(numInput*inputWidth)-1:0] inData,
    input logic inValid, //signal for valid outputs from final layer
    output logic [31:0] outData,
    output logic outValid 
    );
    
    logic [inputWidth-1:0] maxVal; //represents activation value from a neuron
    logic [(numInput*inputWidth)-1:0] DataBuffer;
    integer ctr;
    
    //total clk cycles to find max ~ num neurons in output layer 
    always_ff @(posedge clk) begin
        outValid <= 1'b0;
        if(inValid) begin
            maxVal <= inData[inputWidth-1:0]; //grab the output from the last neuron for an initial value
            ctr <= 1;
            DataBuffer <= inData; //write values to buffer
            outData <= '0; //current out data is 0
        end
        else if (ctr == numInput) begin
            ctr <= 0;
            outValid <= 1'b1;
        end
        else if(ctr != 0) begin
            ctr <= ctr+1;
            //if an output value spanning the inputWidth relative to the counter value is greater than the current max value
            //->Set new maxvalue
            if(DataBuffer[ctr*inputWidth+:inputWidth] > maxVal) begin
                maxVal <= DataBuffer[ctr*inputWidth+:inputWidth]; //update max value
                outData <= ctr; //output is which neuron has the highest value by the end
            end
        end
    end
endmodule
