//MIPS package
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10, 2021

package MIPS_pkg;

    //////////////////////////Parameters///////////////////////////////////////
    parameter int unsigned  MIPS_NUM_REGISTERS  = 32;
    parameter int unsigned  MIPS_DATA_WIDTH     = 32;
    localparam int unsigned MIPS_REG_ADDR_WIDTH = $clog2(NUM_REGISTERS);

    ////////////////////////Typedefs//////////////////////////////////////////
    typedef logic[MIPS_REG_ADDR_WIDTH-1:0] mips_reg_addr_t;
    typedef logic[MIPS_DATA_WIDTH-1:0-]    mips_data_t;

endpackage: MIPS_pkg