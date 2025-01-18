`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// debouncer.v
//////////////////////////////////////////////////////////////////////////////////
module debouncer (
    input clk,          // System clock
    input reset,        // Synchronous reset
    input noisy,        // Noisy input signal (button or switch)
    output reg clean    // Debounced output signal
);
    // 0.2초를 위한 타겟 카운트 (100MHz 기준)
    parameter TARGET_TIME = 1_000_000;  
    // TARGET_TIME을 담을 수 있는 충분히 큰 N 값 선택
    // 2^25 = 33,554,432 > 20,000,000 이므로 N=25면 충분
    parameter N = 25;
    
    reg [N-1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            clean <= 0;
        end else begin
            if (noisy == clean) begin
                // 상태 변화 없음: 카운터 리셋
                counter <= 0;
//                clean <= 0;
            end else begin
                // 상태 변화 시도 중: 카운터 증가
                counter <= counter + 1;
                // 카운터가 TARGET_TIME 도달 시 clean 업데이트
                if (counter == TARGET_TIME) begin
                    clean <= noisy;
                    counter <= 0;
                end
            end
        end
    end
endmodule
