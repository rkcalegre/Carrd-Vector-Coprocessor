//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// v_sldu.sv -- Vector Slide Unit
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 199 Carrd: RISC-V Vector Coprocessor Group (2SAY2223)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: v_sldu.sv
// Description: The VSLDU supports 1) slide up and slide down
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
//                        
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
//`include "vstructs.sv"

module v_sldu #(
    parameter int VECTOR_LENGTH = 128,          // Vector Register length in bits (# of bits per v_reg)
    parameter int ELEMENT_WIDTH = 8,            // Supported effective element widths (EEW) = 8, 16, 32
    parameter int VALU_OP_W_MAX = 32           // VALU operand width in bits (EEW - effective element width)
)(
    input clk,
    input nrst,
    input logic [2:0] op_instr,
    input logic [2:0] sew,
    input logic [2:0] lmul,
    input logic [VECTOR_LENGTH-1:0] vs2_1,//vs2
    input logic [VECTOR_LENGTH-1:0] vs2_2,//vs2
    input logic [VECTOR_LENGTH-1:0] vs2_3,//vs2
    input logic [VECTOR_LENGTH-1:0] vs2_4,//vs2 to accomodate lmul=4
    input logic [VECTOR_LENGTH-1:0] rs1,//rs1     redefine limit of range (currently VECTOR_LENGTH)
    output bit done_vsldu,
    output logic [4*VECTOR_LENGTH-1:0] result //vd
);

    //logic [VALU_OP_W_MAX-1:0] element = vs2[0:VALU_OP_W_MAX-1]; //vs2            
    //logic [VALU_OP_W_MAX-1:0] result;  //vd

    import v_pkg::*;
    logic [4*VECTOR_LENGTH-1:0] vector; //vs2
    //logic [6:0] temp_rs1 = rs1[6:0];         

    assign vector ={vs2_4,vs2_3,vs2_2,vs2_1};

    always @(op_instr, vs2_4,vs2_3,vs2_2,vs2_1, rs1) begin
        done_vsldu = 0;
    end

    always @(posedge clk) begin
        // vslideup, vslidedown, vslide1up, vslide1down, vmv
        case (op_instr)
            VSLDU_VSLIDE1UP: begin //VSLIDE1UP
                case (sew)
                    3'b000: result = {{vector[503:0]},{rs1[7:0]}}; //sew = 8
                    3'b001: result = {{vector[495:0]},{rs1[15:0]}}; //sew = 16
                    3'b010: result = {{vector[479:0]},{rs1[31:0]}}; //sew = 32
                    default: result = {{vector[503:0]},{rs1[7:0]}}; //sew = 8
                endcase
                done_vsldu = 1;
            end

            VSLDU_VSLIDEUP: begin
	           case(sew)
	           default: begin //sew=8
	               case(rs1[6:0])
                        7'd0: result = vector;
                        7'd1: result = {{vector[503:0]},{vector[7:0]}};
                        7'd2: result = {{vector[495:0]},{vector[15:0]}};
                        7'd3: result = {{vector[487:0]},{vector[23:0]}};
                        7'd4: result = {{vector[479:0]},{vector[31:0]}};
                        7'd5: result = {{vector[471:0]},{vector[39:0]}};
                        7'd6: result = {{vector[463:0]},{vector[47:0]}};
                        7'd7: result = {{vector[455:0]},{vector[55:0]}};
                        7'd8: result = {{vector[447:0]},{vector[63:0]}};
                        7'd9: result = {{vector[439:0]},{vector[71:0]}};
                        7'd10: result = {{vector[431:0]},{vector[79:0]}};
                        7'd11: result = {{vector[423:0]},{vector[87:0]}};
                        7'd12: result = {{vector[415:0]},{vector[95:0]}};
                        7'd13: result = {{vector[407:0]},{vector[103:0]}};
                        7'd14: result = {{vector[399:0]},{vector[111:0]}};
                        7'd15: result = {{vector[391:0]},{vector[119:0]}};
                        7'd16: result = {{vector[383:0]},{vector[127:0]}};
                        7'd17: result = {{vector[375:0]},{vector[135:0]}};
                        7'd18: result = {{vector[367:0]},{vector[143:0]}};
                        7'd19: result = {{vector[359:0]},{vector[151:0]}};
                        7'd20: result = {{vector[351:0]},{vector[159:0]}};
                        7'd21: result = {{vector[343:0]},{vector[167:0]}};
                        7'd22: result = {{vector[335:0]},{vector[175:0]}};
                        7'd23: result = {{vector[327:0]},{vector[183:0]}};
                        7'd24: result = {{vector[319:0]},{vector[191:0]}};
                        7'd25: result = {{vector[311:0]},{vector[199:0]}};
                        7'd26: result = {{vector[303:0]},{vector[207:0]}};
                        7'd27: result = {{vector[295:0]},{vector[215:0]}};
                        7'd28: result = {{vector[287:0]},{vector[223:0]}};
                        7'd29: result = {{vector[279:0]},{vector[231:0]}};
                        7'd30: result = {{vector[271:0]},{vector[239:0]}};
                        7'd31: result = {{vector[263:0]},{vector[247:0]}};
                        7'd32: result = {{vector[255:0]},{vector[255:0]}};
                        7'd33: result = {{vector[247:0]},{vector[263:0]}};
                        7'd34: result = {{vector[239:0]},{vector[271:0]}};
                        7'd35: result = {{vector[231:0]},{vector[279:0]}};
                        7'd36: result = {{vector[223:0]},{vector[287:0]}};
                        7'd37: result = {{vector[215:0]},{vector[295:0]}};
                        7'd38: result = {{vector[207:0]},{vector[303:0]}};
                        7'd39: result = {{vector[199:0]},{vector[311:0]}};
                        7'd40: result = {{vector[191:0]},{vector[319:0]}};
                        7'd41: result = {{vector[183:0]},{vector[327:0]}};
                        7'd42: result = {{vector[175:0]},{vector[335:0]}};
                        7'd43: result = {{vector[167:0]},{vector[343:0]}};
                        7'd44: result = {{vector[159:0]},{vector[351:0]}};
                        7'd45: result = {{vector[151:0]},{vector[359:0]}};
                        7'd46: result = {{vector[143:0]},{vector[367:0]}};
                        7'd47: result = {{vector[135:0]},{vector[375:0]}};
                        7'd48: result = {{vector[127:0]},{vector[383:0]}};
                        7'd49: result = {{vector[119:0]},{vector[391:0]}};
                        7'd50: result = {{vector[111:0]},{vector[399:0]}};
                        7'd51: result = {{vector[103:0]},{vector[407:0]}};
                        7'd52: result = {{vector[95:0]},{vector[415:0]}};
                        7'd53: result = {{vector[87:0]},{vector[423:0]}};
                        7'd54: result = {{vector[79:0]},{vector[431:0]}};
                        7'd55: result = {{vector[71:0]},{vector[439:0]}};
                        7'd56: result = {{vector[63:0]},{vector[447:0]}};
                        7'd57: result = {{vector[55:0]},{vector[455:0]}};
                        7'd58: result = {{vector[47:0]},{vector[463:0]}};
                        7'd59: result = {{vector[39:0]},{vector[471:0]}};
                        7'd60: result = {{vector[31:0]},{vector[479:0]}};
                        7'd61: result = {{vector[23:0]},{vector[487:0]}};
                        7'd62: result = {{vector[15:0]},{vector[495:0]}};
                        7'd63: result = {{vector[7:0]},{vector[503:0]}};
                        default: result = vector;
	                endcase
	            end
	           3'b001: begin  //sew=16 
	                case(rs1[6:0])
                        7'd0: result = vector;
                        7'd1: result = {{vector[495:0]},{vector[15:0]}};
                        7'd2: result = {{vector[479:0]},{vector[31:0]}};
                        7'd3: result = {{vector[463:0]},{vector[47:0]}};
                        7'd4: result = {{vector[447:0]},{vector[63:0]}};
                        7'd5: result = {{vector[431:0]},{vector[79:0]}};
                        7'd6: result = {{vector[415:0]},{vector[95:0]}};
                        7'd7: result = {{vector[399:0]},{vector[111:0]}};
                        7'd8: result = {{vector[383:0]},{vector[127:0]}};
                        7'd9: result = {{vector[367:0]},{vector[143:0]}};
                        7'd10: result = {{vector[351:0]},{vector[159:0]}};
                        7'd11: result = {{vector[335:0]},{vector[175:0]}};
                        7'd12: result = {{vector[319:0]},{vector[191:0]}};
                        7'd13: result = {{vector[303:0]},{vector[207:0]}};
                        7'd14: result = {{vector[287:0]},{vector[223:0]}};
                        7'd15: result = {{vector[271:0]},{vector[239:0]}};
                        7'd16: result = {{vector[255:0]},{vector[255:0]}};
                        7'd17: result = {{vector[239:0]},{vector[271:0]}};
                        7'd18: result = {{vector[223:0]},{vector[287:0]}};
                        7'd19: result = {{vector[207:0]},{vector[303:0]}};
                        7'd20: result = {{vector[191:0]},{vector[319:0]}};
                        7'd21: result = {{vector[175:0]},{vector[335:0]}};
                        7'd22: result = {{vector[159:0]},{vector[351:0]}};
                        7'd23: result = {{vector[143:0]},{vector[367:0]}};
                        7'd24: result = {{vector[127:0]},{vector[383:0]}};
                        7'd25: result = {{vector[111:0]},{vector[399:0]}};
                        7'd26: result = {{vector[95:0]},{vector[415:0]}};
                        7'd27: result = {{vector[79:0]},{vector[431:0]}};
                        7'd28: result = {{vector[63:0]},{vector[447:0]}};
                        7'd29: result = {{vector[47:0]},{vector[463:0]}};
                        7'd30: result = {{vector[31:0]},{vector[479:0]}};
                        7'd31: result = {{vector[15:0]},{vector[495:0]}};
                        default: result = vector;
                    endcase
                end
	           3'b010: begin   //sew=32
	               case(rs1[6:0])
                        7'd0: result = vector;
                        7'd1: result = {{vector[479:0]},{vector[31:0]}};
                        7'd2: result = {{vector[447:0]},{vector[63:0]}};
                        7'd3: result = {{vector[415:0]},{vector[95:0]}};
                        7'd4: result = {{vector[383:0]},{vector[127:0]}};
                        7'd5: result = {{vector[351:0]},{vector[159:0]}};
                        7'd6: result = {{vector[319:0]},{vector[191:0]}};
                        7'd7: result = {{vector[287:0]},{vector[223:0]}};
                        7'd8: result = {{vector[255:0]},{vector[255:0]}};
                        7'd9: result = {{vector[223:0]},{vector[287:0]}};
                        7'd10: result = {{vector[191:0]},{vector[319:0]}};
                        7'd11: result = {{vector[159:0]},{vector[351:0]}};
                        7'd12: result = {{vector[127:0]},{vector[383:0]}};
                        7'd13: result = {{vector[95:0]},{vector[415:0]}};
                        7'd14: result = {{vector[63:0]},{vector[447:0]}};
                        7'd15: result = {{vector[31:0]},{vector[479:0]}};
                        default: result = vector;
	               endcase
	            end
                endcase
                done_vsldu = 1;
            end

            /*
            VSLIDE1DOWN: begin //VSLIDE1DOWN
                case(lmul)
                default:result = {{384{1'b0}},{rs1[ELEMENT_WIDTH-1:0]},{vector[127:ELEMENT_WIDTH]}};
                3'b000: result = {{384{1'b0}},{rs1[ELEMENT_WIDTH-1:0]},{vector[127:ELEMENT_WIDTH]}};
                3'b001: result = {{256{1'b0}},{rs1[ELEMENT_WIDTH-1:0]},{vector[255:ELEMENT_WIDTH]}};
                3'b010: result = {{rs1[ELEMENT_WIDTH-1:0]},{vector[511:ELEMENT_WIDTH]}};
                endcase
            end
            */

            VSLDU_VSLIDE1DOWN: begin //VSLIDE1DOWN
                case(lmul)
                default: begin
                    case (sew)
                    3'b000: result = {{384{1'b0}},{rs1[7:0]},{vector[127:8]}}; //sew = 8
                    3'b001: result = {{384{1'b0}},{rs1[15:0]},{vector[127:16]}}; //sew = 16
                    3'b010: result = {{384{1'b0}},{rs1[31:0]},{vector[127:32]}}; //sew = 32
                    default: result = {{384{1'b0}},{rs1[7:0]},{vector[127:8]}}; //sew = 8
                endcase
                end //result = {{384{1'b0}},{rs1[ELEMENT_WIDTH-1:0]},{vector[127:ELEMENT_WIDTH]}};
                3'b000: begin
                    case (sew)
                        3'b000: result = {{384{1'b0}},{rs1[7:0]},{vector[127:8]}}; //sew = 8
                        3'b001: result = {{384{1'b0}},{rs1[15:0]},{vector[127:16]}}; //sew = 16
                        3'b010: result = {{384{1'b0}},{rs1[31:0]},{vector[127:32]}}; //sew = 32
                        default: result = {{384{1'b0}},{rs1[7:0]},{vector[127:8]}}; //sew = 8
                    endcase
                end //result = {{384{1'b0}},{rs1[ELEMENT_WIDTH-1:0]},{vector[127:ELEMENT_WIDTH]}};
                3'b001: begin
                    case (sew)
                        3'b000: result = {{256{1'b0}},{rs1[7:0]},{vector[255:8]}}; //sew = 8
                        3'b001: result = {{256{1'b0}},{rs1[15:0]},{vector[255:16]}}; //sew = 16
                        3'b010: result = {{256{1'b0}},{rs1[31:0]},{vector[255:32]}}; //sew = 32
                        default: result = {{256{1'b0}},{rs1[7:0]},{vector[255:8]}}; //sew = 8
                    endcase
                end //result = {{256{1'b0}},{rs1[ELEMENT_WIDTH-1:0]},{vector[255:ELEMENT_WIDTH]}};
                3'b010: begin
                    case (sew)
                        3'b000: result = {{rs1[7:0]},{vector[511:8]}}; //sew = 8
                        3'b001: result = {{rs1[15:0]},{vector[511:16]}}; //sew = 16
                        3'b010: result = {{rs1[31:0]},{vector[511:32]}}; //sew = 32
                        default: result = {{rs1[7:0]},{vector[511:8]}}; //sew = 8
                    endcase
                end //result = {{rs1[ELEMENT_WIDTH-1:0]},{vector[511:ELEMENT_WIDTH]}};
                endcase
                done_vsldu = 1;
            end               

            VSLDU_VSLIDEDOWN: begin
	            case(sew)
	            default: //sew=8
	               case(lmul)
	               default:
	                   case(rs1[6:0])
                      	    7'd0: result = vector;
                            7'd1: result = {{392{1'b0}},{vector[127:8]}};
                            7'd2: result = {{400{1'b0}},{vector[127:16]}};
                            7'd3: result = {{408{1'b0}},{vector[127:24]}};
                            7'd4: result = {{416{1'b0}},{vector[127:32]}};
                            7'd5: result = {{424{1'b0}},{vector[127:40]}};
                            7'd6: result = {{432{1'b0}},{vector[127:48]}};
                            7'd7: result = {{440{1'b0}},{vector[127:56]}};
                            7'd8: result = {{448{1'b0}},{vector[127:64]}};
                            7'd9: result = {{456{1'b0}},{vector[127:72]}};
                            7'd10: result = {{464{1'b0}},{vector[127:80]}};
                            7'd11: result = {{472{1'b0}},{vector[127:88]}};
                            7'd12: result = {{480{1'b0}},{vector[127:96]}};
                            7'd13: result = {{488{1'b0}},{vector[127:104]}};
                            7'd14: result = {{496{1'b0}},{vector[127:112]}};
                            7'd15: result = {{504{1'b0}},{vector[127:120]}};
                            default: result = 0;
	                   endcase
	               3'b000:
	                   case(rs1[6:0])
	                       7'd0: result = vector;
                            7'd1: result = {{392{1'b0}},{vector[127:8]}};
                            7'd2: result = {{400{1'b0}},{vector[127:16]}};
                            7'd3: result = {{408{1'b0}},{vector[127:24]}};
                            7'd4: result = {{416{1'b0}},{vector[127:32]}};
                            7'd5: result = {{424{1'b0}},{vector[127:40]}};
                            7'd6: result = {{432{1'b0}},{vector[127:48]}};
                            7'd7: result = {{440{1'b0}},{vector[127:56]}};
                            7'd8: result = {{448{1'b0}},{vector[127:64]}};
                            7'd9: result = {{456{1'b0}},{vector[127:72]}};
                            7'd10: result = {{464{1'b0}},{vector[127:80]}};
                            7'd11: result = {{472{1'b0}},{vector[127:88]}};
                            7'd12: result = {{480{1'b0}},{vector[127:96]}};
                            7'd13: result = {{488{1'b0}},{vector[127:104]}};
                            7'd14: result = {{496{1'b0}},{vector[127:112]}};
                            7'd15: result = {{504{1'b0}},{vector[127:120]}};
                            default: result = 0;
	                   endcase
	               3'b001:
	                   case(rs1[6:0])
	                       7'd0: result = vector;
                            7'd1: result = {{264{1'b0}},{vector[255:8]}};
                            7'd2: result = {{272{1'b0}},{vector[255:16]}};
                            7'd3: result = {{280{1'b0}},{vector[255:24]}};
                            7'd4: result = {{288{1'b0}},{vector[255:32]}};
                            7'd5: result = {{296{1'b0}},{vector[255:40]}};
                            7'd6: result = {{304{1'b0}},{vector[255:48]}};
                            7'd7: result = {{312{1'b0}},{vector[255:56]}};
                            7'd8: result = {{320{1'b0}},{vector[255:64]}};
                            7'd9: result = {{328{1'b0}},{vector[255:72]}};
                            7'd10: result = {{336{1'b0}},{vector[255:80]}};
                            7'd11: result = {{344{1'b0}},{vector[255:88]}};
                            7'd12: result = {{352{1'b0}},{vector[255:96]}};
                            7'd13: result = {{360{1'b0}},{vector[255:104]}};
                            7'd14: result = {{368{1'b0}},{vector[255:112]}};
                            7'd15: result = {{376{1'b0}},{vector[255:120]}};
                            7'd16: result = {{384{1'b0}},{vector[255:128]}};
                            7'd17: result = {{392{1'b0}},{vector[255:136]}};
                            7'd18: result = {{400{1'b0}},{vector[255:144]}};
                            7'd19: result = {{408{1'b0}},{vector[255:152]}};
                            7'd20: result = {{416{1'b0}},{vector[255:160]}};
                            7'd21: result = {{424{1'b0}},{vector[255:168]}};
                            7'd22: result = {{432{1'b0}},{vector[255:176]}};
                            7'd23: result = {{440{1'b0}},{vector[255:184]}};
                            7'd24: result = {{448{1'b0}},{vector[255:192]}};
                            7'd25: result = {{456{1'b0}},{vector[255:200]}};
                            7'd26: result = {{464{1'b0}},{vector[255:208]}};
                            7'd27: result = {{472{1'b0}},{vector[255:216]}};
                            7'd28: result = {{480{1'b0}},{vector[255:224]}};
                            7'd29: result = {{488{1'b0}},{vector[255:232]}};
                            7'd30: result = {{496{1'b0}},{vector[255:240]}};
                            7'd31: result = {{504{1'b0}},{vector[255:248]}};
                            default: result = 0;
	                   endcase
	               3'b010:
	                   case(rs1[6:0])
	                   7'd0: result = vector;
                           7'd1: result = {{8{1'b0}},{vector[511:8]}};
                            7'd2: result = {{16{1'b0}},{vector[511:16]}};
                            7'd3: result = {{24{1'b0}},{vector[511:24]}};
                            7'd4: result = {{32{1'b0}},{vector[511:32]}};
                            7'd5: result = {{40{1'b0}},{vector[511:40]}};
                            7'd6: result = {{48{1'b0}},{vector[511:48]}};
                            7'd7: result = {{56{1'b0}},{vector[511:56]}};
                            7'd8: result = {{64{1'b0}},{vector[511:64]}};
                            7'd9: result = {{72{1'b0}},{vector[511:72]}};
                            7'd10: result = {{80{1'b0}},{vector[511:80]}};
                            7'd11: result = {{88{1'b0}},{vector[511:88]}};
                            7'd12: result = {{96{1'b0}},{vector[511:96]}};
                            7'd13: result = {{104{1'b0}},{vector[511:104]}};
                            7'd14: result = {{112{1'b0}},{vector[511:112]}};
                            7'd15: result = {{120{1'b0}},{vector[511:120]}};
                            7'd16: result = {{128{1'b0}},{vector[511:128]}};
                            7'd17: result = {{136{1'b0}},{vector[511:136]}};
                            7'd18: result = {{144{1'b0}},{vector[511:144]}};
                            7'd19: result = {{152{1'b0}},{vector[511:152]}};
                            7'd20: result = {{160{1'b0}},{vector[511:160]}};
                            7'd21: result = {{168{1'b0}},{vector[511:168]}};
                            7'd22: result = {{176{1'b0}},{vector[511:176]}};
                            7'd23: result = {{184{1'b0}},{vector[511:184]}};
                            7'd24: result = {{192{1'b0}},{vector[511:192]}};
                            7'd25: result = {{200{1'b0}},{vector[511:200]}};
                            7'd26: result = {{208{1'b0}},{vector[511:208]}};
                            7'd27: result = {{216{1'b0}},{vector[511:216]}};
                            7'd28: result = {{224{1'b0}},{vector[511:224]}};
                            7'd29: result = {{232{1'b0}},{vector[511:232]}};
                            7'd30: result = {{240{1'b0}},{vector[511:240]}};
                            7'd31: result = {{248{1'b0}},{vector[511:248]}};
                            7'd32: result = {{256{1'b0}},{vector[511:256]}};
                            7'd33: result = {{264{1'b0}},{vector[511:264]}};
                            7'd34: result = {{272{1'b0}},{vector[511:272]}};
                            7'd35: result = {{280{1'b0}},{vector[511:280]}};
                            7'd36: result = {{288{1'b0}},{vector[511:288]}};
                            7'd37: result = {{296{1'b0}},{vector[511:296]}};
                            7'd38: result = {{304{1'b0}},{vector[511:304]}};
                            7'd39: result = {{312{1'b0}},{vector[511:312]}};
                            7'd40: result = {{320{1'b0}},{vector[511:320]}};
                            7'd41: result = {{328{1'b0}},{vector[511:328]}};
                            7'd42: result = {{336{1'b0}},{vector[511:336]}};
                            7'd43: result = {{344{1'b0}},{vector[511:344]}};
                            7'd44: result = {{352{1'b0}},{vector[511:352]}};
                            7'd45: result = {{360{1'b0}},{vector[511:360]}};
                            7'd46: result = {{368{1'b0}},{vector[511:368]}};
                            7'd47: result = {{376{1'b0}},{vector[511:376]}};
                            7'd48: result = {{384{1'b0}},{vector[511:384]}};
                            7'd49: result = {{392{1'b0}},{vector[511:392]}};
                            7'd50: result = {{400{1'b0}},{vector[511:400]}};
                            7'd51: result = {{408{1'b0}},{vector[511:408]}};
                            7'd52: result = {{416{1'b0}},{vector[511:416]}};
                            7'd53: result = {{424{1'b0}},{vector[511:424]}};
                            7'd54: result = {{432{1'b0}},{vector[511:432]}};
                            7'd55: result = {{440{1'b0}},{vector[511:440]}};
                            7'd56: result = {{448{1'b0}},{vector[511:448]}};
                            7'd57: result = {{456{1'b0}},{vector[511:456]}};
                            7'd58: result = {{464{1'b0}},{vector[511:464]}};
                            7'd59: result = {{472{1'b0}},{vector[511:472]}};
                            7'd60: result = {{480{1'b0}},{vector[511:480]}};
                            7'd61: result = {{488{1'b0}},{vector[511:488]}};
                            7'd62: result = {{496{1'b0}},{vector[511:496]}};
                            7'd63: result = {{504{1'b0}},{vector[511:504]}};
                            default: result = 0;
	                   endcase
	               endcase
	           3'b001: //sew=16
	               case(lmul)
	               default:
	                   case(rs1[6:0])
	                      7'd0: result = vector;
                            7'd1: result = {{400{1'b0}},{vector[127:16]}};
                            7'd2: result = {{416{1'b0}},{vector[127:32]}};
                            7'd3: result = {{432{1'b0}},{vector[127:48]}};
                            7'd4: result = {{448{1'b0}},{vector[127:64]}};
                            7'd5: result = {{464{1'b0}},{vector[127:80]}};
                            7'd6: result = {{480{1'b0}},{vector[127:96]}};
                            7'd7: result = {{496{1'b0}},{vector[127:112]}};
                            default: result = 0;
	                   endcase
	               3'b000:
	                   case(rs1[6:0])
	                       7'd0: result = vector;
                            7'd1: result = {{400{1'b0}},{vector[127:16]}};
                            7'd2: result = {{416{1'b0}},{vector[127:32]}};
                            7'd3: result = {{432{1'b0}},{vector[127:48]}};
                            7'd4: result = {{448{1'b0}},{vector[127:64]}};
                            7'd5: result = {{464{1'b0}},{vector[127:80]}};
                            7'd6: result = {{480{1'b0}},{vector[127:96]}};
                            7'd7: result = {{496{1'b0}},{vector[127:112]}};
                            default: result = 0;
	                   endcase
	               3'b001:
	                   case(rs1[6:0])
	                       7'd0: result = vector;
                            7'd1: result = {{272{1'b0}},{vector[255:16]}};
                            7'd2: result = {{288{1'b0}},{vector[255:32]}};
                            7'd3: result = {{304{1'b0}},{vector[255:48]}};
                            7'd4: result = {{320{1'b0}},{vector[255:64]}};
                            7'd5: result = {{336{1'b0}},{vector[255:80]}};
                            7'd6: result = {{352{1'b0}},{vector[255:96]}};
                            7'd7: result = {{368{1'b0}},{vector[255:112]}};
                            7'd8: result = {{384{1'b0}},{vector[255:128]}};
                            7'd9: result = {{400{1'b0}},{vector[255:144]}};
                            7'd10: result = {{416{1'b0}},{vector[255:160]}};
                            7'd11: result = {{432{1'b0}},{vector[255:176]}};
                            7'd12: result = {{448{1'b0}},{vector[255:192]}};
                            7'd13: result = {{464{1'b0}},{vector[255:208]}};
                            7'd14: result = {{480{1'b0}},{vector[255:224]}};
                            7'd15: result = {{496{1'b0}},{vector[255:240]}};
                            default: result = 0;
	                   endcase
	               3'b010:
	                   case(rs1[6:0])
	                  7'd0: result = vector;
                        7'd1: result = {{16{1'b0}},{vector[511:16]}};
                        7'd2: result = {{32{1'b0}},{vector[511:32]}};
                        7'd3: result = {{48{1'b0}},{vector[511:48]}};
                        7'd4: result = {{64{1'b0}},{vector[511:64]}};
                        7'd5: result = {{80{1'b0}},{vector[511:80]}};
                        7'd6: result = {{96{1'b0}},{vector[511:96]}};
                        7'd7: result = {{112{1'b0}},{vector[511:112]}};
                        7'd8: result = {{128{1'b0}},{vector[511:128]}};
                        7'd9: result = {{144{1'b0}},{vector[511:144]}};
                        7'd10: result = {{160{1'b0}},{vector[511:160]}};
                        7'd11: result = {{176{1'b0}},{vector[511:176]}};
                        7'd12: result = {{192{1'b0}},{vector[511:192]}};
                        7'd13: result = {{208{1'b0}},{vector[511:208]}};
                        7'd14: result = {{224{1'b0}},{vector[511:224]}};
                        7'd15: result = {{240{1'b0}},{vector[511:240]}};
                        7'd16: result = {{256{1'b0}},{vector[511:256]}};
                        7'd17: result = {{272{1'b0}},{vector[511:272]}};
                        7'd18: result = {{288{1'b0}},{vector[511:288]}};
                        7'd19: result = {{304{1'b0}},{vector[511:304]}};
                        7'd20: result = {{320{1'b0}},{vector[511:320]}};
                        7'd21: result = {{336{1'b0}},{vector[511:336]}};
                        7'd22: result = {{352{1'b0}},{vector[511:352]}};
                        7'd23: result = {{368{1'b0}},{vector[511:368]}};
                        7'd24: result = {{384{1'b0}},{vector[511:384]}};
                        7'd25: result = {{400{1'b0}},{vector[511:400]}};
                        7'd26: result = {{416{1'b0}},{vector[511:416]}};
                        7'd27: result = {{432{1'b0}},{vector[511:432]}};
                        7'd28: result = {{448{1'b0}},{vector[511:448]}};
                        7'd29: result = {{464{1'b0}},{vector[511:464]}};
                        7'd30: result = {{480{1'b0}},{vector[511:480]}};
                        7'd31: result = {{496{1'b0}},{vector[511:496]}};
                        default: result = 0;
	                   endcase
	               endcase
	           3'b010: //sew=32
	               case(lmul)
	               default:
	                   case(rs1[6:0])
	                      7'd00: result = vector;
	                      7'd1: result = {{416{1'b0}},{vector[127:32]}};
                            7'd2: result = {{448{1'b0}},{vector[127:64]}};
                            7'd3: result = {{480{1'b0}},{vector[127:96]}};
	                       default: result = 0;
	                   endcase
	               3'b000:
	                   case(rs1[6:0])
	                       7'd00: result = vector;
	                       7'd1: result = {{416{1'b0}},{vector[127:32]}};
                            7'd2: result = {{448{1'b0}},{vector[127:64]}};
                            7'd3: result = {{480{1'b0}},{vector[127:96]}};
	                       default: result = 0;
	                   endcase
	               3'b001:
	                   case(rs1[6:0])
	                       7'd00: result = vector;
	                       7'd1: result = {{288{1'b0}},{vector[255:32]}};
                            7'd2: result = {{320{1'b0}},{vector[255:64]}};
                            7'd3: result = {{352{1'b0}},{vector[255:96]}};
                            7'd4: result = {{384{1'b0}},{vector[255:128]}};
                            7'd5: result = {{416{1'b0}},{vector[255:160]}};
                            7'd6: result = {{448{1'b0}},{vector[255:192]}};
                            7'd7: result = {{480{1'b0}},{vector[255:224]}};
	                       default: result = 0;
	                   endcase
	               3'b010:
	                   case(rs1[6:0])
	                       7'd00: result = vector;
	                       7'd1: result = {{32{1'b0}},{vector[511:32]}};
                            7'd2: result = {{64{1'b0}},{vector[511:64]}};
                            7'd3: result = {{96{1'b0}},{vector[511:96]}};
                            7'd4: result = {{128{1'b0}},{vector[511:128]}};
                            7'd5: result = {{160{1'b0}},{vector[511:160]}};
                            7'd6: result = {{192{1'b0}},{vector[511:192]}};
                            7'd7: result = {{224{1'b0}},{vector[511:224]}};
                            7'd8: result = {{256{1'b0}},{vector[511:256]}};
                            7'd9: result = {{288{1'b0}},{vector[511:288]}};
                            7'd10: result = {{320{1'b0}},{vector[511:320]}};
                            7'd11: result = {{352{1'b0}},{vector[511:352]}};
                            7'd12: result = {{384{1'b0}},{vector[511:384]}};
                            7'd13: result = {{416{1'b0}},{vector[511:416]}};
                            7'd14: result = {{448{1'b0}},{vector[511:448]}};
                            7'd15: result = {{480{1'b0}},{vector[511:480]}};
                            default: result = 0;
	                   endcase
	               endcase
	           endcase
                done_vsldu = 1;
            end

            VSLDU_VMV: begin  //vmove
                //result = {{(512-ELEMENT_WIDTH){1'b0}},{rs1[ELEMENT_WIDTH-1:0]}};
                case (sew)
                    3'b000: result = {{504{1'b0}},{rs1[7:0]}}; //sew = 8
                    3'b001: result = {{496{1'b0}},{rs1[15:0]}}; //sew = 16
                    3'b010: result = {{480{1'b0}},{rs1[31:0]}}; //sew = 32
                    default: result = {{504{1'b0}},{rs1[7:0]}}; //sew = 8
                endcase
                done_vsldu = 1;
            end
            default: begin  //vmove
                //result = {{(512-ELEMENT_WIDTH){1'b0}},{rs1[ELEMENT_WIDTH-1:0]}};
/*                 case (sew)
                    3'b000: result = {{504{1'b0}},{rs1[7:0]}}; //sew = 8
                    3'b001: result = {{496{1'b0}},{rs1[15:0]}}; //sew = 16
                    3'b010: result = {{480{1'b0}},{rs1[31:0]}}; //sew = 32
                    default: result = {{504{1'b0}},{rs1[7:0]}}; //sew = 8
                endcase
                done_vsldu = 1;
                 */
                
            end
        endcase
    end
endmodule
