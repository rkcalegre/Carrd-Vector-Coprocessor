`timescale 1ns / 1ps
`include "constants.vh"

class randm;
    randc bit [511:0] regA;                             // register operand A       
    //randc bit[511:0] regB;                             // register operand B          
endclass

module tb_vloadu();
    logic clk, nrst;
    logic [31:0] l_data_in0; 
    logic [31:0] l_data_in1;
    logic [31:0] l_data_in2;
    logic [31:0] l_data_in3;
    logic [3:0] v_lsu_op;
    logic [2:0] lmul;
    logic [2:0] vsew;
    logic [31:0] xreg_out;

    logic [`PC_ADDR_BITS-1:0] data_addr0;
    logic [`PC_ADDR_BITS-1:0] data_addr1;
    logic [`PC_ADDR_BITS-1:0] data_addr2;
    logic [`PC_ADDR_BITS-1:0] data_addr3;

    logic [511:0] l_data_out;
    logic done_vloadu;

    v_loadu uut(
    .clk(clk),
    .l_data_in0(l_data_in0), 
    .l_data_in1(l_data_in1),
    .l_data_in2(l_data_in2),
    .l_data_in3(l_data_in3),
    .v_lsu_op(v_lsu_op),
    .lmul(lmul),
    .vsew(vsew),
    .l_addr(xreg_out),
    .data_addr0(data_addr0),  
    .data_addr1(data_addr1),  
    .data_addr2(data_addr2),  
    .data_addr3(data_addr3),  
    .l_data_out(l_data_out),
    .l_done(done_vloadu)
    );


/* 	// Define parameters for dm_select
	parameter LB = 3'd0;
	parameter LH = 3'd1;
	parameter LW = 3'd2;
	parameter LBU = 3'd4;
	parameter LHU = 3'd5; 

	*/
    randm Reg_Data = new();
	bit [1023:0][3:0][31:0] datamem;
	bit [31:0][127:0] vreg;


	int l_address;
	int err;
	//int s_address;
	bit [511:0] reg_A;

	initial begin 
        // clock source
        clk = 0;
        fork
            forever #20 clk = ~clk;
        join_none  

        nrst = 0;
        #140;

        // disable reset
        nrst = 1;



		l_address = 0;

		// ============| UPDATING V_LSU_OP LOAD | ============

		for (int tb_vlsu_op = 0 ; tb_vlsu_op < 4 ; tb_vlsu_op++ ) begin
			v_lsu_op = tb_vlsu_op;
			xreg_out = l_address;
			case (tb_vlsu_op)
				4'd0: begin
                     $display("===| tb_vlsu_op NO OPERATION | ==="); 
                end
				4'd1: begin
                    $display("===| TESTING VLSU_VLE8 | ==="); 
                    vsew = 3'd0;
                end 
				4'd2: begin
                    $display("===| TESTING VLSU_VLE16 | ===");
                    vsew = 3'd1;
                end 
				4'd3: begin
                    $display("===| TESTING VLSU_VLE32 | ===");
                    vsew = 3'd2;
                end 
				4'd4: $display("===| TESTING VLSU_VLSE8 | ===");
				4'd5: $display("===| TESTING VLSU_VLSE16 | ===");
				4'd6: $display("===| TESTING VLSU_VLSE32 | ===");
				4'd7: $display("===| TESTING VLSU_VSE8 | ===");
				4'd8: $display("===| TESTING VLSU_VSE16 | ===");
				4'd9: $display("===| TESTING VLSU_VSE32 | ===");
				4'd10: $display("===| TESTING VLSU_VSSE8 | ===");
				4'd11: $display("===| TESTING VLSU_VSSE16 | ===");
				4'd12: $display("===| TESTING VLSU_VSSE32 | ===");
				default: $display("===| tb_vlsu_op > 12 | ===");
			endcase

			// ============| UPDATING LMUL | ============

			for (int tb_lmul = 0; tb_lmul < 3; tb_lmul++) begin
				lmul = tb_lmul;

				// ============| Number of Test per instruction and per lmul | ============
				for (int tb_testnum = 1; tb_testnum < 2; tb_testnum++) begin
					//Reg_Data.randomize();
					//reg_A = Reg_Data.regA;
					//reg_A = 512'h4d4d4d4d4c4c4c4c4b4b4b4b4a4a4a4a3d3d3d3d3c3c3c3c3b3b3b3b3a3a3a3a2d2d2d2d2c2c2c2c2b2b2b2b2a2a2a2a1d1d1d1d1c1c1c1c1b1b1b1b1a1a1a1a;
					reg_A = 512'h0d0d0d0d0c0c0c0c0b0b0b0b0a0a0a0a9d9d9d8d9c9c9c8c9b9b9b8b9a9a9a8a7d6d5d4d7c6c5c4c7b6b5b4b7a6a5a4a3d2d1d0d3c2c1c0c3b2b1b0b3a2a1a0a;
					// reg_B = Reg_Data.regB;
					// l_data_in0 = reg_A[31:0];
					// l_data_in1 = reg_A[63:32];
					// l_data_in2 = reg_A[95:64];
					// l_data_in3 = reg_A[127:96];	
					// l_address = l_address + tb_lmul + 1;

					case (tb_lmul)
						0: begin
							l_data_in0 = reg_A[31:0];
							l_data_in1 = reg_A[63:32];
							l_data_in2 = reg_A[95:64];
							l_data_in3 = reg_A[127:96];	
							#40;
							#40;
						end
						1: begin
							l_data_in0 = reg_A[31:0];
							l_data_in1 = reg_A[63:32];
							l_data_in2 = reg_A[95:64];
							l_data_in3 = reg_A[127:96];	
							#40;							
							l_data_in0 = reg_A[159:128];
							l_data_in1 = reg_A[191:160];
							l_data_in2 = reg_A[223:192];
							l_data_in3 = reg_A[255:224];	
							#40;
							#40;
						end
						2: begin
							l_data_in0 = reg_A[31:0];
							l_data_in1 = reg_A[63:32];
							l_data_in2 = reg_A[95:64];
							l_data_in3 = reg_A[127:96];	
							#40;							
							l_data_in0 = reg_A[159:128];
							l_data_in1 = reg_A[191:160];
							l_data_in2 = reg_A[223:192];
							l_data_in3 = reg_A[255:224];
							#40;
							l_data_in0 = reg_A[287:256];
							l_data_in1 = reg_A[319:288];
							l_data_in2 = reg_A[351:320];
							l_data_in3 = reg_A[383:352];	
							#40;							
							l_data_in0 = reg_A[415:384];
							l_data_in1 = reg_A[447:416];
							l_data_in2 = reg_A[479:448];
							l_data_in3 = reg_A[511:480];	
							#40;
							#40;
						end
					endcase

					case (lmul)
						2'd0: begin
							vreg[l_address] = l_data_out[127:0];				
							$strobe("DATAMEMout: 0x%X\tlmul: %d\tl_data_out: 0x%X", {reg_A[127:0]}, lmul, l_data_out[127:0]);
							//$strobe("DATAMEMout: 0x%X\tlmul: %d\tl_data_out: 0x%X", {{384'd0},reg_A[127:0]}, lmul, l_data_out);
							err_chk({{384'd0},reg_A[127:0]}, l_data_out); 
						end
						2'd1: begin
							vreg[l_address] = l_data_out[127:0];								
							vreg[l_address+1] = l_data_out[255:128];											
							$strobe("DATAMEMout: 0x%X\tlmul: %d\tl_data_out: 0x%X", {reg_A[256:0]}, lmul, l_data_out[256:0]);
							//$strobe("DATAMEMout: 0x%X\tlmul: %d\tl_data_out: 0x%X", {{256'd0},reg_A[256:0]}, lmul, l_data_out);
							err_chk({{256'd0},reg_A[256:0]}, l_data_out); 
						end
						2'd2: begin
							vreg[l_address] = l_data_out[127:0];												
							vreg[l_address+1] = l_data_out[255:128];																	
							vreg[l_address+2] = l_data_out[383:256];						
							vreg[l_address+3] = l_data_out[511:384];						
							$strobe("DATAMEMout: 0x%X\tlmul: %d\tl_data_out: 0x%X", reg_A, lmul, l_data_out);
							err_chk(reg_A, l_data_out); 
						end
					endcase	
					
					l_address = l_address + tb_lmul + 1;

				end
                
				//$strobe("DATAMEMout: 0x%X\tlmul: %d\tl_data_out: 0x%X", reg_A, lmul, l_data_out);
				#40;	


			end
		end

		//err_disp(op_instr, sew, lmul, err); 

		//int s_address = 0;

		// ============| UPDATING V_LSU_OP STORE | ============

/* 		for (tb_vlsu_op = 7 ; tb_vlsu_op < 13 ; tb_vlsu_op++ ) begin
			case (tb_vlsu_op)
				4'd0: $display("===| tb_vlsu_op NO OPERATION | ===");
				4'd1: $display("===| TESTING VLSU_VLE8 | ===");
				4'd2: $display("===| TESTING VLSU_VLE16 | ===");
				4'd3: $display("===| TESTING VLSU_VLE32 | ===");
				4'd4: $display("===| TESTING VLSU_VLSE8 | ===");
				4'd5: $display("===| TESTING VLSU_VLSE16 | ===");
				4'd6: $display("===| TESTING VLSU_VLSE32 | ===");
				4'd7: $display("===| TESTING VLSU_VSE8 | ===");
				4'd8: $display("===| TESTING VLSU_VSE16 | ===");
				4'd9: $display("===| TESTING VLSU_VSE32 | ===");
				4'd10: $display("===| TESTING VLSU_VSSE8 | ===");
				4'd11: $display("===| TESTING VLSU_VSSE16 | ===");
				4'd12: $display("===| TESTING VLSU_VSSE32 | ===");
				default: $display("===| tb_vlsu_op > 12 | ===");
			endcase

			#20;

			// ============| UPDATING LMUL | ============

			for (int tb_lmul = 0; tb_lmul < 3; tb_lmul++ ) begin
				lmul = tb_lmul;

				// ============| Number of Test per instruction and per lmul | ============
				for (int tb_testnum = 1; tb_testnum < 5; tb_testnum++) begin
					Reg_Data.randomize();
					reg_A = Reg_Data.regA;
					//reg_B = Reg_Data.regB;
					l_data_in0 = reg_A[0:31];
					l_data_in1 = reg_A[63:32];
					l_data_in2 = reg_A[95:64];
					l_data_in3 = reg_A[127:96];	


				end

				$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tl_data_out: 0x%X", data, byte_offset, l_data_out);
				#20;			
			end
			s_address = lmul + 1;
				
			case (lmul)
				2'd0: begin
					datamem[s_address] = l_data_out[0:127];				
				end
				2'd1: begin
					datamem[s_address] = l_data_out[0:127];				
					datamem[s_address+1] = l_data_out[255:128];					
				end
				2'd2: begin
					datamem[s_address] = l_data_out[0:127];								
					datamem[s_address+1] = l_data_out[255:128];						
					datamem[s_address+2] = l_data_out[383:256];						
					datamem[s_address+3] = l_data_out[511:384];						
				end	
			endcase	
 
		end */

		$finish;
	end

    function void err_chk(logic [511:0] exp_result, logic [511:0] actual_result);

        if (exp_result !== actual_result) begin
            err++;
            $strobe("Error Found. Expected %h. Received %h", exp_result, actual_result);
        end
    endfunction

endmodule