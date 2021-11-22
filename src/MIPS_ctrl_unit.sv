//MIPS control unit
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 20, 2021

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
    output logic[1:0]   PCSrc,
    output ALU_ctrl_e   ALUControl,
    output logic[1:0]   ALUSrcB,
    output logic        ALUSrcA,
    output logic        RegWrite,
    output logic        Branch
);
import MIPS_pkg::*;
import ALU_pkg::*;

//State
mips_state_e state, next_state;

logic[1:0] ALUOp;

logic halt;

assign halt = (op == MIPS_HALT_OP) && (funct == MIPS_HALT_FUNCT);


//FSM
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= MIPS_FETCH_S;
    end else begin
        state <= next_state;
    end
end

//Next state
always_comb begin 
    case(state)
        MIPS_FETCH_S: begin
            next_state = MIPS_DECODE_S;
        end
        MIPS_DECODE_S: begin
            if (halt) begin
                next_state = MIPS_HALT_S;
            end
            else if ((op==MIPS_LW_OP) || (op==MIPS_SW_OP)) begin
                next_state = MIPS_MEMADDR_S;
            end else if (op==MIPS_RTYPE_OP) begin
                next_state = MIPS_EXECUTE_S;
            end else if (op==MIPS_BEQ_OP) begin
                next_state = MIPS_BRANCH_S;
            end else if (op>3) begin
                next_state = MIPS_IEXECUTE_S;
            end else if (op == MIPS_J_OP) begin
                next_state = MIPS_JUMP_S;
            end else begin
                next_state = MIPS_FETCH_S;      //Discard instruction
            end
        end
        MIPS_MEMADDR_S: begin
            if (op == MIPS_LW_OP) begin
                next_state = MIPS_MEMREAD_S;
            end else begin //op == MIPS_SW_OP
                next_state = MIPS_MEMWRITE_S;
            end
        end
        MIPS_MEMREAD_S: begin
            next_state = MIPS_MEMWRITEBACK_S;
        end
        MIPS_MEMWRITEBACK_S: begin
            next_state = MIPS_FETCH_S;
        end
        MIPS_MEMWRITE_S: begin
            next_state = MIPS_FETCH_S;
        end
        MIPS_EXECUTE_S: begin
            next_state = MIPS_ALUWRITEBACK_S;
        end
        MIPS_ALUWRITEBACK_S: begin
            next_state = MIPS_FETCH_S;
        end
        MIPS_BRANCH_S: begin
            next_state = MIPS_FETCH_S;
        end
        MIPS_IEXECUTE_S: begin
            next_state = MIPS_IWRITEBACK_S;
        end
        MIPS_IWRITEBACK_S: begin
            next_state = MIPS_FETCH_S;
        end
        MIPS_JUMP_S: begin
            next_state = MIPS_FETCH_S;
        end
        MIPS_HALT_S: begin
            next_state = MIPS_HALT_S;
        end
        default: begin
            next_state = MIPS_FETCH_S;
        end
    endcase
end

//Outputs
//Next state
always_comb begin 
    //Default values
    IorD        = 1'b0;
    MemWrite    = 1'b0;
    IRWrite     = 1'b0;
    RegDst      = 1'b0;
    MemtoReg    = 1'b0;
    PCWrite     = 1'b0;
    PCSrc       = 2'b00;
    ALUOp       = 2'b00;
    ALUSrcA     = 1'b0;
    ALUSrcB     = 2'b00;
    RegWrite    = 1'b0;
    Branch      = 1'b0;
    case(state)
        MIPS_FETCH_S: begin
            IorD    = 1'b0;
            ALUSrcA = 1'b0;
            ALUSrcB = 2'b01;
            ALUOp   = 2'b00;
            PCSrc   = 2'b00;
            IRWrite = 1'b1;
            PCWrite = 1'b1;
        end
        MIPS_DECODE_S: begin
            ALUSrcA = 1'b0;
            ALUSrcB = 2'b11;
            ALUOp   = 2'b00;
        end
        MIPS_MEMADDR_S: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
            ALUOp   = 2'b00;
        end
        MIPS_MEMREAD_S: begin
            IorD    = 1'b1;
        end
        MIPS_MEMWRITEBACK_S: begin
            RegDst   = 1'b0;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
        end
        MIPS_MEMWRITE_S: begin
            IorD     = 1'b1;
            MemWrite = 1'b1;
        end
        MIPS_EXECUTE_S: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b00;
            ALUOp   = 2'b10;
        end
        MIPS_ALUWRITEBACK_S: begin
            RegDst   = 1'b1;
            MemtoReg = 1'b0;
            RegWrite = 1'b1;
        end
        MIPS_BRANCH_S: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b00;
            ALUOp   = 2'b01;
            PCSrc   = 2'b01;
            Branch  = 1'b1;
        end
        MIPS_IEXECUTE_S: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
            ALUOp   = 2'b11;
        end
        MIPS_IWRITEBACK_S: begin
            RegDst   = 1'b0;
            MemtoReg = 1'b0;
            RegWrite = 1'b1;
        end
        MIPS_JUMP_S: begin
            PCSrc   = 2'b10;
            PCWrite = 1'b1;
        end
        default: begin
            IorD        = 1'b0;
            MemWrite    = 1'b0;
            IRWrite     = 1'b0;
            RegDst      = 1'b0;
            MemtoReg    = 1'b0;
            PCWrite     = 1'b0;
            PCSrc       = 1'b0;
            ALUSrcA     = 1'b0;
            ALUSrcB     = 2'b00;
            RegWrite    = 1'b0;
            Branch      = 1'b0;
			ALUOp       = 2'b00;
        end
    endcase
end

//ALU_control decoder
ALU_decoder decoder(
    .ALUOp(ALUOp),
    .funct(funct),
    .ALUControl(ALUControl),
    .op(op)
);


endmodule: MIPS_ctrl_unit