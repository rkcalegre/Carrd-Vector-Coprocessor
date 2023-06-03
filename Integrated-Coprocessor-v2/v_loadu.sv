`timescale 1ns / 1ps
`include "constants.vh"

module v_loadu(

    input logic clk,
    input logic [31:0] l_data_in0, 
    input logic [31:0] l_data_in1,
    input logic [31:0] l_data_in2,
    input logic [31:0] l_data_in3,
    input logic [3:0] v_lsu_op,
    input logic [2:0] lmul,
    input logic [2:0] vsew,
    input logic [31:0] l_addr,  
    output logic [`DATAMEM_BITS-1:0] data_addr0,
    output logic [`DATAMEM_BITS-1:0] data_addr1,
    output logic [`DATAMEM_BITS-1:0] data_addr2,
    output logic [`DATAMEM_BITS-1:0] data_addr3,
    output logic [511:0] l_data_out,
    output bit l_done

);

    import v_pkg::*;                    // contains constants

    logic [511:0] loaddata;
    //logic [4:0] elem_per_vreg = `VLEN/vsew;
    logic [2:0] num_reg;   // # of registers to be stored
    //int iter = elem_per_vreg / 4;                                                                   // ensures all of the elements in each register are stored
    //int exe_cc = (elem_per_vreg / 4) * iter * num_reg;                                              // # of clock cycles per operation
    //int cc = 0;
    int current_reg = 0;     
                                                                                    // refers to clock cycles
    assign num_reg = (lmul == 3'b000) ? 1 : (lmul == 3'b001) ? 2 : (lmul == 3'b010) ? 4 : 1;   // # of registers to be stored
    //assign iter = elem_per_vreg / 4;                                                                   // ensures all of the elements in each register are stored
    //assign exe_cc = (elem_per_vreg / 4) * iter * num_reg;                                              // # of clock cycles per operation 


    //assign l_done = (current_reg > num_reg);
    //assign done = (current_reg == num_reg);

    //logic [127:0] temp_data;

	logic [32:0] max_count;	
    logic [13:0] calc_addr;
	logic [31:0] l_count = 0;
	logic [511:0] temp;
	logic [511:0] hold;


    assign data_addr0 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr1 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr2 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;
    assign data_addr3 = (l_count == 0)? l_addr : (l_count == 32'd128)? l_addr + 32'd1 : (l_count == 32'd256)? l_addr + 32'd2 : l_addr + 32'd3;

	assign max_count = (lmul ==3'b000) ? 32'd128:
		(lmul ==3'b001) ? 32'd256:
		(lmul ==3'b010) ? 32'd512:
		(lmul ==3'b111) ? 32'd64:
		32'd32;

    always @(posedge clk) begin
        //temp_data = {l_data_in3,l_data_in2, l_data_in1, l_data_in0};
        if (v_lsu_op inside {[1:6]}) begin
            case (v_lsu_op)
                VLSU_VLE8: begin
                        temp ={{32'd384{32'd0}},{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        loaddata = (l_count==0) ? {{(temp[127:0])},{384'd0}}:{{(temp[127:0])},{hold[383:0]}};
                        hold = (l_count==max_count) ? loaddata:loaddata>>128;
                        l_count = l_count + 32'd128;
                end
                VLSU_VLE16: begin
                        temp ={{32'd384{32'd0}},{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        loaddata = (l_count==0) ? {{(temp[127:0])},{384'd0}}:{{(temp[127:0])},{hold[383:0]}};
                        hold = (l_count==max_count) ? loaddata:loaddata>>128;
                        l_count = l_count + 32'd128;
                end
                VLSU_VLE32: begin
                        temp ={{32'd384{32'd0}},{l_data_in3},{l_data_in2},{l_data_in1},{l_data_in0}};
                        loaddata = (l_count==0) ? {{(temp[127:0])},{384'd0}}:{{(temp[127:0])},{hold[383:0]}};
                        hold = (l_count==max_count) ? loaddata:loaddata>>128;
                        l_count = l_count + 32'd128;
                end
                VLSU_VLSE8: begin
                    
                end
                VLSU_VLSE16: begin
                    
                end
                VLSU_VLSE32: begin
                    
                end 
            endcase 
            if (l_count>=max_count)
                begin
                    l_done = 1'b1;
                    l_count = 0;
                    l_data_out = (lmul == 3'b010)? loaddata: (lmul==3'b001) ? {{256{1'b0}},{loaddata[511:256]}}: {{384{1'b0}},{loaddata[511:384]}};
                end
            else
                l_done =1'b0;
        end else l_done =1'b0;


    end 
    

    //assign  l_data_out = loaddata;
    
endmodule