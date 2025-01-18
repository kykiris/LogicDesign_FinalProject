`timescale 1ns / 1ps

module clock_divider_tb;

// Inputs
reg clk;
reg reset;

// Outputs
wire clk4;

// Instantiate the clock_divider module
clock_divider uut (
    .clk(clk),
    .reset(reset),
    .clk4(clk4)
);

// Clock generation: 100MHz clock -> period = 10ns
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Toggle every 5ns (100MHz clock)
end

// Test sequence
initial begin
    // Initialize Inputs
    reset = 1;  // Apply reset to start the simulation

    // Apply reset for 100ns
    #100;
    reset = 0;

    // Simulate for a period of time to observe clk4
    #1000000;  // Run the simulation for 1ms (1000 cycles of 1Hz clock)

    // Finish the simulation
    $finish;
end

// Monitor Outputs
initial begin
    $monitor("Time = %0t | Reset = %b | clk = %b | clk4 = %b", $time, reset, clk, clk4);
end

endmodule
