// enable 값 multidrivne 문제
//


`timescale 1ns / 1ps

module fsm(
    input clk,
    input reset,
    input [3:0] sw,                // Switch inputs
    input btnC,                     // Central button
    input [3:0] current_time_0,
    input [3:0] current_time_1,
    input [3:0] current_time_2,
    input [3:0] current_time_3,    // Current clock seconds
    input [3:0] alarm_setting_output_0, // 다음 시간 값 (4개의 항목)
    input [3:0] alarm_setting_output_1,
    input [3:0] alarm_setting_output_2,
    input [3:0] alarm_setting_output_3,      // Alarm seconds
    input game_done,
    input [3:0] random_led,
    input [2:0] blinky,
    input [2:0] blinky2,
    input game_led_off,
    output reg enable_time_set,     // Enable signal for time setting module
    output reg enable_alarm_set,    // Enable signal for alarm setting module
    output reg enable_alarm_on,     // Enable signal for alarm on module
    output reg enable_stopwatch,    // Enable signal for stopwatch module
    output reg enable_game,         // Enable signal for minigame module
    output reg [15:0] led,          // LED 출력
    output reg [3:0] blink_state
);
    (* KEEP = "TRUE" *) reg isTimeset = 0;

    // Define State
    `define Nothing 3'b000
    `define TimeSet 3'b001
    `define ALset   3'b010
    `define ALSWon  3'b011
    `define ALbellon 3'b100
    `define StopWatch 3'b101
    `define Game    3'b110

    reg [2:0] curr_state, next_state;
    reg game_start; // 추가함

    // 1Hz 깜빡임을 위한 카운터와 토글 플래그
    reg [31:0] blink_counter; // 32비트 카운터
    reg blink_toggle;

    // 4-bit to one-hot encoding function
    function [14:0] fourbit_to_onehot;
        input [3:0] func_in;
        case (func_in)
            4'd0: fourbit_to_onehot = 15'b000_000_000_000_001;
            4'd1: fourbit_to_onehot = 15'b000_000_000_000_010;
            4'd2: fourbit_to_onehot = 15'b000_000_000_000_100;
            4'd3: fourbit_to_onehot = 15'b000_000_000_001_000;
            4'd4: fourbit_to_onehot = 15'b000_000_000_010_000;
            4'd5: fourbit_to_onehot = 15'b000_000_000_100_000;
            4'd6: fourbit_to_onehot = 15'b000_000_001_000_000;
            4'd7: fourbit_to_onehot = 15'b000_000_010_000_000;
            4'd8: fourbit_to_onehot = 15'b000_000_100_000_000;
            4'd9: fourbit_to_onehot = 15'b000_001_000_000_000;
            4'd10: fourbit_to_onehot = 15'b000_010_000_000_000;
            4'd11: fourbit_to_onehot = 15'b000_100_000_000_000;
            4'd12: fourbit_to_onehot = 15'b001_000_000_000_000;
            4'd13: fourbit_to_onehot = 15'b010_000_000_000_000;
            4'd14: fourbit_to_onehot = 15'b100_000_000_000_000;
            default: fourbit_to_onehot = 15'b000_000_000_000_000; // 기본값 (에러 처리)
        endcase
    endfunction

    always @(*) begin
        // 초기화
        enable_time_set = 0;
        enable_alarm_set = 0;
        enable_alarm_on = 0;
        enable_stopwatch = 0;
        enable_game = 0;

        case (curr_state)
            `Nothing: begin
                if (sw[0]) begin
                    next_state = `TimeSet;
                    enable_time_set = 1;
                end else if (sw[1]) begin
                    next_state = `ALset;
                    enable_alarm_set = 1;
                end else if (sw[2]) begin
                    next_state = `StopWatch;
                    enable_stopwatch = 1;
                end else if (sw[3]) begin
                    next_state = `ALSWon;
                    enable_alarm_on = 1;
                end else begin
                    next_state = `Nothing;
                end
            end

            `TimeSet: begin
                if (!sw[0]) begin
                    enable_time_set = 0;
                    if (sw[3] == 1) begin
                        next_state = `ALSWon;
                        enable_alarm_on = 1;
                    end else begin
                        next_state = `Nothing;
                        enable_alarm_on = 0;
                    end
                end else begin
                    next_state = `TimeSet;
                    enable_time_set = 1;
                end
            end

            `ALset: begin
                if (!sw[1]) begin
                    enable_alarm_set = 0;
                    if (sw[3] == 1) begin
                        next_state = `ALSWon;
                        enable_alarm_on = 1;
                    end else begin
                        next_state = `Nothing;
                        enable_alarm_on = 0;
                    end
                end else begin
                    next_state = `ALset;
                    enable_alarm_set = 1;
                end
            end

            `ALSWon: begin
                if (!sw[3]) begin
                    next_state = `Nothing;
                    enable_alarm_on = 0;
                end else if (current_time_0 == alarm_setting_output_0 && current_time_1 == alarm_setting_output_1 && current_time_2 == alarm_setting_output_2 && current_time_3 == alarm_setting_output_3) begin
                    next_state = `ALbellon;
                end else begin
                    next_state = `ALSWon;
                    enable_alarm_on = 1;
                end
            end

            `ALbellon: begin
                if (btnC) begin
                    next_state = `Game;
                    enable_game = 1;
                end else begin
                    next_state = `ALbellon;
                end
            end

            `StopWatch: begin
                if (!sw[2]) begin
                    enable_stopwatch = 0;
                    if (sw[3] == 1) begin
                        next_state = `ALSWon;
                        enable_alarm_on = 1;
                    end else begin
                        next_state = `Nothing;
                        enable_alarm_on = 0;
                    end
                end else begin
                    next_state = `StopWatch;
                    enable_stopwatch = 1;
                end
            end

            `Game: begin
                if (game_done) begin
                    enable_game = 0;
                    if (sw[3] == 1) begin
                        next_state = `ALSWon;
                        enable_alarm_on = 1;
                    end else begin
                        next_state = `Nothing;
                        enable_alarm_on = 0;
                    end
                end else begin
                    next_state = `Game;
                    enable_game = 1;
                end
            end

            default: begin
                next_state = `Nothing;
                enable_time_set = 0;
                enable_alarm_set = 0;
                enable_alarm_on = 0;
                enable_stopwatch = 0;
                enable_game = 0;
            end
        endcase
    end

    
    // Update current state and LED states
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            curr_state <= `Nothing;  // 초기 상태로 리셋
            led <= 16'b0000_0000_0000_0000;  // LED 초기화
            blink_counter <= 32'b0;
            blink_toggle <= 1'b0;
            blink_state <= 4'b0000;
            isTimeset <= 0;
        end else begin
            // 1Hz 깜빡임 생성
            blink_counter <= blink_counter + 1;
            if (blink_counter == 50_000_000) begin // 1초마다
                blink_toggle <= ~blink_toggle;
                blink_counter <= 32'b0;
            end

            // Update LED states based on next state
            case (next_state)
                3'b001: begin
                    led[14:0] <= 15'b000_000_000_000_001; // 기본 LED 상태
                    led[15] <= blink_toggle;
                    isTimeset <= 1;
//                    led_definer<=3'b001;
                end
                3'b010: begin
                    led[14:0] <= 15'b000_000_000_000_010; // 기본 LED 상태
                    led[15] <= blink_toggle;
                    isTimeset <= 1;
//                    led_definer<=3'b010;
                end
                3'b101: begin
                    led[14:0] <= 12'b000_000_000_000_100; // 기본 LED 상태
                    led[15] <= blink_toggle;
                    isTimeset <= 0;
                end
                3'b100: begin
                    if (!blink_toggle) begin
                        led[14:0] <= 15'b111_111_111_111_111;
                    end else begin
                        led[14:0] <= 15'b000_000_000_000_000;
                    end
                    blink_state <= 4'b1111;
                    led[15] <= blink_toggle;
                    isTimeset <= 0;
                end
                3'b110: begin
                    if(game_led_off == 0) begin
                    led[14:0] <= fourbit_to_onehot(random_led);
                    end
                    else led[14:0] <= 15'b000_000_000_000_000;
                    blink_state <= 4'b0000;
                    led[15] <= blink_toggle;
                    isTimeset <= 0;
                end
                default: begin
                    led[14:0] <= 15'b000_000_000_000_000; // 기본 LED 상태
                    led[15] <= blink_toggle;
                    isTimeset <= 0;
                end
            endcase
            
            if(isTimeset) begin
            case(blinky)
                3'b001: blink_state <= 4'b0001;
                3'b010: blink_state <= 4'b0010;
                3'b011: blink_state <= 4'b0100;
                3'b100:blink_state <= 4'b1000;
                default: blink_state <= 4'b0000;
            endcase
            if(!blinky) begin
            case(blinky2)
                3'b001: blink_state <= 4'b0001;
                3'b010: blink_state <= 4'b0010;
                3'b011: blink_state <= 4'b0100;
                3'b100:blink_state <= 4'b1000;
                default: blink_state <= 4'b0000;
            endcase
            end
            end else blink_state <= blink_state;
            
            if(isTimeset == 0 && next_state != 3'b100) begin
                blink_state<= 4'b0000; 
            end
            else if(next_state == 3'b100) begin
                blink_state<= 4'b1111;
            end
            // Update LED[16] for blinking
            

            // Update current state
            curr_state <= next_state;
        end
    end

endmodule
