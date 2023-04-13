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
    OPC_LTYPE  = 7'b0000111,           // Vector Load Instructions
    OPC_STYPE  = 7'b0100111,           // Vector Store Instructions
    OPC_RTYPE  = 7'b1010111           // Vector Arithmetic Instructions
    //OPC_SET    = 7'b1010111            // Vector Configuration Instructions
} opcode;

 //vector addressing modes for load and store instructions
typedef enum logic [1:0] {
    MOP_UNIT_STRIDE  = 2'b00,           // unit-stride
    MOP_INDEXED_UNORDERED  = 2'b01,     // indexed-unordered
    MOP_STRIDED  = 2'b10,               // strided
    MOP_INDEXED_ORDERED  = 2'b11        // indexed-ordered
} mop; 

// funct3 - encodes the operand type (VV: vector-vector, VI: vector-immediate, VX: vector-scalar)
typedef enum logic [2:0] {
    OPI_VV = 3'b000,
    OPF_VV = 3'b001,
    OPM_VV = 3'b010,
    OPI_VI = 3'b011,
    OPI_VX = 3'b100,
    OPF_VF = 3'b101,
    OPM_VX = 3'b110
} funct3;

// vector arithmetic logic unit (VALU) integer arithmetic instructions
/*
typedef enum logic [5:0] {
    VADD       = 6'b000000,        VREDSUM      = 6'b000000,
    VSUB       = 6'b000010,
    VMIN       = 6'b000101,
    VMAX       = 6'b000111,       
    VAND       = 6'b001001,
    VOR        = 6'b001010,
    VXOR       = 6'b001011,
    VSLIDEUP   = 6'b001110,        VSLIDE1UP    = 6'b001110,
    VSLIDEDOWN = 6'b001111,        VSLIDE1DOWN  = 6'b001111,
    VSLL       = 6'b100101,        VMUL         = 6'b100101,     
                                   VMULH        = 6'b100111, 
    VSRL       = 6'b101000,
    VSRA       = 6'b100101,
    VMERGE     = 6'b010111,
    VMSEQ      = 6'b011000,
    VMSNE      = 6'b011001,
    VMSLT      = 6'b011011,
    VMSLE      = 6'b011101,
    VMSGT      = 6'b011111
} funct6_alu;
*/

typedef enum logic [5:0] {
    VREDSUM = 6'b000000,
    VREDMAX = 6'b000111
} funct6_red;

typedef enum logic [5:0] {
    VMOVE = 6'b010111,
    VSLIDEUP   = 6'b001110,        
    VSLIDE1UP    = 6'b101110,
    VSLIDEDOWN = 6'b001111,        
    VSLIDE1DOWN  = 6'b101111
} funct6_sldu;


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
    VMERGE     = 6'b010111,
    VMSEQ      = 6'b011000,
    VMSNE      = 6'b011001,
    VMSLT      = 6'b011011,
    VMSLE      = 6'b011101,
    VMSGT      = 6'b011111
} funct6_alu;

endpackage