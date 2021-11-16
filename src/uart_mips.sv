//UART_MIPS top file
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: november 15, 2021

module uart_mips(
    input  logic clk,
	 input  logic rst_n
);

UART uart0(
	.clk(clk),
	.rst_n(rst_n)
);

MIPS mips0(
	.clk(clk),
	.rst_n(rst_n)
);

//Memories
ROM instr_mem(
	.clk(clk)
);

endmodule: uart_mips