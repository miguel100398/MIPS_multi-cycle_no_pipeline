//MIPS package
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10, 2021

package MIPS_pkg;
    import ALU_pkg::*;

    //////////////////////////Parameters///////////////////////////////////////
    parameter  int unsigned  MIPS_NUM_REGISTERS     = 32;
    parameter  int unsigned  MIPS_DATA_WIDTH        = 32;
    parameter  int unsigned  MIPS_ADDR_WIDTH        = 32;
    localparam int unsigned  MIPS_REG_ADDR_WIDTH    = $clog2(MIPS_NUM_REGISTERS);
    parameter  int unsigned  MIPS_PC_WIDTH          = 32;
    parameter  int unsigned  MIPS_INSTRUCTION_WIDTH = 32;
    parameter  int unsigned  MIPS_IMMEDIATE_WIDTH   = 16;
    parameter  int unsigned  MIPS_OP_WIDTH          = 6;
    parameter  int unsigned  MIPS_FUNCT_WIDTH       = 6;
    parameter  int unsigned  MIPS_RS_WIDTH          = 5;
    parameter  int unsigned  MIPS_RT_WIDTH          = 5;
    parameter  int unsigned  MIPS_RD_WIDTH          = 5;
    parameter  int unsigned  MIPS_SHAMT_WIDTH       = 5;
    parameter  int unsigned  MIPS_JUMP_WIDTH        = 26;

    ////////////////////////Typedefs//////////////////////////////////////////
    typedef logic[MIPS_REG_ADDR_WIDTH-1:0]    mips_reg_addr_t;
    typedef logic[MIPS_DATA_WIDTH-1:0]        mips_data_t;
    typedef logic[MIPS_ADDR_WIDTH-1:0]        mips_addr_t;
    typedef logic[MIPS_PC_WIDTH-1:0]          mips_pc_t;
    typedef logic[MIPS_INSTRUCTION_WIDTH-1:0] mips_instruction_t;
    typedef logic[MIPS_IMMEDIATE_WIDTH-1:0]   mips_immediate_t;
    typedef logic[MIPS_RS_WIDTH-1:0]          mips_rs_t;
    typedef logic[MIPS_RT_WIDTH-1:0]          mips_rt_t;
    typedef logic[MIPS_RD_WIDTH-1:0]          mips_rd_t;
    typedef logic[MIPS_SHAMT_WIDTH-1:0]       mips_shamt_t;
    typedef logic[MIPS_JUMP_WIDTH-1:0]        mips_jump_t;
    
    ////////////////////////ENUMS////////////////////////////////////////////
    typedef enum logic[MIPS_OP_WIDTH-1:0] {
        MIPS_RTYPE_OP = 6'b000000
    } mips_op_e;
    typedef enum logic[MIPS_FUNCT_WIDTH-1:0] {
        MIPSS_ADD_FUNCT = 6'b000000
    } mips_funct_e;

    /////////////////////////////Structs////////////////////////////////////////
    typedef struct packed {
        mips_op_e    op;
        mips_rs_t    rs;
        mips_rt_t    rt;
        mips_rd_t    rd;
        mips_shamt_t shamt;
        mips_funct_e funct;
    } mips_r_type;
    typedef struct packed{
        mips_op_e        op;
        mips_rs_t        rs;
        mips_rt_t        rt;
        mips_immediate_t imm;
    } mips_i_type;
    typedef struct packed {
        mips_op_e   op;
        mips_jump_t jump;
    } mips_j_type;

endpackage: MIPS_pkg