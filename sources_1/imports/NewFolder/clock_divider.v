`timescale 1ns / 1ps

module clock_divider (
    input clk,         // Basys 3 �⺻ Ŭ�� (100 MHz)
    input reset,
    output reg clk4 // 1Hz Ŭ�� ���
);

    reg [26:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk4 <= 0;
        end else begin
            if (counter == 3) begin // 100 MHz -> 1 Hz
                counter <= 0;
                clk4 <= ~clk4;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

//�����ϴ�