`timescale 1ns / 1ps

module display_controller_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 100 MHz

    // Testbench Signals
    reg clk;
    reg reset;
    reg [3:0] blink_state;
    reg [3:0] current_time_0;
    reg [3:0] current_time_1;
    reg [3:0] current_time_2;
    reg [3:0] current_time_3;
    reg [3:0] time_setting_output_0;
    reg [3:0] time_setting_output_1;
    reg [3:0] time_setting_output_2;
    reg [3:0] time_setting_output_3;
    reg [3:0] alarm_setting_output_0;
    reg [3:0] alarm_setting_output_1;
    reg [3:0] alarm_setting_output_2;
    reg [3:0] alarm_setting_output_3;
    reg [3:0] stop_time_0;
    reg [3:0] stop_time_1;
    reg [3:0] stop_time_2;
    reg [3:0] stop_time_3;
    reg [3:0] count;
    reg enable_time_set;
    reg enable_alarm_set;
    reg enable_stopwatch;
    reg enable_game;

    wire [6:0] seg;
    wire [7:0] anodes;

    // Instantiate the display_controller
    display_controller uut (
        .clk(clk),
        .reset(reset),
        .blink_state(blink_state),
        .current_time_0(current_time_0),
        .current_time_1(current_time_1),
        .current_time_2(current_time_2),
        .current_time_3(current_time_3),
        .time_setting_output_0(time_setting_output_0),
        .time_setting_output_1(time_setting_output_1),
        .time_setting_output_2(time_setting_output_2),
        .time_setting_output_3(time_setting_output_3),
        .alarm_setting_output_0(alarm_setting_output_0),
        .alarm_setting_output_1(alarm_setting_output_1),
        .alarm_setting_output_2(alarm_setting_output_2),
        .alarm_setting_output_3(alarm_setting_output_3),
        .stop_time_0(stop_time_0),
        .stop_time_1(stop_time_1),
        .stop_time_2(stop_time_2),
        .stop_time_3(stop_time_3),
        .count(count),
        .enable_time_set(enable_time_set),
        .enable_alarm_set(enable_alarm_set),
        .enable_stopwatch(enable_stopwatch),
        .enable_game(enable_game),
        .seg(seg),
        .anodes(anodes)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test sequences
    initial begin
        // Initialize Inputs
        reset = 1;
        blink_state = 4'b0000;
        current_time_0 = 4'd0;
        current_time_1 = 4'd0;
        current_time_2 = 4'd0;
        current_time_3 = 4'd0;
        time_setting_output_0 = 4'd0;
        time_setting_output_1 = 4'd0;
        time_setting_output_2 = 4'd0;
        time_setting_output_3 = 4'd0;
        alarm_setting_output_0 = 4'd0;
        alarm_setting_output_1 = 4'd0;
        alarm_setting_output_2 = 4'd0;
        alarm_setting_output_3 = 4'd0;
        stop_time_0 = 4'd0;
        stop_time_1 = 4'd0;
        stop_time_2 = 4'd0;
        stop_time_3 = 4'd0;
        count = 4'd0;
        enable_time_set = 0;
        enable_alarm_set = 0;
        enable_stopwatch = 0;
        enable_game = 0;

        // Apply reset
        #(CLK_PERIOD*5);
        reset = 0;

        // Test Case 1: Display current_time
        $display("=== Test Case 1: Display current_time ===");
        current_time_0 = 4'd2;
        current_time_1 = 4'd3;
        current_time_2 = 4'd4;
        current_time_3 = 4'd5;
        enable_time_set = 0;
        enable_alarm_set = 0;
        enable_stopwatch = 0;
        enable_game = 0;
        blink_state = 4'b0000;

        #(CLK_PERIOD*20);

        // Test Case 2: Enable Time Setting and set time
        $display("=== Test Case 2: Enable Time Setting ===");
        enable_time_set = 1;
        time_setting_output_0 = 4'd1;
        time_setting_output_1 = 4'd2;
        time_setting_output_2 = 4'd3;
        time_setting_output_3 = 4'd4;
        blink_state = 4'b0011; // Blink first two digits

        #(CLK_PERIOD*20);

        // Test Case 3: Enable Alarm Setting and set alarm
        $display("=== Test Case 3: Enable Alarm Setting ===");
        enable_time_set = 0;
        enable_alarm_set = 1;
        alarm_setting_output_0 = 4'd5;
        alarm_setting_output_1 = 4'd6;
        alarm_setting_output_2 = 4'd7;
        alarm_setting_output_3 = 4'd8;
        blink_state = 4'b1100; // Blink last two digits

        #(CLK_PERIOD*20);

        // Test Case 4: Enable Stopwatch
        $display("=== Test Case 4: Enable Stopwatch ===");
        enable_alarm_set = 0;
        enable_stopwatch = 1;
        stop_time_0 = 4'd9;
        stop_time_1 = 4'd8;
        stop_time_2 = 4'd7;
        stop_time_3 = 4'd6;
        blink_state = 4'b0000;

        #(CLK_PERIOD*20);

        // Test Case 5: Enable Game
        $display("=== Test Case 5: Enable Game ===");
        enable_stopwatch = 0;
        enable_game = 1;
        count = 4'd4;
        blink_state = 4'b1111; // Blink all digits

        #(CLK_PERIOD*20);

        // Test Case 6: Disable all enables and display current_time again
        $display("=== Test Case 6: Disable All Enables ===");
        enable_game = 0;
        current_time_0 = 4'd5;
        current_time_1 = 4'd6;
        current_time_2 = 4'd7;
        current_time_3 = 4'd8;
        blink_state = 4'b0000;

        #(CLK_PERIOD*20);

        // Finish simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | Anodes: %b | Seg: %b | Display Time: %d%d:%d%d | Enabled: TimeSet=%b, AlarmSet=%b, Stopwatch=%b, Game=%b",
                 $time,
                 anodes,
                 seg,
                 display_controller_tb.uut.display_time[0],
                 display_controller_tb.uut.display_time[1],
                 display_controller_tb.uut.display_time[2],
                 display_controller_tb.uut.display_time[3],
                 enable_time_set,
                 enable_alarm_set,
                 enable_stopwatch,
                 enable_game);
    end

endmodule
