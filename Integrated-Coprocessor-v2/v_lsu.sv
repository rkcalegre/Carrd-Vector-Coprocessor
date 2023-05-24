`timescale 1ns / 1ps
module vlsu (

    input clk,
	input nrst,
    input logic [31:0] data_in1, 
    input logic [31:0] data_in2,
    input logic [31:0] data_in3,
    input logic [31:0] data_in4,
    input logic [6:0] v_lsu_op,
    input logic [2:0] width,
    input logic [2:0] lmul,
    // input logic [1:0] byte_offset,
    input logic [31:0] l_addr,
    input logic [31:0] s_addr1, s_addr2, s_addr3, s_addr4,
    input [511:0] storedata,
    input is_load,
    input is_store, 
    output logic [511:0] loaddata,
    output logic [3:0] write_en,
    output logic [31:0] data_out_1, data_out_2, data_out_3, data_out_4,
    output logic l_done, s_done

);

    import v_pkg::*;                    // contains constants
	wire [32:0] max_count;	
    reg [13:0] addr;
    reg [13:0] calc_addr;
	reg [31:0] l_count;
    reg [31:0] s_count;
	reg [511:0] temp;
	reg [511:0] hold;
	reg [1:0] mode;
    reg [511:0] load_data;
    reg [511:0] store_data;
    reg [31:0] data_out1;
	reg [31:0] data_out2;
	reg [31:0] data_out3;
	reg [31:0] data_out4;
    wire [31:0] data1, data2, data3, data4;


	assign max_count = (lmul ==3'b000) ? 32'd128:
		(lmul ==3'b001) ? 32'd256:
		(lmul ==3'b010) ? 32'd512:
		(lmul ==3'b111) ? 32'd64:
		32'd32;

    assign data1 = (l_addr[3:2] == 2'b00) ? data_in1: ((l_addr[3:2] == 2'b01) ? data_in2: ((l_addr[3:2] == 2'b10) ? data_in3: (data_in4)));
	assign data2 = (l_addr[3:2] == 2'b00) ? data_in2: ((l_addr[3:2] == 2'b01) ? data_in3: ((l_addr[3:2] == 2'b10) ? data_in4: (data_in1)));
	assign data3 = (l_addr[3:2] == 2'b00) ? data_in3: ((l_addr[3:2] == 2'b01) ? data_in4: ((l_addr[3:2] == 2'b10) ? data_in1: (data_in2)));
	assign data4 = (l_addr[3:2] == 2'b00) ? data_in4: ((l_addr[3:2] == 2'b01) ? data_in1: ((l_addr[3:2] == 2'b10) ? data_in2: (data_in3)));

	
	always@(posedge clk) begin
		if(!nrst) 
		    begin
		    addr = l_addr;
			l_count = 32'b0;
			load_data = 0;
			temp = 0;
			l_done = 0;
			hold = 0;
			mode = 0;
            data_out1 = 0;
            data_out2 = 0;
			data_out3 = 0;
			data_out4 = 0;
			end
		else
		begin
        if (is_load)
        begin
		if (mode==0)
		begin
		    calc_addr = addr;
		    mode = 2'b01;
		    load_data = 0;
		    l_done = 0;
		end
		else if (mode==2'b01)
		begin
		    calc_addr = calc_addr + 6'b010000;
		    mode = 2'b10;
		end
		else
		begin
		calc_addr = calc_addr + 6'b010000;
        case (v_lsu_op)
            VLSU_VLE8: 
            begin
                temp = {{32'd480{32'd0}},data4[32'd31:32'd24],data3[32'd31:32'd24],data2[32'd31:32'd24],data1[32'd31:32'd24]};
				load_data = (l_count==0) ? {{(temp[31:0])},{480'd0}}:{{(temp[31:0])},{hold[479:0]}};
				hold = (l_count==max_count) ? load_data:load_data>>32;
				l_count = l_count +32'd32;
            end
            VLSU_VLE16: 
            begin
				temp = {{32'd448{32'd0}},data4[32'd31:32'd16],data3[32'd31:32'd16],data2[32'd31:32'd16],data1[32'd31:32'd16]};
				load_data = (l_count==0) ? {{(temp[63:0])},{448'd0}}:{{(temp[63:0])},{hold[447:0]}};
				hold = (l_count==max_count) ? load_data:load_data>>64;
				l_count = l_count + 32'd64;
            end
            VLSU_VLE32: 
            begin
                temp ={{32'd384{32'd0}},{data4},{data3},{data2},{data1}};
				load_data = (l_count==0) ? {{(temp[127:0])},{384'd0}}:{{(temp[127:0])},{hold[383:0]}};
				hold = (l_count==max_count) ? load_data:load_data>>128;
				l_count = l_count + 32'd128;
            end
            VLSU_VLSE8: 
            begin
                temp = {{32'd480{32'd0}},data4[32'd31:32'd24],data3[32'd31:32'd24],data2[32'd31:32'd24],data1[32'd31:32'd24]};
				load_data = (l_count==0) ? {{(temp[31:0])},{480'd0}}:{{(temp[31:0])},{hold[479:0]}};
				hold = (l_count==max_count) ? load_data:load_data>>32;
				l_count = l_count +32'd32;
            end
            VLSU_VLSE16: 
            begin
				temp = {{32'd448{32'd0}},data4[32'd15:32'd0],data3[32'd15:32'd0],data2[32'd15:32'd0],data1[32'd15:32'd0]};
				load_data = (l_count==0) ? {{(temp[63:0])},{448'd0}}:{{(temp[63:0])},{hold[447:0]}};
				hold = (l_count==max_count) ? load_data:load_data>>64;
				l_count = l_count + 32'd64;
            end
            VLSU_VLSE32: 
            begin
                temp ={{32'd384{32'd0}},{data4},{data3},{data2},{data1}};
				load_data = (l_count==0) ? {{(temp[127:0])},{384'd0}}:{{(temp[127:0])},{hold[383:0]}};
				hold = (l_count==max_count) ? load_data:load_data>>128;
				l_count = l_count + 32'd128;
            end
        endcase
        end 
        if (l_count==max_count)
		begin
			l_done = 1'b1;
			l_count = 0;
			mode = 0;
			loaddata = (lmul == 3'b010)? load_data: (lmul==3'b001) ? {{256{1'b0}},{load_data[511:256]}}: {{384{1'b0}},{load_data[511:384]}};
		end
	    else
	        l_done =1'b0;
		end
		end
        if (is_store)
        begin
        case (v_lsu_op)
        VLSU_VSE8: 
        begin
            storedata = {{480{32'd0}},{loaddata[32'd31:32'd0]}};
            data_out1 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
			data_out2 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
			data_out3 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
			data_out4 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
            s_count = s_count + 32'd32;
        end
        VLSU_VSE16:
        begin
            storedata = {{448{32'd0}},{loaddata[32'd63:32'd0]}};
            data_out1 = {{16{storedata[32'd15]}},{storedata[32'd15:0]}};
			data_out2 = {{16{storedata[32'd31]}},{storedata[32'd31:32'd16]}};
			data_out3 = {{16{storedata[32'd47]}},{storedata[32'd47:32'd32]}};
			data_out4 = {{16{storedata[32'd63]}},{storedata[32'd63:32'd48]}};
            s_count = s_count + 32'd64;
        end
        VLSU_VSE32:
        begin
            storedata = {{384{32'd0}},{loaddata[32'd127:32'd0]}};
            data_out1 = {storedata[32'd31:0]};
		    data_out2 = {storedata[32'd63:32'd32]};
			data_out3 = {storedata[32'd95:32'd64]};
			data_out4 = {storedata[32'd127:32'd96]};
            s_count = s_count + 32'd128;
        end
        VLSU_VSSE8:
        begin
            storedata = {{480{32'd0}},{loaddata[32'd31:32'd0]}};
            data_out1 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
			data_out2 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
			data_out3 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
			data_out4 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
            s_count = s_count + 32'd32;
        end
        VLSU_VSSE16:
        begin
            storedata = {{480{32'd0}},{loaddata[32'd31:32'd0]}};
            data_out1 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
			data_out2 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
			data_out3 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
			data_out4 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
            s_count = s_count + 32'd64;
        end
        VLSU_VSSE32:
        begin
            storedata = {{480{32'd0}},{loaddata[32'd31:32'd0]}};
            data_out1 = {{24{storedata[32'd7]}},{storedata[32'd7:0]}};
			data_out2 = {{24{storedata[32'd15]}},{storedata[32'd15:32'd8]}};
			data_out3 = {{24{storedata[32'd23]}},{storedata[32'd23:32'd16]}};
			data_out4 = {{24{storedata[32'd31]}},{storedata[32'd31:32'd24]}};
            s_count = s_count + 32'd128;
        end
        endcase

        case (addr[3:2])
        2'b0:
        begin
            data_out_1 = data_out1;
            data_out_2 = data_out2;
            data_out_3 = data_out3;
            data_out_4 = data_out4;
            s_addr1 = calc_addr>>2;
            s_addr2 = calc_addr>>2;
            s_addr3 = calc_addr>>2;
            s_addr4 = calc_addr>>2;
        end
        2'b01:
        begin
            data_out_1 = data_out4;
            data_out_2 = data_out1;
            data_out_3 = data_out2;
            data_out_4 = data_out3;
            s_addr1 = (calc_addr>>2) +  4'b0100;
            s_addr2 = calc_addr>>2;
            s_addr3 = calc_addr>>2;
            s_addr4 = calc_addr>>2;
        end
        2'b10:
        begin
            data_out_1 = data_out3;
            data_out_2 = data_out4;
            data_out_3 = data_out1;
            data_out_4 = data_out2;
            s_addr1 = (calc_addr>>2) +  4'b0100;
            s_addr2 = (calc_addr>>2) +  4'b0100;
            s_addr3 = calc_addr>>2;
            s_addr4 = calc_addr>>2;
        end
        2'b11:
         begin
            data_out_1 = data_out2;
            data_out_2 = data_out3;
            data_out_3 = data_out4;
            data_out_4 = data_out1;
            s_addr1 = (calc_addr>>2) +  4'b0100;
            s_addr2 = (calc_addr>>2) +  4'b0100;
            s_addr3 = (calc_addr>>2) +  4'b0100;
            s_addr4 = calc_addr>>2;
        end
        endcase
        if (s_count>=max_count)
        s_done = 1'b1;
        s_count = 32'b0;
        end
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





