interface UART_csr_if;
import UART_csr_pkg::*;

//Registers
uart_baud_rate_csr_t uart_baud_rate_csr;
uart_control_0_csr_t uart_control_0_csr;
uart_status_0_csr_t  uart_status_0_csr;
uart_send_data_csr_t uart_send_data_csr;
uart_read_data_csr_t uart_read_data_csr;

//Csr side interface
modport csr_mp(
    output uart_baud_rate_csr,
    output uart_control_0_csr,
    output uart_status_0_csr,
    output uart_send_data_csr,
    output uart_read_data_csr
);

//UART side interface
modport uart_mp(
    input uart_baud_rate_csr,
    input uart_control_0_csr,
    input uart_status_0_csr,
    input uart_send_data_csr,
    input uart_read_data_csr
);



endinterface: UART_csr_if