`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/22/2024 01:43:21 PM
// Module Name: Layer2
// Description: Creating neurons in layer2 simply by instantiating neuron module with certain parameters and inputs
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// All neurons have the same pipelining so all of them will recieve input at the same time
// and will output at the same time.
// The input is serially fed to the layer module according to the number of inputs in the
// previous layer.
//////////////////////////////////////////////////////////////////////////////////

module layer2 #(parameter NN=30, numWeight=784, dataWidth=16, layerNum=2, sigmoidSize=10, weightIntWidth=4, actType="sigmoid") 
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
             .biasFile("b_2_0.mif"), .weightFile("w_2_0.mif"))
        a2_0(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[0*dataWidth+:dataWidth]), 
            .outvalid(o_valid[0])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(1), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_1.mif"), .weightFile("w_2_1.mif"))
        a2_1(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[1*dataWidth+:dataWidth]), 
            .outvalid(o_valid[1])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(2), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_2.mif"), .weightFile("w_2_2.mif"))
        a2_2(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[2*dataWidth+:dataWidth]), 
            .outvalid(o_valid[2])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(3), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_3.mif"), .weightFile("w_2_3.mif"))
        a2_3(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[3*dataWidth+:dataWidth]), 
            .outvalid(o_valid[3])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(4), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_4.mif"), .weightFile("w_2_4.mif"))
        a2_4(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[4*dataWidth+:dataWidth]), 
            .outvalid(o_valid[4])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(5), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_5.mif"), .weightFile("w_2_5.mif"))
        a2_5(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[5*dataWidth+:dataWidth]), 
            .outvalid(o_valid[5])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(6), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_6.mif"), .weightFile("w_2_6.mif"))
        a2_6(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[6*dataWidth+:dataWidth]), 
            .outvalid(o_valid[6])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(7), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_7.mif"), .weightFile("w_2_7.mif"))
        a2_7(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[7*dataWidth+:dataWidth]), 
            .outvalid(o_valid[7])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(8), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_8.mif"), .weightFile("w_2_8.mif"))
        a2_8(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[8*dataWidth+:dataWidth]), 
            .outvalid(o_valid[8])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(9), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_9.mif"), .weightFile("w_2_9.mif"))
        a2_9(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[9*dataWidth+:dataWidth]), 
            .outvalid(o_valid[9])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(10), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_10.mif"), .weightFile("w_2_10.mif"))
        a2_10(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[10*dataWidth+:dataWidth]), 
            .outvalid(o_valid[10])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(11), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_11.mif"), .weightFile("w_2_11.mif"))
        a2_11(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[11*dataWidth+:dataWidth]), 
            .outvalid(o_valid[11])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(12), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_12.mif"), .weightFile("w_2_12.mif"))
        a2_12(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[12*dataWidth+:dataWidth]), 
            .outvalid(o_valid[12])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(13), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_13.mif"), .weightFile("w_2_13.mif"))
        a2_13(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[13*dataWidth+:dataWidth]), 
            .outvalid(o_valid[13])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(14), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_14.mif"), .weightFile("w_2_14.mif"))
        a2_14(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[14*dataWidth+:dataWidth]), 
            .outvalid(o_valid[14])
            );
    /*Neuron #(.layerNo(layerNum),.neuronNo(15), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_15.mif"), .weightFile("w_2_15.mif"))
        a2_15(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[15*dataWidth+:dataWidth]), 
            .outvalid(o_valid[15])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(16), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_16.mif"), .weightFile("w_2_16.mif"))
        a2_16(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[16*dataWidth+:dataWidth]), 
            .outvalid(o_valid[16])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(17), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_17.mif"), .weightFile("w_2_17.mif"))
        a2_17(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[17*dataWidth+:dataWidth]), 
            .outvalid(o_valid[17])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(18), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_18.mif"), .weightFile("w_2_18.mif"))
        a2_18(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[18*dataWidth+:dataWidth]), 
            .outvalid(o_valid[18])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(19), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_19.mif"), .weightFile("w_2_19.mif"))
        a2_19(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[19*dataWidth+:dataWidth]), 
            .outvalid(o_valid[19])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(20), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_20.mif"), .weightFile("w_2_20.mif"))
        a2_20(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[20*dataWidth+:dataWidth]), 
            .outvalid(o_valid[20])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(21), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_21.mif"), .weightFile("w_2_21.mif"))
        a2_21(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[21*dataWidth+:dataWidth]), 
            .outvalid(o_valid[21])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(22), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_22.mif"), .weightFile("w_2_22.mif"))
        a2_22(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[22*dataWidth+:dataWidth]), 
            .outvalid(o_valid[22])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(23), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_23.mif"), .weightFile("w_2_23.mif"))
        a2_23(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[23*dataWidth+:dataWidth]), 
            .outvalid(o_valid[23])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(24), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_24.mif"), .weightFile("w_2_24.mif"))
        a2_24(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[24*dataWidth+:dataWidth]), 
            .outvalid(o_valid[24])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(25), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_25.mif"), .weightFile("w_2_25.mif"))
        a2_25(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[25*dataWidth+:dataWidth]), 
            .outvalid(o_valid[25])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(26), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_26.mif"), .weightFile("w_2_26.mif"))
        a2_26(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[26*dataWidth+:dataWidth]), 
            .outvalid(o_valid[26])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(27), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_27.mif"), .weightFile("w_2_27.mif"))
        a2_27(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[27*dataWidth+:dataWidth]), 
            .outvalid(o_valid[27])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(28), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_28.mif"), .weightFile("w_2_28.mif"))
        a2_28(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[28*dataWidth+:dataWidth]), 
            .outvalid(o_valid[28])
            );
    Neuron #(.layerNo(layerNum),.neuronNo(29), .numWeight(numWeight),
            .dataWidth(dataWidth), .sigmoidSize(sigmoidSize), 
             .weightIntWidth(weightIntWidth), .actType(actType), 
             .biasFile("b_2_29.mif"), .weightFile("w_2_29.mif"))
        a2_29(
            .clk(clk), .rst(rst), .myinput(x_in), .myinputValid(x_valid), 
            .weightValid(weightValid), .biasValid(biasValid), .weightVal(weightVal), 
            .biasVal(biasVal), .config_layer_num(config_layer_num), 
            .config_neuron_num(config_neuron_num), .out(x_out[29*dataWidth+:dataWidth]), 
            .outvalid(o_valid[29])
            );*/                     
endmodule