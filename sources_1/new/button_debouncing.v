module button_debouncer #(
    parameter IN = 1,
    parameter OUT = 0,
    parameter LIMIT = 1_000_000 // 100MHz
) (
    input  clk,
    input  reset,
    input  noise,      // �񵿱� ��ư �Է�
    output clean       // 1clk �߻�
);

    // Synchronizer
    reg noisy_meta, noisy_sync;

    //reg for debouncing
    reg [32:0] debounce_count = 0;
    reg switch_pulse = 0;
    reg prev_state = OUT;

    assign clean = switch_pulse;

    // �Է� ��ȣ ����ȭ
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            noisy_meta <= OUT;
            noisy_sync <= OUT;
        end else begin
            noisy_meta <= noise;
            noisy_sync <= noisy_meta;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // ���� �ʱ�ȭ
            debounce_count <= 0;
            prev_state <= OUT;
            switch_pulse <= 0;
        end else begin
            // switch_pulse �ʱ�ȭ
            switch_pulse <= 0;

            // OUT -> noisy_sync IN => in debounce
            if ((noisy_sync == IN) && (prev_state == OUT)) begin
                if (debounce_count < LIMIT) begin
                    debounce_count <= debounce_count + 1;
                end else begin
                    // in debounce
                    debounce_count <= 0;
                    prev_state <= IN;
                    switch_pulse <= 1; 
                end

            // IN -> noisy_sync OUT => out debounce 
            end else if ((noisy_sync == OUT) && (prev_state == IN)) begin
                if (debounce_count < LIMIT) begin
                    debounce_count <= debounce_count + 1;
                end else begin
                    // out debounce
                    debounce_count <= 0;
                    prev_state <= OUT;
                end

            end else begin
                // ��ȭX -> ī���� �ʱ�ȭ
                debounce_count <= 0;
            end
        end
    end

endmodule  