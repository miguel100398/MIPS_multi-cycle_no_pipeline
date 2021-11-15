//MIPS package
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10, 2021

package MIPS_pkg;
    import ALU_pkg::*;

    //////////////////////////Parameters///////////////////////////////////////
    parameter  int unsigned  MIPS_NUM_REGISTERS     = 32;
    parameter  int unsigned  MIPS_DATA_WIDTH        = 32;
    localparam int unsigned  MIPS_REG_ADDR_WIDTH    = $clog2(MIPS_NUM_REGISTERS);
    parameter  int unsigned  MIPS_PC_WIDTH          = 32;
    parameter  int unsigned  MIPS_INSTRUCTION_WIDTH = 32;
    parameter  int unsigned  MIPS_IMMEDIATE_WIDTH   = 16;
    parameter  int unsigned  MIPS_OP_WIDTH          = 6;
    parameter  int unsigned  MIPS_FUNCT_WIDTH       = 6;

    ////////////////////////Typedefs//////////////////////////////////////////
    typedef logic[MIPS_REG_ADDR_WIDTH-1:0]    mips_reg_addr_t;
    typedef logic[MIPS_DATA_WIDTH-1:0]        mips_data_t;
    typedef logic[MIPS_PC_WIDTH-1:0]          mips_pc_t;
    typedef logic[MIPS_INSTRUCTION_WIDTH-1:0] mips_instruction_t;
    typedef logic[MIPS_IMMEDIATE_WIDTH-1:0]   mips_immediate_t;
    
    ////////////////////////ENUMS////////////////////////////////////////////
    typedef enum logic[MIPS_OP_WIDTH-1:0] {
        MIPS_RTYPE_OP = 6'b000000
    } mips_op_e;
    typedef enum logic[MIPS_FUNCT_WIDTH-1:0] {
        MIPSS_ADD_FUNCT = 6'b000000
    } mips_funct_e;

endpackage: MIPS_pkg