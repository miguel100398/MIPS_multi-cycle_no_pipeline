//MIPS ALU Decoder
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 20, 2021

module ALU_decoder
import MIPS_pkg::*,
       ALU_pkg::*;
(
    input  logic[1:0]   ALUOp,
    input  mips_funct_e funct,
    output ALU_ctrl_e   ALUControl
);  

always_comb begin 
    case(ALUOp)
        2'b00: begin    //ADD
            ALUControl = ALU_ADD;
        end
        2'b01: begin    //Branch
            ALUControl = ALU_SUB;       
        end
        2'b10: begin   //Rtype
            case(funct)
                MIPS_SLL_FUNCT: begin
                    ALUControl = ALU_SHL;
                end
                MIPS_SRL_FUNCT: begin
                    ALUControl = ALU_SHR;
                end
                MIPS_JR_FUNCT: begin
                    ALUControl = ALU_ADD;
                end
                MIPS_ADD_FUNCT: begin
                    ALUControl = ALU_ADD;
                end
                MIPS_ADDU_FUNCT: begin
                    ALUControl = ALU_ctrl_e'(4'bXXXX);       //Unsigned operations no implemented in ALU yet
                end
                MIPS_SUB_FUNCT: begin
                    ALUControl = ALU_SUB;
                end
                MIPS_SUBU_FUNCT: begin
                    ALUControl = ALU_ctrl_e'(4'bXXXX);       //Unsigned operations no implemented in ALU yet
                end
                MIPS_AND_FUNCT: begin
                    ALUControl = ALU_AND;
                end
                MIPS_OR_FUNCT: begin
                    ALUControl = ALU_OR;
                end
                MIPS_NOR_FUNCT: begin
                    ALUControl = ALU_ctrl_e'(4'bXXXX);       //Nor operation no implemented in ALU yet
                end
                MIPS_SLT_FUNCT: begin
                    ALUControl = ALU_ctrl_e'(4'bXXXX);       //Compare operations no implemented in ALU yet
                end
                MIPS_SLTU_FUNCT: begin
                    ALUControl = ALU_ctrl_e'(4'bXXXX);       //Compare operations no implemented in ALU yet
                end
			    default: begin
					ALUControl = ALU_ctrl_e'(4'bXXXX);
				end
            endcase
        end
        default: begin
           ALUControl = ALU_ADD; 
        end
    endcase
end

endmodule: ALU_decoder 