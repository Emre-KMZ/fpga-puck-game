`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2023 05:35:09 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,
    input rst,
    
    input BTNA, //BTN L
    input BTNB, //BTN R
    
    input [1:0] DIRA, // sw12-11
    input [1:0] DIRB, //sw4-3
    
    input [2:0] YA, // sw15-13
    input [2:0] YB, // sw2-0
   
    output LEDA, 
    output LEDB,
    output [4:0] LEDX,
    
    output a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,
    output [7:0]an
);
    
    
    wire [6:0] _SSD7,_SSD6,_SSD5,_SSD4,_SSD3,_SSD2,_SSD1,_SSD0;
    wire clkD;
    wire DB_BTNA, DB_BTNB ;
    wire X,Y;


    clk_divider clock(clk, rst, clkD);
    
    debouncer db1(clkD,rst,BTNA, DB_BTNA);
    debouncer db2(clkD,rst,BTNB, DB_BTNB);
    
    hockey hockey_(  clkD,
                     rst, DB_BTNA, 
                     DB_BTNB, 
                     DIRA, DIRB, 
                     YA, YB,
                     LEDA, LEDB,
                     LEDX, _SSD7,
                     _SSD6, _SSD5, _SSD4, _SSD3, _SSD2, _SSD1, _SSD0,
                     X, Y

                    );

    ssd ssd_(   clk, rst, _SSD7, _SSD6, _SSD5, _SSD4, _SSD3, _SSD2, _SSD1, _SSD0, 
                a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,an
            );
    
    
        

    
   
	
endmodule