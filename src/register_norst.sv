//Parametrizable register without rst
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: november 14, 2021

module register_norst#(
    parameter int unsigned WIDTH = 32
)(
    input  logic clk,
    input  logic en,
    input  logic[WIDTH-1:0] D,
    output logic[WIDTH-1:0] Q
);

always_ff @(posedge clk) begin
    if (en) begin
        Q <= D;
    end
end

endmodule: register_norst