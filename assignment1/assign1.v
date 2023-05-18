 module assign1 (
  input clk,
  input front_sensor,
  input [3:0] password_input,
  input back_sensor,
  output gate_control
);

  // Internal signal for password verification
  reg [3:0] password = 4'b0000;
  
  // Initial state
  reg [1:0] state = 2'b00;
  
  // FSM states
  parameter IDLE = 2'b00;
  parameter ASK_PASSWORD = 2'b01;
  parameter VERIFY_PASSWORD = 2'b10;
  parameter OPEN_GATE = 2'b11;
  
  always @(posedge clk) begin
    case (state)
      IDLE:
        if (front_sensor) begin
          state <= ASK_PASSWORD;
        end
      
      ASK_PASSWORD:
        begin
          if (password_input != 4'b0000) begin
            password <= password_input;
            state <= VERIFY_PASSWORD;
          end
        end
      
      VERIFY_PASSWORD:
        begin
          if (password == password_input) begin
            state <= OPEN_GATE;
          end else begin
            password <= 4'b0000;
            state <= ASK_PASSWORD;
          end
        end
      
      OPEN_GATE:
        begin
          gate_control = 1'b1;
          
          if (back_sensor) begin
            gate_control = 1'b0;
            password <= 4'b0000;
            state <= IDLE;
          end
        end
    endcase
  end
endmodule
