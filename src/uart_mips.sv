//UART_MIPS top file
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: november 15, 2021

module uart_mips(
    input  logic clk,
	 input  logic rst_n,
    output logic UART_tx,
    output logic UART_rx
);

import MIPS_pkg::*;
import UART_pkg::*;
import UART_csr_pkg::*;



//MIPS signals
mips_addr_t mips_addr;
mips_data_t mips_wr_data;
logic mips_wr_en;
mips_data_t mips_rd_data;
//Memoryu signals
logic chip_sel_memory;
logic[MIPS_DATA_WIDTH-2:0] mem_addr;
mips_data_t mem_rd_data;
//Uart signals 
logic chip_sel_uart;
uart_csr_addr_t uart_csr_wr_addr;
uart_csr_addr_t uart_csr_rd_addr;
uart_csr_data_t uart_csr_wr_data;
uart_csr_data_t uart_csr_rd_data;
logic           uart_csr_wen;
logic           uart_csr_ren;


//MIPS signals 
assign mips_rd_data        = (chip_sel_memory) ? mem_rd_data : uart_csr_rd_data;
//Memory signals
assign chip_sel_memory     = ~mips_addr[MIPS_ADDR_WIDTH-1];
assign mem_addr            = mips_addr[MIPS_ADDR_WIDTH-2:0];
//UART signals
assign chip_sel_uart       = mips_addr[MIPS_ADDR_WIDTH-1];
assign uart_csr_wr_addr    = mips_addr[2:0];
assign uart_csr_rd_addr    = mips_addr[2:0];
assign uart_csr_wr_data    = mips_wr_data;
assign uart_csr_wen        = chip_sel_uart && mips_wr_en;
assign uart_csr_ren        = chip_sel_uart && ~mips_wr_en;


//UART
UART uart0(
	.clk(clk),
	.rst_n(rst_n),
    .csr_wr_addr(uart_csr_wr_addr),
    .csr_wr_data(uart_csr_wr_data),
    .csr_wen(uart_csr_wen),
    .csr_rd_addr(uart_csr_rd_addr),
    .csr_ren(uart_csr_ren),
    .csr_rd_data(uart_csr_rd_data),
    .tx(UART_tx),
    .rx(UART_rx)
);



//MIPS
MIPS mips0(
	.clk(clk),
	.rst_n(rst_n),
    .rd_data_mem(mips_rd_data),
    .addr_mem(mips_addr),
    .wr_data_mem(mips_wr_data),
    .wr_en_mem(mips_wr_en)
);


instruction_data_memory #(
    .DATA_WIDTH(MIPS_DATA_WIDTH),
    .ADDR_WIDTH(8),		//Quartus doesn't supports unsigned 32'FFFF_FFFF
    .MEMORY_FORMAT("hex")
)memory(
    .clk(clk),
    .chip_sel(chip_sel_memory),
    .addr(mem_addr),
    .wr_data(mips_wr_data),
    .wr_en(mips_wr_en),
    .rd_data(mem_rd_data)
);


endmodule: uart_mips