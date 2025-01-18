`timescale 1ns/1ps

module mini_game_tb;
    reg clk;
    reg reset;
    reg enable_game;
    reg [14:0] spdt_switches;
    reg [3:0] random_out;

    wire [3:0] random_led;
    wire game_done;
    wire [3:0] count;

    // DUT 인스턴스: 시뮬레이션 편의를 위해 ONE_SEC_COUNT를 작게 설정
    mini_game #(
        .ONE_SEC_COUNT(1000) // 1초를 1000카운트로 가정
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable_game(enable_game),
        .spdt_switches(spdt_switches),
        .random_out(random_out),
        .random_led(random_led),
        .game_done(game_done),
        .count(count)
    );

    // 클록 생성 (100MHz 가정: 10ns 주기)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        // 초기화
        reset = 1;
        enable_game = 0;
        spdt_switches = 15'b0;
        random_out = 4'd0;
        #100;
        reset = 0;
        #100;

        enable_game = 1;

        // 1) LED=3 (random_out=3), 정답(3) 입력 -> count=1
        random_out = 4'd3;
        #2000; // 2초 대기
        // 정답: LED=3 -> onehot: 15'b000000000001000
        spdt_switches = 15'b000000000001000;
        #100;
        spdt_switches = 0;
        #2000; // 다음 2초 후 정답 판정 -> count=1 기대

        // 2) LED=8 (random_out=8), 오답(0) 입력 -> count 리셋
        random_out = 4'd8;
        #2000; 
        // 오답: LED=8인데 0번 스위치 누름
        spdt_switches = 15'b000000000000001; 
        #100;
        spdt_switches = 0;
        #2000; // 오답 판정 -> count=0 기대

        // 3) LED=2 (random_out=2), 아무도 안 누르거나 여러 스위치 눌러 오답
        random_out = 4'd2;
        #2000;
        // 아무것도 누르지 않음으로 오답 처리
        // spdt_switches = 0 유지
        #2000; // 오답 -> count=0 유지

        // 4) LED=1 (random_out=1), 정답(1) 입력 -> count=1
        random_out = 4'd1;
        #2000;
        // 정답: LED=1 -> onehot: 15'b000000000000010
        spdt_switches = 15'b000000000000010;
        #100;
        spdt_switches = 0;
        #2000; // count=1

        // 5) LED=2 (random_out=2), 정답(2) 입력 -> count=2
        random_out = 4'd2;
        #2000;
        // 정답: LED=2 -> 15'b000000000000100
        spdt_switches = 15'b000000000000100;
        #100;
        spdt_switches = 0;
        #2000; // count=2

        // 6) LED=3 (random_out=3), 정답(3) 입력 -> count=3 game_done=1
        random_out = 4'd3;
        #2000;
        spdt_switches = 15'b000000000001000;
        #100;
        spdt_switches = 0;
        #2000; // count=3, game_done=1 기대

        #2000;
        $stop;
    end

    initial begin
        $monitor("Time=%0t ns: random_led=%d, count=%d, game_done=%b",
                 $time, random_led, count, game_done);
    end

endmodule
