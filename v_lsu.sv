module v_lsu (
    
    input logic clk,
    input logic nrst,
    input logic [2:0] ld_store_op,
    input logic [2:0] vsew,
    input logic [1:0] stride,
    input logic [31:0] addr,
    input logic [31:0] data_in, 
    output logic [31:0] loaddata,
    output logic [31:0] data_out 

);

    parameter VLE = 3'b000;
    parameter VLSE = 3'b010;
    parameter VSE = 3'b011;
    parameter VSSE = 3'b110;


    always@(posedge clk) begin
        if (!nrst)
        begin
        case (ld_store_op)
        // vector load unit-stride 
        VLE: 
            case (vsew)
                2'b00: loaddata = { data_in[7:0], 24'd0 };
                2'b01: loaddata = { data_in[15:0], 16'd0 };
                2'b10: loaddata = {data_in[31:0]};
                default: loaddata = 0;
            endcase

        // vector load strided 
        VLSE:
            case (vsew)
                2'b00: 
                    case (stride)
                        2'd0: loaddata = { data_in[7:0], 24'd0 };
                        2'd1: loaddata = { 1'd0, data_in[7:0], 23'd0 };
					    2'd2: loaddata = { 2'd0, data_in[7:0], 22'd0 };
					    2'd3: loaddata = { 3'd0, data_in[7:0], 21'd0 };
                    endcase
                2'b01: 
                    case (stride)
                        2'd0: loaddata = { data_in[15:0], 16'd0 };
                        2'd1: loaddata = { 1'd0, data_in[15:0], 15'd0 };
					    2'd2: loaddata = { 2'd0, data_in[15:0], 14'd0 };
					    2'd3: loaddata = { 3'd0, data_in[15:0], 13'd0 };
                    endcase
                2'b10: 
                    case (stride)
                        2'd0: loaddata = { data_in[31:0] };
                        2'd1: loaddata = { 1'd0, data_in[30:1] };
					    2'd2: loaddata = { 2'd0, data_in[29:2] };
					    2'd3: loaddata = { 3'd0, data_in[28:3] };
                    endcase
            endcase
        // vector store unit-stride 
        VSE:
            case (vsew)
                2'b00: data_out = { data_in[7:0], 24'd0 };
                2'b01: data_out = { data_in[15:0], 16'd0 };
                2'b10: data_out = {data_in[31:0]};
            endcase
        // strided store
        VSSE:
            case (vsew)
             2'b00: 
                    case (stride)
                        2'd0: data_out = { data_in[7:0], 24'd0 };
                        2'd1: data_out = { 1'd0, data_in[7:0], 23'd0 };
					    2'd2: data_out = { 2'd0, data_in[7:0], 22'd0 };
					    2'd3: data_out = { 3'd0, data_in[7:0], 21'd0 };
                    endcase
                2'b01: 
                    case (stride)
                        2'd0: data_out = { data_in[15:0], 16'd0 };
                        2'd1: data_out = { 1'd0, data_in[15:0], 15'd0 };
					    2'd2: data_out = { 2'd0, data_in[15:0], 14'd0 };
					    2'd3: data_out = { 3'd0, data_in[15:0], 13'd0 };
                    endcase
                2'b10: 
                    case (stride)
                        2'd0: data_out = { data_in[31:0] };
                        2'd1: data_out = { 1'd0, data_in[30:1] };
					    2'd2: data_out = { 2'd0, data_in[29:2] };
					    2'd3: data_out = { 3'd0, data_in[28:3] };
                    endcase
            endcase
        endcase
    end 
    end 

endmodule 
    






