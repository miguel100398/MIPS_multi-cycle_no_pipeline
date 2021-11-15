//MIPS multi-cyle (no pipeline)
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10, 2021

module MIPS(
    input  logic clk,
    input  logic rst_n
);
import MIPS_pkg::*;

//PC register signals
logic en_pc;
mips_pc_t next_pc;
mips_pc_t pc;
//Register file signals
mips_reg_addr_t rf_A1;
mips_reg_addr_t rf_A2;
mips_reg_addr_t rf_A3;
mips_data_t     rf_RD1;
mips_data_t     rf_RD2;
mips_data_t     rf_WD3;
logic           rf_WE3;
//Instruction register
logic en_instr_reg;
mips_instruction_t next_instruction;
mips_instruction_t instruction;
//Data register
mips_data_t next_data;
mips_data_t data;
//Reg_a
mips_data_t next_A;
mips_data_t A;
//Reg_b
mips_data_t next_B;
mips_data_t B;
//ALU reg
mips_data_t next_ALU_result;
mips_data_t ALU_result;


//PC register
PC_reg #(
    .PC_WIDTH(MIPS_PC_WIDTH)
)pc_inst(
    .clk(clk),
    .rst_n(rst_n),
    .en(en_pc),
    .next_pc(next_pc),
    .pc(pc)
);

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

//Instruction register
register_norst#(
    .WIDTH(MIPS_INSTRUCTION_WIDTH)
) instruction_reg(
    .clk(clk),
    .en(en_instr_reg),
    .D(next_instruction),
    .Q(instruction)
);
//Data register
register_norst_noen#(
    .WIDTH(MIPS_DATA_WIDTH)
) data_reg(
    .clk(clk),
    .D(next_data),
    .Q(data)
);
//Register A
register_norst_noen#(
    .WIDTH(MIPS_DATA_WIDTH)
) reg_A(
    .clk(clk),
    .D(next_A),
    .Q(A)
);
//register B
register_norst_noen#(
    .WIDTH(MIPS_DATA_WIDTH)
) reg_B(
    .clk(clk),
    .D(next_B),
    .Q(B)
);
//ALU register
register_norst_noen#(
    .WIDTH(MIPS_DATA_WIDTH)
) ALU_reg(
    .clk(clk),
    .D(next_ALU_result),
    .Q(ALU_result)
);


endmodule: MIPS