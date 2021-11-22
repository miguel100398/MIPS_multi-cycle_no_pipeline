//FIFO
//author: Miguel Bucio miguel_angel_bucio@@hotmail.com
//date: November 221, 2021

module FIFO#(
    parameter int unsigned DEPTH      = 8,
    parameter int unsigned DATA_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  wr,
    input  logic                  rd,
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  full,
    output logic                  empty
);

localparam int unsigned PTR_WIDTH = $clog2(DEPTH);

//Memory    //8-bit wide    4-location deep
logic[DATA_WIDTH-1:0] mem[DEPTH];
//Pointers
logic[PTR_WIDTH-1:0] wr_ptr;
logic[PTR_WIDTH-1:0] rd_ptr;
//Enable write
logic en_write;
//Enable read
logic en_read;
//Num of entries in FIFO
logic[PTR_WIDTH:0] num_entries;

//Enable write
assign en_write = wr && ~full;
//Enable read
assign en_read = rd  && ~empty;

//Write memory
always @(posedge clk) begin 
    if (en_write) begin
        mem[wr_ptr] <= wr_data;
    end
end 

//write pointer
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wr_ptr <= {PTR_WIDTH{1'b0}};
    end else if (en_write) begin
        wr_ptr <= wr_ptr + 1'b1;
    end
end

//read memory (asyncrhonous)
assign rd_data = mem[rd_ptr];

//Read pointer
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin 
        rd_ptr <= {PTR_WIDTH{1'b0}};
    end else if (en_read) begin
        rd_ptr <= rd_ptr + 1'b1;
    end
end

//Num entries
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        num_entries <= {PTR_WIDTH+1{1'b0}};
    end else begin
        case ({en_write, en_read}) 
            2'b01 : begin       //read
                num_entries <= num_entries - 1'b1;
            end
            2'b10: begin        //Write
                num_entries <= num_entries + 1'b1;
            end
            default: begin      //Write and read or not write and not read
                num_entries <= num_entries;
            end
        endcase
    end
end

//Full flag
assign full = (num_entries == DEPTH);
//empty flag
assign empty = (num_entries == 0);

endmodule