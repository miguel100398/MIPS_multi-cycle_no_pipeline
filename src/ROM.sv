//ROM memory
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: november 15, 2021

module ROM#(
    //parameter string       MEMORY_FILE   = "no_file",     //Cant use paramter in readmem in quartus
    parameter int unsigned DATA_WIDTH    = 32,
    parameter int unsigned ADDR_WIDTH    = 32,
    parameter string       MEMORY_FORMAT = "hex" 
)(
    input  logic                 clk,
    input  logic[ADDR_WIDTH-1:0] addr,
    output logic[DATA_WIDTH-1:0] data_o
);

localparam int unsigned NUM_MEM = 2**ADDR_WIDTH;

//Memory
logic [DATA_WIDTH-1:0] rom_mem[NUM_MEM];

//Initialize ROM
generate
    if ((MEMORY_FORMAT == "hex") || (MEMORY_FORMAT == "HEX") || MEMORY_FORMAT == "h" || MEMORY_FORMAT == "H") begin : gen_hex_rom 
        initial begin
            $readmemh("no_file", rom_mem);
        end
    end else if ((MEMORY_FORMAT == "bin") || (MEMORY_FORMAT == "BIN") || MEMORY_FORMAT == "b" || MEMORY_FORMAT == "B") begin : gen_bin_rom 
        initial begin
            $readmemb("no_file", rom_mem);
        end
    end else if ((MEMORY_FORMAT == "dec") || (MEMORY_FORMAT == "DEC") || MEMORY_FORMAT == "d" || MEMORY_FORMAT == "D") begin : gen_dec_rom
        initial begin
            $readmemd("no_file", rom_mem);
        end
    end else begin : gen_error_rom
        initial begin
            $fatal("ROM(): Error, invalid memory format, valid formats are hex, bin and dec");
        end
    end 
endgenerate

//Read rom
always_ff @(posedge clk) begin
    data_o <= rom_mem[addr];
end

endmodule: ROM