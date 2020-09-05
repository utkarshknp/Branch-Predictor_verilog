`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2019 10:19:05 PM
// Design Name: 
// Module Name: clk_reduced_sec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_reduced_sec( input clkin,output clkout);
reg [30:0] s=0;
reg clkout=1'b0;

always @(posedge clkin)
    begin
        s<=s+1'b1;
        if(s==0)
            clkout=~clkout;
    end


endmodule
