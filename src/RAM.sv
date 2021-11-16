//RAM memory
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: 16/11/2021

module RAM#(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned ADDR_WIDTH = 32 
)(
    input  logic                 clk,
    input  logic[ADDR_WIDTH-1:0] addr,
    input  logic[DATA_WIDTH-1:0] wr_data,
    input  logic                 wr_en,
    output logic[DATA_WIDTH-1:0] rd_data
);

localparam int unsigned NUM_MEM = 2**ADDR_WIDTH;

//Memory
logic[DATA_WIDTH-1:0] ram_mem[NUM_MEM];

//Write Memory
always_ff @(posedge clk) begin
    if (wr_en) begin
        ram_mem[addr] <= wr_data;
    end
end

//Read Memory
assign rd_data = ram_mem[addr];

endmodule: RAM