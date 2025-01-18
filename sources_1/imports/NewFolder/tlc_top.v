// top.v
module top (
    input clk,
    input reset,
    
    input [14:0] sw,
    input btnC,
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    output [6:0] seg,
    output [3:0] anodes,
    output [15:0] led
);
    // Debounced Signals
    wire [14:0] sw_debounced;
    wire btnC_debounced;
    wire btnU_debounced;
    wire btnL_debounced;
    wire btnR_debounced;
    wire btnD_debounced;

    // Instantiate Debouncers for each switch
    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : deb_sw
            debouncer debouncer_inst (
                .clk(clk),
                .reset(reset),
                .noisy(sw[i]),
                .clean(sw_debounced[i])
            );
        end
    endgenerate
    
    wire clk4;
    // Instantiate Debouncers for each button
    button_debouncer deb_btnC (
        .clk(clk4),
        .reset(reset),
        .noisy(btnC),
        .clean(btnC_debounced)
    );

    button_debouncer deb_btnU (
        .clk(clk4),
        .reset(reset),
        .noisy(btnU),
        .clean(btnU_debounced)
    );

    button_debouncer deb_btnL (
        .clk(clk4),
        .reset(reset),
        .noisy(btnL),
        .clean(btnL_debounced)
    );

    button_debouncer deb_btnR (
        .clk(clk4),
        .reset(reset),
        .noisy(btnR),
        .clean(btnR_debounced)
    );

    button_debouncer deb_btnD (
        .clk(clk4),
        .reset(reset),
        .noisy(btnD),
        .clean(btnD_debounced)
    );

    // Rest of your top module signals

    wire [3:0] current_time_0;
    wire [3:0] current_time_1;
    wire [3:0] current_time_2;
    wire [3:0] current_time_3;
    wire [3:0] time_setting_output_0;
    wire [3:0] time_setting_output_1;
    wire [3:0] time_setting_output_2;
    wire [3:0] time_setting_output_3;
    wire [3:0] alarm_setting_output_0;
    wire [3:0] alarm_setting_output_1;
    wire [3:0] alarm_setting_output_2;
    wire [3:0] alarm_setting_output_3;
    wire [3:0] stop_time_0;
    wire [3:0] stop_time_1;
    wire [3:0] stop_time_2;
    wire [3:0] stop_time_3;
    wire [3:0] count;
    wire game_done;
    wire enable_time_set;
    wire enable_alarm_set;
    wire enable_alarm_on;
    wire enable_stopwatch;
    wire enable_game;
    wire [3:0] random_out;
    wire [3:0] blink_state;
    wire [3:0] random_led;
    wire [2:0] blinky;
    wire [2:0] blinky2;
    
    wire [3:0] min_tens;       // 분 10의 자리
    wire [3:0] min_units;      // 분 1의 자리
    wire [3:0] sec_tens;       // 초 10의 자리
    wire [3:0] sec_units;      // 초 1의 자리
    wire [3:0] setting_position;     // 현재 설정 위치
    
    wire [3:0] min_tens2;       // 분 10의 자리
    wire [3:0] min_units2;      // 분 1의 자리
    wire [3:0] sec_tens2;       // 초 10의 자리
    wire [3:0] sec_units2;      // 초 1의 자리
    wire [3:0] setting_position2;     // 현재 설정 위치
    wire game_led_off;
    
    // Instantiate your submodules using debounced signals
    clock clock_inst (
        .clk(clk),
        .reset(reset),
        .enable_time_set(enable_time_set),
        .time_setting_output_0(time_setting_output_0),
        .time_setting_output_1(time_setting_output_1),
        .time_setting_output_2(time_setting_output_2),
        .time_setting_output_3(time_setting_output_3),
        .current_time_0(current_time_0),
        .current_time_1(current_time_1),
        .current_time_2(current_time_2),
        .current_time_3(current_time_3)
    );
    
    // State machine
    fsm FSM(
        .clk(clk),
        .reset(reset),
        .sw(sw_debounced), // Use debounced switches
        .btnC(btnC_debounced), // Use debounced buttons
        .blinky(blinky),
        .blinky2(blinky2),
        .current_time_0(current_time_0),
        .current_time_1(current_time_1),
        .current_time_2(current_time_2),
        .current_time_3(current_time_3),    // Current clock seconds
        .alarm_setting_output_0(alarm_setting_output_0), // 다음 시간 값 (4개의 항목)
        .alarm_setting_output_1(alarm_setting_output_1),
        .alarm_setting_output_2(alarm_setting_output_2),
        .alarm_setting_output_3(alarm_setting_output_3),
        .game_done(game_done),
        .random_led(random_led),
        .enable_time_set(enable_time_set),
        .enable_alarm_set(enable_alarm_set),
        .enable_alarm_on(enable_alarm_on),
        .enable_stopwatch(enable_stopwatch),
        .enable_game(enable_game),
        .led(led),
        .blink_state(blink_state),
        .game_led_off(game_led_off)
    );
    clock_divider (
        .clk(clk),         // Basys 3 기본 클럭 (100 MHz)
        .reset(reset),
        .clk4(clk4) // 1Hz 클럭 출력
    );
    
    // Time Setting Module
    time_setting time_setting_inst (
        .clk4(clk4),
        .reset(reset),
        .inc(btnU_debounced),
        .dec(btnD_debounced),
        .moveLEFT(btnL_debounced),
        .moveRIGHT(btnR_debounced),
        .current_time_0(current_time_0),
        .current_time_1(current_time_1),
        .current_time_2(current_time_2),
        .current_time_3(current_time_3),
        .time_setting_output_0(time_setting_output_0),
        .time_setting_output_1(time_setting_output_1),
        .time_setting_output_2(time_setting_output_2),
        .time_setting_output_3(time_setting_output_3),
        .enable(enable_time_set),
        .min_tens(min_tens),        // 분 10의 자리
        .min_units(min_units),      // 분 1의 자리
        .sec_tens(sec_tens),       // 초 10의 자리
        .sec_units(sec_units),      // 초 1의 자리
        .setting_position(setting_position),     // 현재 설정 위치
        .blinky(blinky)
    );
    
    
    
    // Alarm Module
    alarm alarm_inst (
        //.alarm_minutes(alarm_minutes),
        //.alarm_seconds(alarm_seconds), // when sw[1] is off -> save alarm m.s ?닔?젙 ?븘?슂
        .alarm_setting_output_0(alarm_setting_output_0),
        .alarm_setting_output_1(alarm_setting_output_1),
        .alarm_setting_output_2(alarm_setting_output_2),
        .alarm_setting_output_3(alarm_setting_output_3),
        .clk4(clk4),
        .reset(reset),
        .blinky(blinky2),
        .inc(btnU_debounced),
        .dec(btnD_debounced),       
        .moveLEFT(btnL_debounced),           
        .moveRIGHT(btnR_debounced),           
        .enable(enable_alarm_set),
        .min_tens2(min_tens2),        // 분 10의 자리
        .min_units2(min_units2),      // 분 1의 자리
        .sec_tens2(sec_tens2),       // 초 10의 자리
        .sec_units2(sec_units2),      // 초 1의 자리
        .setting_position2(setting_position2)     // 현재 설정 위치
    );

    // Mini-Game Module
    mini_game mini_game_module (
        .clk(clk4),
        .reset(reset),
        .spdt_switches(sw_debounced), // Use debounced switches
        .random_out(random_out),
        .enable_game(enable_game),
        .random_led(random_led),
        .game_done(game_done),
        .count(count),
        .game_led_off(game_led_off)
    );

    // Stopwatch Module
    stopwatch stopwatch_inst (
        .clk4(clk4),
        .reset(reset),
        .start_pause(btnC_debounced), // Use debounced button
        .stop_time_0(stop_time_0),
        .stop_time_1(stop_time_1),
        .stop_time_2(stop_time_2),
        .stop_time_3(stop_time_3),
        .enable(enable_stopwatch)
    );

    // Display Controller
    display_controller display_ctrl (
        .clk(clk),
        .reset(reset),
        //.alarm_active(alarm_active),
        .blink_state(blink_state),
        .current_time_0(current_time_0),
        .current_time_1(current_time_1),
        .current_time_2(current_time_2),
        .current_time_3(current_time_3),
        .time_setting_output_0(time_setting_output_0),
        .time_setting_output_1(time_setting_output_1),
        .time_setting_output_2(time_setting_output_2),
        .time_setting_output_3(time_setting_output_3),
        .alarm_setting_output_0(alarm_setting_output_0),
        .alarm_setting_output_1(alarm_setting_output_1),
        .alarm_setting_output_2(alarm_setting_output_2),
        .alarm_setting_output_3(alarm_setting_output_3),
        .stop_time_0(stop_time_0),
        .stop_time_1(stop_time_1),
        .stop_time_2(stop_time_2),
        .stop_time_3(stop_time_3),
        .count(count),
        .enable_time_set(enable_time_set),
        .enable_alarm_set(enable_alarm_set),
        .enable_stopwatch(enable_stopwatch),
        .enable_game(enable_game),
        .seg(seg),
        .anodes(anodes)
    );
    
    // Generator
    random_generator random_gen(
        .clk(clk),
        .reset(reset),            
        .random_out(random_out) 
    );
    
endmodule
