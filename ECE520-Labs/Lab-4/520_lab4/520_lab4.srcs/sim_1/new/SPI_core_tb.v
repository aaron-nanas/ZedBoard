`timescale 1ns / 1ps

module SPI_core_tb();
    reg CLK, RESET, SSN, SCLK, MOSI;
    reg [15:0] RDATA;
    wire MISO, WSTROBE;
    wire [6:0] ADDR;
    wire [15:0] WDATA;
    
SPI_core spi_slave(.CLK(CLK), .RESET(RESET), .SSN(SSN), .SCLK(SCLK), .MOSI(MOSI), .RDATA(RDATA), .MISO(MISO),
                    .ADDR(ADDR), .WSTROBE(WSTROBE), .WDATA(WDATA));
        
   initial begin
        RESET = 1'b0;
        #15 RESET = 1'b0;
        #10 RESET = 1'b1;
        #2875 RESET = 1'b0;
        #100 RESET = 1'b1;
   end  
   
   initial begin
   RDATA <= 16'b1000001100100001;
   end 
                    
   initial begin
        CLK = 1'b0;
        forever begin
            #10 CLK = ~CLK;
        end
   end
   
   initial begin
        SSN = 1'b1;
        #300 SSN = ~SSN;
        #2600 SSN = 1'b1;
   end
   
   initial begin
        SCLK = 1'b0;
        #400 SCLK = ~SCLK;
        forever begin
            #50 SCLK = ~SCLK;
        end
   end
   
   initial begin
   // MOSI: 0 1010 1011 0101 1001 1000 0001 
   MOSI = 1'b0;
   #400 MOSI = 1'b1;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b1;
   #100 MOSI = 1'b0;
   
   #100 MOSI = 1'b1;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b1;
   #100 MOSI = 1'b1;
   
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b1;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b1;
   
   #100 MOSI = 1'b1;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b1;
   
   #100 MOSI = 1'b1;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b0;
   
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b0;
   #100 MOSI = 1'b1;
   
    end
endmodule
