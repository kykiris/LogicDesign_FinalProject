//module random_generator (
//    input clk,            // Ŭ�� ��ȣ
//    input reset,          // ���� ��ȣ
//    output reg [7:0] random_out // ���� �� ���
//);
//    reg [7:0] lfsr;
//
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            lfsr <= 8'b1; // �ʱ� �� (0�� ����ϸ� LFSR�� ���߹Ƿ� ���ؾ� ��)
//        end else begin
//            // LFSR �ǵ�� �� (XOR�� ����)
//            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
//        end
//    end
//
//    // ���� �� ���
//    assign random_out = lfsr;
//endmodule


module random_generator (
    input clk,              // Clock signal
    input reset,            // Reset signal
    //
    output reg [3:0] random_out  // 4-bit output for 10 LEDs (0-9)
);
    // Using 8-bit LFSR for better randomness
    reg [7:0] lfsr;
    reg [3:0] last_value;   // Store last output to avoid repetition

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 8'hAB;          // Non-zero initial value
            random_out <= 4'b0;
            last_value <= 4'b0;
        end else  begin
            // LFSR feedback logic
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
            
            // Generate number between 0-9
            if (lfsr[3:0] < 4'd10) begin
                // If number is already in range 0-9
                if (lfsr[3:0] == last_value) begin
                    // Avoid repetition by using different bits
                    random_out <= (lfsr[7:4] < 4'd10) ? lfsr[7:4] : lfsr[7:4] % 4'd10;
                end else begin
                    random_out <= lfsr[3:0];
                end
            end else begin
                // If number is 10-15, take modulo 10
                random_out <= lfsr[3:0] % 4'd10;
            end
            
            last_value <= random_out;
        end
    end

endmodule