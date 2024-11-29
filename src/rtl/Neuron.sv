`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/22/2024 01:43:21 PM
// Module Name: Neuron
// Description: Neuron Design with inference and control logic, weight memory, and activation function design based off
// the function a' = sigmoid(w*a + b) where w=weight matrix(weight memory), a is identifier of a specific neuron, and b is the bias for said neuron.
// Sigmoid is the chosen activation function for our NN.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
//`define DEBUG
`include "include.sv"

module Neuron #(parameter layerNo=0, neuronNo=0, numWeight=784, 
                dataWidth=16, sigmoidSize=5, weightIntWidth=4 /*how many bits representing the integer part of the weight - defined by module above*/, 
                actType="sigmoid", biasFile="b_1_0.mif", weightFile="w_1_0.mif")
    (
    input logic clk, rst,
    input logic [dataWidth-1:0] myinput,
    input logic myinputValid, weightValid, biasValid,
    input logic [31:0] weightVal, biasVal,
    input logic [31:0] config_layer_num, config_neuron_num,
    output logic [dataWidth-1:0] out,
    output logic outvalid
    );
    parameter addressWidth = $clog2(numWeight); //the addressWidth is a direct function of the number of weights and is statically expanded
    //Initialize internal signals
    //------Memory related------
    logic wen, ren;
    logic [addressWidth-1:0] w_addr;
    logic [addressWidth:0] r_addr; //read address spans all of numWeight hence extra bit
    logic [dataWidth-1:0] w_in, w_out;
    //bias register
    logic [31:0] biasReg[0:0];
    //For internal Operations---
    //->add and mul
    logic [2*dataWidth-1:0] mul, sum, bias;
    logic weight_valid, mul_valid, mux_valid, sigValid;
    logic [2*dataWidth:0] comboAdd, biasAdd;
    logic [dataWidth-1:0] myinputD;
    logic muxValid_D, muxValid_F;
    logic addr=0;
  
    //Load weight values into memory
    always_ff @(posedge clk) begin
        if(rst) begin
            //using replication operator to assign weight address all 1 on reset
            //-> this works because of the w_addr <= w_addr+1 in the else if.
            //-> beacuse w_addr is incrementing, to ensure a start w_addr of 0, we need all 1's as 1+ "all 1's"~0 
            w_addr <= {addressWidth{1'b1}};
            wen <= 0;
        end
        //weightValid for a particular neuron identified by two parameters layerNo and neuronNo
        else if(weightValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo)) begin
            w_in <= weightVal;
            w_addr <= w_addr+1;
            wen <= 1;
        end
        else    wen <= 0;
    end
    
    //loading bias value
    `ifdef pretrained
        initial begin
            $readmemb(biasFile, biasReg); //load our bias values into bias register
        end
        always_ff @(posedge clk) begin
            //on clock edge, assign bias to associated bias using address concatenated with 0's
            bias <= {biasReg[addr][dataWidth-1:0], {dataWidth{1'b0}}};
        end
    `else
        //not pretrained so
        always_ff @(posedge clk) begin
            //check bias signal valid and neuron
            if(biasValid & (config_layer_num==layerNo) & config_neuron_num==neuronNo) begin
                bias <= {biasVal[dataWidth-1:0], {dataWidth{1'b0}}}; //assign bias based on the input value with 0's
            end
        end
    `endif
    
    //continuous statements
    assign mux_valid = mul_valid;
    assign comboAdd = mul + sum;
    assign biasAdd = bias + sum;
    assign ren = myinputValid;
    
    //Weight MEM instantiation
    Weight_Mem #(.numWeight(numWeight), .neuronNo(neuronNo), .layerNo(layerNo), .addressWidth(addressWidth),
                    .dataWidth(dataWidth), .weightFile(weightFile)) 
                    WM(.clk(clk), .wen(wen), .ren(ren), .wadd(w_addr), .radd(r_addr), .win(w_in), .wout(w_out));
    
    //delay signal assignments on clock to match our sequential reading of weight memory which has one clock delay or latency
    //basically establishes the pipelined design
    always_ff @(posedge clk) begin
        myinputD <= myinput;
        weight_valid <= myinputValid; //delay weight_valid signal by the inputValid to allow proper fetching from memory
        mul_valid <= weight_valid; //aligns mul_valid to be set after reading the weight from memory
        sigValid <= ((r_addr == numWeight) & muxValid_F) ? 1'b1: 1'b0; //if all weights read and multiplexer operation satisfied
        outvalid <= sigValid;
        muxValid_D <= mux_valid;
        muxValid_F <= !mux_valid & muxValid_D; //used for detecting the end of valid multiplexing window
    end
    //increment read address according to outvalid event
    always_ff @(posedge clk) begin
        if(rst | outvalid) //if we've gone through every weight or reset high
            r_addr <= 0; 
        else if(myinputValid) r_addr <= r_addr+1; //otherwise increment read address
    end
    //multiplication
    always_ff @(posedge clk) begin
        //each weight multiplied by corresponding input
        //->because we are using 2's complement mul
        //->system task tells vivado we are doing signed multiplication and to make the appropriate circuit and make relevant DSP slices
        mul <= $signed(myinputD) * $signed(w_out);
    end
    //operation condition handling(overflow, underflow)
    always_ff @(posedge clk) begin
        //when reset or neuron has final output after activation
        if(rst | outvalid)  sum <= 0;
        //Final output case when all weights have been read and we must add the bias associated with the neuron
        else if((r_addr == numWeight) & muxValid_F) begin
            //if MSB of bias is 0 or pos and of previous sum is 0 or pos. but biasAdd yields neg
            //-> overflow
            if(!bias[2*dataWidth-1] & !sum[2*dataWidth-1] & biasAdd[2*dataWidth-1]) begin
                //latch sum to highest possible
                sum[2*dataWidth-1] <= 1'b0;
                sum[2*dataWidth-2:0] <= {2*dataWidth-1{1'b1}};
            end
            //underflow
            else if(bias[2*dataWidth-1] & sum[2*dataWidth-1] & !biasAdd[2*dataWidth-1]) begin
                //latch sum to lowest possible
                sum[2*dataWidth-1] <= 1'b1;
                sum[2*dataWidth-2:0] <= {2*dataWidth-1{1'b0}};
            end
            else    sum <= biasAdd; //accumulate sum with the bias finally
        end
        //Normal Case - end of a multiplexing window 
        else if(mux_valid) begin
            //if MSB of mul op is 0 or pos. and of previous sum is 0 or pos. but comboAdd yields negative
            //-> overflow error
            if(!mul[2*dataWidth-1] & !sum[2*dataWidth-1] & comboAdd[2*dataWidth-1]) begin
                //assign MSB positive
                sum[2*dataWidth-1] <= 1'b0;
                //approximate result answer to the largest positive number with replication of all 1's in remainder bits
                sum[2*dataWidth-2:0] <= {2*dataWidth-1{1'b1}};
            end
            //MSB of mul op is 1 or neg. and of prev sum is 1 or neg. but comboAdd yields positive
            //-> underflow error
            else if(mul[2*dataWidth-1] & sum[2*dataWidth-1] & !comboAdd[2*dataWidth-1]) begin
                //assign MSB negative
                sum[2*dataWidth-1] <= 1'b1;
                //approximate result answer to the lowest negative number with replication of all 0's in remainder bits
                sum[2*dataWidth-2:0] <= {2*dataWidth-1{1'b0}};
            end
            else    sum <= comboAdd; //simply accumulate sum with comboAdd
        end
    end
    
    //Activation Function
    //-> We use generate generally if you must instantiate a module multiple times and use a for loop within
    //-> Here generate is used to selectively instantiate one of the activation functions
    //-> Sigmoid(non-linear) or Rectified Linear Unit(ReLU)(Linear)
    generate
        if(actType == "sigmoid") begin
            //only upper bits (max width - sigmoid size) sent as sum bc sigmoid is implemented as memory so depth of memory
            //-> resource utilization is a concern
            //-> Cannot send 32 bits to sigmoid so we send only upper sigmoidSize bits to rectify our ROM Depth and input range EX: (2^5 = 32 entries in mem, 2^10 = 1024)
            Sig_ROM #(.inWidth(sigmoidSize), .dataWidth(dataWidth)) sig(.clk(clk), .x(sum[2*dataWidth-1-:sigmoidSize]), .out(out));
        end
        else begin
            ReLU #(.dataWidth(dataWidth), .weightIntWidth(weightIntWidth)) re(.clk(clk), .x(sum), .out(out));
        end
    endgenerate
    
    //for debugging
    `ifdef DEBUG
    always_ff @(posedge clk) begin
        if(outvalid)
            $display(neuronNo,,,,"%b", out);   
    end
    `endif
endmodule
