//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_pkg.sv -- Vector Packages
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: v_pkg.sv
// Description: This contains the constants needed for each module
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments
//                        
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

package v_pkg;

// vsew - selected element width (refers to the # of bits per element)
typedef enum logic [1:0] {
    VSEW_8       = 2'b00,
    VSEW_16      = 2'b01,
    VSEW_32      = 2'b10,
    VSEW_INVALID = 2'b11
} vsew;


typedef enum logic [6:0] {
    OPC_LTYPE  = 7'b0000111,          // Vector Load Instructions
    OPC_STYPE  = 7'b0100111,          // Vector Store Instructions
    OPC_RTYPE  = 7'b1010111           // Vector Arithmetic Instructions and Configuration Instructions
} opcode;

 //vector addressing modes for load and store instructions
typedef enum logic [1:0] {
    MOP_UNIT_STRIDE  = 2'b00,           // unit-stride
    MOP_INDEXED_UNORDERED  = 2'b01,     // indexed-unordered
    MOP_STRIDED  = 2'b10,               // strided
    MOP_INDEXED_ORDERED  = 2'b11        // indexed-ordered
} mop; 

typedef enum logic [2:0] {
    WIDTH_8  = 3'b000,
    WIDTH_16 = 3'b101,
    WIDTH_32 = 3'b110
} width;

// funct3 - encodes the operand type (VV: vector-vector, VI: vector-immediate, VX: vector-scalar)
typedef enum logic [2:0] {
    OPI_VV = 3'b000,
    OPF_VV = 3'b001,
    OPM_VV = 3'b010,
    OPI_VI = 3'b011,
    OPI_VX = 3'b100,
    OPF_VF = 3'b101,
    OPM_VX = 3'b110,
    OP_SET = 3'b111
} funct3;

typedef enum logic [5:0] {
    VREDSUM = 6'b000000,
    VREDMAX = 6'b000111
} funct6_red;

typedef enum logic [5:0] {
    VMOVE      = 6'b010111,
    VSLIDEUP   = 6'b001110,        
    VSLIDEDOWN = 6'b001111        
} funct6_sldu;

typedef enum logic [5:0] { 
    VMOVE1      = 6'b010000,       
    VSLIDE1UP    = 6'b001110,      
    VSLIDE1DOWN  = 6'b001111
} funct6_sldu1;


typedef enum logic [5:0] {
    VADD       = 6'b000000, 
    VSUB       = 6'b000010,
    VMIN       = 6'b000101,
    VMAX       = 6'b000111,       
    VAND       = 6'b001001,
    VOR        = 6'b001010,
    VXOR       = 6'b001011,
    VSLL       = 6'b100101,
    VSRL       = 6'b101000,
    VSRA       = 6'b101001,
    VMSEQ      = 6'b011000,
    VMSNE      = 6'b011001,
    VMSLT      = 6'b011011,
    VMSLE      = 6'b011101,
    VMSGT      = 6'b011111
} funct6_alu;

typedef enum logic [5:0] {
    VMUL = 6'b100101
} funct6_mul;

typedef enum logic [3:0] {
    VALU_VADD  = 4'd1,
    VALU_VSUB  = 4'd2,
    VALU_VAND  = 4'd3,
    VALU_VOR   = 4'd4,
    VALU_VXOR  = 4'd5,
    VALU_VSLL  = 4'd6,
    VALU_VSRL  = 4'd7,
    VALU_VSRA  = 4'd8,
    VALU_VMIN  = 4'd9,
    VALU_VMAX  = 4'd10,
    VALU_VMSEQ = 4'd11,
    VALU_VMSNE = 4'd12,
    VALU_VMSLT = 4'd13,
    VALU_VMSLE = 4'd14,
    VALU_VMSGT = 4'd15
} valu_op;

typedef enum logic [2:0] {
    VRED_VREDSUM = 3'd1,
    VRED_VREDMAX = 3'd2
} vred_op;

typedef enum logic [2:0] { 
    VSLDU_VSLIDEUP     = 3'd1,
    VSLDU_VSLIDEDOWN   = 3'd2,
    VSLDU_VSLIDE1UP    = 3'd3,
    VSLDU_VSLIDE1DOWN  = 3'd4,
    VSLDU_VMV          = 3'd5
} vsldu_op;

typedef enum logic [3:0] {
    VLSU_VLE8   = 4'd1,
    VLSU_VLE16  = 4'd2,
    VLSU_VLE32  = 4'd3,
    VLSU_VLSE8  = 4'd4,
    VLSU_VLSE16 = 4'd5,
    VLSU_VLSE32 = 4'd6,
    VLSU_VSE8   = 4'd7,
    VLSU_VSE16  = 4'd8,
    VLSU_VSE32  = 4'd9,
    VLSU_VSSE8  = 4'd10,
    VLSU_VSSE16 = 4'd11,
    VLSU_VSSE32 = 4'd12
} vlsu_op;


endpackage
