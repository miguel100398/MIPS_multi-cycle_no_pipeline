//MIPS multi-cyle (no pipeline)
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10, 2021

module MIPS(
    input  logic clk,
    input  logic rst_n
);
import MIPS_pkg::*;

//Register file signals
mips_reg_addr_t rf_A1;
mips_reg_addr_t rf_A2;
mips_reg_addr_t rf_A3;
mips_data_t     rf_RD1;
mips_data_t     rf_RD2;
mips_data_t     rf_WD3;
logic           rf_WE3;

//Register file
register_file#(
    .NUM_REGISTERS(MIPS_NUM_REGISTERS),     //32 registers
    .DATA_WIDTH(MIPS_DATA_WIDTH)            //32 bits
) rf(
    .clk(clk),
    .rst_n(rst_n),
    .A1(rf_A1),
    .A2(rf_A2),
    .A3(rf_A3),
    .RD1(rf_RD1),
    .RD2(rf_RD2),
    .WD3(rf_WD3),
    .WE3(rf_WE3)
);


endmodule: MIPS