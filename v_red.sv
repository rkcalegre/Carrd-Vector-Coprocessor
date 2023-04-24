
module v_red (
    input clk,
    input nrst,
    input logic [5:0] op_instr,
    input logic [1:0] sew,
    input logic [1:0] lmul,
    input logic [127:0] vec_regB_1,//vec_regB
    input logic [127:0] vec_regB_2,//vec_regB
    input logic [127:0] vec_regB_3,//vec_regB
    input logic [127:0] vec_regB_4,//vec_regB to accomodate lmul=4
    input logic [31:0] vec_regA,
    input logic red_mode,
    output logic done,
    output logic [31:0] result
);
    
logic [511:0] vec_regB; //vec_regB     
assign vec_regB ={vec_regB_4,vec_regB_3,vec_regB_2,vec_regB_1};


logic [255:0] current_reg;
logic [2:0] step;

always@( clk)
if (!nrst)
begin
    step = 0;
    done = 0;
end
else
begin
    case(red_mode)
    1'b0:
    begin
        case(step)
        default:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = vec_regB[7:0] + vec_regB[15:8];
                current_reg[15:8] = vec_regB[23:16] + vec_regB[31:24];
                current_reg[23:16] = vec_regB[39:32] + vec_regB[47:40];
                current_reg[31:24] = vec_regB[55:48] + vec_regB[63:56];
                current_reg[39:32] = vec_regB[71:64] + vec_regB[79:72];
                current_reg[47:40] = vec_regB[87:80] + vec_regB[95:88];
                current_reg[55:48] = vec_regB[103:96] + vec_regB[111:104];
                current_reg[63:56] = vec_regB[119:112] + vec_regB[127:120];
                current_reg[71:64] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[135:128] + vec_regB[143:136]:0;
                current_reg[79:72] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[151:144] + vec_regB[159:152]:0;
                current_reg[87:80] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[167:160] + vec_regB[175:168]:0;
                current_reg[95:88] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[183:176] + vec_regB[191:184]:0;
                current_reg[103:96] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[199:192] + vec_regB[207:200]:0;
                current_reg[111:104] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[215:208] + vec_regB[223:216]:0;
                current_reg[119:112] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[231:224] + vec_regB[239:232]:0;
                current_reg[127:120] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[247:240] + vec_regB[255:248]:0;
                current_reg[135:128] = (lmul == 2'b10) ? vec_regB[263:256] + vec_regB[271:264]:0;
                current_reg[143:136] = (lmul == 2'b10) ? vec_regB[279:272] + vec_regB[287:280]:0;
                current_reg[151:144] = (lmul == 2'b10) ? vec_regB[295:288] + vec_regB[303:296]:0;
                current_reg[159:152] = (lmul == 2'b10) ? vec_regB[311:304] + vec_regB[319:312]:0;
                current_reg[167:160] = (lmul == 2'b10) ? vec_regB[327:320] + vec_regB[335:328]:0;
                current_reg[175:168] = (lmul == 2'b10) ? vec_regB[343:336] + vec_regB[351:344]:0;
                current_reg[183:176] = (lmul == 2'b10) ? vec_regB[359:352] + vec_regB[367:360]:0;
                current_reg[191:184] = (lmul == 2'b10) ? vec_regB[375:368] + vec_regB[383:376]:0;
                current_reg[199:192] = (lmul == 2'b10) ? vec_regB[391:384] + vec_regB[399:392]:0;
                current_reg[207:200] = (lmul == 2'b10) ? vec_regB[407:400] + vec_regB[415:408]:0;
                current_reg[215:208] = (lmul == 2'b10) ? vec_regB[423:416] + vec_regB[431:424]:0;
                current_reg[223:216] = (lmul == 2'b10) ? vec_regB[439:432] + vec_regB[447:440]:0;
                current_reg[231:224] = (lmul == 2'b10) ? vec_regB[455:448] + vec_regB[463:456]:0;
                current_reg[239:232] = (lmul == 2'b10) ? vec_regB[471:464] + vec_regB[479:472]:0;
                current_reg[247:240] = (lmul == 2'b10) ? vec_regB[487:480] + vec_regB[495:488]:0;
                current_reg[255:248] = (lmul == 2'b10) ? vec_regB[503:496] + vec_regB[511:504]:0;

                result[7:0] = current_reg[7:0];
                result[31:8] = 0;
                step = 3'b001;
                done = 0;
            end
            2'b01:
            begin
                current_reg[15:0] = vec_regB[15:0] + vec_regB[31:16];
                current_reg[31:16] = vec_regB[47:32] + vec_regB[63:48];
                current_reg[47:32] = vec_regB[79:64] + vec_regB[95:80];
                current_reg[63:48] = vec_regB[111:96] + vec_regB[127:112];
                current_reg[79:64] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[143:128] + vec_regB[159:144]:0;
                current_reg[95:80] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[175:160] + vec_regB[191:176]:0;
                current_reg[111:96] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[207:192] + vec_regB[223:208]:0;
                current_reg[127:112] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[239:224] + vec_regB[255:240]:0;
                current_reg[143:128] = (lmul == 2'b10) ? vec_regB[271:256] + vec_regB[287:272]:0;
                current_reg[159:144] = (lmul == 2'b10) ? vec_regB[303:288] + vec_regB[319:304]:0;
                current_reg[175:160] = (lmul == 2'b10) ? vec_regB[335:320] + vec_regB[351:336]:0;
                current_reg[191:176] = (lmul == 2'b10) ? vec_regB[367:352] + vec_regB[383:368]:0;
                current_reg[207:192] = (lmul == 2'b10) ? vec_regB[399:384] + vec_regB[415:400]:0;
                current_reg[223:208] = (lmul == 2'b10) ? vec_regB[431:416] + vec_regB[447:432]:0;
                current_reg[239:224] = (lmul == 2'b10) ? vec_regB[463:448] + vec_regB[479:464]:0;
                current_reg[255:240] = (lmul == 2'b10) ? vec_regB[495:480] + vec_regB[511:496]:0;

                result[15:0] = current_reg[15:0];
                result[31:15] = 0;
                step = 3'b001;
                done = 0;
            end
            default:
            begin
                current_reg[31:0] = vec_regB[31:0] + vec_regB[63:32];
                current_reg[63:32] = vec_regB[95:64] + vec_regB[127:96];
                current_reg[95:64] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[159:128] + vec_regB[191:160]:0;
                current_reg[127:96] = (lmul == 2'b01 || lmul == 2'b10) ? vec_regB[223:192] + vec_regB[255:224]:0;
                current_reg[159:128] = (lmul == 2'b10) ? vec_regB[287:256] + vec_regB[319:288]:0;
                current_reg[191:160] = (lmul == 2'b10) ? vec_regB[351:320] + vec_regB[383:352]:0;
                current_reg[223:192] = (lmul == 2'b10) ? vec_regB[415:384] + vec_regB[447:416]:0;
                current_reg[255:224] = (lmul == 2'b10) ? vec_regB[479:448] + vec_regB[511:480]:0;

                result[31:0] = current_reg[31:0];
                step = 3'b001;
                done = 0;
            end
            endcase
        end
        3'b001:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = current_reg[7:0] + current_reg[15:8];
                current_reg[15:8] = current_reg[23:16] + current_reg[31:24];
                current_reg[23:16] = current_reg[39:32] + current_reg[47:40];
                current_reg[31:24] = current_reg[55:48] + current_reg[63:56];
                current_reg[39:32] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[71:64] + current_reg[79:72]:0;
                current_reg[47:40] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[87:80] + current_reg[95:88]:0;
                current_reg[55:48] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[103:96] + current_reg[111:104]:0;
                current_reg[63:56] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[119:112] + current_reg[127:120]:0;
                current_reg[71:64] = (lmul == 2'b10) ? current_reg[135:128] + current_reg[143:136]:0;
                current_reg[79:72] = (lmul == 2'b10) ? current_reg[151:144] + current_reg[159:152]:0;
                current_reg[87:80] = (lmul == 2'b10) ? current_reg[167:160] + current_reg[175:168]:0;
                current_reg[95:88] = (lmul == 2'b10) ? current_reg[183:176] + current_reg[191:184]:0;
                current_reg[103:96] = (lmul == 2'b10) ? current_reg[199:192] + current_reg[207:200]:0;
                current_reg[111:104] = (lmul == 2'b10) ? current_reg[215:208] + current_reg[223:216]:0;
                current_reg[119:112] = (lmul == 2'b10) ? current_reg[231:224] + current_reg[239:232]:0;
                current_reg[127:120] = (lmul == 2'b10) ? current_reg[247:240] + current_reg[255:248]:0;
                
                result[7:0] = current_reg[7:0];  
                step = 3'b010;
                done = 0;
            end
            2'b01:
            begin
                current_reg[15:0] = current_reg[15:0] + current_reg[31:16];
                current_reg[31:16] = current_reg[47:32] + current_reg[63:48];
                current_reg[47:32] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[79:64] + current_reg[95:80]:0;
                current_reg[63:48] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[111:96] + current_reg[127:112]:0;
                current_reg[79:64] = (lmul == 2'b10) ? current_reg[143:128] + current_reg[159:144]:0;
                current_reg[95:80] = (lmul == 2'b10) ? current_reg[175:160] + current_reg[191:176]:0;
                current_reg[111:96] = (lmul == 2'b10) ? current_reg[207:192] + current_reg[223:208]:0;
                current_reg[127:112] = (lmul == 2'b10) ? current_reg[239:224] + current_reg[255:240]:0;


                result[15:0] = current_reg[15:0];
                step = 3'b010;
                done = 0;  
            end
            default:
            begin

                current_reg[31:0] = current_reg[31:0] + current_reg[63:32];
                current_reg[63:32] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[95:64] + current_reg[127:96]:0;
                current_reg[95:64] = (lmul == 2'b10) ? current_reg[159:128] + current_reg[191:160]:0;
                current_reg[127:96] = (lmul == 2'b10) ? current_reg[223:192] + current_reg[255:224]:0;

                result[31:0] = (lmul==2'b00) ? current_reg[31:0] + vec_regA [31:0]:current_reg[31:0];
                step = (lmul==2'b00) ? 3'b000:3'b010;
                done = (lmul==2'b00) ? 1:0;
            end
            endcase
        end

        3'b010:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = current_reg[7:0] + current_reg[15:8];
                current_reg[15:8] = current_reg[23:16] + current_reg[31:24];
                current_reg[23:16] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[39:32] + current_reg[47:40]:0;
                current_reg[31:24] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[55:48] + current_reg[63:56]:0;
                current_reg[39:32] = (lmul == 2'b10) ? current_reg[71:64] + current_reg[79:72]:0;
                current_reg[47:40] = (lmul == 2'b10) ? current_reg[87:80] + current_reg[95:88]:0;
                current_reg[55:48] = (lmul == 2'b10) ? current_reg[103:96] + current_reg[111:104]:0;
                current_reg[63:56] = (lmul == 2'b10) ? current_reg[119:112] + current_reg[127:120]:0;

                result[7:0] = current_reg[7:0];
                step = 3'b011;
                done = 0;
            end
            2'b01:
            begin
                current_reg[15:0] = current_reg[15:0] + current_reg[31:16];
                current_reg[31:16] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[47:32] + current_reg[63:48]:0;
                current_reg[47:32] = (lmul == 2'b10) ? current_reg[79:64] + current_reg[95:80]:0;
                current_reg[63:48] = (lmul == 2'b10) ? current_reg[111:96] + current_reg[127:112]:0;

                result[15:0] = (lmul==2'b00) ? current_reg[15:0] + vec_regA[15:0]:current_reg[15:0];
                step = (lmul==2'b00) ? 3'b000:3'b011;
                done = (lmul==2'b00) ? 1:0;  
            end
            default:
            begin
                current_reg[31:0] = current_reg[31:0] + current_reg[63:32];
                current_reg[63:32] = (lmul == 2'b10) ? current_reg[95:64] + current_reg[127:96]:0;

                result[31:0] = (lmul==2'b01) ? current_reg[31:0] + vec_regA[31:0]:current_reg[31:0];
                step = (lmul==2'b01) ? 3'b000:3'b011;
                done = (lmul==2'b01) ? 1:0;
            end
            endcase
        end
        3'b011:
        begin
            case (sew)
            2'b00:
            begin

                current_reg[7:0] = current_reg[7:0] + current_reg[15:8];
                current_reg[15:8] = (lmul == 2'b01 || lmul == 2'b10) ? current_reg[23:16] + current_reg[31:24]:0;
                current_reg[23:16] = (lmul == 2'b10) ? current_reg[39:32] + current_reg[47:40]:0;
                current_reg[31:24] = (lmul == 2'b10) ? current_reg[55:48] + current_reg[63:56]:0;

                result[7:0] = (lmul == 2'b00) ? current_reg[7:0] + vec_regA[7:0]:current_reg[7:0];
                step = (lmul == 2'b00) ? 3'b000:3'b100;
                done = (lmul == 2'b00) ? 1:0;
            end
            2'b01:
            begin

                current_reg[15:0] = current_reg[15:0] + current_reg[31:16];
                current_reg[31:16] = (lmul == 2'b10) ? current_reg[47:32] + current_reg[63:48]:0;

                result[15:0] = (lmul==2'b01) ? current_reg[15:0] + vec_regA[15:0]:current_reg[15:0];
                step = (lmul==2'b01) ? 3'b000:3'b0100;
                done = (lmul==2'b01) ? 1:0;  
            end
            default:
            begin
                current_reg[31:0] = current_reg[31:0] + current_reg[63:32];
                result[31:0] = current_reg[31:0] + vec_regA [31:0];
                step = 3'b000;
                done = 1;
            end
            endcase
        end
        3'b100:
        begin
            case (sew)
            2'b00:
            begin

                current_reg[7:0] = current_reg[7:0] + current_reg[15:8];
                current_reg[15:8] = (lmul == 2'b10) ? current_reg[23:16] + current_reg[31:24]:0;

                result[7:0] = (lmul == 2'b01) ? current_reg[7:0] + vec_regA[7:0]:current_reg[7:0];
                step = (lmul == 2'b01) ? 3'b000:3'b101;
                done = (lmul == 2'b01) ? 1:0;
            end
            2'b01:
            begin
                current_reg[15:0] = current_reg[15:0] + current_reg[31:16];
                result[15:0] = current_reg[15:0] + vec_regA[15:0];
                step = 3'b000;
                done = 1;
            end
            endcase
        end
        3'b101:
        begin
            current_reg[7:0] = current_reg[7:0] + current_reg[15:8];
            result[7:0] = current_reg[7:0] + vec_regA[7:0];
            step = 3'b000;
            done = 1;
        end
        endcase
    end
    1'b1:
    begin
        case(step)
        default:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = ($signed(vec_regB[7:0]) >= $signed(vec_regB[15:8])) ? vec_regB[7:0]:vec_regB[15:8];
                current_reg[15:8] = ($signed(vec_regB[23:16]) >= $signed(vec_regB[31:24])) ? vec_regB[23:16]:vec_regB[31:24];
                current_reg[23:16] = ($signed(vec_regB[39:32]) >= $signed(vec_regB[47:40])) ? vec_regB[39:32]:vec_regB[47:40];
                current_reg[31:24] = ($signed(vec_regB[55:48]) >= $signed(vec_regB[63:56])) ? vec_regB[55:48]:vec_regB[63:56];
                current_reg[39:32] = ($signed(vec_regB[71:64]) >= $signed(vec_regB[79:72])) ? vec_regB[71:64]:vec_regB[79:72];
                current_reg[47:40] = ($signed(vec_regB[87:80]) >= $signed(vec_regB[95:88])) ? vec_regB[87:80]:vec_regB[95:88];
                current_reg[55:48] = ($signed(vec_regB[103:96]) >= $signed(vec_regB[111:104])) ? vec_regB[103:96]:vec_regB[111:104];
                current_reg[63:56] = ($signed(vec_regB[119:112]) >= $signed(vec_regB[127:120])) ? vec_regB[119:112]:vec_regB[127:120];
                current_reg[71:64] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[135:128]) >= $signed(vec_regB[143:136])) ? vec_regB[135:128]:vec_regB[143:136];
                current_reg[79:72] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[151:144]) >= $signed(vec_regB[159:152])) ? vec_regB[151:144]:vec_regB[159:152];
                current_reg[87:80] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[167:160]) >= $signed(vec_regB[175:168])) ? vec_regB[167:160]:vec_regB[175:168];
                current_reg[95:88] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[183:176]) >= $signed(vec_regB[191:184])) ? vec_regB[183:176]:vec_regB[191:184];
                current_reg[103:96] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[199:192]) >= $signed(vec_regB[207:200])) ? vec_regB[199:192]:vec_regB[207:200];
                current_reg[111:104] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[215:208]) >= $signed(vec_regB[223:216])) ? vec_regB[215:208]:vec_regB[223:216];
                current_reg[119:112] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[231:224]) >= $signed(vec_regB[239:232])) ? vec_regB[231:224]:vec_regB[239:232];
                current_reg[127:120] = (lmul==2'b00) ? 8'b10000000: ($signed(vec_regB[247:240]) >= $signed(vec_regB[255:248])) ? vec_regB[247:240]:vec_regB[255:248];
                current_reg[135:128] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[263:256]) >= $signed(vec_regB[271:264])) ? vec_regB[263:256]:vec_regB[271:264];
                current_reg[143:136] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[279:272]) >= $signed(vec_regB[287:280])) ? vec_regB[279:272]:vec_regB[287:280];
                current_reg[151:144] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[295:288]) >= $signed(vec_regB[303:296])) ? vec_regB[295:288]:vec_regB[303:296];
                current_reg[159:152] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[311:304]) >= $signed(vec_regB[319:312])) ? vec_regB[311:304]:vec_regB[319:312];
                current_reg[167:160] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[327:320]) >= $signed(vec_regB[335:328])) ? vec_regB[327:320]:vec_regB[335:328];
                current_reg[175:168] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[343:336]) >= $signed(vec_regB[351:344])) ? vec_regB[343:336]:vec_regB[351:344];
                current_reg[183:176] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[359:352]) >= $signed(vec_regB[367:360])) ? vec_regB[359:352]:vec_regB[367:360];
                current_reg[191:184] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[375:368]) >= $signed(vec_regB[383:376])) ? vec_regB[375:368]:vec_regB[383:376];
                current_reg[199:192] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[391:384]) >= $signed(vec_regB[399:392])) ? vec_regB[391:384]:vec_regB[399:392];
                current_reg[207:200] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[407:400]) >= $signed(vec_regB[415:408])) ? vec_regB[407:400]:vec_regB[415:408];
                current_reg[215:208] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[423:416]) >= $signed(vec_regB[431:424])) ? vec_regB[423:416]:vec_regB[431:424];
                current_reg[223:216] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[439:432]) >= $signed(vec_regB[447:440])) ? vec_regB[439:432]:vec_regB[447:440];
                current_reg[231:224] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[455:448]) >= $signed(vec_regB[463:456])) ? vec_regB[455:448]:vec_regB[463:456];
                current_reg[239:232] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[471:464]) >= $signed(vec_regB[479:472])) ? vec_regB[471:464]:vec_regB[479:472];
                current_reg[247:240] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[487:480]) >= $signed(vec_regB[495:488])) ? vec_regB[487:480]:vec_regB[495:488];
                current_reg[255:248] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(vec_regB[503:496]) >= $signed(vec_regB[511:504])) ? vec_regB[503:496]:vec_regB[511:504];

                result[7:0] = current_reg[7:0];
                result[31:8] = 0;
                step = 3'b001;
                done = 0;
            end
            2'b01:
            begin
                current_reg[15:0] = ($signed(vec_regB[15:0]) >= $signed(vec_regB[31:16])) ? vec_regB[15:0]:vec_regB[31:16];
                current_reg[31:16] = ($signed(vec_regB[47:32]) >= $signed(vec_regB[63:48])) ? vec_regB[47:32]:vec_regB[63:48];
                current_reg[47:32] = ($signed(vec_regB[79:64]) >= $signed(vec_regB[95:80])) ? vec_regB[79:64]:vec_regB[95:80];
                current_reg[63:48] = ($signed(vec_regB[111:96]) >= $signed(vec_regB[127:112])) ? vec_regB[111:96]:vec_regB[127:112];
                current_reg[79:64] = (lmul==2'b00) ? 16'b1000000000000000: ($signed(vec_regB[143:128]) >= $signed(vec_regB[159:144])) ? vec_regB[143:128]:vec_regB[159:144];
                current_reg[95:80] = (lmul==2'b00) ? 16'b1000000000000000: ($signed(vec_regB[175:160]) >= $signed(vec_regB[191:176])) ? vec_regB[175:160]:vec_regB[191:176];
                current_reg[111:96] = (lmul==2'b00) ? 16'b1000000000000000: ($signed(vec_regB[207:192]) >= $signed(vec_regB[223:208])) ? vec_regB[207:192]:vec_regB[223:208];
                current_reg[127:112] = (lmul==2'b00) ? 16'b1000000000000000: ($signed(vec_regB[239:224]) >= $signed(vec_regB[255:240])) ? vec_regB[239:224]:vec_regB[255:240];
                current_reg[143:128] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[271:256]) >= $signed(vec_regB[287:272])) ? vec_regB[271:256]:vec_regB[287:272];
                current_reg[159:144] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[303:288]) >= $signed(vec_regB[319:304])) ? vec_regB[303:288]:vec_regB[319:304];
                current_reg[175:160] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[335:320]) >= $signed(vec_regB[351:336])) ? vec_regB[335:320]:vec_regB[351:336];
                current_reg[191:176] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[367:352]) >= $signed(vec_regB[383:368])) ? vec_regB[367:352]:vec_regB[383:368];
                current_reg[207:192] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[399:384]) >= $signed(vec_regB[415:400])) ? vec_regB[399:384]:vec_regB[415:400];
                current_reg[223:208] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[431:416]) >= $signed(vec_regB[447:432])) ? vec_regB[431:416]:vec_regB[447:432];
                current_reg[239:224] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[463:448]) >= $signed(vec_regB[479:464])) ? vec_regB[463:448]:vec_regB[479:464];
                current_reg[255:240] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(vec_regB[495:480]) >= $signed(vec_regB[511:496])) ? vec_regB[495:480]:vec_regB[511:496];

                result[15:0] = current_reg[15:0];
                result[31:15] = 0;
                step = 3'b001;
                done = 0;
            end
            default:
            begin
                current_reg[31:0] = ($signed(vec_regB[31:0]) >= $signed(vec_regB[63:32])) ? vec_regB[31:0]:vec_regB[63:32];
                current_reg[63:32] = ($signed(vec_regB[95:64]) >= $signed(vec_regB[127:96])) ? vec_regB[95:64]:vec_regB[127:96];
                current_reg[95:64] = (lmul==2'b00) ? 32'b10000000000000000000000000000000: ($signed(vec_regB[159:128]) >= $signed(vec_regB[191:160])) ? vec_regB[159:128]:vec_regB[191:160];
                current_reg[127:96] = (lmul==2'b00) ? 32'b10000000000000000000000000000000: ($signed(vec_regB[223:192]) >= $signed(vec_regB[255:224])) ? vec_regB[223:192]:vec_regB[255:224];
                current_reg[159:128] = (lmul==2'b00 || lmul==2'b01) ? 32'b10000000000000000000000000000000: ($signed(vec_regB[287:256]) >= $signed(vec_regB[319:288])) ? vec_regB[287:256]:vec_regB[319:288];
                current_reg[191:160] = (lmul==2'b00 || lmul==2'b01) ? 32'b10000000000000000000000000000000: ($signed(vec_regB[351:320]) >= $signed(vec_regB[383:352])) ? vec_regB[351:320]:vec_regB[383:352];
                current_reg[223:192] = (lmul==2'b00 || lmul==2'b01) ? 32'b10000000000000000000000000000000: ($signed(vec_regB[415:384]) >= $signed(vec_regB[447:416])) ? vec_regB[415:384]:vec_regB[447:416];
                current_reg[255:224] = (lmul==2'b00 || lmul==2'b01) ? 32'b10000000000000000000000000000000: ($signed(vec_regB[479:448]) >= $signed(vec_regB[511:480])) ? vec_regB[479:448]:vec_regB[511:480];

                result[31:0] = current_reg[31:0];
                step = 3'b001;
                done = 0;
            end
            endcase
        end
        3'b001:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = ($signed(current_reg[7:0]) >= $signed(current_reg[15:8])) ? current_reg[7:0]:current_reg[15:8];
                current_reg[15:8] = ($signed(current_reg[23:16]) >= $signed(current_reg[31:24])) ? current_reg[23:16]:current_reg[31:24];
                current_reg[23:16] = ($signed(current_reg[39:32]) >= $signed(current_reg[47:40])) ? current_reg[39:32]:current_reg[47:40];
                current_reg[31:24] = ($signed(current_reg[55:48]) >= $signed(current_reg[63:56])) ? current_reg[55:48]:current_reg[63:56];
                current_reg[39:32] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[71:64]) >= $signed(current_reg[79:72])) ? current_reg[71:64]:current_reg[79:72];
                current_reg[47:40] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[87:80]) >= $signed(current_reg[95:88])) ? current_reg[87:80]:current_reg[95:88];
                current_reg[55:48] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[103:96]) >= $signed(current_reg[111:104])) ? current_reg[103:96]:current_reg[111:104];
                current_reg[63:56] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[119:112]) >= $signed(current_reg[127:120])) ? current_reg[119:112]:current_reg[127:120];
                current_reg[71:64] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[135:128]) >= $signed(current_reg[143:136])) ? current_reg[135:128]:current_reg[143:136];
                current_reg[79:72] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[151:144]) >= $signed(current_reg[159:152])) ? current_reg[151:144]:current_reg[159:152];
                current_reg[87:80] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[167:160]) >= $signed(current_reg[175:168])) ? current_reg[167:160]:current_reg[175:168];
                current_reg[95:88] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[183:176]) >= $signed(current_reg[191:184])) ? current_reg[183:176]:current_reg[191:184];
                current_reg[103:96] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[199:192]) >= $signed(current_reg[207:200])) ? current_reg[199:192]:current_reg[207:200];
                current_reg[111:104] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[215:208]) >= $signed(current_reg[223:216])) ? current_reg[215:208]:current_reg[223:216];
                current_reg[119:112] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[231:224]) >= $signed(current_reg[239:232])) ? current_reg[231:224]:current_reg[239:232];
                current_reg[127:120] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[247:240]) >= $signed(current_reg[255:248])) ? current_reg[247:240]:current_reg[255:248];
               
                result[7:0] = current_reg[7:0];  
                step = 3'b010;
                done = 0;
            end
            2'b01:
            begin
                current_reg[15:0] = ($signed(current_reg[15:0]) >= $signed(current_reg[31:16])) ? current_reg[15:0]:current_reg[31:16];
                current_reg[31:16] = ($signed(current_reg[47:32]) >= $signed(current_reg[63:48])) ? current_reg[47:32]:current_reg[63:48];
                current_reg[47:32] = (lmul==2'b00) ? 16'b1000000000000000: ($signed(current_reg[79:64]) >= $signed(current_reg[95:80])) ? current_reg[79:64]:current_reg[95:80];
                current_reg[63:48] = (lmul==2'b00) ? 16'b1000000000000000: ($signed(current_reg[111:96]) >= $signed(current_reg[127:112])) ? current_reg[111:96]:current_reg[127:112];
                current_reg[79:64] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(current_reg[143:128]) >= $signed(current_reg[159:144])) ? current_reg[143:128]:current_reg[159:144];
                current_reg[95:80] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(current_reg[175:160]) >= $signed(current_reg[191:176])) ? current_reg[175:160]:current_reg[191:176];
                current_reg[111:96] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(current_reg[207:192]) >= $signed(current_reg[223:208])) ? current_reg[207:192]:current_reg[223:208];
                current_reg[127:112] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(current_reg[239:224]) >= $signed(current_reg[255:240])) ? current_reg[239:224]:current_reg[255:240];

                result[15:0] = current_reg[15:0];
                step = 3'b010;
                done = 0;  
            end
            default:
            begin
                current_reg[31:0] = ($signed(current_reg[31:0]) >= $signed(current_reg[63:32])) ? current_reg[31:0]:current_reg[63:32];
                current_reg[63:32] = (lmul==2'b00) ? 32'b10000000000000000000000000000000: ($signed(current_reg[95:64]) >= $signed(current_reg[127:96])) ? current_reg[95:64]:current_reg[127:96];
                current_reg[95:64] = (lmul==2'b00 || lmul==2'b01) ? 32'b10000000000000000000000000000000: ($signed(current_reg[159:128]) >= $signed(current_reg[191:160])) ? current_reg[159:128]:current_reg[191:160];
                current_reg[127:96] = (lmul==2'b00 || lmul==2'b01) ? 32'b10000000000000000000000000000000: ($signed(current_reg[223:192]) >= $signed(current_reg[255:224])) ? current_reg[223:192]:current_reg[255:224];

                result[31:0] = ((lmul==2'b00) && (($signed(vec_regA[31:0])) >= ($signed(current_reg[31:0])))) ? vec_regA[31:0]:current_reg[31:0];
                step = (lmul==2'b00) ? 3'b000:3'b010;
                done = (lmul==2'b00) ? 1:0;
            end
            endcase
        end

        3'b010:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = ($signed(current_reg[7:0]) >= $signed(current_reg[15:8])) ? current_reg[7:0]:current_reg[15:8];
                current_reg[15:8] = ($signed(current_reg[23:16]) >= $signed(current_reg[31:24])) ? current_reg[23:16]:current_reg[31:24];
                current_reg[23:16] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[39:32]) >= $signed(current_reg[47:40])) ? current_reg[39:32]:current_reg[47:40];
                current_reg[31:24] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[55:48]) >= $signed(current_reg[63:56])) ? current_reg[55:48]:current_reg[63:56];
                current_reg[39:32] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[71:64]) >= $signed(current_reg[79:72])) ? current_reg[71:64]:current_reg[79:72];
                current_reg[47:40] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[87:80]) >= $signed(current_reg[95:88])) ? current_reg[87:80]:current_reg[95:88];
                current_reg[55:48] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[103:96]) >= $signed(current_reg[111:104])) ? current_reg[103:96]:current_reg[111:104];
                current_reg[63:56] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[119:112]) >= $signed(current_reg[127:120])) ? current_reg[119:112]:current_reg[127:120];

                result[7:0] = current_reg[7:0];
                step = 3'b011;
                done = 0;
            end
            2'b01:
            begin
                current_reg[15:0] = ($signed(current_reg[15:0]) >= $signed(current_reg[31:16])) ? current_reg[15:0]:current_reg[31:16];
                current_reg[31:16] = (lmul==2'b00) ? 16'b1000000000000000: ($signed(current_reg[47:32]) >= $signed(current_reg[63:48])) ? current_reg[47:32]:current_reg[63:48];
                current_reg[47:32] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(current_reg[79:64]) >= $signed(current_reg[95:80])) ? current_reg[79:64]:current_reg[95:80];
                current_reg[63:48] = (lmul==2'b00 || lmul==2'b01) ? 16'b1000000000000000: ($signed(current_reg[111:96]) >= $signed(current_reg[127:112])) ? current_reg[111:96]:current_reg[127:112];

                result[15:0] = ((lmul==2'b00) && ($signed(vec_regA[15:0])) >= $signed(current_reg[15:0])) ? vec_regA[15:0]:current_reg[15:0];
                step = (lmul==2'b00) ? 3'b000:3'b011;
                done = (lmul==2'b00) ? 1:0;  
            end
            default:
            begin
                current_reg[31:0] = ($signed(current_reg[31:0]) >= $signed(current_reg[63:32])) ? current_reg[31:0]:current_reg[63:32];
                current_reg[63:32] = (lmul==2'b01) ? 32'b10000000000000000000000000000000: ($signed(current_reg[95:64]) >= $signed(current_reg[127:96])) ? current_reg[95:64]:current_reg[127:96];

                result[31:0] = ((lmul==2'b01) && (($signed(vec_regA[31:0])) >= ($signed(current_reg[31:0])))) ? vec_regA[31:0]:current_reg[31:0];
                step = (lmul==2'b01) ? 3'b000:3'b011;
                done = (lmul==2'b01) ? 1:0;
            end
            endcase
        end
        3'b011:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = ($signed(current_reg[7:0]) >= $signed(current_reg[15:8])) ? current_reg[7:0]:current_reg[15:8];
                current_reg[15:8] = (lmul==2'b00) ? 8'b10000000: ($signed(current_reg[23:16]) >= $signed(current_reg[31:24])) ? current_reg[23:16]:current_reg[31:24];
                current_reg[23:16] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[39:32]) >= $signed(current_reg[47:40])) ? current_reg[39:32]:current_reg[47:40];
                current_reg[31:24] = (lmul==2'b00 || lmul==2'b01) ? 8'b10000000: ($signed(current_reg[55:48]) >= $signed(current_reg[63:56])) ? current_reg[55:48]:current_reg[63:56];

                result[7:0] = ((lmul==2'b00) && ($signed(vec_regA[7:0])) >= $signed(current_reg[7:0])) ? vec_regA[7:0]:current_reg[7:0];
                step = (lmul == 2'b00) ? 3'b000:3'b100;
                done = (lmul == 2'b00) ? 1:0;
            end
            2'b01:
            begin
                current_reg[15:0] = ($signed(current_reg[15:0]) >= $signed(current_reg[31:16])) ? current_reg[15:0]:current_reg[31:16];
                current_reg[31:16] = (lmul==2'b01) ? 16'b1000000000000000: ($signed(current_reg[47:32]) >= $signed(current_reg[63:48])) ? current_reg[47:32]:current_reg[63:48];


                result[15:0] = ((lmul==2'b01) && ($signed(vec_regA[15:0])) >= $signed(current_reg[15:0])) ? vec_regA[15:0]:current_reg[15:0];
                step = (lmul==2'b01) ? 3'b000:3'b0100;
                done = (lmul==2'b01) ? 1:0;  
            end
            default:
            begin
                current_reg[31:0] = ($signed(current_reg[31:0]) >= $signed(current_reg[63:32])) ? current_reg[31:0]:current_reg[63:32];

                result[31:0] = ($signed(vec_regA[31:0]) >= $signed(current_reg[31:0])) ? vec_regA[31:0]:current_reg[31:0];
                step = 3'b000;
                done = 1;
            end
            endcase
        end
        3'b100:
        begin
            case (sew)
            2'b00:
            begin
                current_reg[7:0] = ($signed(current_reg[7:0]) >= $signed(current_reg[15:8])) ? current_reg[7:0]:current_reg[15:8];
                current_reg[15:8] = (lmul==2'b01) ? 8'b10000000: ($signed(current_reg[23:16]) >= $signed(current_reg[31:24])) ? current_reg[23:16]:current_reg[31:24];

                result[7:0] = ((lmul==2'b01) && ($signed(vec_regA[7:0])) >= $signed(current_reg[7:0])) ? vec_regA[7:0]:current_reg[7:0];
                step = (lmul == 2'b01) ? 3'b000:3'b101;
                done = (lmul == 2'b01) ? 1:0;
            end
            2'b01:
            begin
                current_reg[15:0] = ($signed(current_reg[15:0]) >= $signed(current_reg[31:16])) ? current_reg[15:0]:current_reg[31:16];

                result[15:0] = ($signed(vec_regA[15:0]) >= $signed(current_reg[15:0])) ? vec_regA[15:0]:current_reg[15:0];
                step = 3'b000;
                done = 1;
            end
            endcase
        end
        3'b101:
        begin
            current_reg[7:0] = ($signed(current_reg[7:0]) >= $signed(current_reg[15:8])) ? current_reg[7:0]:current_reg[15:8];
            result[7:0] = ($signed(vec_regA[7:0])) >= $signed(current_reg[7:0]) ? vec_regA[7:0]:current_reg[7:0];
   
            step = 3'b000;
            done = 1;
        end
        endcase
    end
    endcase
end
endmodule

