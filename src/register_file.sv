//Register File
//Author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10 2021

module register_file#(
    parameter NUM_REGISTERS = 32,
    parameter DATA_WIDTH    = 32,
    //Localparam
    parameter ADDR_WIDTH = $clog2(NUM_REGISTERS)
)(
    input  logic                 clk,
    input  logic                 rst_n,
    //Address
    input  logic[ADDR_WIDTH-1:0] A1,
    input  logic[ADDR_WIDTH-1:0] A2,
    input  logic[ADDR_WIDTH-1:0] A3,
    //Data
    output logic[DATA_WIDTH-1:0] RD1,
    output logic[DATA_WIDTH-1:0] RD2,
    input  logic[DATA_WIDTH-1:0] WD3,
    //Control signals
    input  logic                 WE3
);

//Registers
logic[DATA_WIDTH-1:0] regs[NUM_REGISTERS];

//Write register
always_ff @(posedge clk or negedge rst_n) begin 
    if (~rst_n) begin
        for (int i=0; i<NUM_REGISTERS; i++) begin 
            regs[i] <= {DATA_WIDTH{1'b0}};
        end 
    end else if (WE3) begin
        regs[A3] <= WD3;
    end
end

//Read register 1
assign RD1 = regs[A1];
//Read register 2
assign RD2 = regs[A2];

endmodule: register_file