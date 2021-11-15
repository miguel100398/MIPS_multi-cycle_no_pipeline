//Parametrizable register without rst and without en
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: november 14, 2021

module register_norst_noen#(
    parameter int unsigned WIDTH = 32
)(
    input  logic clk,
    input  logic[WIDTH-1:0] D,
    output logic[WIDTH-1:0] Q
);

always_ff @(posedge clk) begin
    Q <= D;
end

endmodule: register_norst_noen