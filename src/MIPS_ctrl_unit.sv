//MIPS control unit
module MIPS_ctrl_unit
import MIPS_pkg::*,
       ALU_pkg::*;
(
    input  logic        clk,
    input  logic        rst_n,
    input  mips_op_e    op,
    input  mips_funct_e funct,
    output logic        IorD,
    output logic        MemWrite,
    output logic        IRWrite,
    output logic        RegDst,
    output logic        MemtoReg,
    output logic        PCWrite,
    output logic        PCSrc,
    output ALU_ctrl_e   ALUControl,
    output logic[1:0]   ALUSrcB,
    output logic        ALUSrcA,
    output logic        RegWrite
);
import MIPS_pkg::*;
import ALU_pkg::*;

endmodule: MIPS_ctrl_unit