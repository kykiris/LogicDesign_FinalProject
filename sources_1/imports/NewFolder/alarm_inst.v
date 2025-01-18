`timescale 1ns / 1ps

`define MIN_TENS   4'b1000 // �� 10�� �ڸ�
`define MIN_UNITS  4'b0100 // �� 1�� �ڸ�
`define SEC_TENS   4'b0010 // �� 10�� �ڸ�
`define SEC_UNITS  4'b0001 // �� 1�� �ڸ�

module alarm (
    input clk4,
    input reset,
    input inc,                 // ���� ��ư
    input dec,                 // ���� ��ư
    input moveLEFT,            // �������� �̵�
    input moveRIGHT,           // ���������� �̵�
    input enable,              // ���� ���� Ȱ��ȭ ��ȣ
    output reg [3:0] alarm_setting_output_0, // ���� �ð� �� (4���� �׸�)
    output reg [3:0] alarm_setting_output_1,
    output reg [3:0] alarm_setting_output_2,
    output reg [3:0] alarm_setting_output_3,
    output reg [3:0] min_tens2,  // �� 10�� �ڸ� (0~5)
    output reg [3:0] min_units2, // �� 1�� �ڸ� (0~9)
    output reg [3:0] sec_tens2,  // �� 10�� �ڸ� (0~5)
    output reg [3:0] sec_units2, // �� 1�� �ڸ� (0~9)
    output reg [3:0] setting_position2, // ���� ���� ��ġ (��/�� �ڸ���)
    output reg [2:0] blinky
);
    
    // �ڸ��� �̵� ó��
    always @(posedge clk4 or posedge reset) begin
        if (reset) begin
            setting_position2 <= `MIN_TENS; // �ʱ� ����: �� 10�� �ڸ�
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
            // ���� ��ư ó��: �ڸ��� �̵� (�ð����)
            if (moveLEFT) begin
                case (setting_position2)
                    `MIN_TENS:  setting_position2 <= `SEC_UNITS;
                    `MIN_UNITS: setting_position2 <= `MIN_TENS;
                    `SEC_TENS:  setting_position2 <= `MIN_UNITS;
                    `SEC_UNITS: setting_position2 <= `SEC_TENS;
                    default:    setting_position2 <= `MIN_TENS;
                endcase
            end

            // ������ ��ư ó��: �ڸ��� �̵� (�ݽð����)
            if (moveRIGHT) begin
                case (setting_position2)
                    `MIN_TENS:  setting_position2 <= `MIN_UNITS;
                    `MIN_UNITS: setting_position2 <= `SEC_TENS;
                    `SEC_TENS:  setting_position2 <= `SEC_UNITS;
                    `SEC_UNITS: setting_position2 <= `MIN_TENS;
                    default:    setting_position2 <= `MIN_TENS;
                endcase
            end

            // �� �ڸ����� ���� �� ������Ʈ
            case (setting_position2)
                `MIN_TENS: begin // �� 10�� �ڸ� (0~5)
                    if (inc) min_tens2 <= (min_tens2 == 4'd5) ? 0 : min_tens2 + 1;
                    if (dec) min_tens2 <= (min_tens2 == 0) ? 4'd5 : min_tens2 - 1;
                    blinky <= 3'b001;
                end
                `MIN_UNITS: begin // �� 1�� �ڸ� (0~9)
                    if (inc) min_units2 <= (min_units2 == 4'd9) ? 0 : min_units2 + 1;
                    if (dec) min_units2 <= (min_units2 == 0) ? 4'd9 : min_units2 - 1;
                    blinky <= 3'b010;
                end
                `SEC_TENS: begin // �� 10�� �ڸ� (0~5)
                    if (inc) sec_tens2 <= (sec_tens2 == 4'd5) ? 0 : sec_tens2 + 1;
                    if (dec) sec_tens2 <= (sec_tens2 == 0) ? 4'd5 : sec_tens2 - 1;
                    blinky <= 3'b011;
                end
                `SEC_UNITS: begin // �� 1�� �ڸ� (0~9)
                    if (inc) sec_units2 <= (sec_units2 == 4'd9) ? 0 : sec_units2 + 1;
                    if (dec) sec_units2 <= (sec_units2 == 0) ? 4'd9 : sec_units2 - 1;
                    blinky <= 3'b100;
                end
            endcase
            alarm_setting_output_0 <= min_tens2;  // �� 10�� �ڸ�
            alarm_setting_output_1 <= min_units2; // �� 1�� �ڸ�
            alarm_setting_output_2 <= sec_tens2;  // �� 10�� �ڸ�
            alarm_setting_output_3 <= sec_units2; // �� 1�� �ڸ�
        end else begin
            setting_position2 <= `MIN_TENS; // �ʱ� ����: �� 10�� �ڸ�
            min_tens2 <= alarm_setting_output_0;
            min_units2 <= alarm_setting_output_1;
            sec_tens2 <= alarm_setting_output_2;
            sec_units2 <= alarm_setting_output_3;
            blinky <= 3'b000;
        end
    end

endmodule
