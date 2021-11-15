//PC register
//Author: Miguel Bucio Macias miguel_angel_bucio@hotmail.com
//date: november 14, 2021

module PC_reg#(
    parameter int unsigned PC_WIDTH = 32
)(
    input  logic               clk,
    input  logic               rst_n,
    input  logic               en,
    input  logic[PC_WIDTH-1:0] next_pc,
    output logic[PC_WIDTH-1:0] pc
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pc <= {PC_WIDTH{1'b0}};
    end else if (en) begin
        pc <= next_pc;
    end
end 

endmodule: PC_reg 