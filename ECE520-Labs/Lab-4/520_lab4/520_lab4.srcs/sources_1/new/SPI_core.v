/* Aaron Joseph Nanas
* ECE 520 - Lab 4: Design of a SPI Slave Core
* Professor Mirzaei
*/
`timescale 1ns / 1ps

module SPI_core(CLK, RESET, SSN, SCLK, MOSI, RDATA, MISO, ADDR, WSTROBE, WDATA);
    input CLK, RESET, SSN, SCLK, MOSI;
    input [15:0] RDATA;
    output reg MISO;
    output WSTROBE;
    output [6:0] ADDR;
    output [15:0] WDATA;
    
    reg [4:0] r_COUNT;
    reg [15:0] r_WDATA;
    reg [6:0] r_ADDR;
    reg r_WSTROBE = 1'b0;    
    reg r_RW_BIT;           // Used to determine 8th bit status

// Up counter to track SCLK cycles    
always @(posedge SCLK or negedge RESET)
begin
    if (RESET == 0)
        r_COUNT <= 0;
    else if (SSN == 1)           // Reset counter if SSN is high; otherwise, increment by 1
        r_COUNT <= 0;
    else if (r_COUNT > 24)
        r_COUNT <= 0;
    else if (SCLK == 1)
        r_COUNT <= r_COUNT + 1;
end

// MISO line represents the 16-bit read data
always @(posedge CLK or negedge RESET)
begin
    if (RESET == 0)
        MISO <= 0;
    else if (r_COUNT > 7 && r_COUNT < 24)   // Get RDATA value after address is determined
        MISO <= RDATA[23 - r_COUNT];
    else
        MISO <= 0;
end

always @(negedge SCLK or negedge RESET)
begin
    if (RESET == 0) begin
        r_ADDR <= 0;
        r_WDATA <= 0;
    end   
    if (SSN == 0) begin                                 // Active low SSN - acts like an enable
        if (r_COUNT <= 7 && r_COUNT > 0)                // After 7 SCLK cycles, the ADDR value will output
            r_ADDR <= {r_ADDR[5:0], MOSI};              // Shift MOSI left to get ADDR value until 7th count     
        else if (r_COUNT >= 9 && r_COUNT <= 24)         // After 16 SCLK cycles, the WDATA value will output
            r_WDATA <= {r_WDATA[14:0], MOSI};           // Shift MOSI left to get WDATA value until end of count                              
        else if (r_COUNT > 24) begin                    // WDATA and ADDR will latch
        r_WDATA <= r_WDATA;         
        r_ADDR <= r_ADDR;
        end
    end
end

// Getting write/read operation based on the 8th bit
always @(posedge CLK or negedge RESET or negedge SCLK)
begin
    if (RESET == 0) begin
        r_RW_BIT <= 0;
        r_WSTROBE <= 0;
    end
        if (r_COUNT == 8)
            r_RW_BIT <= MISO;      
        else if (r_COUNT == 24 && SCLK == 0)
            r_WSTROBE <= r_RW_BIT;
        else
            r_WSTROBE <= 0;         // r_RW_BIT latches onto bit value when it is not assigned here
end

// Assign the register values to output
assign ADDR = r_ADDR;
assign WDATA = r_WDATA;
assign WSTROBE = r_WSTROBE;

endmodule