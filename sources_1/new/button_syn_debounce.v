module button_synchronizer_debounced (
    input clk,           // FPGA Ŭ�� ��ȣ
    input reset,         // ���� ��ȣ
    input async_signal,  // ��ư �Է� (�񵿱� ��ȣ)
    output reg sync_signal // ����ȭ�� ��� ��ȣ
);
    reg [15:0] counter;   // ��ư ���� ���� �ð�
    reg debounced_signal; // Debounce ó���� ��ȣ
    reg sync_ff1, sync_ff2;

    // Debounce ó��
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 16'b0;
            debounced_signal <= 1'b0;
        end else begin
            if (async_signal == debounced_signal) begin
                counter <= 16'b0;  // ���°� �����Ǹ� ī���� ����
            end else begin
                counter <= counter + 1;  // ���°� ���ϸ� ī���� ����
                if (counter == 16'hFFFF) begin
                    debounced_signal <= async_signal; // ���ο� ���� ����
                end
            end
        end
    end

    // Synchronizer
    always @(posedge clk) begin
        sync_ff1 <= debounced_signal;
        sync_ff2 <= sync_ff1;
    end

    // ����ȭ�� ��� ��ȣ
    assign sync_signal = sync_ff2;
endmodule
