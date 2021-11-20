//File:   ALU_pkg.sv
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date:   september 4, 2021
//Description:
//          Defines the parameters and typedefs used by the ALU

package ALU_pkg;

//Typedefs
typedef enum logic[3:0] {
    ALU_ADD   = 4'd0,       // A + B
    ALU_SUB   = 4'd1,       // A - B
    ALU_NEG_B = 4'd2,       // -B
    ALU_MUL   = 4'd3,       // A * B
    ALU_AND   = 4'd4,       // A & B
    ALU_OR    = 4'd5,       // A | B
    ALU_A_N   = 4'd6,       // ~A
    ALU_XOR   = 4'd7,       // A ^ B
    ALU_SHL   = 4'd8,       // A << B[3:0]
    ALU_SHR   = 4'd9        // B >> B[3:0]
} ALU_ctrl_e;

endpackage: ALU_pkg