`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/30/2024 03:38:02 PM
// Design Name: 
// Module Name: digitSim_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top level Testbench of NN Accelerator Design
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// `include "..\..\sources_1\new\include.sv" 
`include "include.sv" 
`define NumSamples 100 //how many examples to test total

module digitSim_top();
    //Define our variables
    logic reset, clock;
    logic [`dataWidth-1:0] in;
    logic in_valid;
    logic [`dataWidth-1:0] inMem [784:0];
    string filename;
    logic s_axi_awvalid;
    logic [31:0] s_axi_awaddr;
    logic s_axi_awready;
    logic [31:0] s_axi_wdata;
    logic s_axi_wvalid, s_axi_wready, s_axi_bvalid, s_axi_bready;
    logic intr;
    logic [31:0] axiRdData, s_axi_araddr, s_axi_rdata;
    logic s_axi_arvalid, s_axi_arready, s_axi_rvalid, s_axi_rready;
    logic [`dataWidth-1:0] expected;
    
    //4 LAYER ARCHITECTURE SETUP
    //2D arrays of 30 elements of size 32-bits
//    logic [31:0] numNeurons[3:0];
//    logic [31:0] numWeights[3:0];

    //set the number of neurons at each layer
//    assign numNeurons[0] = 30; //layer 1
//    assign numNeurons[1] = 30; //layer 2
//    assign numNeurons[2] = 10; //layer 3
//    assign numNeurons[3] = 10; //layer 4
    //set number of weights to each neuron based on layer
//    assign numWeights[0] = 784; //num weights to the 1st layer
//    assign numWeights[1] = 30; //num weights to 2nd hidden layer
//    assign numWeights[2] = 30; //num weights to 3rd hidden layer
//    assign numWeights[3] = 10; //numWeights to 4th layer
    
//    //3 LAYER ARCHITECTURE SETUP 30-20-10
//    logic [31:0] numNeurons[3:1];
//    logic [31:0] numWeights[3:1];
//    assign numNeurons[1] = 30; //layer 1
//    assign numNeurons[2] = 20; //layer 2
//    assign numNeurons[3] = 10; //layer 3
//    assign numWeights[1] = 784; //num weights to input layer
//    assign numWeights[2] = 30; //num weights to 1st hidden layer
//    assign numWeights[3] = 20; //num weights to 2nd hidden layer
    
    //3 LAYER ARCHITECTURE SETUP 20-15-10
    logic [31:0] numNeurons[3:1];
    logic [31:0] numWeights[3:1];
    assign numNeurons[1] = 20; //layer 1
    assign numNeurons[2] = 15; //layer 2
    assign numNeurons[3] = 10; //layer 3
    assign numWeights[1] = 784; //num weights to input layer
    assign numWeights[2] = 20; //num weights to 1st hidden layer
    assign numWeights[3] = 15; //num weights to 2nd hidden layer    


    integer correct;

    //instantiate DUT
    //->empty input means data is left unconnected
    digitRecog 
    dut(
        .s_axi_aclk(clock), .s_axi_aresetn(reset), 
        .axis_in_data(in), .axis_in_data_valid(in_valid),
        .axis_in_data_ready(), .s_axi_awaddr(s_axi_awaddr), 
        .s_axi_awprot('0), .s_axi_awvalid(s_axi_awvalid), 
        .s_axi_awready(s_axi_awready), .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(4'hF), .s_axi_wvalid(s_axi_wvalid), 
        .s_axi_wready(s_axi_wready), .s_axi_bresp(), 
        .s_axi_bvalid(s_axi_bvalid), .s_axi_bready(s_axi_bready), 
        .s_axi_araddr(s_axi_araddr), .s_axi_arprot(0), 
        .s_axi_arvalid(s_axi_arvalid), .s_axi_arready(s_axi_arready), 
        .s_axi_rdata(s_axi_rdata), .s_axi_rresp(), 
        .s_axi_rvalid(s_axi_rvalid), .s_axi_rready(s_axi_rready),
        .intr(intr)
    );
    //Set initial values from read/write in AXI interface
    initial begin
        clock = 1'b0;
        s_axi_awvalid = 1'b0;
        s_axi_wvalid = 1'b0;
        s_axi_arvalid = 1'b0;
    end
    always
        #5 clock = ~clock;
    //bready -> Response ready. Master generates this signal when it can accept a write response
    //bvalid -> Write response valid. Slave generates this signal when the write response on the bus is valid.
    //rready -> Read ready. Master generates this signal when it can accept the Read Data and response.
    //rvalid -> Read valid. Slave generates this signal when Read Data is valid
    always_ff @(posedge clock) begin
        //this if may be an issue
        //->make it a !reset ?
        if(!reset)
            s_axi_bready <= 1'b0;
        s_axi_bready <= s_axi_bvalid; //write response valid then master can accept
        s_axi_rready <= s_axi_rvalid; //same idea
    end
    //awvalid -> Write address valid. Master generates this signal when Write Address and control signals are valid
    //awaddr -> write address
    //wdata -> write data
    //wvalid -> write valid
    task writeAxi(input logic [31:0] address, input logic [31:0] data);
        begin
            @(posedge clock);
            s_axi_awvalid <= 1'b1;
            s_axi_awaddr <= address;
            s_axi_wdata <= data;
            s_axi_wvalid <= 1'b1;
            wait(s_axi_wready); //wait for write ready response
            @(posedge clock); //on next clock edge
            s_axi_awvalid <= 1'b0; //invalidate write address
            s_axi_wvalid <= 1'b0; //invalidate write valid
            @(posedge clock);
        end
    endtask
    //arvalid -> Read address valid. Master generates this signal when Read Address and the control signals are valid.
    //araddr -> Read address
    //arready -> Read address ready. Slave generates this signal when it can accept the read address and control signals.
    //rvalid -> Read valid. Slave generates this signal when Read Data is valid
    task readAxi(input logic [31:0] address);
        begin
            @(posedge clock);
            s_axi_arvalid <= 1'b1; //master has valid read address
            s_axi_araddr <= address; //set the address value
            wait(s_axi_arready); //when the slave can accept the read
            @(posedge clock); //on the next clock
            s_axi_arvalid <= 1'b0; //flip valid read addr signal
            wait(s_axi_rvalid); //when slave generates read data valid
            @(posedge clock);
            axiRdData <= s_axi_rdata; //get the data from final layer
            @(posedge clock);
        end
    endtask

    task configWeights();
        integer i,j,k;
        //784 weight memory items each 17? bits wide
        logic [`dataWidth:0] configMem [783:0];
        begin
            @(posedge clock);
            for(i=1;i < `numLayers; i = i + 1) begin
                writeAxi(12, i); //writing layer number
                //for each neuron in a given layer i
                for(j=0; j<numNeurons[i]; j=j+1) begin
                    filename = $sformatf("w_%0d_%0d.mif", i, j);
                    //$display("weight file: %s", filename);
                    //write the filename contents to the weight configuration memory
                    $readmemb(filename, configMem);
                    writeAxi(16, j); //write the neuron number
                    for(k = 0; k < numWeights[i]; k=k+1) begin
                        writeAxi(0, {15'd0, configMem[k]}); //write values to weight register
                    end
                end
            end
        end
    endtask
    task configBias();
        integer i,j;
        logic [31:0] bias [0:0]; //adding [0:0] makes this a memory so readmemb will accept it
        begin
            @(posedge clock);
            for(i=1;i <`numLayers; i = i + 1) begin
                writeAxi(12, i); //writing layer number
                //for each neuron in a given layer i
                for(j=0; j<numNeurons[i]; j=j+1) begin
                    filename = $sformatf("b_%0d_%0d.mif", i, j);
                    //$display("bias file: %s", filename);
                    //write the filename contents to the weight configuration memory
                    $readmemb(filename, bias);
                    writeAxi(16, j); //write the neuron number
                    writeAxi(4, {15'd0, bias[0]}); //write values to bias register
                end
            end
        end
    endtask
    //task for writing pixel data to input layer
    task sendData();
        integer i;
        begin
            $readmemb(filename, inMem);
            //wait 3 cycles
            repeat (3) @(posedge clock);
            for(i=0; i<784; i=i+1) begin
                @(posedge clock);
                in <= inMem[i]; //set input data
                in_valid <= 1;
            end
            @(posedge clock);
            in_valid <= 0;
            expected = inMem[i]; //expected digit value is the last entry in the test data file
        end
    endtask
    integer start, testDataCtr;
    initial begin
        reset = 0;
        in_valid = 0;
        correct = 0;
        #100; //time delay of 100ns
        reset = 1;
        #100;
        writeAxi(28,0); //this clears the softreset in the AXI lite wrapper
        start = $time; //get current time
        `ifdef pretrained //if pretrained
            //configure the weights and biases in our design
            configWeights();
            configBias(); 
        `endif
        $display("Configuration Done; Time - %0t ns", $time-start);
        start = $time;
        for(testDataCtr=0; testDataCtr<`NumSamples; testDataCtr=testDataCtr+1) begin
            //this is for the formatting because the file names have structure
            //-> "test_data_0000.txt" with a fixed 4 digits for the number
            filename = $sformatf("test_data_%04d.txt", testDataCtr);
            //send input data from the test data to the neural network using AXI interface
            sendData();
            //was previously @(posedge intr);
            wait(intr == 1'b1); //when digit training is done for this input
            readAxi(8); //read the output from the network
            if(axiRdData==expected) //Output correct digit
                correct=correct+1;
            //$display("%0d. Accuracy: %0f, Detected number: %x, Expected %x", testDataCtr+1, correct*100.0/(testDataCtr+1), axiRdData, expected);
            $display("%0d. Accuracy: %f, Detected number: %0x, Expected %0x", testDataCtr+1, (correct)*100.0 / (testDataCtr+1), axiRdData, expected);
        end
        $display("Total Accuracy: %f", correct*100.0/testDataCtr);
        $stop; //done with all test data
    end
endmodule
