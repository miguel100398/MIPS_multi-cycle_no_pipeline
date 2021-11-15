//Parametrizable MUX
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 14, 2021

module mux#(
    parameter int unsigned NUM_INPUTS = 2,
    parameter int unsigned WIDTH      = 32,
    //Local parameter
    parameter int unsigned SEL_WIDTH  = $clog2(NUM_INPUTS)
)(
    input  logic[WIDTH-1:0]     d_in[NUM_INPUTS],
    input  logic[SEL_WIDTH-1:0] sel,
    output logic[WIDTH-1:0]     d_out
);

assign d_out = d_in[sel];

endmodule: mux