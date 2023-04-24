//`ifndef CONST_VH		// Guard prevents header file from being included more than once
`define CONST_VH

// ceilLog2(x) returns how many bits are needed to represent x values
// EX: 1. ceilLog2(32) = 5 since 5 bits are needed to represent 32 values [0,31]
// EX: 2. ceilLog2(128) = 7 bits to represent 128 values [0,127]
`define ceilLog2(x) ((x) > 2**30 ? 31 : \
                     (x) > 2**29 ? 30 : \
                     (x) > 2**28 ? 29 : \
                     (x) > 2**27 ? 28 : \
                     (x) > 2**26 ? 27 : \
                     (x) > 2**25 ? 26 : \
                     (x) > 2**24 ? 25 : \
                     (x) > 2**23 ? 24 : \
                     (x) > 2**22 ? 23 : \
                     (x) > 2**21 ? 22 : \
                     (x) > 2**20 ? 21 : \
                     (x) > 2**19 ? 20 : \
                     (x) > 2**18 ? 19 : \
                     (x) > 2**17 ? 18 : \
                     (x) > 2**16 ? 17 : \
                     (x) > 2**15 ? 16 : \
                     (x) > 2**14 ? 15 : \
                     (x) > 2**13 ? 14 : \
                     (x) > 2**12 ? 13 : \
                     (x) > 2**11 ? 12 : \
                     (x) > 2**10 ? 11 : \
                     (x) > 2**9 ? 10 : \
                     (x) > 2**8 ? 9 : \
                     (x) > 2**7 ? 8 : \
                     (x) > 2**6 ? 7 : \
                     (x) > 2**5 ? 6 : \
                     (x) > 2**4 ? 5 : \
                     (x) > 2**3 ? 4 : \
                     (x) > 2**2 ? 3 : \
                     (x) > 2**1 ? 2 : \
                     (x) > 2**0 ? 1 : 0)

`define INT_SIG_WIDTH 6         // If changing this, make sure to go to mcont.v so interrupt signals match the width

`define MEM_DEPTH 8192          // For 16kB Halfword-addressable Instruction Memory
`define ISR_DEPTH 512           // ISR
`define MEM_WIDTH 16            // Halfwords
`define WORD_WIDTH 32           // Word width of 32bits; Used for Instructions, operands, and immediates

`define PC_ADDR_BITS 14         // For addressing 16kB Instruction memory

// If changing any of the parameters below, double check datamem.v, since some signals
// there don't use parameters.
`define DATAMEM_WIDTH 32        // Block Memory Width; Can be changed with WORD_WIDTH
`define DATAMEM_DEPTH 8208  	// ~1024~ NEW -- 8192 (COREMEM) + 16(PROTOCOLMEM) Block Memory Depth
`define DATAMEM_BITS `ceilLog2(`DATAMEM_DEPTH)

//`define WORD_WIDTH           32   // Word width of 32bits; Used for Instructions, operands, and immediates
`define V_REGS 32   //32 vector registers as defined by RVV
`define VLEN 128    //unit:bits ; constant parameter chosen by the implementor [VLEN=VL*SEW]

`define REGFILE_SIZE 32         // Can be changed if implementing RISC-V Floating point extensions,
								// but read up on the RISC-V specifications to be sure.




//`endif	// CONST_VH