module button_synchronizer_debounced (
    input clk,           // FPGA 클럭 신호
    input reset,         // 리셋 신호
    input async_signal,  // 버튼 입력 (비동기 신호)
    output reg sync_signal // 동기화된 출력 신호
);
    reg [15:0] counter;   // 버튼 상태 유지 시간
    reg debounced_signal; // Debounce 처리된 신호
    reg sync_ff1, sync_ff2;

    // Debounce 처리
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 16'b0;
            debounced_signal <= 1'b0;
        end else begin
            if (async_signal == debounced_signal) begin
                counter <= 16'b0;  // 상태가 유지되면 카운터 리셋
            end else begin
                counter <= counter + 1;  // 상태가 변하면 카운터 증가
                if (counter == 16'hFFFF) begin
                    debounced_signal <= async_signal; // 새로운 상태 적용
                end
            end
        end
    end

    // Synchronizer
    always @(posedge clk) begin
        sync_ff1 <= debounced_signal;
        sync_ff2 <= sync_ff1;
    end

    // 동기화된 출력 신호
    assign sync_signal = sync_ff2;
endmodule
