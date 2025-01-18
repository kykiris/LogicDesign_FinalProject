//`timescale 1ns / 1ps

//module mini_game #(
//    parameter PUSHED = 1,
//    parameter RELEASED = 0,
//    parameter ONE_SEC_COUNT = 25_000_000 // 1초를 25,000,000 사이클로 가정(100MHz)
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
//    // 내부 신호 정의
//    //----------------------------------------
//    reg [3:0]  current_led;    // 현재 표시 중인 LED 인덱스
//    reg [31:0] timer_count;    // 2초 카운트 (2초 -> 2*ONE_SEC_COUNT)
//    reg [3:0]  prev_correct_count; // 내부적으로 count 관리용
    
//    // 상태 정의
//    localparam S_IDLE       = 0;
//    localparam S_SHOW_LED   = 1;
//    localparam S_WAIT_ANSWER= 2;
//    localparam S_CHECK      = 3;
    
//    reg [1:0] state, next_state;

//    //----------------------------------------
//    // 스위치 인덱스 추출 함수
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
//            default: index_from_onehot = 4'd15; // 여러 스위치 눌림 혹은 none
//        endcase
//    endfunction

//    //----------------------------------------
//    // 상태 레지스터
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
//    // 상태 전이 논리 & 출력 논리
//    //----------------------------------------
//    always @(*) begin
//        next_state = state;
//        case (state)
//            S_IDLE: begin
//                if (enable_game && !game_done)
//                    next_state = S_SHOW_LED;
//            end

//            S_SHOW_LED: begin
//                // LED 표시 시작 후 바로 WAIT_ANSWER로 이동
//                next_state = S_WAIT_ANSWER;
//            end

//            S_WAIT_ANSWER: begin
//                // 2초간 대기 후 정답 체크
//                if (timer_count >= (2 * ONE_SEC_COUNT))
//                    next_state = S_CHECK;
//            end

//            S_CHECK: begin
//                // 정답 판정 후 다시 LED 표시 단계 (계속 반복)
//                if (game_done)
//                    next_state = S_IDLE; 
//                else
//                    next_state = S_SHOW_LED;
//            end
//        endcase
//    end
//    reg [3:0] sw_index; //!!
//    //----------------------------------------
//    // 동기식 로직
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
//                // 게임 비활성 시 초기화
//                game_done <= 0;
//                count <= 0;
//                prev_correct_count <= 0;
//                // state는 S_IDLE 유지, random_led도 초기 상태
//            end

//            case (state)
//                S_IDLE: begin
//                    timer_count <= 0;
//                    // 여기서 별도 동작 없음. enable_game =1 && !game_done 될 때 진입
//                end

//                S_SHOW_LED: begin
//                    // 새로운 LED 선택
////                    current_led <= random_out;
//                    random_led  <= random_out;
//                    timer_count <= 0;
//                end

//                S_WAIT_ANSWER: begin
//                    // 2초 동안 대기
//                    timer_count <= timer_count + 1;
//                end

//                S_CHECK: begin
//                    // 2초 경과 -> 정답 판정
//                    // spdt_switches 상태 체크
//                    // 정답 조건: index_from_onehot(spdt_switches) == current_led AND 스위치 하나만 눌림
//                    // 오답 조건: 
//                    //   - 정답 아닌 인덱스 
//                    //   - 여러 스위치 눌림(index=15)
//                    //   - 또는 2초 내에 아무것도 안눌렀을 때 (switch=15 or 2초간 미입력)
//                    //   여기서는 2초 내 미입력이라도 switch=15로 나옴 (한개도 안눌림)
                    
//                    sw_index = index_from_onehot(spdt_switches);

//                    if (sw_index == random_out) begin
//                        // 정답
//                        count <= count + 1;
//                        prev_correct_count <= count + 1;
//                        if (count + 1 == 3) begin
//                            game_done <= 1;
//                        end
//                    end else begin
//                        // 오답 또는 시간초과(아무 것도 안 누름 or 여러개 누름)
//                        count <= 0;
//                        prev_correct_count <= 0;
//                    end

//                    // 다음 라운드 준비 (next_state = S_SHOW_LED)
//                    timer_count <= 0;
//                end
//            endcase
//            state <= next_state;
//        end
//    end

//endmodule

//module mini_game (
//    input clk,                // 메인 클럭
//    input reset,              // 리셋 신호
//    input enable_game,        // 게임 시작 신호
//    input [14:0] spdt_switches, // SPDT 스위치 입력
//    input [3:0] random_out,   // 랜덤 출력 값 (0~9)
//    output reg [3:0] random_led, // 랜덤으로 켜진 LED
//    output reg [3:0] count,      // 정답 횟수 카운트
//    output reg game_done,         // 게임 완료 신호
//    output reg game_led_off
//);

//    (* KEEP = "TRUE" *) reg [3:0] prev_switches;    // 이전 스위치 상태 저장
//    reg [3:0] switch_index;     // 현재 누른 스위치의 인덱스
//    reg [31:0] timer;           // 시간 카운터
//    reg [1:0] state;            // 상태 머신 (LED ON/OFF 상태 관리)
//    localparam LED_ON = 2'b01;
//    localparam LED_OFF = 2'b10;

//    // SPDT 스위치 인덱스 변환 함수
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
//            default: index = 4'd15; // 잘못된 입력 처리
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
//                        // 오답 조건 :잘못된 스위치 또는 여러 스위치 ON
//                        if (switch_index != random_led & switch_index != 4'd15) begin
//                            count <= 0;
//                            prev_switches <= 4'b0000;
//                            state <= LED_OFF; // 정답 또는 오답 시 즉시 상태 전환
//                            timer <= 0;
//                        end                 
//                        // 정답 조건
//                         else begin // && spdt_switches != prev_switches
//                            count <= count + 1;
//                            prev_switches <= spdt_switches;
//                            if (count == 2) begin
//                                game_done <= 1; // 3번째 정답 시 게임 종료
//                            end
//                            state <= LED_OFF; // 정답 후 즉시 LED OFF
//                            timer <= 0;
//                        end                      
//                    end else if (timer >= 25_000_000) begin
//                        // 2초 경과 시 상태 전환
//                        count <= 0;
//                        prev_switches <= 4'b0000;
//                        state <= LED_OFF;
//                        timer <= 0;
//                    end
//                    random_led <= random_out;
//                end

//                LED_OFF: begin
//                    game_led_off <= 1;
//                    if (timer >= 12_500_000) begin // 1초 OFF 후 새로운 라운드
//                        timer <= 0;
//                        state <= LED_ON;
//                        //random_led <= random_out; // 새로운 랜덤 LED
//                        prev_switches <= 4'b0000; // 이전 스위치 초기화
//                    end
//                    count<=count;
//                end
//            endcase
//        end else begin
//            // 게임 비활성화 또는 종료 시 초기화
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
//    input clk,                // 메인 클럭
//    input reset,              // 리셋 신호
//    input enable_game,        // 게임 시작 신호
//    input [14:0] spdt_switches, // SPDT 스위치 입력
//    input [3:0] random_out,   // 랜덤 출력 값 (0~9)
//    output reg [3:0] random_led, // 랜덤으로 켜진 LED
//    output reg [3:0] count,      // 정답 횟수 카운트
//    output reg game_done         // 게임 완료 신호
//);

//    reg [3:0] prev_switches;    // 이전 스위치 상태 저장
//    reg [3:0] switch_index;     // 현재 누른 스위치의 인덱스
//    reg [31:0] timer;           // 시간 카운터
//    reg [1:0] state;            // 상태 머신 (LED ON/OFF 상태 관리)

//    localparam LED_ON = 2'b01;
//    localparam LED_OFF = 2'b10;

//    // SPDT 스위치 인덱스 변환 함수
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
//            default: index = 4'd15; // 잘못된 입력 처리
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

//            // 상태 머신: LED ON (2초) → OFF (1초)
//            case (state)
//                LED_ON: begin
//                    if (timer == 12500_000) begin // 2초 (100MHz 클럭 기준)
//                        timer <= 0;
//                        state <= LED_OFF;
//                    end else begin
//                        switch_index <= index(spdt_switches);

//                        // 정답 확인: SPDT 스위치가 랜덤 LED와 일치할 경우
//                        if (switch_index == random_led && spdt_switches != prev_switches && spdt_switches != 4'b0000) begin
//                            count <= count + 1;
//                            prev_switches <= spdt_switches;
//                            if (count == 3) begin
//                                count <= 0;
//                                game_done <= 1; // 3번째 정답 시 게임 종료
//                            end
//                        end
//                        // 오답 조건: 잘못된 스위치 또는 여러 스위치 ON
//                        else if (spdt_switches != 4'b0000 && (spdt_switches != (1 << random_led) || |(spdt_switches & (spdt_switches - 1)))) begin
//                            count <= 0;
//                            prev_switches <= 4'd15;
//                        end
//                    end
//                end

//                LED_OFF: begin
//                    if (timer == 7000_000) begin // 1초 OFF
//                        timer <= 0;
//                        state <= LED_ON;
//                        random_led <= random_out; // 새로운 랜덤 LED
//                        prev_switches <= 4'b0000; // 이전 스위치 초기화
//                    end
//                end
//            endcase
//        end else begin
//            // 게임 비활성화 또는 종료 시 초기화
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
//    localparam ON_CYCLES  = CLOCK_FREQ * ON_TIME_SEC;  // 2초
//    localparam OFF_CYCLES = CLOCK_FREQ * OFF_TIME_SEC; // 1초

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
    parameter ON_TIME_SEC = 2,          // LED ON Time (2초)
    parameter OFF_TIME_SEC = 1,         // LED OFF Time (1초)
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

    // answer_status: 0=아직 입력 없음, 1=정답, 2=오답
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
                        answer_status <= 0; // 새 라운드 시작 시 상태 초기화
                    end
                end

                STATE_LED_ON: begin
                    timer <= timer + 1;

                    // 2초 동안 들어오는 입력 체크, 단 즉시 반응하지 않고 결과만 기록
                    if (spdt_switches != prev_switches && spdt_switches != 0) begin
                        // 스위치 변화 발생
                        if (single_switch && switch_index == random_led && answer_status != 2) begin
                            // 정답 (단, 이미 오답이 기록되었다면 무시)
                            answer_status <= 1;
                        end else begin
                            // 오답
                            answer_status <= 2;
                        end
                    end

                    // 2초가 지난 후 결과에 따라 처리
                    if (timer >= ON_CYCLES) begin
                        if (answer_status == 1) begin
                            // 정답이면 count 증가
                            count <= count + 1;
                            if (count + 1 == WIN_COUNT) begin
                                // 게임 종료
                                game_done <= 1;
                                enable_game_ <= 0;
                                state <= STATE_IDLE;
                                count <= 0;
                                timer <= 0;
                            end else begin
                                // 정답이지만 아직 WIN_COUNT 미도달이면 LED_OFF로
                                state <= STATE_LED_OFF;
                                timer <= 0;
                                game_led_off <= 1;
                            end
                        end else begin
                            // 오답 또는 입력 없음
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
                        answer_status <= 0; // 새 라운드 시작 시 상태 초기화
                    end
                end
            endcase

            prev_switches <= spdt_switches;
        end
    end

endmodule
