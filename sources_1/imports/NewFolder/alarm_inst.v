`timescale 1ns / 1ps

`define MIN_TENS   4'b1000 // 분 10의 자리
`define MIN_UNITS  4'b0100 // 분 1의 자리
`define SEC_TENS   4'b0010 // 초 10의 자리
`define SEC_UNITS  4'b0001 // 초 1의 자리

module alarm (
    input clk4,
    input reset,
    input inc,                 // 증가 버튼
    input dec,                 // 감소 버튼
    input moveLEFT,            // 왼쪽으로 이동
    input moveRIGHT,           // 오른쪽으로 이동
    input enable,              // 설정 가능 활성화 신호
    output reg [3:0] alarm_setting_output_0, // 다음 시간 값 (4개의 항목)
    output reg [3:0] alarm_setting_output_1,
    output reg [3:0] alarm_setting_output_2,
    output reg [3:0] alarm_setting_output_3,
    output reg [3:0] min_tens2,  // 분 10의 자리 (0~5)
    output reg [3:0] min_units2, // 분 1의 자리 (0~9)
    output reg [3:0] sec_tens2,  // 초 10의 자리 (0~5)
    output reg [3:0] sec_units2, // 초 1의 자리 (0~9)
    output reg [3:0] setting_position2, // 현재 설정 위치 (분/초 자릿수)
    output reg [2:0] blinky
);
    
    // 자릿수 이동 처리
    always @(posedge clk4 or posedge reset) begin
        if (reset) begin
            setting_position2 <= `MIN_TENS; // 초기 설정: 분 10의 자리
            min_tens2 <= 0;
            min_units2 <= 0;
            sec_tens2 <= 0;
            sec_units2 <= 0;
            alarm_setting_output_0 <= 4'b0;
            alarm_setting_output_1 <= 4'b0;
            alarm_setting_output_2 <= 4'b0;
            alarm_setting_output_3 <= 4'b0;
            blinky <= 3'b000;
        end else if (enable) begin
            // 왼쪽 버튼 처리: 자릿수 이동 (시계방향)
            if (moveLEFT) begin
                case (setting_position2)
                    `MIN_TENS:  setting_position2 <= `SEC_UNITS;
                    `MIN_UNITS: setting_position2 <= `MIN_TENS;
                    `SEC_TENS:  setting_position2 <= `MIN_UNITS;
                    `SEC_UNITS: setting_position2 <= `SEC_TENS;
                    default:    setting_position2 <= `MIN_TENS;
                endcase
            end

            // 오른쪽 버튼 처리: 자릿수 이동 (반시계방향)
            if (moveRIGHT) begin
                case (setting_position2)
                    `MIN_TENS:  setting_position2 <= `MIN_UNITS;
                    `MIN_UNITS: setting_position2 <= `SEC_TENS;
                    `SEC_TENS:  setting_position2 <= `SEC_UNITS;
                    `SEC_UNITS: setting_position2 <= `MIN_TENS;
                    default:    setting_position2 <= `MIN_TENS;
                endcase
            end

            // 각 자릿수에 따른 값 업데이트
            case (setting_position2)
                `MIN_TENS: begin // 분 10의 자리 (0~5)
                    if (inc) min_tens2 <= (min_tens2 == 4'd5) ? 0 : min_tens2 + 1;
                    if (dec) min_tens2 <= (min_tens2 == 0) ? 4'd5 : min_tens2 - 1;
                    blinky <= 3'b001;
                end
                `MIN_UNITS: begin // 분 1의 자리 (0~9)
                    if (inc) min_units2 <= (min_units2 == 4'd9) ? 0 : min_units2 + 1;
                    if (dec) min_units2 <= (min_units2 == 0) ? 4'd9 : min_units2 - 1;
                    blinky <= 3'b010;
                end
                `SEC_TENS: begin // 초 10의 자리 (0~5)
                    if (inc) sec_tens2 <= (sec_tens2 == 4'd5) ? 0 : sec_tens2 + 1;
                    if (dec) sec_tens2 <= (sec_tens2 == 0) ? 4'd5 : sec_tens2 - 1;
                    blinky <= 3'b011;
                end
                `SEC_UNITS: begin // 초 1의 자리 (0~9)
                    if (inc) sec_units2 <= (sec_units2 == 4'd9) ? 0 : sec_units2 + 1;
                    if (dec) sec_units2 <= (sec_units2 == 0) ? 4'd9 : sec_units2 - 1;
                    blinky <= 3'b100;
                end
            endcase
            alarm_setting_output_0 <= min_tens2;  // 분 10의 자리
            alarm_setting_output_1 <= min_units2; // 분 1의 자리
            alarm_setting_output_2 <= sec_tens2;  // 초 10의 자리
            alarm_setting_output_3 <= sec_units2; // 초 1의 자리
        end else begin
            setting_position2 <= `MIN_TENS; // 초기 설정: 분 10의 자리
            min_tens2 <= alarm_setting_output_0;
            min_units2 <= alarm_setting_output_1;
            sec_tens2 <= alarm_setting_output_2;
            sec_units2 <= alarm_setting_output_3;
            blinky <= 3'b000;
        end
    end

endmodule
