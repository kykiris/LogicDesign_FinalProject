module clock (
    input clk,
    input reset,
    input enable_time_set,
    input [3:0] time_setting_output_0, // 다음 시간 값 (4개의 항목)
    input [3:0] time_setting_output_1,
    input [3:0] time_setting_output_2,
    input [3:0] time_setting_output_3,
    output reg [3:0] current_time_0,
    output reg [3:0] current_time_1,
    output reg [3:0] current_time_2,
    output reg [3:0] current_time_3
);
    
    (* KEEP = "TRUE" *) reg clk_1hz_1;
    reg [26:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_1hz_1 <= 0;
        end else begin
            if (counter == 50_000_000) begin // 100 MHz -> 1 Hz
                counter <= 0;
                clk_1hz_1 <= ~clk_1hz_1;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @(posedge clk_1hz_1 or posedge reset) begin
        if (reset) begin
            current_time_0 <= 0;
            current_time_1 <= 0;
            current_time_2 <= 0;
            current_time_3 <= 0;
        end else if(!enable_time_set) begin
            if(current_time_3 == 4'd9) begin //seconds , if required, reverse the number of "current_time_(number)"
                current_time_3 <= 0;
                if(current_time_2 == 4'd5) begin
                    current_time_2 <= 0;
                    if(current_time_1 == 4'd9) begin // minutes
                        current_time_1 <= 0;
                        if(current_time_0 == 4'd5) begin
                            current_time_0 <= 0;
                        end
                        else current_time_0  <= current_time_0 + 1;
                    end
                    else current_time_1 <= current_time_1 + 1;
                end
                else current_time_2  <= current_time_2 + 1;
            end
            else current_time_3 <= current_time_3 + 1;
        end else begin
            current_time_0 <= time_setting_output_0;
            current_time_1 <= time_setting_output_1;
            current_time_2 <= time_setting_output_2;
            current_time_3 <= time_setting_output_3;
        end
    end
endmodule
