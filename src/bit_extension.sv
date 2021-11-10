//Bit extension (ZERO or SIGN)
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10 2021

module bit_extension#(
    parameter bit          SIGN_EXTEND    = 1'b1,
    parameter int unsigned DATA_IN_WIDTH  = 16,
    parameter int unsigned DATA_OUT_WIDTH = 32
)(
    input  logic[DATA_IN_WIDTH-1:0]  d_in,
    output logic[DATA_OUT_WIDTH-1:0] d_out
);

localparam int unsigned EXTEND_BITS = DATA_OUT_WIDTH - DATA_IN_WIDTH;

generate
    if (SIGN_EXTEND) begin : gen_sign_extend
        assign d_out = {{EXTEND_BITS{d_in[DATA_IN_WIDTH-1]}}, d_in};
    end else begin : gen_zero_extend 
        assign d_out = {{EXTEND_BITS{1'b0}}, d_in};
    end 
endgenerate

endmodule: bit_extension