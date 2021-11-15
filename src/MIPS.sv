//MIPS multi-cyle (no pipeline)
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10, 2021

module MIPS(
    input  logic clk,
    input  logic rst_n,
    //Memory signals
    input  mips_data_t rd_data_mem,
    output mips_pc_t   addr_mem,
    output mips_data_t wr_data_mem,
    output logic       wr_en_mem
);
import MIPS_pkg::*;
import ALU_pkg::*;

////////////////////////////////////////////////Signals//////////////////////////////////////////////
//Instruction
mips_r_type R_instruction;
mips_i_type I_instruction;
mips_j_type J_instruction;
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
//Control unit signals
mips_op_e       ctrl_op;
mips_funct_e    ctrl_funct;
logic           ctrl_IorD;
logic           ctrl_MemWrite;
logic           ctrl_IRWrite;
logic           ctrl_RegDst;
logic           ctrl_MemtoReg;
logic           ctrl_PCWrite;
logic           ctrl_PCSrc;
ALU_ctrl_e      ctrl_ALUControl;  
logic[1:0]      ctrl_ALUSrcB;
logic           ctrl_ALUSrcA;
logic           ctrl_RegWrite;     
//ALU signals
mips_data_t     alu_src_A;
mips_data_t     alu_src_B;
ALU_ctrl_e      alu_ctrl;
mips_data_t     alu_out;
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
//Sign extend
mips_immediate_t sign_extend_imm;
mips_data_t      sign_extended_imm;
//Zero extend
mips_immediate_t zero_extend_imm;
mips_data_t      zero_extendedn_imm;
//Mux Address
mips_pc_t pc_addr_mux_in;
mips_pc_t alu_addr_mux_in;
logic     addr_mux_sel;
mips_pc_t addr_mux_in[2];   
mips_pc_t addr_mux_out;  
//RegDsst mux
mips_reg_addr_t src0_regdst_mux_in;
mips_reg_addr_t src1_regdst_mux_in;
logic           regdst_mux_sel;
mips_reg_addr_t regdst_mux_in[2];
mips_reg_addr_t regdst_mux_out;
//WriteData mux
mips_data_t alu_writedata_mux_in;
mips_data_t data_writedata_mux_in;
logic       writedata_mux_sel;
mips_data_t writedata_mux_in[2];
mips_data_t writedata_mux_out;
//Mux SRCA
mips_data_t pc_srcA_mux_in;
mips_data_t A_srcA_mux_in;
logic       srcA_mux_sel;
mips_data_t srcA_mux_in[2];
mips_data_t srcA_mux_out;
//Mux SRCB
mips_data_t B_srcB_mux_in;
mips_data_t incrPC_srcB_mux_in;
mips_data_t signextend_srcB_mux_in;
mips_data_t zeroextend_srcB_mux_in;
logic[1:0]  srcB_mux_sel;
mips_data_t srcB_mux_in[4];
mips_data_t srcB_mux_out;
//MUX ALU Result
mips_data_t alu_alurslt_mux_in;
mips_data_t alureg_alurslt_mux_in;
logic       alurslt_mux_sel;
mips_data_t alurslt_mux_in[2];
mips_data_t alurslt_mux_out;


///////////////////////////////////////////Instantiate Modules//////////////////////////////////////////////////
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

//Control Unit
MIPS_ctrl_unit ctrl(
    .clk(clk),
    .rst_n(rst_n),
    .op(ctrl_op),
    .funct(ctrl_funct),
    .IorD(ctrl_IorD),
    .MemWrite(ctrl_MemWrite),
    .IRWrite(ctrl_IRWrite),
    .RegDst(ctrl_RegDst),
    .MemtoReg(ctrl_MemtoReg),
    .PCWrite(ctrl_PCWrite),
    .PCSrc(ctrl_PCSrc),
    .ALUControl(ctrl_ALUControl),
    .ALUSrcA(ctrl_ALUSrcA),
    .ALUSrcB(ctrl_ALUSrcB),
    .RegWrite(ctrl_RegWrite)
);

//ALU
ALU#(
    .LENGTH(MIPS_DATA_WIDTH),
    .REG_INPUTS(1'b0),
    .REG_OUTPUTS(1'b0),
    .CHECK_PARAM(1'b1)
) ALU0(
    .clk(clk),
    .rst_n(rst_n),
    .en(1'b1),
    .A(alu_src_A),
    .B(alu_src_B),
    .ctrl(alu_ctrl),
    .Result(alu_out)
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

//Sign extend
bit_extension#(
    .SIGN_EXTEND(1'b1),
    .DATA_IN_WIDTH(MIPS_IMMEDIATE_WIDTH),
    .DATA_OUT_WIDTH(MIPS_DATA_WIDTH)
) sign_extend(
    .d_in(sign_extend_imm),
    .d_out(sign_extended_imm)
);
//Zero extend
bit_extension#(
    .SIGN_EXTEND(1'b0),
    .DATA_IN_WIDTH(MIPS_IMMEDIATE_WIDTH),
    .DATA_OUT_WIDTH(MIPS_DATA_WIDTH)
) zero_extend(
    .d_in(zero_extend_imm),
    .d_out(zero_extendedn_imm)
);

//Mux address
mux#(
    .NUM_INPUTS(2),
    .WIDTH(MIPS_PC_WIDTH)
)addr_mux(
    .d_in(addr_mux_in),
    .sel(addr_mux_sel),
    .d_out(addr_mux_out)
);
//Mux RegDst
mux#(
    .NUM_INPUTS(2),
    .WIDTH(MIPS_REG_ADDR_WIDTH)
)regdst_mux(
    .d_in(regdst_mux_in),
    .sel(regdst_mux_sel),
    .d_out(regdst_mux_out)
);
//Mux WriteData
mux#(
    .NUM_INPUTS(2),
    .WIDTH(MIPS_DATA_WIDTH)
)writedata_mux(
    .d_in(writedata_mux_in),
    .sel(writedata_mux_sel),
    .d_out(writedata_mux_out)
);
//Mux SRCA
mux#(
    .NUM_INPUTS(2),
    .WIDTH(MIPS_DATA_WIDTH)
)srcA_mux(
    .d_in(srcA_mux_in),
    .sel(srcA_mux_sel),
    .d_out(srcA_mux_out)
);
//Mux SRCB
mux#(
    .NUM_INPUTS(4),
    .WIDTH(MIPS_DATA_WIDTH)
)srcB_mux(
    .d_in(srcB_mux_in),
    .sel(srcB_mux_sel),
    .d_out(srcB_mux_out)
);
//Mux ALU result
mux#(
    .NUM_INPUTS(2),
    .WIDTH(MIPS_DATA_WIDTH)
)alurslt_mux(
    .d_in(alurslt_mux_in),
    .sel(alurslt_mux_sel),
    .d_out(alurslt_mux_out)
);

/////////////////////////////////////////////Interconect Modules////////////////////////////////////////////////////

//Instruction (Union is not available in Quartus, work around)
assign R_instruction = instruction;
assign I_instruction = instruction;
assign J_instruction = instruction; 


endmodule: MIPS