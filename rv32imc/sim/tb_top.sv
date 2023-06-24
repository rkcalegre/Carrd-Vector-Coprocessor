`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2020 11:27:17 PM
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "constants.vh"

module tb_top();

	reg CLK100MHZ, nrst;
	wire ck_io0;
	reg  ck_io1;
	wire ck_io2;
	wire ck_io3;
	wire ck_io4;
	wire ck_io5;
	wire ck_io6;
	wire ck_io7;
	// reg  ck_io8;
	wire ck_io8 = 1;
	wire ck_io38;
	wire ck_io39;

	reg [3:0] con_write = TOP.RISCVCORE.con_write;
	//reg [`DATAMEM_BITS-1:0] con_addr = TOP.RISCVCORE.con_addr;
	reg [13:0] con_addr;
	reg [`WORD_WIDTH-1:0] con_in = TOP.RISCVCORE.con_in;
	wire [`WORD_WIDTH-1:0] con_out = TOP.RISCVCORE.con_out;
	reg [`WORD_WIDTH-1:0] last_inst;

	top TOP(
		.CLK100MHZ(CLK100MHZ),
		.nrst(nrst),

		.ck_io0(ck_io0),
		.ck_io1(ck_io1),
		.ck_io2(ck_io2),
		.ck_io3(ck_io3),
		.ck_io4(ck_io4),
		.ck_io5(ck_io5),
		.ck_io6(ck_io6),
		.ck_io7(ck_io7),
		.ck_io8(ck_io8),
		.ck_io38(ck_io38),
		.ck_io39(ck_io39),
		.con_addr(con_addr)
	);

	answerkey AK();
	answerkey0 AK0();
	answerkey1 AK1();
	answerkey2 AK2();
	answerkey3 AK3();

	integer i, j, check, done, pass, consecutive_nops;
	integer total_test_cases = 0;
	integer print_metrics = 0;
	integer nop_counter;
	integer max_data_addr;
	wire [31:0] INST;
	assign INST = TOP.RISCVCORE.if_inst;
	//assign TOP.RISCVCORE.con_addr = con_addr;

	always
		#5 CLK100MHZ = ~CLK100MHZ;

	initial begin
		CLK100MHZ = 0;
		nrst = 0;
		ck_io1 = 1;

		last_inst = 0;

		con_write = 0;
		con_addr = 0;
		con_in = 0;
		done = 0;
		check = 0;
		pass = 0;
		i = 0;
		j = 0;

		#100 nrst = 1;
	end
	//force con_addr = 0;
	
	// reg [11:0] mem_PC, wb_PC;
	// always@(posedge TOP.CLKIP_OUT) begin
	// 	if(!nrst) begin
	// 		mem_PC <= 0;
	// 		wb_PC <= 0;
	// 	end else begin
	// 		mem_PC <= {TOP.RISCVCORE.exe_PC, 1'b0};
	// 		wb_PC <= mem_PC;
	// 	end
	// end

	// Stimulus for the UART decoder
//	reg [7:0] enc_din = 0;
//	reg enc_en = 0;
//	reg [1:0] enc_parity = 0;
//	reg enc_stopsel = 0;
//	reg [23:0] enc_baud = 24'd5207;
//	wire enc_tx;
//	integer enc_counter = 0;

	// reg CLK50MHZ = 0;
	// always #10 CLK50MHZ = ~CLK50MHZ;

//	test_encoder ENCODER(
//		.clk(CLK50MHZ),
//        .nrst(nrst),

//        .data_in(enc_din),
//        .en(enc_en),
//        .parity(enc_parity),
//        .stop_sel(enc_stopsel),
//        .baudcontrol(enc_baud),

//        .uart_enc(enc_tx),
//        .uart_rco(/*This signal is not needed*/)
//	);

//	always@(*) ck_io8 = enc_tx;

//	// Task for encoder stimulus
//	task enc_stimulus();
//		input [7:0] din;
//		begin
//			enc_din = din;
//			#5 enc_en = 1'b1;
//			#20 enc_en = 1'b0;
//		end
//	endtask

//	task enc_strinput();
//		input [16*8:0] string;
//		begin
//			enc_stimulus(string[127:120]);
//			#200 enc_stimulus(string[119:112]);
//			#200 enc_stimulus(string[111:104]);
//			#200 enc_stimulus(string[103:96]);
//			#200 enc_stimulus(string[95:88]);
//			#200 enc_stimulus(string[87:80]);
//			#200 enc_stimulus(string[79:72]);
//			#200 enc_stimulus(string[71:64]);
//			#200 enc_stimulus(string[63:56]);
//			#200 enc_stimulus(string[55:48]);
//			#200 enc_stimulus(string[47:40]);
//			#200 enc_stimulus(string[39:32]);
//			#200 enc_stimulus(string[31:24]);
//			#200 enc_stimulus(string[23:16]);
//			#200 enc_stimulus(string[15:8]);
//			#200 enc_stimulus(string[7:0]);
//		end
//	endtask

//	always@(posedge CLK50MHZ) begin
//		if(nrst /* & TOP.locked */) begin
//			// Up to 16 bytes only -> max data that TXBUFFER can store
//			enc_counter <= enc_counter + 1;
//			if(enc_counter == 130000) enc_strinput("The Deli\n5:32pm\r\n");
//			if(enc_counter == 240000) enc_strinput("Chon\nRosewood\r\n\0");
//			if(enc_counter == 350000) enc_strinput("hCon\nRosewood\r\n\0");
//			if(enc_counter == 460000) enc_strinput("Vraell\nFall\r\n\0\0\0");
//			if(enc_counter == 570000) enc_strinput("Coldplay\nSparks\n");
//			if(enc_counter == 680000) enc_strinput("Polyphia\nGOAT\r\n\0");
//			if(enc_counter == 790000) enc_strinput("NITO\nHomesick\r\n\0");
//			if(enc_counter == 800000) enc_strinput("NITO\nHomesick\r\n\0");
//		end
//	end

	 // For checking UART_TX output of top-level design
	 // settings: 115200bps, no parity, 1 stop bit
	 /*
	 reg [7:0] uart_shiftreg = 0;
	 reg [7:0] uart_recvd = 0;
	 integer uart_counter = 0;
	 reg uart_clk = 0;

	 // for generating 115.2kHz clock w/ delayed start
	 initial begin
	 	while(ck_io7 == 1) #5;
	 	    #20000 uart_clk = 1;
	 	forever begin
	 		#52080 uart_clk = ~uart_clk;
	 	end
	 end

	 // Just manually change uart_counter 'threshold' depending on expected
	 // transmission length.
	 // SETTINGS: 1 stop bit, no parity -> 10 bits per transaction (start, 8bit data, parity, stop)
	 always@(posedge uart_clk) begin
	 	if(!nrst) uart_counter <= 0;
	 	else if(uart_counter == 10) uart_counter <= 1;
	 	else uart_counter <= uart_counter + 1;
	 end

	 always@(posedge uart_clk) begin
	 	if(nrst) begin
	 		if(uart_counter == 10) uart_shiftreg <= 0;
	 		else begin
	 			uart_shiftreg[0] <= uart_shiftreg[1];
	 			uart_shiftreg[1] <= uart_shiftreg[2];
	 			uart_shiftreg[2] <= uart_shiftreg[3];
	 			uart_shiftreg[3] <= uart_shiftreg[4];
	 			uart_shiftreg[4] <= uart_shiftreg[5];
	 			uart_shiftreg[5] <= uart_shiftreg[6];
	 			uart_shiftreg[6] <= uart_shiftreg[7];
	 			uart_shiftreg[7] <= ck_io7;
	 		end
	 	end
	 end

	 always@(posedge uart_clk) begin
	 	if(nrst) begin
	 		if(uart_counter == 9) uart_recvd <= uart_shiftreg;
	 	end
	 end
	*/
//	// For checking MOSI output of top-level design
//	// NOTE: just manually change sampling edge (if posedge or negedge)
//	// depending on CPHA & CPOL settings. This snippet just helps confirm MOSI.
//	// Also, you need to manually change order of the shift register depending on ORD setting.
//	reg [15:0] spi_shiftreg = 0;
//	integer i = 0;
//	always@(posedge ck_io0) begin
//		for(i = 15; i > 0; i = i-1)
//			spi_shiftreg[i] <= spi_shiftreg[i-1];
//		spi_shiftreg[0] <= ck_io2;
//	end

//	integer spi_counter = 0;
//	always@(posedge ck_io0) begin
//		if(!nrst) spi_counter <= 0;
//		else begin
//			if(spi_counter == 16) spi_counter <= 1;
//			else spi_counter <= spi_counter + 1;
//		end
//	end

//	// SPI Stimulus
//	reg [15:0] spi_miso_shiftreg = 16'h0009;
//	always@(negedge ck_io0) begin
//		spi_miso_shiftreg <= spi_miso_shiftreg << 1;
//	end
//	always@(*) ck_io1 = spi_miso_shiftreg[15];

//	// For checking I2C outputs of top-level design
//	// NOTE: Data is sent MSB first. Every 9th bit is reserved for slave ACKs.
//	reg SCL = 1'b1;
//	reg SDA = 1'b1;
	
//	always@(posedge ck_io38) SCL <= 1;
//	always@(negedge ck_io38) SCL <= 0;

//	always@(posedge ck_io39) SDA <= 1;
//	always@(negedge ck_io39) SDA <= 0;

//	reg [31:0] i2c_shiftreg = 0;
//	integer i2c_counter = 0;

//	// Detect start & stop bits
//	reg sda_reg = 0;
//	reg last_sda_reg = 0;
//	reg scl_reg = 0;
//	reg last_scl_reg = 0;
//	wire sda_posedge = sda_reg & ~last_sda_reg;
//	wire sda_negedge = ~sda_reg & last_sda_reg;
//	wire scl_posedge = scl_reg & ~last_scl_reg;
//	wire scl_negedge = ~scl_reg & last_scl_reg;
//	wire start_bit = sda_negedge & scl_reg;
//	wire stop_bit = sda_posedge & scl_reg;

//	always@(posedge CLK50MHZ) begin
//		sda_reg <= ck_io39;
//		scl_reg <= ck_io38;
//		last_sda_reg <= sda_reg;
//		last_scl_reg <= scl_reg;
//	end

//	always@(posedge SCL or posedge stop_bit) begin
//		if(!nrst) i2c_counter <= 0;
//		else if(i2c_counter == 9) i2c_counter <= 1;
//		else if(stop_bit) i2c_counter <= 0;
//		else i2c_counter <= i2c_counter + 1;
//	end

//	// Sample the data bits only. Skip ACK bits
//	always@(posedge SCL) begin
//		if(nrst) begin
//			if(i2c_counter != 8) begin
//				for(i = 31; i > 0; i = i-1)
//					i2c_shiftreg[i] <= i2c_shiftreg[i-1];
//				i2c_shiftreg[0] <= SDA;
//			end
//		end
//	end

	// Drive inout ports of the module
	assign ck_io39 = 1'b1;
	assign ck_io38 = 1'b1;
	
	
	// dump all variables
//	initial begin
//	   $dumpfile("D:/Files/CIDR/RV32IMC-Redeployment/top_sim_cdchange.vcd");
//	   $dumpvars(0, TOP);
//	   $dumpvars(0, TOP.RISCVCORE.RF);
//	   $dumpvars(0, TOP.RISCVCORE.SF_CONTROLLER);
//	   $dumpvars(0, TOP.RISCVCORE.DATAMEM);
//	   $dumpvars(0, TOP.RISCVCORE.BRANCHPREDICTOR);
	   	   
//	   $dumpoff;
//	   #14480000;
//	   $dumpon;
//	   #800000;
//	   $dumpoff;
//	   #400000;
//	   $finish;
//	end

	always@(posedge CLK100MHZ) begin
	    if (!nrst) begin
	        check = 0;
	        consecutive_nops = 0;
	        last_inst = 0;
	    end
	    else
            if (!done)
                if (INST == last_inst && (INST[15:0] == 16'h0001 || INST == 32'h00000013)) begin
                    consecutive_nops = consecutive_nops + 1;
                    check = check + 1;
                end
                else if (INST == last_inst) begin
                    check = check + 1;
                end
                else begin
                    last_inst <= INST;
                    consecutive_nops = 0;
                    check = 0;
                end
	end
	// This controls the NOP counter
	always@(posedge CLK100MHZ) begin
	   if (!done)
            if(!nrst)
                nop_counter <= 0;
            else if(!done)
                if(INST[15:0] == 16'h0001 || INST == 32'h00000013)
                    nop_counter <= nop_counter + 1;
	end
	// This controlls the done flag
	always@(posedge CLK100MHZ) begin
		if(check == 49 || consecutive_nops == 16) done = 1;
	end

	// This controls max_data_addr
	always@(posedge CLK100MHZ) begin
		if(!nrst)
			max_data_addr <= 0;
		else if(!done) 
			max_data_addr <= 14'd783;
			/*
			if((CORE.exe_is_stype && |CORE.exe_dm_write && CORE.exe_ALUout[15:2] > max_data_addr) && (CORE.exe_ALUout[15:2] < 14'h2c))
				max_data_addr <= CORE.exe_ALUout[15:2];
			*/
	end

	// The following code is for checking the contents
	// of BLOCKMEM
	always@(posedge done) begin
		$display("---------| SUMMARY |---------");
		$display("Address\t  Actual  \tExpected ");
		$display("=======\t==========\t==========");	
	end

	/*
	always@(negedge CLK100MHZ) begin
		if(done) begin
			if (con_addr[1:0] == 2'b00) begin
				if(con_out == AK0.memory0[con_addr[`DATAMEM_BITS-1:2]]) begin
					//$display("0x%3X\t0x%X\t0x%X\tPass", con_addr, con_out, AK.memory[con_addr]);
					pass = pass + 1;
				end else begin
					$display("0x%3X\t0x%X\t0x%X\tFail--------------------", con_addr, con_out, AK0.memory0[con_addr[`DATAMEM_BITS-1:2]]);
				end
			end else if (con_addr[1:0] == 2'b01) begin
				if(con_out == AK1.memory1[con_addr[`DATAMEM_BITS-1:2]]) begin
					//$display("0x%3X\t0x%X\t0x%X\tPass", con_addr, con_out, AK.memory[con_addr]);
					pass = pass + 1;
				end else begin
					$display("0x%3X\t0x%X\t0x%X\tFail--------------------", con_addr, con_out, AK1.memory1[con_addr[`DATAMEM_BITS-1:2]]);
				end
			end	else if (con_addr[1:0] == 2'b10) begin
				if(con_out == AK2.memory2[con_addr[`DATAMEM_BITS-1:2]]) begin
					//$display("0x%3X\t0x%X\t0x%X\tPass", con_addr, con_out, AK.memory[con_addr]);
					pass = pass + 1;
				end else begin
					$display("0x%3X\t0x%X\t0x%X\tFail--------------------", con_addr, con_out, AK2.memory2[con_addr[`DATAMEM_BITS-1:2]]);
				end
			end else begin
				if(con_out == AK3.memory3[con_addr[`DATAMEM_BITS-1:2]]) begin
					//$display("0x%3X\t0x%X\t0x%X\tPass", con_addr, con_out, AK.memory[con_addr]);
					pass = pass + 1;
				end else begin
					$display("0x%3X\t0x%X\t0x%X\tFail--------------------", con_addr, con_out, AK3.memory3[con_addr[`DATAMEM_BITS-1:2]]);
				end
			end

			total_test_cases = total_test_cases + 1;
			if (con_addr == max_data_addr) print_metrics = 1;
			con_addr = con_addr + 1;
		end
	end
	*/
	
	always@(negedge CLK100MHZ) begin
		if(done) begin	
			if(con_out == AK.memory[con_addr]) begin
				//$display("0x%3X\t0x%X\t0x%X\tPass", con_addr, con_out, AK.memory[con_addr]);
				pass = pass + 1;
			end else begin
				$display("0x%3X\t0x%X\t0x%X\tFail--------------------", con_addr, con_out, AK.memory[con_addr]);
			end

			total_test_cases = total_test_cases + 1;
			if(con_addr == max_data_addr) print_metrics = 1;
			con_addr = con_addr + 1;
		end
	end
	

	always @(posedge print_metrics) begin
		done = 0;
		$display("\n");
		$display("Passed %0d/%0d test cases.", pass, total_test_cases);
		$finish;
	end

endmodule

module answerkey();
	reg [31:0] memory [0:1023];
	initial begin
		$readmemh("answerkey.mem", memory);
	end
endmodule

module answerkey0();
	reg [31:0] memory0 [0:255];
	initial begin
		$readmemh("answerkey0.mem", memory0);
	end
endmodule

module answerkey1();
	reg [31:0] memory1 [0:255];
	initial begin
		$readmemh("answerkey1.mem", memory1);
	end
endmodule

module answerkey2();
	reg [31:0] memory2 [0:255];
	initial begin
		$readmemh("answerkey2.mem", memory2);
	end
endmodule

module answerkey3();
	reg [31:0] memory3 [0:255];
	initial begin
		$readmemh("answerkey3.mem", memory3);
	end
endmodule