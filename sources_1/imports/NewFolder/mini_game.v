//`timescale 1ns / 1ps

//module mini_game #(
//    parameter PUSHED = 1,
//    parameter RELEASED = 0,
//    parameter ONE_SEC_COUNT = 25_000_000 // 1�ʸ� 25,000,000 ����Ŭ�� ����(100MHz)
//) (
//    input        clk,
//    input        reset,
//    input        enable_game,
//    input [14:0] spdt_switches,
//    input  [3:0] random_out,
//    output reg [3:0] random_led,
//    output reg game_done,
//    output reg [3:0] count
//);

//    //----------------------------------------
//    // ���� ��ȣ ����
//    //----------------------------------------
//    reg [3:0]  current_led;    // ���� ǥ�� ���� LED �ε���
//    reg [31:0] timer_count;    // 2�� ī��Ʈ (2�� -> 2*ONE_SEC_COUNT)
//    reg [3:0]  prev_correct_count; // ���������� count ������
    
//    // ���� ����
//    localparam S_IDLE       = 0;
//    localparam S_SHOW_LED   = 1;
//    localparam S_WAIT_ANSWER= 2;
//    localparam S_CHECK      = 3;
    
//    reg [1:0] state, next_state;

//    //----------------------------------------
//    // ����ġ �ε��� ���� �Լ�
//    //----------------------------------------
//    function [3:0] index_from_onehot;
//        input [14:0] onehot;
//        case (onehot)
//            15'b000000000000001: index_from_onehot = 4'd0;
//            15'b000000000000010: index_from_onehot = 4'd1;
//            15'b000000000000100: index_from_onehot = 4'd2;
//            15'b000000000001000: index_from_onehot = 4'd3;
//            15'b000000000010000: index_from_onehot = 4'd4;
//            15'b000000000100000: index_from_onehot = 4'd5;
//            15'b000000001000000: index_from_onehot = 4'd6;
//            15'b000000010000000: index_from_onehot = 4'd7;
//            15'b000000100000000: index_from_onehot = 4'd8;
//            15'b000001000000000: index_from_onehot = 4'd9;
//            15'b000010000000000: index_from_onehot = 4'd10;
//            15'b000100000000000: index_from_onehot = 4'd11;
//            15'b001000000000000: index_from_onehot = 4'd12;
//            15'b010000000000000: index_from_onehot = 4'd13;
//            15'b100000000000000: index_from_onehot = 4'd14;
//            default: index_from_onehot = 4'd15; // ���� ����ġ ���� Ȥ�� none
//        endcase
//    endfunction

//    //----------------------------------------
//    // ���� ��������
//    //----------------------------------------
    
////    (* KEEP = "TRUE" *) reg clk_1hz;
////    reg [26:0] counter;
////    always @(posedge clk or posedge reset) begin
////        if (reset) begin
////            
////        end else begin
////            if (counter == 25_000_000) begin // 100 MHz -> 1 Hz
////                counter <= 0;
////                clk_1hz <= ~clk_1hz;
////            end else begin
////                counter <= counter + 1;
////            end

////        end
////    end

//    //----------------------------------------
//    // ���� ���� �� & ��� ��
//    //----------------------------------------
//    always @(*) begin
//        next_state = state;
//        case (state)
//            S_IDLE: begin
//                if (enable_game && !game_done)
//                    next_state = S_SHOW_LED;
//            end

//            S_SHOW_LED: begin
//                // LED ǥ�� ���� �� �ٷ� WAIT_ANSWER�� �̵�
//                next_state = S_WAIT_ANSWER;
//            end

//            S_WAIT_ANSWER: begin
//                // 2�ʰ� ��� �� ���� üũ
//                if (timer_count >= (2 * ONE_SEC_COUNT))
//                    next_state = S_CHECK;
//            end

//            S_CHECK: begin
//                // ���� ���� �� �ٽ� LED ǥ�� �ܰ� (��� �ݺ�)
//                if (game_done)
//                    next_state = S_IDLE; 
//                else
//                    next_state = S_SHOW_LED;
//            end
//        endcase
//    end
//    reg [3:0] sw_index; //!!
//    //----------------------------------------
//    // ����� ����
//    //----------------------------------------
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            random_led      <= 0;
//            current_led     <= 0;
//            timer_count     <= 0;
//            prev_correct_count <= 0;
//            count           <= 0;
//            game_done       <= 0;
//            state <= S_IDLE;
//        end else begin
//            if (!enable_game) begin
//                // ���� ��Ȱ�� �� �ʱ�ȭ
//                game_done <= 0;
//                count <= 0;
//                prev_correct_count <= 0;
//                // state�� S_IDLE ����, random_led�� �ʱ� ����
//            end

//            case (state)
//                S_IDLE: begin
//                    timer_count <= 0;
//                    // ���⼭ ���� ���� ����. enable_game =1 && !game_done �� �� ����
//                end

//                S_SHOW_LED: begin
//                    // ���ο� LED ����
////                    current_led <= random_out;
//                    random_led  <= random_out;
//                    timer_count <= 0;
//                end

//                S_WAIT_ANSWER: begin
//                    // 2�� ���� ���
//                    timer_count <= timer_count + 1;
//                end

//                S_CHECK: begin
//                    // 2�� ��� -> ���� ����
//                    // spdt_switches ���� üũ
//                    // ���� ����: index_from_onehot(spdt_switches) == current_led AND ����ġ �ϳ��� ����
//                    // ���� ����: 
//                    //   - ���� �ƴ� �ε��� 
//                    //   - ���� ����ġ ����(index=15)
//                    //   - �Ǵ� 2�� ���� �ƹ��͵� �ȴ����� �� (switch=15 or 2�ʰ� ���Է�)
//                    //   ���⼭�� 2�� �� ���Է��̶� switch=15�� ���� (�Ѱ��� �ȴ���)
                    
//                    sw_index = index_from_onehot(spdt_switches);

//                    if (sw_index == random_out) begin
//                        // ����
//                        count <= count + 1;
//                        prev_correct_count <= count + 1;
//                        if (count + 1 == 3) begin
//                            game_done <= 1;
//                        end
//                    end else begin
//                        // ���� �Ǵ� �ð��ʰ�(�ƹ� �͵� �� ���� or ������ ����)
//                        count <= 0;
//                        prev_correct_count <= 0;
//                    end

//                    // ���� ���� �غ� (next_state = S_SHOW_LED)
//                    timer_count <= 0;
//                end
//            endcase
//            state <= next_state;
//        end
//    end

//endmodule

//module mini_game (
//    input clk,                // ���� Ŭ��
//    input reset,              // ���� ��ȣ
//    input enable_game,        // ���� ���� ��ȣ
//    input [14:0] spdt_switches, // SPDT ����ġ �Է�
//    input [3:0] random_out,   // ���� ��� �� (0~9)
//    output reg [3:0] random_led, // �������� ���� LED
//    output reg [3:0] count,      // ���� Ƚ�� ī��Ʈ
//    output reg game_done,         // ���� �Ϸ� ��ȣ
//    output reg game_led_off
//);

//    (* KEEP = "TRUE" *) reg [3:0] prev_switches;    // ���� ����ġ ���� ����
//    reg [3:0] switch_index;     // ���� ���� ����ġ�� �ε���
//    reg [31:0] timer;           // �ð� ī����
//    reg [1:0] state;            // ���� �ӽ� (LED ON/OFF ���� ����)
//    localparam LED_ON = 2'b01;
//    localparam LED_OFF = 2'b10;

//    // SPDT ����ġ �ε��� ��ȯ �Լ�
//    function [3:0] index;
//        input [14:0] onehot;
//        case (onehot)
//            15'b000000000000001: index = 4'd0;
//            15'b000000000000010: index = 4'd1;
//            15'b000000000000100: index = 4'd2;
//            15'b000000000001000: index = 4'd3;
//            15'b000000000010000: index = 4'd4;
//            15'b000000000100000: index = 4'd5;
//            15'b000000001000000: index = 4'd6;
//            15'b000000010000000: index = 4'd7;
//            15'b000000100000000: index = 4'd8;
//            15'b000001000000000: index = 4'd9;
////            15'b000010000000000: index = 4'd10;
////            15'b000100000000000: index = 4'd11;
////            15'b001000000000000: index = 4'd12;
////            15'b010000000000000: index = 4'd13;
////            15'b100000000000000: index = 4'd14;
//            default: index = 4'd15; // �߸��� �Է� ó��
//        endcase
//    endfunction

//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            count <= 0;
//            game_done <= 0;
//            random_led <= 0;
//            timer <= 0;
//            state <= LED_ON;
//            prev_switches <= 0;
//            switch_index <= 0;
//            game_led_off <= 1;
//        end else if (enable_game && !game_done) begin
//            timer <= timer + 1;
            

//            case (state)
//                LED_ON: begin
//                    game_led_off <= 0;
//                    if (spdt_switches != 4'b0000) begin
//                        switch_index <= index(spdt_switches);
//                        // ���� ���� :�߸��� ����ġ �Ǵ� ���� ����ġ ON
//                        if (switch_index != random_led & switch_index != 4'd15) begin
//                            count <= 0;
//                            prev_switches <= 4'b0000;
//                            state <= LED_OFF; // ���� �Ǵ� ���� �� ��� ���� ��ȯ
//                            timer <= 0;
//                        end                 
//                        // ���� ����
//                         else begin // && spdt_switches != prev_switches
//                            count <= count + 1;
//                            prev_switches <= spdt_switches;
//                            if (count == 2) begin
//                                game_done <= 1; // 3��° ���� �� ���� ����
//                            end
//                            state <= LED_OFF; // ���� �� ��� LED OFF
//                            timer <= 0;
//                        end                      
//                    end else if (timer >= 25_000_000) begin
//                        // 2�� ��� �� ���� ��ȯ
//                        count <= 0;
//                        prev_switches <= 4'b0000;
//                        state <= LED_OFF;
//                        timer <= 0;
//                    end
//                    random_led <= random_out;
//                end

//                LED_OFF: begin
//                    game_led_off <= 1;
//                    if (timer >= 12_500_000) begin // 1�� OFF �� ���ο� ����
//                        timer <= 0;
//                        state <= LED_ON;
//                        //random_led <= random_out; // ���ο� ���� LED
//                        prev_switches <= 4'b0000; // ���� ����ġ �ʱ�ȭ
//                    end
//                    count<=count;
//                end
//            endcase
//        end else begin
//            // ���� ��Ȱ��ȭ �Ǵ� ���� �� �ʱ�ȭ
//            count <= 0;
//            game_done <= 0;
//            random_led <= random_out;
//            timer <= 0;
//            state <= LED_ON;
//            prev_switches <= 4'd15;
//            switch_index <= 4'd15;
//            game_led_off <= 1;
//        end
//    end
//endmodule


//module mini_game (
//    input clk,                // ���� Ŭ��
//    input reset,              // ���� ��ȣ
//    input enable_game,        // ���� ���� ��ȣ
//    input [14:0] spdt_switches, // SPDT ����ġ �Է�
//    input [3:0] random_out,   // ���� ��� �� (0~9)
//    output reg [3:0] random_led, // �������� ���� LED
//    output reg [3:0] count,      // ���� Ƚ�� ī��Ʈ
//    output reg game_done         // ���� �Ϸ� ��ȣ
//);

//    reg [3:0] prev_switches;    // ���� ����ġ ���� ����
//    reg [3:0] switch_index;     // ���� ���� ����ġ�� �ε���
//    reg [31:0] timer;           // �ð� ī����
//    reg [1:0] state;            // ���� �ӽ� (LED ON/OFF ���� ����)

//    localparam LED_ON = 2'b01;
//    localparam LED_OFF = 2'b10;

//    // SPDT ����ġ �ε��� ��ȯ �Լ�
//    function [3:0] index;
//        input [14:0] onehot;
//        case (onehot)
//            15'b000000000000001: index = 4'd0;
//            15'b000000000000010: index = 4'd1;
//            15'b000000000000100: index = 4'd2;
//            15'b000000000001000: index = 4'd3;
//            15'b000000000010000: index = 4'd4;
//            15'b000000000100000: index = 4'd5;
//            15'b000000001000000: index = 4'd6;
//            15'b000000010000000: index = 4'd7;
//            15'b000000100000000: index = 4'd8;
//            15'b000001000000000: index = 4'd9;
//            default: index = 4'd15; // �߸��� �Է� ó��
//        endcase
//    endfunction

//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            count <= 0;
//            game_done <= 0;
//            random_led <= 0;
//            timer <= 0;
//            state <= LED_ON;
//            prev_switches <= 0;
//            switch_index <= 4'd15;
//        end else if (enable_game && !game_done) begin
//            timer <= timer + 1;

//            // ���� �ӽ�: LED ON (2��) �� OFF (1��)
//            case (state)
//                LED_ON: begin
//                    if (timer == 12500_000) begin // 2�� (100MHz Ŭ�� ����)
//                        timer <= 0;
//                        state <= LED_OFF;
//                    end else begin
//                        switch_index <= index(spdt_switches);

//                        // ���� Ȯ��: SPDT ����ġ�� ���� LED�� ��ġ�� ���
//                        if (switch_index == random_led && spdt_switches != prev_switches && spdt_switches != 4'b0000) begin
//                            count <= count + 1;
//                            prev_switches <= spdt_switches;
//                            if (count == 3) begin
//                                count <= 0;
//                                game_done <= 1; // 3��° ���� �� ���� ����
//                            end
//                        end
//                        // ���� ����: �߸��� ����ġ �Ǵ� ���� ����ġ ON
//                        else if (spdt_switches != 4'b0000 && (spdt_switches != (1 << random_led) || |(spdt_switches & (spdt_switches - 1)))) begin
//                            count <= 0;
//                            prev_switches <= 4'd15;
//                        end
//                    end
//                end

//                LED_OFF: begin
//                    if (timer == 7000_000) begin // 1�� OFF
//                        timer <= 0;
//                        state <= LED_ON;
//                        random_led <= random_out; // ���ο� ���� LED
//                        prev_switches <= 4'b0000; // ���� ����ġ �ʱ�ȭ
//                    end
//                end
//            endcase
//        end else begin
//            // ���� ��Ȱ��ȭ �Ǵ� ���� �� �ʱ�ȭ
//            count <= 0;
//            game_done <= 0;
//            random_led <= random_out;
//            timer <= 0;
//            state <= LED_ON;
//            prev_switches <= 4'd15;
//            switch_index <= 4'd15;
//        end
//    end
//endmodule


//module mini_game #(
//    parameter CLOCK_FREQ = 100_000_000,  // 100MHz Clock
//    parameter ON_TIME_SEC = 2,           // LED ON Time
//    parameter OFF_TIME_SEC = 1,          // LED OFF Time
//    parameter WIN_COUNT = 3              // Winning count
//)(
//    input clk, reset, enable_game,
//    input [14:0] spdt_switches,         // Switch inputs
//    input [3:0] random_out,             // Random LED input
//    output reg [3:0] random_led,        // Random LED output
//    output reg [3:0] count,             // Correct count
//    output reg game_done,               // Game completion
//    output reg game_led_off             // LED off state indicator
//);

//    // Timing calculations
//    localparam ON_CYCLES  = CLOCK_FREQ * ON_TIME_SEC;  // 2��
//    localparam OFF_CYCLES = CLOCK_FREQ * OFF_TIME_SEC; // 1��

//    // State definitions
//    localparam STATE_IDLE   = 2'b00;
//    localparam STATE_LED_ON = 2'b01;
//    localparam STATE_LED_OFF = 2'b10;
//    localparam STATE_DONE   = 2'b11;

//    reg [1:0] state;
//    reg [31:0] timer;
//    reg [14:0] prev_switches;
//    wire [3:0] switch_index;

//    // Function to find switch index
//    function [3:0] get_switch_index(input [14:0] switches);
//        integer i;
//        begin
//            get_switch_index = 4'hF; // Default invalid
//            for (i = 0; i < 10; i = i + 1) begin
//                if (switches[i]) get_switch_index = i[3:0];
//            end
//        end
//    endfunction

//    // Main FSM
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            state <= STATE_IDLE;
//            count <= 0;
//            game_done <= 0;
//            random_led <= 0;
//            timer <= 0;
//            game_led_off <= 1;
//            prev_switches <= 0;
//        end else begin
//            case (state)
//                STATE_IDLE: begin
//                    if (enable_game) begin
//                        state <= STATE_LED_ON;
//                        random_led <= random_out;
//                        game_led_off <= 0;
//                        timer <= 0;
//                    end
//                end

//                STATE_LED_ON: begin
//                    timer <= timer + 1;

//                    // Check for switch input
//                    if (spdt_switches != 0 && spdt_switches != prev_switches) begin
//                        if (get_switch_index(spdt_switches) == random_led && !(spdt_switches & (spdt_switches - 1))) begin
//                            count <= count + 1; // Correct answer
//                            if (count == WIN_COUNT) state <= STATE_DONE;
//                        end else begin
//                            count <= 0; // Wrong answer
//                        end
//                        state <= STATE_LED_OFF; // Move to LED_OFF state
//                        timer <= 0;
//                        game_led_off <= 1;
//                    end

//                    // Timeout
//                    if (timer >= ON_CYCLES) begin
//                        state <= STATE_LED_OFF;
//                        timer <= 0;
//                        count <= 0;
//                        game_led_off <= 1;
//                    end
//                end

//                STATE_LED_OFF: begin
//                    timer <= timer + 1;
//                    if (timer >= OFF_CYCLES) begin
//                        state <= STATE_LED_ON;
//                        random_led <= random_out;
//                        timer <= 0;
//                        game_led_off <= 0;
//                    end
//                end

//                STATE_DONE: begin
//                    game_done <= 1; // Game completion signal
//                end
//            endcase
//            prev_switches <= spdt_switches;
//        end
//    end

//endmodule


module mini_game #(
    parameter CLOCK_FREQ = 12_500_000,  // 25MHz
    parameter ON_TIME_SEC = 2,          // LED ON Time (2��)
    parameter OFF_TIME_SEC = 1,         // LED OFF Time (1��)
    parameter WIN_COUNT = 3
)(
    input clk, reset, enable_game,
    input [14:0] spdt_switches,
    input [3:0] random_out,
    output reg [3:0] random_led,
    output reg [3:0] count,
    output reg game_done,
    output reg game_led_off
);

    localparam ON_CYCLES  = CLOCK_FREQ * ON_TIME_SEC;  
    localparam OFF_CYCLES = CLOCK_FREQ * OFF_TIME_SEC; 

    localparam STATE_IDLE    = 2'b00;
    localparam STATE_LED_ON  = 2'b01;
    localparam STATE_LED_OFF = 2'b10;

    reg [1:0] state;
    reg [31:0] timer;
    reg [14:0] prev_switches;
    reg enable_game_;  

    // answer_status: 0=���� �Է� ����, 1=����, 2=����
    reg [1:0] answer_status; 

    function [3:0] get_switch_index(input [14:0] switches);
        integer i;
        begin
            get_switch_index = 4'hF; 
            for (i = 0; i < 10; i = i + 1) begin
                if (switches[i]) get_switch_index = i[3:0];
            end
        end
    endfunction

    wire [3:0] switch_index = get_switch_index(spdt_switches);
    wire single_switch = !(spdt_switches & (spdt_switches - 1)) && (spdt_switches != 0);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            count <= 0;
            game_done <= 0;
            random_led <= 0;
            timer <= 0;
            enable_game_ <= 0;
            game_led_off <= 1;
            prev_switches <= 0;
            answer_status <= 0;
        end else begin
            if (enable_game && !game_done)
                enable_game_ <= 1;

            case (state)
                STATE_IDLE: begin
                    game_done <= 0;
                    if (enable_game_ && !game_done) begin
                        state <= STATE_LED_ON;
                        random_led <= random_out;
                        game_led_off <= 0;
                        timer <= 0;
                        count <= 0;
                        answer_status <= 0; // �� ���� ���� �� ���� �ʱ�ȭ
                    end
                end

                STATE_LED_ON: begin
                    timer <= timer + 1;

                    // 2�� ���� ������ �Է� üũ, �� ��� �������� �ʰ� ����� ���
                    if (spdt_switches != prev_switches && spdt_switches != 0) begin
                        // ����ġ ��ȭ �߻�
                        if (single_switch && switch_index == random_led && answer_status != 2) begin
                            // ���� (��, �̹� ������ ��ϵǾ��ٸ� ����)
                            answer_status <= 1;
                        end else begin
                            // ����
                            answer_status <= 2;
                        end
                    end

                    // 2�ʰ� ���� �� ����� ���� ó��
                    if (timer >= ON_CYCLES) begin
                        if (answer_status == 1) begin
                            // �����̸� count ����
                            count <= count + 1;
                            if (count + 1 == WIN_COUNT) begin
                                // ���� ����
                                game_done <= 1;
                                enable_game_ <= 0;
                                state <= STATE_IDLE;
                                count <= 0;
                                timer <= 0;
                            end else begin
                                // ���������� ���� WIN_COUNT �̵����̸� LED_OFF��
                                state <= STATE_LED_OFF;
                                timer <= 0;
                                game_led_off <= 1;
                            end
                        end else begin
                            // ���� �Ǵ� �Է� ����
                            count <= 0; 
                            state <= STATE_LED_OFF;
                            timer <= 0;
                            game_led_off <= 1;
                        end
                    end
                end

                STATE_LED_OFF: begin
                    timer <= timer + 1;
                    if (timer >= OFF_CYCLES) begin
                        state <= STATE_LED_ON;
                        random_led <= random_out;
                        timer <= 0;
                        game_led_off <= 0;
                        answer_status <= 0; // �� ���� ���� �� ���� �ʱ�ȭ
                    end
                end
            endcase

            prev_switches <= spdt_switches;
        end
    end

endmodule
