//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_storeunit.sv -- Vector Load Store Data Unit
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: v_lsu.sv
// Description: 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//                        
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
`include "constants.vh"

module v_lsu #(
    parameter int VLEN = 128
)(
    //Load Unit
    input logic clk,
    input logic nrst,
    input logic [31:0] l_data_in0, 
    input logic [31:0] l_data_in1,
    input logic [31:0] l_data_in2,
    input logic [31:0] l_data_in3,
    input logic [3:0] v_lsu_op,
    input logic [2:0] lmul,
    input logic [2:0] vsew,
    input logic [5:0] stride,
    input logic [`DATAMEM_BITS-1:0] address,
    output logic [511:0] l_data_out,
    output bit l_done,

    //Store Unit
    input logic [511:0] s_data,

    // Each Data Address triggers the write enable of their respective memory bank
    output logic [`DATAMEM_BITS-1:0] data_addr0,
    output logic [`DATAMEM_BITS-1:0] data_addr1,
    output logic [`DATAMEM_BITS-1:0] data_addr2,
    output logic [`DATAMEM_BITS-1:0] data_addr3,
    output logic [`DATAMEM_WIDTH-1:0] data_out0,
    output logic [`DATAMEM_WIDTH-1:0] data_out1,
    output logic [`DATAMEM_WIDTH-1:0] data_out2,
    output logic [`DATAMEM_WIDTH-1:0] data_out3,
    output logic dm_v_write,
    output logic s_done
);

    import v_pkg::*;

    logic [511:0] storedata;
    logic [4:0] elem_per_vreg;
    logic [2:0] instr_vsew;                 //based on instruction vsew
    logic [2:0] num_reg;                    // # of registers to be stored
    logic [4:0] iter;                       // ensures all of the elements in each register are stored
    logic [4:0] exe_cc;                     // # of clock cycles per operation
    wire [1:0] s_cc;
    logic [`DATAMEM_BITS-1:0] temp_addr, temp_addr_load;
    logic [6:0] strided_cc;
    logic nrst_ctr;


    assign elem_per_vreg = (vsew == 3'b000) ? 5'd16 : (vsew == 3'b001) ? 5'd8 : (vsew == 3'b010) ? 5'd4 : 5'd4; 
    assign num_reg = (lmul == 3'b000) ? 3'd1 : (lmul == 3'b001) ? 3'd2 : (lmul == 3'b010) ? 3'd4 : 3'd1;                                                                                // refers to clock cycles
    assign iter = (elem_per_vreg == 5'd16) ? 5'd4 : (elem_per_vreg == 5'd8) ? 5'd2 : (elem_per_vreg == 5'd4) ? 5'd1 : 5'd1;
    assign strided_cc = (v_lsu_op == 4'd10) ? 7'd4 : (v_lsu_op == 4'd11) ? 7'd2 : (v_lsu_op == 4'd12) ? 7'd1 : 7'd4; 
    assign exe_cc = (v_lsu_op inside {[7:9]}) ? num_reg : (v_lsu_op inside {[10:12]}) ? ((stride inside {2,6,10,14}) ? num_reg*2*strided_cc : (stride inside {3,5,7,9,11,13,15}) ? num_reg*1*strided_cc : (stride inside {4,8,12,16}) ? num_reg*4*strided_cc : 0) : 1;
    assign dm_v_write = (v_lsu_op inside {[7:12]}) ? 1 : 0;

    // load signals
    logic [127:0] temp_data;
    logic [511:0] loaddata;
    logic [6:0] max_cc; 	
	logic [6:0] l_cc;
	logic [511:0] hold;
    logic is_vltype;
    assign instr_vsew = (v_lsu_op == 4'd4)? 3'd4 : (v_lsu_op == 3'd5)? 3'd2: 3'd1;
    assign max_cc = (v_lsu_op inside {[1:3]}) ? num_reg : (v_lsu_op inside {[4:6]}) ? (((stride == 6'b0) || (stride == 6'b1)) ? num_reg :(stride[1:0] == 2'd0) ? instr_vsew*num_reg*4 : (stride[1:0] == 2'd1) ? instr_vsew*num_reg : (stride[1:0] == 2'd2) ? instr_vsew*num_reg*2 : instr_vsew*num_reg):  0;
    assign l_done = (l_cc == max_cc + 1)? 1: 0;
    //assign temp_data = (l_cc == max_cc + 1)? loaddata : 0;
    assign is_vltype = (v_lsu_op inside {[1:6]});
    assign temp_addr_load = address + (l_cc* 4);

    // assign temp signals for store
    assign s_cc = out_ctr;
    assign nrst_ctr = (v_lsu_op inside {[7:12]}) ? 1 : 0;
    assign s_done = (out_ctr == exe_cc + 1) ? 1 : 0;

    // instantiate counters
    counter_lsu ctr_store (
        .clk(~clk),
        .nrst(nrst_ctr),
        .out(out_ctr)
    );

    // instantiate clock cycle counter for load
    counter_lsu ctr_load (
        .clk(clk && is_vltype),
        .nrst(nrst && is_vltype),
        .out(l_cc)
    );    

    // set done signal
    /* always @(posedge clk) begin
        if (!nrst) begin
            s_done <= 0;
        end else begin
            if (out_ctr == exe_cc + 1) begin
                s_done <= 1;
            end else
                s_done <= 0;
        end
    end */
    
    always @(posedge l_done) begin
        if (l_done && l_cc == max_cc + 1) begin
            l_data_out <= ((v_lsu_op inside {4,5,6}) && !(stride inside {0,1})) ? ((lmul == 3'b010)? loaddata: (lmul==3'b001) ? {{256{1'b0}},{loaddata[511:256]}}: {{384{1'b0}},{loaddata[511:384]}}):
                                                    ((lmul == 3'b010)? loaddata: (lmul==3'b001) ? {{256{1'b0}},{loaddata[255:0]}}: {{384{1'b0}},{loaddata[127:0]}});
        end else l_data_out <= 0;
    end

    // set initial value of temp address and temp data values
    always @(negedge clk or negedge nrst) begin
        if (!nrst) begin
            temp_addr <= 0;
        end else begin
            if (s_cc == 0) begin                                    // starting value
                temp_addr <= address;
                temp_data <= s_data;
            end else begin
                if (v_lsu_op inside {[7:9]}) begin                  // unit-stride
                    temp_addr <= temp_addr + 4;
                    temp_data <= temp_data >> 128;
                end else if (v_lsu_op == 10) begin                  // vsse8
                    case (stride)
                        2,6,10,14: begin
                            temp_addr <= temp_addr + stride*2;
                            temp_data <= temp_data >> 16;
                        end
                        3,5,7,9,11,13,15: begin
                            temp_addr <= temp_addr + stride*4;
                            temp_data <= temp_data >> 32;
                        end
                        4,8,12,16: begin
                            temp_addr <= temp_addr + 4;
                            temp_data <= temp_data >> 8;
                        end
                        default: begin
                            temp_addr <= 0;
                            temp_data <= 0;
                        end
                    endcase
                end else if (v_lsu_op == 11) begin                  // vsse16
                    case (stride)
                        2,6,10,14: begin
                            temp_addr <= temp_addr + stride*2;
                            temp_data <= temp_data >> 32;
                        end
                        3,5,7,9,11,13,15: begin
                            temp_addr <= temp_addr + stride*4;
                            temp_data <= temp_data >> 64;
                        end
                        4,8,12,16: begin
                            temp_addr <= temp_addr + 4;
                            temp_data <= temp_data >> 16;
                        end
                        default: begin
                            temp_addr <= 0;
                            temp_data <= 0;
                        end
                    endcase
                end else if (v_lsu_op == 12) begin                  // vsse32
                    case (stride)
                        2,6,10,14: begin
                            temp_addr <= temp_addr + stride*2;
                            temp_data <= temp_data >> 64;
                        end
                        3,5,7,9,11,13,15: begin
                            temp_addr <= temp_addr + stride*4;
                            temp_data <= temp_data >> 128;
                        end
                        4,8,12,16: begin
                            temp_addr <= temp_addr + 4;
                            temp_data <= temp_data >> 32;
                        end
                        default: begin
                            temp_addr <= 0;
                            temp_data <= 0;
                        end
                    endcase
                end            
            end
        end
    end

    // set value of output addresses
    always_comb begin
        if (v_lsu_op inside {[7:9]}) begin
            data_addr0 = (s_cc != exe_cc + 1) ? temp_addr     : data_addr0;
            data_addr1 = (s_cc != exe_cc + 1) ? temp_addr + 1 : data_addr1;
            data_addr2 = (s_cc != exe_cc + 1) ? temp_addr + 2 : data_addr2;
            data_addr3 = (s_cc != exe_cc + 1) ? temp_addr + 3 : data_addr3;
        end else if (v_lsu_op inside {[10:12]}) begin
            case (stride)
                2,6,10,14: begin
                    data_addr0 = (s_cc != exe_cc + 1) ? temp_addr          : data_addr0;
                    data_addr1 = (s_cc != exe_cc + 1) ? 0                  : 0;
                    data_addr2 = (s_cc != exe_cc + 1) ? temp_addr + stride : data_addr2;
                    data_addr3 = (s_cc != exe_cc + 1) ? 0                  : 0;
                end
                3,7,11,15: begin
                    data_addr0 = (s_cc != exe_cc + 1) ? temp_addr            : data_addr0;
                    data_addr1 = (s_cc != exe_cc + 1) ? temp_addr + stride*3 : data_addr1;
                    data_addr2 = (s_cc != exe_cc + 1) ? temp_addr + stride*2 : data_addr2;
                    data_addr3 = (s_cc != exe_cc + 1) ? temp_addr + stride   : data_addr3;  
                end
                4,8,12,16: begin
                    data_addr0 = (s_cc != exe_cc + 1) ? temp_addr : data_addr0;
                    data_addr1 = (s_cc != exe_cc + 1) ? 0         : 0;
                    data_addr2 = (s_cc != exe_cc + 1) ? 0         : 0;
                    data_addr3 = (s_cc != exe_cc + 1) ? 0         : 0;
                end
                5,9,13: begin
                    data_addr0 = (s_cc != exe_cc + 1) ? temp_addr            : data_addr0;
                    data_addr1 = (s_cc != exe_cc + 1) ? temp_addr + stride   : data_addr1;
                    data_addr2 = (s_cc != exe_cc + 1) ? temp_addr + stride*2 : data_addr2;
                    data_addr3 = (s_cc != exe_cc + 1) ? temp_addr + stride*3 : data_addr3;
                end
                default: begin
                    data_addr0 = 0;
                    data_addr1 = 0;
                    data_addr2 = 0;
                    data_addr3 = 0;
                end
            endcase
        end else if (v_lsu_op inside {[1:3]}) begin             
//            temp_addr = (l_cc == 0) ? address : temp_addr + 4;
            data_addr0 = (l_cc <= max_cc) ? temp_addr_load : data_addr0;
            data_addr1 = (l_cc <= max_cc) ? temp_addr_load + 1 : data_addr1;
            data_addr2 = (l_cc <= max_cc) ? temp_addr_load + 2 : data_addr2;
            data_addr3 = (l_cc <= max_cc) ? temp_addr_load + 3 : data_addr3;    
        end else if (v_lsu_op inside {[4:6]}) begin
            case (stride[1:0])
                //4,8,12,16
                2'd0: begin
                    data_addr0 = (l_cc <= max_cc) ? temp_addr_load : data_addr0;
                    data_addr1 = (l_cc <= max_cc) ? 0 : 0;
                    data_addr2 = (l_cc <= max_cc) ? 0 : 0;
                    data_addr3 = (l_cc <= max_cc) ? 0 : 0;
                end
                //5,9,13
                2'd1: begin
                    data_addr0 = (l_cc <= max_cc) ? temp_addr_load : data_addr0;
                    data_addr1 = (l_cc <= max_cc) ? temp_addr_load + stride : data_addr1;
                    data_addr2 = (l_cc <= max_cc) ? temp_addr_load + stride*2 : data_addr2;
                    data_addr3 = (l_cc <= max_cc) ? temp_addr_load + stride*3 : data_addr3;
                end
                //2,6,10,14
                2'd2: begin
                    data_addr0 = (l_cc <= max_cc) ? temp_addr_load : data_addr0;
                    data_addr1 = (l_cc <= max_cc) ? 0 : 0;
                    data_addr2 = (l_cc <= max_cc) ? temp_addr_load + stride : data_addr2;
                    data_addr3 = (l_cc <= max_cc) ? 0 : 0;
                end
                //3,7,11,15
                2'd3: begin
                    data_addr0 = (l_cc <= max_cc) ? temp_addr_load : data_addr0;
                    data_addr1 = (l_cc <= max_cc) ? temp_addr_load + stride*3 : data_addr1;
                    data_addr2 = (l_cc <= max_cc) ? temp_addr_load + stride*2 : data_addr2;
                    data_addr3 = (l_cc <= max_cc) ? temp_addr_load + stride : data_addr3;  
                end            
                default: begin
                    data_addr0 = 0;
                    data_addr1 = 0;
                    data_addr2 = 0;
                    data_addr3 = 0;
                end
            endcase
        end else begin
            data_addr0 = 0;
            data_addr1 = 0;
            data_addr2 = 0;
            data_addr3 = 0;
        end
        
    end

    // set value of output data for store
    always_comb begin
        case (v_lsu_op)
            VLSU_VSE8, VLSU_VSE16, VLSU_VSE32: begin
                storedata = temp_data[127:0];
                data_out0 = storedata[31:0];
                data_out1 = storedata[63:32];
                data_out2 = storedata[95:64];
                data_out3 = storedata[127:96];
            end
            VLSU_VSSE8: begin
                case (stride)
                    2,6,10,14: begin
                        storedata = { {496{1'b0}} , {temp_data[15:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                        data_out1 = 0;
                        data_out2 = { {24{storedata[15]}} , {storedata[15:8]} };
                        data_out3 = 0;
                    end
                    3,7,11,15: begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                        data_out1 = { {24{storedata[31]}} , {storedata[31:24]} };
                        data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };                            
                        data_out3 = { {24{storedata[15]}} , {storedata[15:8]} };
                    end
                    4,8,12,16: begin
                        storedata = { {504{1'b0}} , {temp_data[7:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                    end
                    5,9,13:  begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = { {24{storedata[7]}}  , {storedata[7:0]} };
                        data_out1 = { {24{storedata[15]}} , {storedata[15:8]} };
                        data_out2 = { {24{storedata[23]}} , {storedata[23:16]} };
                        data_out3 = { {24{storedata[31]}} , {storedata[31:24]} };
                    end
                    default: begin
                        storedata = 0;
                        data_out0 = 0;
                        data_out1 = 0;
                        data_out2 = 0;
                        data_out3 = 0;
                    end 
                endcase
            end
            VLSU_VSSE16: begin
                case (stride)
                    2,6,10,14: begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                        data_out1 = 0;
                        data_out2 = { {16{storedata[31]}} , {storedata[31:16]} };
                        data_out3 = 0;
                    end
                    3,7,11,15: begin
                        storedata = { {448{1'b0}} , {temp_data[63:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                        data_out1 = { {16{storedata[63]}} , {storedata[63:48]} };
                        data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                        data_out3 = { {16{storedata[31]}} , {storedata[31:16]} };
                    end
                    4,8,12,16: begin
                        storedata = { {496{1'b0}} , {temp_data[15:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                    end
                    5,9,13:  begin
                        storedata = { {448{1'b0}} , {temp_data[63:0]} };
                        data_out0 = { {16{storedata[15]}} , {storedata[15:0]} };
                        data_out1 = { {16{storedata[31]}} , {storedata[31:16]} };
                        data_out2 = { {16{storedata[47]}} , {storedata[47:32]} };
                        data_out3 = { {16{storedata[63]}} , {storedata[63:48]} };
                    end
                    default: begin
                        storedata = 0;
                        data_out0 = 0;
                        data_out1 = 0;
                        data_out2 = 0;
                        data_out3 = 0;     
                    end 
                endcase
            end
            VLSU_VSSE32: begin
                case (stride)
                    2,6,10,14: begin
                        storedata = { {448{1'b0}} , {temp_data[63:0]} };
                        data_out0 = storedata[31:0];
                        data_out1 = 0;
                        data_out2 = storedata[63:32];
                        data_out3 = 0;
                    end
                    3,7,11,15: begin
                        storedata = { {384{1'b0}} , {temp_data[127:0]} };
                        data_out0 = storedata[31:0];
                        data_out1 = storedata[127:96];
                        data_out2 = storedata[95:64];
                        data_out3 = storedata[63:32];
                    end
                    4,8,12,16: begin
                        storedata = { {480{1'b0}} , {temp_data[31:0]} };
                        data_out0 = storedata[31:0];
                    end
                    5,9,13: begin
                        storedata = { {384{1'b0}} , {temp_data[127:0]} };
                        data_out0 = storedata[31:0];
                        data_out1 = storedata[63:32];
                        data_out2 = storedata[95:64];
                        data_out3 = storedata[127:96];
                    end
                    default: begin
                        storedata = 0;
                        data_out0 = 0;
                        data_out1 = 0;
                        data_out2 = 0;
                        data_out3 = 0;
                    end  
                endcase
            end           
            default: begin
                storedata = 0;
                data_out0 = 0;
                data_out1 = 0;
                data_out2 = 0;
                data_out3 = 0;
            end
        endcase
    end

        // set value of output data for Load
    always @(posedge clk) begin
        case (v_lsu_op)
            VLSU_VLE8, VLSU_VLE16, VLSU_VLE32: begin
                case(l_cc)
                    7'd1: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    7'd2: loaddata[255:128] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    7'd3: loaddata[383:256] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    7'd4: loaddata[511:384] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    default: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                endcase
            end
            VLSU_VLSE8: begin
                if (stride == 0 || stride == 1) begin
                    case(l_cc)
                        7'd1: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd2: loaddata[255:128] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd3: loaddata[383:256] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd4: loaddata[511:384] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        default: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    endcase                    
                end else begin
                    case (stride[1:0])
                        //4,8,12,16
                        2'd0: begin
                            temp_data = {{120{1'b0}}, {l_data_in0[7:0]}};
                            loaddata = (l_cc==0) ? {{temp_data[7:0]},{504'd0}}: {temp_data[7:0], hold[503:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 8 : loaddata;
                        end
                        //5,9,13
                        2'd1: begin
                            temp_data = {{96{1'b0}},l_data_in3[7:0],l_data_in2[7:0],l_data_in1[7:0],l_data_in0[7:0]};
                            loaddata = (l_cc==0) ? {{temp_data[31:0]},{480'd0}}: {temp_data[31:0], hold[479:0]};
                           hold = (l_cc <= max_cc)? loaddata >> 32 : loaddata;
                        end
                        //2,6,10,14
                        2'd2: begin
                            temp_data = {{112{1'b0}},l_data_in2[7:0],l_data_in0[7:0]};
                            loaddata = (l_cc==0) ? {{temp_data[15:0]},{496'd0}}: {temp_data[15:0], hold[495:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 16 : loaddata;
                        end
                        //3,7,11,15
                        2'd3: begin
                            temp_data = {{96{1'b0}},l_data_in1[7:0],l_data_in2[7:0],l_data_in3[7:0],l_data_in0[7:0]};
                            loaddata = (l_cc==0) ? {{temp_data[31:0]},{496'd0}}: {temp_data[31:0], hold[479:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 32 : loaddata;
                        end            
                        default: begin
                            temp_data = {{120{1'b0}}, {l_data_in0[7:0]}};
                            loaddata = (l_cc==0) ? {{temp_data[7:0]},{504'd0}}: {temp_data[7:0], hold[503:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 8 : loaddata;
                        end
                    endcase                    
                end
            end 
            VLSU_VLSE16: begin
                if (stride == 0 || stride == 1) begin
                    case(l_cc)
                        7'd1: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd2: loaddata[255:128] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd3: loaddata[383:256] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd4: loaddata[511:384] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        default: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    endcase                    
                end else begin
                    case (stride[1:0])
                        //4,8,12,16
                        2'd0: begin
                            temp_data = {{112{1'b0}},l_data_in0[15:0]};
                            loaddata = (l_cc==0) ? {{temp_data[16:0]},{496'd0}}: {temp_data[15:0], hold[495:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 16 : loaddata;
                        end
                        //5,9,13
                        2'd1: begin
                            temp_data = {{64{1'b0}},l_data_in3[15:0],l_data_in2[15:0],l_data_in1[15:0],l_data_in0[15:0]};
                            loaddata = (l_cc==0) ? {{temp_data[63:0]},{448'd0}}: {temp_data[63:0], hold[447:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 64 : loaddata;
                        end
                        //2,6,10,14
                        2'd2: begin
                            temp_data = {{96{1'b0}},l_data_in2[15:0],l_data_in0[15:0]};
                            loaddata = (l_cc==0) ? {{temp_data[32:0]},{480'd0}}: {temp_data[31:0], hold[479:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 32 : loaddata;
                        end
                        //3,7,11,15
                        2'd3: begin
                            temp_data = {{64{1'b0}},l_data_in1[15:0],l_data_in2[15:0],l_data_in3[15:0],l_data_in0[15:0]};
                            loaddata = (l_cc==0) ? {{temp_data[64:0]},{448'd0}}: {temp_data[63:0], hold[447:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 64 : loaddata;
                        end            
                        default: begin
                            temp_data = {{112{1'b0}},l_data_in0[15:0]};
                            loaddata = (l_cc==0) ? {{temp_data[16:0]},{496'd0}}: {temp_data[15:0], hold[495:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 16 : loaddata;
                        end
                    endcase                    
                end
            end 
            VLSU_VLSE32: begin
                if (stride == 0 || stride == 1) begin
                    case(l_cc)
                        7'd1: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd2: loaddata[255:128] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd3: loaddata[383:256] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        7'd4: loaddata[511:384] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        default: loaddata[127:0] = {{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                    endcase                    
                end else begin
                    case (stride[1:0])
                        //4,8,12,16
                        2'd0: begin
                            temp_data = {{96{1'b0}},l_data_in0};
//                            temp_data = (l_cc[0] == 0)? {{96{1'b0}},32'd6}: {{96{1'b0}},32'd7};
                            loaddata = (l_cc==0) ? {{temp_data[31:0]},{480'd0}}: {temp_data[31:0], hold[479:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 32 : loaddata;
//                            hold = loaddata;
                        end
                        //5,9,13
                        2'd1: begin
                            temp_data = {l_data_in3,l_data_in2,l_data_in1,l_data_in0};
                            loaddata = (l_cc==0) ? {{temp_data[127:0]},{384'd0}}: {temp_data, hold[383:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 128 : loaddata;
                        end
                        //2,6,10,14
                        2'd2: begin
                            temp_data = {{64{1'b0}},l_data_in2,l_data_in0};
                            loaddata = (l_cc==0) ? {{temp_data[64:0]},{448'd0}}: {temp_data[63:0], hold[447:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 64 : loaddata;
                        end
                        //3,7,11,15
                        2'd3: begin
                            temp_data = {l_data_in1,l_data_in2,l_data_in3,l_data_in0};
                            loaddata = (l_cc==0) ? {{temp_data[127:0]},{384'd0}}: {temp_data, hold[383:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 128 : loaddata;
                        end            
                        default: begin
                            temp_data = {{96{1'b0}},l_data_in0};
                            loaddata = (l_cc==0) ? {{temp_data[32:0]},{480'd0}}: {temp_data[31:0], hold[479:0]};
                            hold = (l_cc <= max_cc)? loaddata >> 32 : loaddata;
                        end
                    endcase                    
                end
            end             
            default: begin
                temp_data = 0;
                hold = 0;
            end
        endcase
    end
    
endmodule

// 7-bit Counter
module counter_lsu (
    input clk, 
    input nrst,
    output reg [6:0] out
);
    initial begin
        out <= 0;
    end
    always @(posedge clk or negedge nrst) begin
        if (!nrst)
            out <= 0;
        else    
            out <= out + 1;
    end
    
endmodule
