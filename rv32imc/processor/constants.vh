`ifndef CONST_VH		// Guard prevents header file from being included more than once
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
`define BANK_DEPTH 2048         // For a 32kB Data Memory, we have a 8192 Block Memory Depth. So, each bank should have a depth of 2048 (8192/4 banks)

`define PC_ADDR_BITS 14         // For addressing 32kB Instruction memory four-way interleaved

// If changing any of the parameters below, double check datamem.v, since some signals
// there don't use parameters.
`define DATAMEM_WIDTH 32                                // Block Memory Width; Can be changed with WORD_WIDTH
`define DATAMEM_DEPTH `BANK_DEPTH + 16 	                // 2048 (COREMEM) + 16(PROTOCOLMEM) Block Memory Depth
`define DATAMEM_BITS `ceilLog2(`DATAMEM_DEPTH) + 2      // 12 bits of addressing to each memory bank + 2 bits for Bank Selection
`define MEMBANK_BITS `ceilLog2(`DATAMEM_DEPTH)          // 12 bits of addressing to each memory bank

//`define WORD_WIDTH           32   // Word width of 32bits; Used for Instructions, operands, and immediates
`define V_REGS 32   //32 vector registers as defined by RVV
`define VLEN 128    //unit:bits ; constant parameter chosen by the implementor [VLEN=VL*SEW]

`define REGFILE_SIZE 32         // Can be changed if implementing RISC-V Floating point extensions,
								// but read up on the RISC-V specifications to be sure.

`define REGFILE_BITS `ceilLog2(`REGFILE_SIZE)

// BHT CONSTANTS
`define BHT_PC_ADDR_BITS `PC_ADDR_BITS-1		// No need to take byte offset of PC address
`define BHT_ENTRY 64							// Only use values in powers of 2
												// NOTE: the BHT is expected to be a 4-way set associative cache
												// even if the size is changed.

`define BHT_SET_BITS `ceilLog2(`BHT_ENTRY/4)     // log2(16)=4
`define BHT_TAG_BITS `BHT_PC_ADDR_BITS - `BHT_SET_BITS      // 9
`define BHT_ENTRY_BITS 4 + `BHT_TAG_BITS + `BHT_PC_ADDR_BITS    // 4 = 2bits saturating counter + 1bit ISR_running + 1bit valid
                                                // 4 + 9 + 13 = 26 bits

// For the following parameters, some values will have to be changed manually
`define BHT_TAG_FIELD `BHT_ENTRY_BITS-2:15      // NOTE: please manually change the LSB when changing PC_ADDR_BITS
                                                // since Verilog does not allow the use of more than 1 parameter
                                                // in defining a vector. The LSB should be equivalent to:
                                                // `BHT_ENTRY_BITS-`BHT_TAG_BITS-2
                                                // 26 - 9 - 2 = 15

`define BHT_PC_TAG_FIELD `BHT_PC_ADDR_BITS-1:4  // Same with this, please change LSB when
                                                // changing BHT size. LSB is equivalent to:
                                                // `BHT_SET_BITS

`define BHT_CNI_TAG_FIELD `BHT_ENTRY_BITS-3:15  // Please change LSB when changing PC_ADDR_BITS
                                                // LSB = `BHT_ENTRY_BITS-`BHT_TAG_BITS-2
                                                // 26 - 9 - 2 = 15

// CONTROLLER CONSTANTS
// Instruction opcodes; can be modified if implementing more extensions
`define OPC_LUI 7'h37
`define OPC_AUIPC 7'h17
`define OPC_JAL 7'h6f
`define OPC_JALR 7'h67
`define OPC_BTYPE 7'h63
`define OPC_ITYPE 7'h13
`define OPC_STYPE 7'h23
`define OPC_RTYPE 7'h33
`define OPC_LOAD 7'h03
`define OPC_URET 7'h73

// ALU opcodes
`define ALU_ADD 4'd1
`define ALU_SUB 4'd2
`define ALU_AND 4'd3
`define ALU_OR  4'd4
`define ALU_XOR 4'd5
`define ALU_SLT 4'd6
`define ALU_SLTU 4'd7
`define ALU_SLL 4'd8
`define ALU_SRL 4'd9
`define ALU_SRA 4'd10
`define ALU_MUL 4'd11
`define ALU_MULH 4'd12
`define ALU_MULHSU 4'd13
`define ALU_MULHU 4'd14

`endif	// CONST_VH