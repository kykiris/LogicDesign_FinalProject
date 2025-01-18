`timescale 1ns / 1ps

module stopwatch (
    input clk4,          // 25 MHz System clock
    input reset,         // Reset signal
    input enable,        // Enable stopwatch
    input start_pause,   // Push button for start/pause
    output reg [3:0] stop_time_0,
    output reg [3:0] stop_time_1,
    output reg [3:0] stop_time_2,
    output reg [3:0] stop_time_3
);

    // Internal signals
    reg running;
    reg centisecond_clk;
    reg [19:0] div_count;

    // Button synchronization
    reg start_pause_meta, start_pause_sync;
    reg start_pause_sync_prev;

    // centisecond_clk previous value for edge detection
    reg centisecond_clk_prev;
    wire centisecond_clk_rise;

    // -------------------------
    // 1. Clock division for 100Hz
    always @(posedge clk4 or posedge reset) begin
        if (reset) begin
            div_count <= 0;
            centisecond_clk <= 0;
        end else begin
            // 25MHz -> 100Hz
            // half-period: 5ms = 125,000 cycles
            // Toggle after 124,999 counts
            if (div_count == 62500) begin
                div_count <= 0;
                centisecond_clk <= ~centisecond_clk;
            end else begin
                div_count <= div_count + 1;
            end
        end
    end

    // centisecond_clk rise detection
    always @(posedge clk4 or posedge reset) begin
        if (reset) begin
            centisecond_clk_prev <= 0;
        end else begin
            centisecond_clk_prev <= centisecond_clk;
        end
    end
    assign centisecond_clk_rise = (centisecond_clk == 1 && centisecond_clk_prev == 0);

    // -------------------------
    // 2. Button synchronization (no debouncing)
    always @(posedge clk4 or posedge reset) begin
        if (reset) begin
            start_pause_meta <= 0;
            start_pause_sync <= 0;
            start_pause_sync_prev <= 0;
        end else begin
            // 2-stage synchronization
            start_pause_meta <= start_pause;
            start_pause_sync <= start_pause_meta;

            // Previous state 저장
            start_pause_sync_prev <= start_pause_sync;
        end
    end

    // Button edge detection (rising edge)
    wire button_pressed = (start_pause_sync == 1 && start_pause_sync_prev == 0);

    // -------------------------
    // 3. Stopwatch logic
    always @(posedge clk4 or posedge reset) begin
        if (reset) begin
            stop_time_0 <= 4'd0;
            stop_time_1 <= 4'd0;
            stop_time_2 <= 4'd0;
            stop_time_3 <= 4'd0;
            running <= 1'b0;
        end else begin
            if (enable) begin
                // Button pressed -> toggle running
                if (button_pressed) begin
                    running <= ~running;
                end

                // Increase count on centisecond_clk rising edge when running
                if (running && centisecond_clk_rise) begin
                    if (stop_time_3 == 4'd9) begin
                        stop_time_3 <= 0;
                        if (stop_time_2 == 4'd9) begin
                            stop_time_2 <= 0;
                            if (stop_time_1 == 4'd9) begin
                                stop_time_1 <= 0;
                                if (stop_time_0 == 4'd9) begin
                                    stop_time_0 <= 0;
                                end else begin
                                    stop_time_0 <= stop_time_0 + 1;
                                end
                            end else begin
                                stop_time_1 <= stop_time_1 + 1;
                            end
                        end else begin
                            stop_time_2 <= stop_time_2 + 1;
                        end
                    end else begin
                        stop_time_3 <= stop_time_3 + 1;
                    end
                end
            end else begin
                // enable이 0일 때 리셋
                stop_time_0 <= 4'd0;
                stop_time_1 <= 4'd0;
                stop_time_2 <= 4'd0;
                stop_time_3 <= 4'd0;
                running <= 1'b0;
            end
        end
    end

endmodule
