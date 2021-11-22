//Instruction and Data memory
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 16, 2021

module instruction_data_memory#(
    parameter int unsigned DATA_WIDTH     = 32,
    parameter int unsigned ADDR_WIDTH     = 32,
    parameter string       MEMORY_FORMAT  = "hex"
)(  
    input  logic                  clk,
    input  logic                  chip_sel,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic                  wr_en,
    output logic [DATA_WIDTH-1:0] rd_data
);


logic[ADDR_WIDTH-2:0] addr_mem;
logic[DATA_WIDTH-1:0] instr_mem_rd_data;
logic[DATA_WIDTH-1:0] data_mem_rd_data;
logic wr_en_data_memory;
logic access_data_mem;

assign addr_mem         = addr[ADDR_WIDTH-2:0];
assign access_data_mem  = addr[ADDR_WIDTH-1];


//Instruction Memory
ROM #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MEMORY_FORMAT(MEMORY_FORMAT)
)instruction_memory(
    .clk(clk),
    .addr(addr_mem),
    .data_o(instr_mem_rd_data)
);

//Data Memory
assign wr_en_data_memory = wr_en && access_data_mem && chip_sel;

RAM #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
)data_memory(
    .clk(clk),
    .addr(addr_mem),
    .wr_data(wr_data),
    .wr_en(wr_en_data_memory),
    .rd_data(data_mem_rd_data)
);

//Assign output
assign rd_data = (access_data_mem) ? data_mem_rd_data : instr_mem_rd_data;


endmodule: instruction_data_memory