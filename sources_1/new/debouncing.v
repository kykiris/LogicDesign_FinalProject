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
    // 0.2�ʸ� ���� Ÿ�� ī��Ʈ (100MHz ����)
    parameter TARGET_TIME = 1_000_000;  
    // TARGET_TIME�� ���� �� �ִ� ����� ū N �� ����
    // 2^25 = 33,554,432 > 20,000,000 �̹Ƿ� N=25�� ���
    parameter N = 25;
    
    reg [N-1:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            clean <= 0;
        end else begin
            if (noisy == clean) begin
                // ���� ��ȭ ����: ī���� ����
                counter <= 0;
//                clean <= 0;
            end else begin
                // ���� ��ȭ �õ� ��: ī���� ����
                counter <= counter + 1;
                // ī���Ͱ� TARGET_TIME ���� �� clean ������Ʈ
                if (counter == TARGET_TIME) begin
                    clean <= noisy;
                    counter <= 0;
                end
            end
        end
    end
endmodule
