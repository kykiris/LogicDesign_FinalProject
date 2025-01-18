`timescale 1ns / 1ps

`define MIN_TENS   4'b1000 // �� 10�� �ڸ�
`define MIN_UNITS  4'b0100 // �� 1�� �ڸ�
`define SEC_TENS   4'b0010 // �� 10�� �ڸ�
`define SEC_UNITS  4'b0001 // �� 1�� �ڸ�

module time_setting (
    input clk4,
    input reset,
    input inc,                 // ���� ��ư
    input dec,                 // ���� ��ư
    input moveLEFT,            // �������� �̵�
    input moveRIGHT,           // ���������� �̵�
    input enable,              // ���� ���� Ȱ��ȭ ��ȣ
    
    input [3:0] current_time_0,
    input [3:0] current_time_1,
    input [3:0] current_time_2,
    input [3:0] current_time_3,
    
    output reg [3:0] time_setting_output_0, // ���� �ð� �� (4���� �׸�)
    output reg [3:0] time_setting_output_1,
    output reg [3:0] time_setting_output_2,
    output reg [3:0] time_setting_output_3,
    
    output reg [3:0] min_tens,  // �� 10�� �ڸ� (0~5)
    output reg [3:0] min_units, // �� 1�� �ڸ� (0~9)
    output reg [3:0] sec_tens,  // �� 10�� �ڸ� (0~5)
    output reg [3:0] sec_units, // �� 1�� �ڸ� (0~9)
    output reg [3:0] setting_position, // ���� ���� ��ġ (��/�� �ڸ���)
    
    output reg [2:0] blinky
);

    
    
    // �ڸ��� �̵� ó��
    always @(posedge clk4 or posedge reset) begin
        if (reset) begin
            setting_position <= `MIN_TENS; // �ʱ� ����: �� 10�� �ڸ�
            min_tens <= 0;
            min_units <= 0;
            sec_tens <= 0;
            sec_units <= 0;
            time_setting_output_0 <= 4'b0;
            time_setting_output_1 <= 4'b0;
            time_setting_output_2 <= 4'b0;
            time_setting_output_3 <= 4'b0;
            blinky <= 3'b000;
        end 
        else if (enable) begin
            // ���� ��ư ó��: �ڸ��� �̵� (�ð����)
            if (moveLEFT) begin
                case (setting_position)
                    `MIN_TENS:  setting_position <= `SEC_UNITS;
                    `MIN_UNITS: setting_position <= `MIN_TENS;
                    `SEC_TENS:  setting_position <= `MIN_UNITS;
                    `SEC_UNITS: setting_position <= `SEC_TENS;
                    default:    setting_position <= `MIN_TENS;
                endcase
            end

            // ������ ��ư ó��: �ڸ��� �̵� (�ݽð����)
            if (moveRIGHT) begin
                case (setting_position)
                    `MIN_TENS:  setting_position <= `MIN_UNITS;
                    `MIN_UNITS: setting_position <= `SEC_TENS;
                    `SEC_TENS:  setting_position <= `SEC_UNITS;
                    `SEC_UNITS: setting_position <= `MIN_TENS;
                    default:    setting_position <= `MIN_TENS;
                endcase
            end

            // �� �ڸ����� ���� �� ������Ʈ
            case (setting_position)
                `MIN_TENS: begin // �� 10�� �ڸ� (0~5)
                    if (inc) min_tens <= (min_tens == 4'd5) ? 0 : min_tens + 1;
                    if (dec) min_tens <= (min_tens == 0) ? 4'd5 : min_tens - 1;
                    blinky <= 3'b001;
                end
                `MIN_UNITS: begin // �� 1�� �ڸ� (0~9)
                    if (inc) min_units <= (min_units == 4'd9) ? 0 : min_units + 1;
                    if (dec) min_units <= (min_units == 0) ? 4'd9 : min_units - 1;
                    blinky <= 3'b010;
                end
                `SEC_TENS: begin // �� 10�� �ڸ� (0~5)
                    if (inc) sec_tens <= (sec_tens == 4'd5) ? 0 : sec_tens + 1;
                    if (dec) sec_tens <= (sec_tens == 0) ? 4'd5 : sec_tens - 1;
                    blinky <= 3'b011;
                end
                `SEC_UNITS: begin // �� 1�� �ڸ� (0~9)
                    if (inc) sec_units <= (sec_units == 4'd9) ? 0 : sec_units + 1;
                    if (dec) sec_units <= (sec_units == 0) ? 4'd9 : sec_units - 1;
                    blinky <= 3'b100;
                end
            endcase
            time_setting_output_0 <= min_tens;  // �� 10�� �ڸ�
            time_setting_output_1 <= min_units; // �� 1�� �ڸ�
            time_setting_output_2 <= sec_tens;  // �� 10�� �ڸ�
            time_setting_output_3 <= sec_units; // �� 1�� �ڸ�
        end else begin
            min_tens <= current_time_0;
            min_units <= current_time_1;
            sec_tens <= current_time_2;
            sec_units <= current_time_3;
            blinky <= 3'b000;
        end
    end
    // next_time �迭�� �� �ڸ��� ���� ä���� ���

endmodule
