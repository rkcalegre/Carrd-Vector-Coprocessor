module vlsu (
    
    input logic [31:0] data_in1, 
    input logic [31:0] data_in2,
    input logic [31:0] data_in3,
    input logic [31:0] data_in4,
    input logic [6:0] v_lsu_op,
    input logic [2:0] width,
    input logic [1:0] byte_offset,
    //input logic [31:0] addr,

    output logic [127:0] loaddata,
    output logic [31:0] data_out1, data_out2, data_out3, data_out4

);

    import v_pkg::*;                    // contains constants



    parameter VL = 7'b0000111;
    parameter VS = 7'b0100111;

    always @(*) begin
        case (v_lsu_op)
            VLSU_VLE8: loaddata = {{32'd96{32'd0}},data_in4[32'd31:32'd24],data_in3[32'd31:32'd24],data_in2[32'd31:32'd24],data_in1[32'd31:32'd24]};
            VLSU_VLE16: loaddata = {{32'd64{32'd0}},data_in4[32'd31:32'd16],data_in3[32'd31:32'd16],data_in2[32'd31:32'd16],data_in1[32'd31:32'd16]};
            VLSU_VLE32: loaddata = {{data_in4},{data_in3},{data_in2},{data_in1}};
            VLSU_VLSE8: loaddata = {{32'd96{32'd0}},data_in4[32'd23:32'd16],data_in3[32'd23:32'd16],data_in2[32'd23:32'd16],data_in1[32'd23:32'd16]};
            VLSU_VLSE16: loaddata = {{32'd64{32'd0}},data_in4[32'd31:32'd16],data_in3[32'd31:32'd16],data_in2[32'd31:32'd16],data_in1[32'd31:32'd16]};
            VLSU_VLSE32: loaddata = {{data_in4},{data_in3},{data_in2},{data_in1}};
            VLSU_VSE8: begin
                data_out1 = {{32'd24{32'd0}},data_in4[32'd31:32'd24]}; 
                data_out2 = {{32'd24{32'd0}},data_in3[32'd31:32'd24]};
                data_out3 = {{32'd24{32'd0}},data_in2[32'd31:32'd24]};
                data_out4 = {{32'd24{32'd0}},data_in1[32'd31:32'd24]};
            end
            VLSU_VSE16: begin
                data_out1 = {{32'd16{32'd0}},data_in4[32'd31:32'd16]}; 
                data_out2 = {{32'd16{32'd0}},data_in3[32'd31:32'd16]}; 
                data_out3 = {{32'd16{32'd0}},data_in2[32'd31:32'd16]}; 
                data_out4 = {{32'd26{32'd0}},data_in1[32'd31:32'd16]}; 
            end
            VLSU_VSE32: begin
                data_out1 = {data_in4};
                data_out2 = {data_in3};
                data_out3 = {data_in2};
                data_out4 = {data_in1};
            end
            VLSU_VSSE8: begin
                data_out1 = {{32'd24{32'd0}},data_in4[32'd23:32'd16]}; 
                data_out2 = {{32'd24{32'd0}},data_in3[32'd23:32'd16]};
                data_out3 = {{32'd24{32'd0}},data_in2[32'd23:32'd16]};
                data_out4 = {{32'd24{32'd0}},data_in1[32'd23:32'd16]};
            end
            VLSU_VSSE16: begin
                data_out1 = {{32'd16{32'd0}},data_in4[32'd31:32'd16]}; 
                data_out2 = {{32'd16{32'd0}},data_in3[32'd31:32'd16]}; 
                data_out3 = {{32'd16{32'd0}},data_in2[32'd31:32'd16]}; 
                data_out4 = {{32'd26{32'd0}},data_in1[32'd31:32'd16]}; 
            end
            VLSU_VSSE32: begin
                data_out1 = {data_in4};
                data_out2 = {data_in3};
                data_out3 = {data_in2};
                data_out4 = {data_in1};
            end
        endcase
    end

    /*
    always @(*) begin
        case (v_lsu_op)
            VL: begin
                case (byte_offset)
                2'd0: begin
                    case(width)
                        3'b000: loaddata = {{32'd96{32'd0}},data_in4[32'd31:32'd24],data_in3[32'd31:32'd24],data_in2[32'd31:32'd24],data_in1[32'd31:32'd24]};// VLE8
                        3'b101: loaddata = {{32'd64{32'd0}},data_in4[32'd31:32'd16],data_in3[32'd31:32'd16],data_in2[32'd31:32'd16],data_in1[32'd31:32'd16]}; //VLE16
                        default: loaddata = {{data_in4},{data_in3},{data_in2},{data_in1}};
                    endcase
                end
                2'd1: begin
                    case(width)
                        3'b000: loaddata = {{32'd96{32'd0}},data_in4[32'd23:32'd16],data_in3[32'd23:32'd16],data_in2[32'd23:32'd16],data_in1[32'd23:32'd16]};// VLE8
                        3'b101: loaddata = {{32'd64{32'd0}},data_in4[32'd31:32'd16],data_in3[32'd31:32'd16],data_in2[32'd31:32'd16],data_in1[32'd31:32'd16]}; //VLE16
                        default: loaddata = {{data_in4},{data_in3},{data_in2},{data_in1}};
                    endcase
                end
                2'd2: begin
                    case(width)
                        3'b000: loaddata = {{32'd96{32'd0}},data_in4[32'd15:32'd8],data_in3[32'd15:32'd8],data_in2[32'd15:32'd8],data_in1[32'd15:32'd8]};// VLE8
                        3'b101: loaddata = {{32'd64{32'd0}},data_in4[32'd15:32'd0],data_in3[32'd15:32'd0],data_in2[32'd15:32'd0],data_in1[32'd15:32'd0]}; 
                        default: loaddata = {{data_in4},{data_in3},{data_in2},{data_in1}};
                    endcase
                end
                2'd3: begin
                    case(width)
                        3'b000: loaddata = {{32'd96{32'd0}}, data_in4[32'd7:32'd0],data_in3[32'd7:32'd0],data_in2[32'd7:32'd0],data_in1[32'd7:32'd0]};// VLE8
                        3'b101: loaddata = {{32'd64{32'd0}},data_in4[32'd15:32'd0],data_in3[32'd15:32'd0],data_in2[32'd15:32'd0],data_in1[32'd15:32'd0]}; 
                        default: loaddata = {{data_in4},{data_in3},{data_in2},{data_in1}};
                    endcase
                end
                default: loaddata = {{data_in4},{data_in3},{data_in2},{data_in1}};
                endcase
            end
        VS: begin
            case (byte_offset)
                2'd0: begin
                    case (width)
                        3'b000: begin
                            data_out1 = {{32'd24{32'd0}},data_in4[32'd31:32'd24]}; 
                            data_out2 = {{32'd24{32'd0}},data_in3[32'd31:32'd24]};
                            data_out3 = {{32'd24{32'd0}},data_in2[32'd31:32'd24]};
                            data_out4 = {{32'd24{32'd0}},data_in1[32'd31:32'd24]};
                        end
                        3'b101: begin
                            data_out1 = {{32'd16{32'd0}},data_in4[32'd31:32'd16]}; 
                            data_out2 = {{32'd16{32'd0}},data_in3[32'd31:32'd16]}; 
                            data_out3 = {{32'd16{32'd0}},data_in2[32'd31:32'd16]}; 
                            data_out4 = {{32'd26{32'd0}},data_in1[32'd31:32'd16]}; 
                        end 
                        default: begin
                            data_out1 = {data_in4};
                            data_out2 = {data_in3};
                            data_out3 = {data_in2};
                            data_out4 = {data_in1};
                        end
                    endcase 
                end
                2'd1: begin // BYTE OFFSET = 1
                    case (width)
                        3'b000: begin
                            data_out1 = {{32'd24{32'd0}},data_in4[32'd23:32'd16]}; 
                            data_out2 = {{32'd24{32'd0}},data_in3[32'd23:32'd16]};
                            data_out3 = {{32'd24{32'd0}},data_in2[32'd23:32'd16]};
                            data_out4 = {{32'd24{32'd0}},data_in1[32'd23:32'd16]};
                        end
                        3'b101: begin
                            data_out1 = {{32'd16{32'd0}},data_in4[32'd31:32'd16]}; 
                            data_out2 = {{32'd16{32'd0}},data_in3[32'd31:32'd16]}; 
                            data_out3 = {{32'd16{32'd0}},data_in2[32'd31:32'd16]}; 
                            data_out4 = {{32'd26{32'd0}},data_in1[32'd31:32'd16]}; 
                        end
                        default: begin
                            data_out1 = {data_in4};
                            data_out2 = {data_in3};
                            data_out3 = {data_in2};
                            data_out4 = {data_in1};
                        end
                    endcase 
                end
                    2'd2: begin   // BYTE OFFSET = 2
                        case (width)
                        3'b000: begin
                            data_out1 = {{32'd24{32'd0}},data_in4[32'd15:32'd8]}; 
                            data_out2 = {{32'd24{32'd0}},data_in3[32'd15:32'd8]};
                            data_out3 = {{32'd24{32'd0}},data_in2[32'd15:32'd8]};
                            data_out4 = {{32'd24{32'd0}},data_in1[32'd15:32'd8]};
                        end
                        3'b101: begin
                            data_out1 = {{32'd16{32'd0}},data_in4[32'd15:32'd0]}; 
                            data_out2 = {{32'd16{32'd0}},data_in3[32'd15:32'd0]}; 
                            data_out3 = {{32'd16{32'd0}},data_in2[32'd15:32'd0]}; 
                            data_out4 = {{32'd26{32'd0}},data_in1[32'd15:32'd0]}; 
                        end 
                        default: begin
                            data_out1 = {data_in4};
                            data_out2 = {data_in3};
                            data_out3 = {data_in3};
                            data_out4 = {data_in1};
                        end
                    endcase 
                end
            
                    2'd3: begin   // BYTE OFFSET = 3
                        case (width)
                            3'b000: begin
                                data_out1 = {{32'd24{32'd0}},data_in4[32'd7:32'd0]}; 
                                data_out2 = {{32'd24{32'd0}},data_in3[32'd7:32'd0]};
                                data_out3 = {{32'd24{32'd0}},data_in2[32'd7:32'd0]};
                                data_out4 = {{32'd24{32'd0}},data_in1[32'd7:32'd0]};
                            end
                            3'b101: begin
                                data_out1 = {{32'd16{32'd0}},data_in4[32'd15:32'd0]}; 
                                data_out2 = {{32'd16{32'd0}},data_in3[32'd15:32'd0]}; 
                                data_out3 = {{32'd16{32'd0}},data_in2[32'd15:32'd0]}; 
                                data_out4 = {{32'd26{32'd0}},data_in1[32'd15:32'd0]}; 
                            end
                            default: begin
                                data_out1 = {data_in4};
                                data_out2 = {data_in3};
                                data_out3 = {data_in2};
                                data_out4 = {data_in1};
                            end
                    endcase 
                end
                endcase
                end
            endcase
        end
        */
        
    
endmodule





