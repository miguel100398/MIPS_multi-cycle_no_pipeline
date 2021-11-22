`timescale 1ns/1ns
//UART mips tb
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 21 2021

module uart_mips_tb;

    logic clk;
    logic rst_n;
    logic UART_tx;
    logic UART_rx;

    uart_mips dut(
        .clk(clk),
        .rst_n(rst_n),
        .UART_tx(UART_tx),
        .UART_rx(UART_rx)
    );


    //CLock
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    //Test
    initial begin
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
        #4200;
        $stop;
    end

endmodule: uart_mips_tb