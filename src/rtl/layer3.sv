`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/22/2024 01:43:21 PM
// Module Name: Layer1
// Description: Creating neurons in layer1 simply by instantiating neuron module with certain parameters and inputs
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// All neurons have the same pipelining so all of them will recieve input at the same time
// and will output at the same time.
// The input is serially fed to the layer module according to the number of inputs in the
// previous layer.
//////////////////////////////////////////////////////////////////////////////////

module layer3 #(parameter NN=30, numWeight=784, dataWidth=16, layerNum=3, sigmoidSize=10, weightIntWidth=4, actType="sigmoid") 
    (
    input logic clk, rst, weightValid, biasValid,
    input logic [31:0] weightVal, biasVal, config_layer_num, config_neuron_num,
    input logic x_valid, //valid input
    input logic [dataWidth-1:0] x_in,
    output logic [NN-1:0] o_valid, //linking outputs to neurons using valid signal
    output logic [NN*dataWidth-1:0] x_out //output based on the neuron so there are a total of NN outputs from each neuron with width=dataWidth in a given layer
    );
    //now to 'generate' our neurons
    //->normally we could use a generate function to instantiate modules with a for loop however
    //->some inputs to the neuron module are based on different file names so there is no simple way to go about iterating through file names using
    //->strings and such so unfortunately we must 'manually' install 30 neurons or whatever number you choose
    Neuron #(.layerNo(layerNum),.neuronNo(0), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_0.mif"), .weightFile("w_3_0.mif"))
        a3_0(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[0*dataWidth+:dataWidth]), 
            .outvalid(o_valid[0])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(1), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_1.mif"), .weightFile("w_3_1.mif"))
        a3_1(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[1*dataWidth+:dataWidth]), 
            .outvalid(o_valid[1])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(2), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_2.mif"), .weightFile("w_3_2.mif"))
        a3_2(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[2*dataWidth+:dataWidth]), 
            .outvalid(o_valid[2])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(3), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_3.mif"), .weightFile("w_3_3.mif"))
        a3_3(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[3*dataWidth+:dataWidth]), 
            .outvalid(o_valid[3])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(4), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_4.mif"), .weightFile("w_3_4.mif"))
        a3_4(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[4*dataWidth+:dataWidth]), 
            .outvalid(o_valid[4])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(5), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_5.mif"), .weightFile("w_3_5.mif"))
        a3_5(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[5*dataWidth+:dataWidth]), 
            .outvalid(o_valid[5])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(6), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_6.mif"), .weightFile("w_3_6.mif"))
        a3_6(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[6*dataWidth+:dataWidth]), 
            .outvalid(o_valid[6])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(7), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_7.mif"), .weightFile("w_3_7.mif"))
        a3_7(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[7*dataWidth+:dataWidth]), 
            .outvalid(o_valid[7])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(8), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_8.mif"), .weightFile("w_3_8.mif"))
        a3_8(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[8*dataWidth+:dataWidth]), 
            .outvalid(o_valid[8])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(9), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_3_9.mif"), .weightFile("w_3_9.mif"))
        a3_9(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[9*dataWidth+:dataWidth]), 
            .outvalid(o_valid[9])
            );                      
endmodule