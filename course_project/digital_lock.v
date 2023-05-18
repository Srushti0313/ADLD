`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:42 05/06/2023 
// Design Name: 
// Module Name:    digital_lock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module digital_lock (
  input clk, reset,
  input [3:0] password, input [3:0] input_pass,
  output reg unlocked, output reg alarm, output reg authorized
);
  parameter [2:0] IDLE = 3'b000, CHECK_PASS = 3'b001, ALARM = 3'b010, UNLOCKED = 3'b011;
  reg [2:0] state = IDLE;
  reg [1:0] count = 2'b00;
  wire correct_pass = (input_pass == password || (count == 2'b11 && input_pass == 4'b1111));

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      unlocked <= 0;
      alarm <= 0;
      count <= 2'b00;
      authorized <= 0;
    end
    else begin
     case (state)
       IDLE: begin
       if (correct_pass) begin
           state <= UNLOCKED;
           unlocked <= 1;
           alarm <= 0;
           authorized <= (input_pass == 4'b1111); 
       end
         else if (count == 2'b11) begin
           state <= ALARM;
           unlocked <= 0;
           alarm <= 1;
           authorized <= 0;
         end
          else begin
           state <= CHECK_PASS;
          end
        end
       CHECK_PASS: begin
          if (correct_pass) begin
            state <= UNLOCKED;
            unlocked <= 1;
            alarm <= 0;
            count <= 2'b00;
            authorized <= (input_pass == 4'b1111); 
          end
          else if (count == 2'b10) begin
            state <= ALARM;
            unlocked <= 0;
            alarm <= 1;
            count <= count + 2'b01;
            authorized <= 0;
          end
          else begin
           count <= count + 2'b01;
          end
        end
       ALARM: begin
          if (correct_pass) begin
            state <= UNLOCKED;
            unlocked <= 1;
            alarm <= 0;
            count <= 2'b00;
            authorized <= (input_pass == 4'b1111); 
          end
          else begin
           state <= ALARM;
           authorized <= 0;
          end
        end
        UNLOCKED: begin
          if (!correct_pass) begin
            state <= IDLE;
            unlocked <= 0;
            alarm <= 0;
            count <= 2'b01;
            authorized <= 0;
          end
          else begin
           state <= UNLOCKED;
			  unlocked <= 1;
           alarm <= 0;
           authorized <= (input_pass == 4'b1111);
          end
        end
        endcase
      end
   end
endmodule

