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

    // DUT �ν��Ͻ�: �ùķ��̼� ���Ǹ� ���� ONE_SEC_COUNT�� �۰� ����
    mini_game #(
        .ONE_SEC_COUNT(1000) // 1�ʸ� 1000ī��Ʈ�� ����
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

    // Ŭ�� ���� (100MHz ����: 10ns �ֱ�)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        // �ʱ�ȭ
        reset = 1;
        enable_game = 0;
        spdt_switches = 15'b0;
        random_out = 4'd0;
        #100;
        reset = 0;
        #100;

        enable_game = 1;

        // 1) LED=3 (random_out=3), ����(3) �Է� -> count=1
        random_out = 4'd3;
        #2000; // 2�� ���
        // ����: LED=3 -> onehot: 15'b000000000001000
        spdt_switches = 15'b000000000001000;
        #100;
        spdt_switches = 0;
        #2000; // ���� 2�� �� ���� ���� -> count=1 ���

        // 2) LED=8 (random_out=8), ����(0) �Է� -> count ����
        random_out = 4'd8;
        #2000; 
        // ����: LED=8�ε� 0�� ����ġ ����
        spdt_switches = 15'b000000000000001; 
        #100;
        spdt_switches = 0;
        #2000; // ���� ���� -> count=0 ���

        // 3) LED=2 (random_out=2), �ƹ��� �� �����ų� ���� ����ġ ���� ����
        random_out = 4'd2;
        #2000;
        // �ƹ��͵� ������ �������� ���� ó��
        // spdt_switches = 0 ����
        #2000; // ���� -> count=0 ����

        // 4) LED=1 (random_out=1), ����(1) �Է� -> count=1
        random_out = 4'd1;
        #2000;
        // ����: LED=1 -> onehot: 15'b000000000000010
        spdt_switches = 15'b000000000000010;
        #100;
        spdt_switches = 0;
        #2000; // count=1

        // 5) LED=2 (random_out=2), ����(2) �Է� -> count=2
        random_out = 4'd2;
        #2000;
        // ����: LED=2 -> 15'b000000000000100
        spdt_switches = 15'b000000000000100;
        #100;
        spdt_switches = 0;
        #2000; // count=2

        // 6) LED=3 (random_out=3), ����(3) �Է� -> count=3 game_done=1
        random_out = 4'd3;
        #2000;
        spdt_switches = 15'b000000000001000;
        #100;
        spdt_switches = 0;
        #2000; // count=3, game_done=1 ���

        #2000;
        $stop;
    end

    initial begin
        $monitor("Time=%0t ns: random_led=%d, count=%d, game_done=%b",
                 $time, random_led, count, game_done);
    end

endmodule
