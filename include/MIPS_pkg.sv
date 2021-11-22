//MIPS package
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10, 2021

package MIPS_pkg;
    import ALU_pkg::*;

    //////////////////////////Parameters///////////////////////////////////////
    parameter  int unsigned  MIPS_NUM_REGISTERS     = 32;
    parameter  int unsigned  MIPS_DATA_WIDTH        = 32;
    parameter  int unsigned  MIPS_ADDR_WIDTH        = 32;
    parameter  int unsigned  MIPS_MEMORY_ADDR_WIDTH = 8;
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
        MIPS_RTYPE_OP = 6'h0,
        MIPS_J_OP     = 6'h2,
        MIPS_JAL_OP   = 6'h3,
        MIPS_BEQ_OP   = 6'h4,
        MIPS_BNE_OP   = 6'h5,
        MIPS_ADDI_OP  = 6'h8,
        MIPS_ADDIU_OP = 6'h9,
        MIPS_SLTI_OP  = 6'hA,
        MIPS_SLTIU_OP = 6'hB,
        MIPS_ANDI_OP  = 6'hC,
        MIPS_ORI_OP   = 6'hD,
        MIPS_LUI_OP   = 6'hF,
        MIPS_LW_OP    = 6'h23,
        MIPS_LBU_OP   = 6'h24,
        MIPS_LHU_OP   = 6'h25,
        MIPS_SB_OP    = 6'h28,
        MIPS_SH_OP    = 6'h29,
        MIPS_SW_OP    = 6'h2B,
        MIPS_LL_OP    = 6'h30,
        MIPS_SC_OP    = 6'h38
    } mips_op_e;

    typedef enum logic[MIPS_FUNCT_WIDTH-1:0] {
        MIPS_SLL_FUNCT  = 6'h0,
        MIPS_SRL_FUNCT  = 6'h2,
        MIPS_JR_FUNCT   = 6'h8,
        MIPS_ADD_FUNCT  = 6'h20,
        MIPS_ADDU_FUNCT = 6'h21,
        MIPS_SUB_FUNCT  = 6'h22,
        MIPS_SUBU_FUNCT = 6'h23,
        MIPS_AND_FUNCT  = 6'h24,
        MIPS_OR_FUNCT   = 6'h25,
        MIPS_NOR_FUNCT  = 6'h27,
        MIPS_SLT_FUNCT  = 6'h2A,
        MIPS_SLTU_FUNCT = 6'h2B
    } mips_funct_e;
    
    typedef enum logic[3:0] {
        MIPS_FETCH_S         = 4'd0,
        MIPS_DECODE_S        = 4'd1,
        MIPS_MEMADDR_S       = 4'd2,
        MIPS_MEMREAD_S       = 4'd3,
        MIPS_MEMWRITEBACK_S  = 4'd4,
        MIPS_MEMWRITE_S      = 4'd5,
        MIPS_EXECUTE_S       = 4'd6,
        MIPS_ALUWRITEBACK_S  = 4'd7,
        MIPS_BRANCH_S        = 4'd8,
        MIPS_ADDIEXECUTE_S   = 4'd9,
        MIPS_ADDIWRITEBACK_S = 4'd10,
        MIPS_JUMP_S          = 4'd11
    } mips_state_e;

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