`timescale 1ns / 1ps

module clock_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 100MHz 클럭 주기: 10ns
    parameter COUNTER_MAX_SIM = 100; // 시뮬레이션용 카운터 최대 값

    // Testbench Signals
    reg clk;
    reg reset;
    wire [3:0] current_time_0;
    wire [3:0] current_time_1;
    wire [3:0] current_time_2;
    wire [3:0] current_time_3;

    // Instantiate the clock module with COUNTER_MAX_SIM
    clock #(
        .COUNTER_MAX(COUNTER_MAX_SIM)
    ) uut (
        .clk(clk),
        .reset(reset),
        .current_time_0(current_time_0),
        .current_time_1(current_time_1),
        .current_time_2(current_time_2),
        .current_time_3(current_time_3)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk; // 100MHz 클럭 생성
    end

    // Test sequences
    initial begin
        // Initialize Inputs
        reset = 1;
        // 초기화 상태 유지
        #(CLK_PERIOD*10);
        
        // Release reset
        reset = 0;
        #(CLK_PERIOD*10);

        // Run simulation for enough time to observe multiple increments
        #(CLK_PERIOD * 10000);

        // Finish simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | clk_1hz_1: %b | current_time: %0d%d:%0d%d",
                 $time,
                 uut.clk_1hz_1,
                 current_time_0,
                 current_time_1,
                 current_time_2,
                 current_time_3);
    end

endmodule
