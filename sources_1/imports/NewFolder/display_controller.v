//`timescale 1ns / 1ps

//module display_controller (
//    input clk,
//    input reset,
//    //input alarm_active,    // ?��?�� ?��?��?�� ?��?��
//    input [3:0] blink_state, // �? anode?�� ?���? ?��?��
//    input [3:0] current_time_0,
//    input [3:0] current_time_1,
//    input [3:0] current_time_2,
//    input [3:0] current_time_3,
//    input [3:0] time_setting_output_0,
//    input [3:0] time_setting_output_1,
//    input [3:0] time_setting_output_2,
//    input [3:0] time_setting_output_3,
//    input [3:0] alarm_setting_output_0,
//    input [3:0] alarm_setting_output_1,
//    input [3:0] alarm_setting_output_2,
//    input [3:0] alarm_setting_output_3,
//    input [3:0] stop_time_0,
//    input [3:0] stop_time_1,
//    input [3:0] stop_time_2,
//    input [3:0] stop_time_3,
//    input [3:0] count,
//    input enable_time_set,
//    input enable_alarm_set,
//    input enable_stopwatch,
//    input enable_game,
//    output reg [6:0] seg,
//    output reg [7:0] anodes
//);
//    //-------------------------------------------------------
//    // ?���? ?��?�� ?��?��
//    //-------------------------------------------------------
//    reg [1:0] iter;
//    reg [31:0] blink_counter; // 1초마?�� 깜빡?��?�� ?��?�� 카운?��
//    reg [3:0] blink_toggle;  // �? anode?�� 깜빡?�� ?��?�� ?���?
    
//    reg [3:0] display_time [3:0];
    
//    //-------------------------------------------------------
//    // 7-?��그먼?�� ?��코딩 ?��?��
//    //-------------------------------------------------------
//    function [6:0] decode_digit;
//        input [3:0] digit;
//        case (digit)
//            4'd0: decode_digit = 7'b100_0000;
//            4'd1: decode_digit = 7'b111_1001;
//            4'd2: decode_digit = 7'b010_0100;
//            4'd3: decode_digit = 7'b011_0000;
//            4'd4: decode_digit = 7'b001_1001;
//            4'd5: decode_digit = 7'b001_0010;
//            4'd6: decode_digit = 7'b000_0010;
//            4'd7: decode_digit = 7'b111_1000;
//            4'd8: decode_digit = 7'b000_0000;
//            4'd9: decode_digit = 7'b001_0000;
//            default: decode_digit = 7'b111_1111;
//        endcase
//    endfunction

//    //-------------------------------------------------------
//    // 깜빡?�� ?��?�� ?��?��?��?�� 블록
//    //-------------------------------------------------------
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            iter <= 0;
//            seg <= 7'b111_1111;
//            anodes <= 8'b1111_1111;
//            blink_counter <= 32'b0;
//            blink_toggle <= 4'b0;
//            display_time[0] <= 4'b0;
//            display_time[1] <= 4'b0;
//            display_time[2] <= 4'b0;
//            display_time[3] <= 4'b0;
//        end else begin
//            ////
//            if(enable_time_set==1) begin
//                display_time[0] <= time_setting_output_0;
//                display_time[1] <= time_setting_output_1;
//                display_time[2] <= time_setting_output_2;
//                display_time[3] <= time_setting_output_3;
//            end else if(enable_alarm_set==1) begin
//                display_time[0] <= alarm_setting_output_0;
//                display_time[1] <= alarm_setting_output_1;
//                display_time[2] <= alarm_setting_output_2;
//                display_time[3] <= alarm_setting_output_3;
//            end else if(enable_stopwatch==1) begin
//                display_time[0] <= stop_time_0;
//                display_time[1] <= stop_time_1;
//                display_time[2] <= stop_time_2;
//                display_time[3] <= stop_time_3;
//            end else if(enable_game==1) begin
//                display_time[0] <= 4'b0;
//                display_time[1] <= 4'b0;
//                display_time[2] <= 4'b0;
//                display_time[3] <= count;
//            end else begin
//                display_time[0] <= current_time_0;
//                display_time[1] <= current_time_1;
//                display_time[2] <= current_time_2;
//                display_time[3] <= current_time_3;
//            end
//            ////
//            blink_counter <= blink_counter + 1;
//            if (blink_counter == 50_000_000) begin // 1초마?�� ?���? (100MHz 기�?)
//                blink_toggle <= ~blink_toggle;
//                blink_counter <= 32'b0;
//            end
            
//            // 7 - segment control
//            case (iter)
//                2'd0: begin
//                    anodes <= 8'b1111_1110;
//                    if (blink_state[0] && blink_toggle[0]) begin
//                        seg <= 7'b111_1111; // �? 번째 anode 깜빡?�� ?��?��
//                    end else begin
//                        seg <= decode_digit(display_time[0]);
//                    end
//                end
//                2'd1: begin
//                    anodes <= 8'b1111_1101;
//                    if ( blink_state[1] && blink_toggle[1]) begin
//                        seg <= 7'b111_1111; // ?�� 번째 anode 깜빡?�� ?��?��
//                    end else begin
//                        seg <= decode_digit(display_time[1]);
//                    end
//                end
//                2'd2: begin
//                    anodes <= 8'b1111_1011;
//                    if ( blink_state[2] && blink_toggle[2]) begin
//                        seg <= 7'b111_1111; // ?�� 번째 anode 깜빡?�� ?��?��
//                    end else begin
//                        seg <= decode_digit(display_time[2]);
//                    end
//                end
//                2'd3: begin
//                    anodes <= 8'b1111_0111;
//                    if (blink_state[3] && blink_toggle[3]) begin
//                        seg <= 7'b111_1111; // ?�� 번째 anode 깜빡?�� ?��?��
//                    end else begin
//                        seg <= decode_digit(display_time[3]);
//                    end
//                end
//                default: begin
//                    iter <= 0;
//                    anodes <= 8'b1111_1111;
//                    seg <= 7'b111_1111;
//                end
//            endcase
//            iter <= iter + 1;
            
//        end
//    end


//endmodule

`timescale 1ns / 1ps

module display_controller (
    input clk,
    input reset,
    //input alarm_active,    // �˶� Ȱ��ȭ ��ȣ (�ʿ� �� ���)
    input [3:0] blink_state, // �� anode�� ������ ����
    input [3:0] current_time_0,
    input [3:0] current_time_1,
    input [3:0] current_time_2,
    input [3:0] current_time_3,
    input [3:0] time_setting_output_0,
    input [3:0] time_setting_output_1,
    input [3:0] time_setting_output_2,
    input [3:0] time_setting_output_3,
    input [3:0] alarm_setting_output_0,
    input [3:0] alarm_setting_output_1,
    input [3:0] alarm_setting_output_2,
    input [3:0] alarm_setting_output_3,
    input [3:0] stop_time_0,
    input [3:0] stop_time_1,
    input [3:0] stop_time_2,
    input [3:0] stop_time_3,
    input [3:0] count,
    input enable_time_set,
    input enable_alarm_set,
    input enable_stopwatch,
    input enable_game,
    output reg [6:0] seg,
    output reg [3:0] anodes
);
    //-------------------------------------------------------
    // ���� ��ȣ ����
    //-------------------------------------------------------
    reg [1:0] iter;
    reg [31:0] blink_counter; // 1�� ���� ī��Ʈ
    reg [3:0] blink_toggle;  // �� anode�� ������ ���

    reg [3:0] display_time [3:0];

    // �߰��� ��ȣ: iter_counter �� ���� �Ķ����
    reg [19:0] iter_counter; // ����� ū ��Ʈ �� (��: 20��Ʈ -> �ִ� 1,048,575)
    parameter ITER_COUNTER_MAX = 100_000; // iter ������ ������ ī���� �ִ� �� (100,000)

    //-------------------------------------------------------
    // 7-segment ���÷��� ���ڵ� �Լ�
    //-------------------------------------------------------
    function [6:0] decode_digit;
        input [3:0] digit;
        case (digit)
            4'd0: decode_digit = 7'b100_0000;
            4'd1: decode_digit = 7'b111_1001;
            4'd2: decode_digit = 7'b010_0100;
            4'd3: decode_digit = 7'b011_0000;
            4'd4: decode_digit = 7'b001_1001;
            4'd5: decode_digit = 7'b001_0010;
            4'd6: decode_digit = 7'b000_0010;
            4'd7: decode_digit = 7'b111_1000;
            4'd8: decode_digit = 7'b000_0000;
            4'd9: decode_digit = 7'b001_0000;
            default: decode_digit = 7'b111_1111; // ��� ����
        endcase
    endfunction

    //-------------------------------------------------------
    // ���÷��� ��Ʈ�� ����
    //-------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // �ʱ�ȭ
            iter <= 0;
            seg <= 7'b111_1111;
            anodes <= 8'b1111_1111;
            blink_counter <= 32'b0;
            blink_toggle <= 4'b0;
            display_time[0] <= 4'b0;
            display_time[1] <= 4'b0;
            display_time[2] <= 4'b0;
            display_time[3] <= 4'b0;
            iter_counter <= 0;
        end else begin
            // ���÷��� Ÿ�� ����
            if (enable_time_set) begin
                display_time[0] <= time_setting_output_0;
                display_time[1] <= time_setting_output_1;
                display_time[2] <= time_setting_output_2;
                display_time[3] <= time_setting_output_3;
            end else if (enable_alarm_set) begin
                display_time[0] <= alarm_setting_output_0;
                display_time[1] <= alarm_setting_output_1;
                display_time[2] <= alarm_setting_output_2;
                display_time[3] <= alarm_setting_output_3;
            end else if (enable_stopwatch) begin
                display_time[0] <= stop_time_0;
                display_time[1] <= stop_time_1;
                display_time[2] <= stop_time_2;
                display_time[3] <= stop_time_3;
            end else if (enable_game) begin
                display_time[0] <= 4'b0;
                display_time[1] <= 4'b0;
                display_time[2] <= 4'b0;
                display_time[3] <= count;
            end else begin
                display_time[0] <= current_time_0;
                display_time[1] <= current_time_1;
                display_time[2] <= current_time_2;
                display_time[3] <= current_time_3;
            end

            // Blink Counter ������Ʈ
            blink_counter <= blink_counter + 1;
            if (blink_counter == 50_000_000) begin // 1�ʸ���
                blink_toggle <= ~blink_toggle;
                blink_counter <= 32'b0;
            end

            // iter_counter ������Ʈ
            iter_counter <= iter_counter + 1;
            if (iter_counter == ITER_COUNTER_MAX) begin
                iter_counter <= 0;
                iter <= (iter == 2'd3) ? 2'd0 : iter + 1;
            end

            // 7-segment ����
            case (iter)
                2'd0: begin
                    anodes <= 4'b1110;
                    if (blink_state[0] && blink_toggle[0]) begin
                        seg <= 7'b111_1111; // ������ OFF
                    end else begin
                        seg <= decode_digit(display_time[0]);
                    end
                end
                2'd1: begin
                    anodes <= 4'b1101;
                    if (blink_state[1] && blink_toggle[1]) begin
                        seg <= 7'b111_1111; // ������ OFF
                    end else begin
                        seg <= decode_digit(display_time[1]);
                    end
                end
                2'd2: begin
                    anodes <= 4'b1011;
                    if (blink_state[2] && blink_toggle[2]) begin
                        seg <= 7'b111_1111; // ������ OFF
                    end else begin
                        seg <= decode_digit(display_time[2]);
                    end
                end
                2'd3: begin
                    anodes <= 4'b0111;
                    if (blink_state[3] && blink_toggle[3]) begin
                        seg <= 7'b111_1111; // ������ OFF
                    end else begin
                        seg <= decode_digit(display_time[3]);
                    end
                end
                default: begin
                    iter <= 0;
                    anodes <= 4'b1111;
                    seg <= 7'b111_1111;
                end
            endcase
        end
    end

endmodule

