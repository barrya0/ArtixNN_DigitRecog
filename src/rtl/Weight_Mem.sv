`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/22/2024 01:43:21 PM
// Module Name: Weight_Mem
// Description: Stores the weights associated with different neuron to neuron connections and helps to determine 
// Activation function values for specific neurons
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// -> MEM or MIF files are memory initialization files written to a memory unit
// -> Parameters configured from higher module
//////////////////////////////////////////////////////////////////////////////////

`include "include.sv"
module Weight_Mem #(parameter numWeight = 3, neuronNo=5, layerNo=1, 
                    addressWidth=10, dataWidth=16, weightFile="w_1_15.mif")
    (
    input logic clk, wen, ren,
    input logic [addressWidth-1:0] wadd, radd,
    input logic [dataWidth-1:0] win,
    output logic [dataWidth-1:0] wout
    );
    
    logic [dataWidth-1:0] mem [numWeight-1:0];
    
    //Deciding whether this design will act as RAM or ROM
    //-> if pretrained is defined, behave like ROM otherwise, RAM
    `ifdef pretrained
        initial begin
            $readmemb(weightFile, mem); //use systemtask to write mif file binary data to mem as ROM
        end
    `else
        always_ff @(posedge clk) begin
            //if write enabled
            if(wen) mem[wadd] <= win; //write weight input to the corresponding weight address to memory(RAM)
        end
    `endif
    //read logic -> by using sequential logic, vivado will implement blockRAM instead of distributed RAM.
    //-> if the read logic was combinatorial/continuous, it would be distributed
    always_ff @(posedge clk) begin
        if(ren) wout <= mem[radd];
    end
endmodule
