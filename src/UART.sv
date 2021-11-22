//Description: UART control status registers
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 4/10/2021



module UART
import UART_pkg::*,
	   UART_csr_pkg::*;
(
    //Clock and resets
    
    input  logic           clk,
    input  logic           rst_n,
    //CSR signals
    input  uart_csr_addr_t csr_wr_addr,
    input  uart_csr_data_t csr_wr_data,
    input  logic           csr_wen,
    input  uart_csr_addr_t csr_rd_addr,
    input  logic           csr_ren,
    output uart_csr_data_t csr_rd_data,
    //UART external interface
    output logic           tx,
    input  logic           rx
);


//CSR interface
	UART_csr_if csr_if();

    //Status flags
    uart_busy_e uart_busy_f;
    logic uart_parity_error_f;
    logic data_sent;
    logic rx_data_valid;
    uart_data_t rx_uart_data;
	
	//CSR
    UART_csr csr(
        .clk(clk),
        .rst_n(rst_n),
        .wr_addr(csr_wr_addr),
        .wr_data(csr_wr_data),
        .wen(csr_wen),
        .rd_addr(csr_rd_addr),
        .rd_data(csr_rd_data),
        .ren(csr_ren),
        .csr(csr_if.csr_mp),
        .parity_error(uart_parity_error_f),
        .busy(uart_busy_f),
        .data_sent(data_sent),
        .data_valid(rx_data_valid),
        .rx_uart_data(rx_uart_data)
    );
	 
	  //UART tx
    UART_tx tx0(
        .clk(clk),
        .rst_n(rst_n),
        .tx(tx),
        .csr(csr_if.uart_mp),
        .busy(uart_busy_f),
        .data_sent(data_sent)
    );


    //AURT rx
    UART_rx rx0(
        .clk(clk),
        .rst_n(rst_n),
        .rx_data(rx_uart_data),
        .rx_data_valid(rx_data_valid),
        .rx(rx),
        .csr(csr_if.uart_mp),
        .parity_error(uart_parity_error_f)
    );
    

endmodule: UART