`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:38:11 05/06/2023
// Design Name:   digital_lock
// Module Name:   /home/srushti/Desktop/srushti/khushi/digital_lock_tb.v
// Project Name:  khushi
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: digital_lock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module digital_lock_tb();
  reg clk = 0;
  reg reset = 1;
  reg [3:0] password = 4'b0100;
  reg [3:0] input_pass;
  wire unlocked;
  wire alarm;
  wire authorized;
  
  digital_lock dut (
    .clk(clk),
    .reset(reset),
    .password(password),
    .input_pass(input_pass),
    .unlocked(unlocked),
    .alarm(alarm),
    .authorized(authorized)
  );
  always #5 clk = ~clk;
  initial begin
  #5 reset = 0;
   
 // Test 1: Correct password entered after one incorrect attempt
  #10 input_pass = 4'b1010;
  #10 input_pass = 4'b0100;
 // Test 2: Incorrect password entered three times
  #10 input_pass = 4'b1010;
  #10 input_pass = 4'b0110;
  #10 input_pass = 4'b0111;
// Test 3: Incorrect authorised password entered
  #10 input_pass = 4'b1100;
  #10 input_pass = 4'b0000;
// Test 4: Correct authorised password entered 
  #10 input_pass = 4'b1111;
// Test 5: Correct password  after incorrect password entered  
  #10 input_pass = 4'b1010;
  #10 input_pass = 4'b0110;	 
  #10 input_pass = 4'b0100;
   
  #100 $finish;
  end
endmodule
