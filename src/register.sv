//Parametrizable register
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: november 14, 2021

module register#(
    parameter int unsigned WIDTH = 32
)(
    input  logic clk,
    input  logic rst_n,
    input  logic en,
    input  logic[WIDTH-1:0] D,
    output logic[WIDTH-1:0] Q
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= {WIDTH{1'b0}};
    end else if (en) begin
        Q <= D;
    end
end

endmodule: register