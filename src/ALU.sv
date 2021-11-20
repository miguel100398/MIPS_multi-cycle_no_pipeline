//File:   ALU.sv
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date:   september 4, 2021
//Description:
//          Behavioral ALU that supports:
//              Arithmetic sum:         Result = A + B
//              Arithmetic subtraction: Result = A - B
//              Negative B:             Result = B * -1
//              Multiplication          Result = A * B
//              AND                     Result = A & B
//              OR                      Result = A | B
//              A negated:              Result = ~A
//              XOR:                    Result = A ^ B
//              Shift left              Result = A << B[3:0]
//              Shift right             Reulst = A >> B[3:0]
//Parameters:
//  LENGTH      = 8: Defines the width of the signasl A, B and Result
//  REG_INPUTS  = 1: Registers the inputs of the ALU
//  REG_OUTPUTS = 1: Registers the outputs of the ALU
//Dependencies:
//  ALU_pkg.sv



module ALU 
import ALU_pkg::*;
#(
    parameter int unsigned LENGTH      = 8,
    parameter bit          REG_INPUTS  = 1,
    parameter bit          REG_OUTPUTS = 1,
    parameter bit          CHECK_PARAM = 1
)(
    input  logic             clk,
    input  logic             rst_n,
    input  logic             en,
    input  logic [LENGTH-1:0] A,
    input  logic [LENGTH-1:0] B,
    input  ALU_ctrl_e        ctrl,
    output logic [LENGTH-1:0] Result,
    output logic             carry_f,
    output logic             overflow_f,
    output logic             zero_f
);

//Inputs to be used by the ALU
logic [LENGTH-1:0] A_int;
logic [LENGTH-1:0] B_int;
logic [3:0]       ctrl_reg;
ALU_ctrl_e        ctrl_int;
//Output from the ALU
logic [LENGTH-1:0] Result_int;
//ALU operations
logic [LENGTH-1:0]      add_result;
logic [LENGTH-1:0]      sub_result;
logic [LENGTH-1:0]      negb_result;
logic [(LENGTH*2)-1:0]  mul_result;
logic [LENGTH-1:0]      and_result;
logic [LENGTH-1:0]      or_result;
logic [LENGTH-1:0]      a_n_result;
logic [LENGTH-1:0]      xor_result;
logic [LENGTH-1:0]      shl_result;
logic [LENGTH-1:0]      shr_result;
//ALU flags
logic             overflow_en;
logic             carry_int;
logic             overflow_int;
logic             overflow_negative;
logic             overflow_mul;
logic             overflow_arith;
logic             zero_int;
logic             carry_add;
logic             carry_sub;

//Cast
assign ctrl_int = ALU_ctrl_e'(ctrl_reg);

//Register inputs if needed
generate
    if (REG_INPUTS) begin : gen_reg_input
        //Register input
        register #(
            .WIDTH(LENGTH)
        ) reg_input_A (
            .clk(clk),
            .rst_n(rst_n),
            .en(en),
            .d(A),
            .q(A_int)
        );
        register #(
            .WIDTH(LENGTH)
        ) reg_input_B (
            .clk(clk),
            .rst_n(rst_n),
            .en(en),
            .d(B),
            .q(B_int)
        );
        register #(
            .WIDTH($bits(ctrl_int))
        ) reg_input_ctrl(
            .clk(clk),
            .rst_n(rst_n),
            .en(en),
            .d(ctrl),
            .q(ctrl_reg)
        );
    end // gen_reg_input
    else begin : gen_no_reg_input
        //Combinational inputs
        assign A_int    = A;
        assign B_int    = B;
		assign ctrl_reg = ctrl;
    end // gen_no_reg_input
endgenerate

//Register output if needed
generate
    if (REG_OUTPUTS) begin : gen_reg_output
        register #(
            .WIDTH(LENGTH)
        ) reg_output_result (
            .clk(clk),
            .rst_n(rst_n),
            .en(en),
            .d(Result_int),
            .q(Result)
        );
        register #(
            .WIDTH(3)
        ) reg_output_flags (
            .clk(clk),
            .rst_n(rst_n),
            .en(en),
            .d({carry_int, overflow_int, zero_int}),
            .q({carry_f, overflow_f, zero_f})
        );
    end // gen_reg_output
    else begin : gen_no_reg_output
        //Combinational output
        assign Result = Result_int;
        assign {carry_f, overflow_f, zero_f} = {carry_int, overflow_int, zero_int};
    end // gen_no_reg_output
endgenerate

//Perform operations
assign {carry_add, add_result}  = signed'(A_int) + signed'(B_int);
assign {carry_sub, sub_result}  = signed'(A_int) - signed'(B_int);
assign negb_result              = -(signed'(B_int));
assign mul_result               = signed'(A_int) * signed'(B_int);
assign and_result               = A_int & B_int;
assign or_result                = A_int | B_int;
assign a_n_result               = ~A_int;
assign xor_result               = A_int ^ B_int;
assign shl_result               = A_int << B_int[3:0];
assign shr_result               = A_int >> B_int[3:0];

//Multiplex Result
always_comb begin
    case(ctrl_int)
        ALU_ADD: begin
            Result_int = add_result;
        end
        ALU_SUB: begin
            Result_int = sub_result;
        end
        ALU_NEG_B: begin
            Result_int = negb_result;
        end
        ALU_MUL: begin
            Result_int = mul_result[LENGTH-1:0];
        end
        ALU_AND: begin
            Result_int = and_result;
        end
        ALU_OR: begin
            Result_int = or_result;
        end
        ALU_A_N: begin
            Result_int = a_n_result;
        end
        ALU_XOR: begin
            Result_int = xor_result;
        end
        ALU_SHL: begin
            Result_int = shl_result;
        end
        ALU_SHR: begin
            Result_int = shr_result;
        end
        default: begin
            Result_int = {LENGTH{1'bX}};
        end
    endcase
end

//Flags
assign carry_int         = (ctrl_int==ALU_SUB) ? carry_sub : carry_add;
assign zero_int          = (Result_int == 0);
assign overflow_negative = (B_int == {1'b1,{LENGTH-1{1'b0}}}) & (ctrl_int == ALU_NEG_B);       //Overflow only when B = -16
assign overflow_mul      = ((signed'(mul_result) >= 2**(LENGTH-1)) || (signed'(mul_result) < 2**LENGTH)) & (ctrl_int == ALU_MUL);
assign overflow_arith    = (carry_int ^ Result_int[LENGTH-1]) & ((ctrl_int == ALU_ADD) | (ctrl_int == ALU_SUB));
assign overflow_en       = (ctrl_int <= 3);
assign overflow_int      = (overflow_arith | overflow_mul | overflow_negative) & overflow_en;

//Check parameters
`ifndef SYNTHESIS
    generate
        if (CHECK_PARAM) begin : gen_check_param
            if (LENGTH < 4) begin : gen_check_length
                initial begin
                    $fatal("ALU-check_length(): Error, Lenght can't be less than 4, to disable this check set check_param = 0");
                end
            end // gen_check_lenght
        end // gen_check_param
    endgenerate
`endif //SYNTHESIS

endmodule: ALU