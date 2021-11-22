//Description: UART control status registers
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//Date: 4/10/2021



module UART_csr
import UART_csr_pkg::*,
	    UART_pkg::*;
(
    //CSR interface to exterior
    input  logic           clk,
    input  logic           rst_n,
    input  uart_csr_addr_t wr_addr,
    input  uart_csr_data_t wr_data,
    input  logic           wen,
    input  uart_csr_addr_t rd_addr,
    output uart_csr_data_t rd_data,
    input  logic           ren,
    //CSR interface to UART sub modules
    UART_csr_if.csr_mp    csr,
    //Status flags
    input uart_data_t     rx_uart_data,       //Data received by UART
    input logic           parity_error,
    input uart_busy_e     busy,
    input logic           data_sent,            //Data sent by UART, clean send_Data bit in control register
    input logic           data_valid            //Data received by UART, set flag in status register
);

//Registers
uart_baud_rate_csr_t uart_baud_rate_csr;
uart_control_0_csr_t uart_control_0_csr;
uart_status_0_csr_t  uart_status_0_csr;
uart_send_data_csr_t uart_send_data_csr;
uart_read_data_csr_t uart_read_data_csr;
//Write enables
logic write_uart_baud_rate_csr;
logic write_uart_control_0_csr;
logic write_uart_send_data_csr;
//Read registers
logic read_uart_status_0_csr;
logic read_uart_read_data_csr;
//Error in data bits
logic data_bit_error;
//FIFO uart data send
uart_csr_data_t rd_data_fifo_uart_data_send;
logic full_fifo_uart_data_send;
logic empty_fifo_uart_data_send;
//FIFO UART data receive
uart_csr_data_t rd_data_fifo_uart_data_receive;
logic full_fifo_uart_data_receive;
logic empty_fifo_uart_data_receive;

//Assign registers to interfaces
assign csr.uart_baud_rate_csr = uart_baud_rate_csr;
assign csr.uart_control_0_csr = uart_control_0_csr;
assign csr.uart_status_0_csr  = uart_status_0_csr;
assign csr.uart_send_data_csr = uart_send_data_csr;
assign csr.uart_read_data_csr = uart_read_data_csr;

//Write enables
assign write_uart_baud_rate_csr = wen && (wr_addr == UART_BAUD_RATE_CSR_ADDR);
assign write_uart_control_0_csr = wen && (wr_addr == UART_CONTROL_0_CSR_ADDR);
assign write_uart_send_data_csr = wen && (wr_addr == UART_SEND_DATA_CSR_ADDR);
//Read clean
assign read_uart_status_0_csr  = ren && (rd_addr == UART_STATUS_0_CSR_ADDR);
assign read_uart_read_data_csr = ren && (rd_addr == UART_READ_DATA_CSR_ADDR);

//Registers
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        uart_baud_rate_csr <= UART_BAUD_RATE_CSR_RST;
    end else if (write_uart_baud_rate_csr) begin
        uart_baud_rate_csr <= wr_data;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        uart_control_0_csr <= UART_CONTROL_0_CSR_RST;
    end else if (write_uart_control_0_csr) begin
        uart_control_0_csr <= wr_data;
    end 
end

//UART send data fifo
FIFO #(
    .DEPTH(UART_SEND_DATA_FIFO_WIDTH),
    .DATA_WIDTH(UART_CSR_DATA_WIDTH)
) fifo_uart_send_data (
    .clk(clk),
    .rst_n(rst_n),
    .wr(write_uart_send_data_csr),
    .rd(data_sent),
    .wr_data(wr_data),
    .rd_data(rd_data_fifo_uart_data_send),
    .full(full_fifo_uart_data_send),
    .empty(empty_fifo_uart_data_send)
);

assign uart_send_data_csr = rd_data_fifo_uart_data_send;


//UART receive data fifo
FIFO #(
    .DEPTH(UART_RECEIVE_DATA_FIFO_WIDTH),
    .DATA_WIDTH(UART_CSR_DATA_WIDTH)
) fifo_uart_recieve_data(
    .clk(clk),
    .rst_n(rst_n),
    .wr(data_valid),
    .rd(read_uart_read_data_csr),
    .wr_data(rx_uart_data),
    .rd_data(rd_data_fifo_uart_data_receive),
    .full(full_fifo_uart_data_receive),
    .empty(empty_fifo_uart_data_receive)
);

assign uart_read_data_csr = rd_data_fifo_uart_data_receive;

//Error in data bits
assign data_bit_error = (uart_control_0_csr.data_bits < 5) || (uart_control_0_csr.data_bits > 8);

//Quartus will infer latches for dont_care bits as they are never written,
//These latches are expected
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        uart_status_0_csr <= UART_STATUS_0_CSR_RST;
    end else begin
        uart_status_0_csr.fifo_send_data_empty    <= empty_fifo_uart_data_send;
        uart_status_0_csr.fifo_send_data_full     <= full_fifo_uart_data_send;
        uart_status_0_csr.fifo_receive_data_empty <= empty_fifo_uart_data_receive;
        uart_status_0_csr.fifo_receive_data_full  <= full_fifo_uart_data_receive;
        uart_status_0_csr.busy                    <= busy;
        uart_status_0_csr.data_valid              <= ~empty_fifo_uart_data_receive;
        if (read_uart_status_0_csr) begin      //clean bits with read
            uart_status_0_csr.data_bits_error <= UART_NO_ERROR;
            uart_status_0_csr.parity_error    <= UART_NO_ERROR;
        end else begin
            //Write flags
            if (data_bit_error) begin
                uart_status_0_csr.data_bits_error <= UART_ERROR;
            end
            if (parity_error) begin
                uart_status_0_csr.parity_error    <= UART_ERROR;
            end
            
        end
    end
end

//Read register
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rd_data <= {UART_CSR_DATA_WIDTH{1'b0}};
    end else if (ren) begin
        case (rd_addr)
            UART_BAUD_RATE_CSR_ADDR: begin
                rd_data <= uart_baud_rate_csr;
            end
            UART_CONTROL_0_CSR_ADDR: begin
                rd_data <= uart_control_0_csr;
            end
            UART_STATUS_0_CSR_ADDR: begin
                rd_data <= uart_status_0_csr;
            end
            UART_SEND_DATA_CSR_ADDR: begin
                rd_data <= uart_send_data_csr;
            end
            UART_READ_DATA_CSR_ADDR: begin
                rd_data <= uart_read_data_csr;
            end
            default: begin
                rd_data <= {UART_CSR_DATA_WIDTH{1'b0}};
            end
        endcase
    end
end


endmodule: UART_csr