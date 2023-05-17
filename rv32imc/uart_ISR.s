# This test code is to demonstrate UART functionality of the
# Pipelined RV32IMC + Protocol controllers
#
# An external device sends a lowercase character to the FPGA, and outputs
# the uppercase character.
# ==========================
# Register usage:
#		gp -> points to PROTOCOLMEM addresses
#		s0 -> x0 for compressed instructions
#		s1 -> TXBF
#		s2 -> Asserted if valid data has been received
#		s11 -> WRDONE & RDDONE status from previous interrupt
#		t0-t6 -> local subroutine registers (not saved between calls)
#		a0-a1 -> subroutine return values
#		a2-a7 -> subroutine arguments
# ==========================
# NOTE: ISR should save a0-a7 & t0-t6 in the stack to preserve their value.
# Also, should the ISR need to use c.jal, dont forget to save ra to the stack first.

.text
isr:
	# push temporary register contents to the stack
	addi sp, sp, -4
	sw gp, 0(sp)
	
	addi sp, sp, -60			# formula: sp - (# of registers to save)*4
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	sw t5, 20(sp)
	sw t6, 24(sp)
	sw a0, 28(sp)
	sw a1, 32(sp)
	sw a2, 36(sp)
	sw a3, 40(sp)
	sw a4, 44(sp)
	sw a5, 48(sp)
	sw a6, 52(sp)
	sw a7, 56(sp)
	
	la gp, 0x8000
	
	# here, check if program is in send function
	lw t3, 0x40(x0)				# send function flag
	lw t4, 0x80(x0)				# receive function flag


	# check if UART interrupted
	lw t0, 0xc(gp)				# load UART Output Control to t0
	andi t1, t0, 0x101			# get RDDONE & WRDONE
	beq t1, x0, eret			# if both are deasserted, UART didn't interrupt. execute URET
	beqz t3, skip_tx_flag_set		# skip TX flag set
	
	andi s1, t0, 0x40			# get TXBF & store to s1 so main program can check if buffer is still full
	
	skip_tx_flag_set:
	c.mv t2, s11				# copy s11 contents to t2
	andi t2, t2, 0x100			# get RDDONE from s11
	bne t2, x0, eret			# if RDDONE was asserted from the previous interrupt, then current interrupt is due to WRDONE.
								# Don't execute code for received data.
	
	beqz t3, eret		# skip RX flag set
	andi t1, t0, 0x100			# get RDDONE
	beq t1, x0, eret			# if interrupt wasn't due to received data, exit ISR

	# Check if data received is valid
	andi t1, t0, 0x200			# get PERR
	bne t1, x0, eret			# if PERR is asserted, data is invalid; exit ISR
	
	# here, check if check if 
	c.li s2, 1					# if data is valid, assert s2

eret:
	# Pop registers from stack
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	lw t5, 20(sp)
	lw t6, 24(sp)
	lw a0, 28(sp)
	lw a1, 32(sp)
	lw a2, 36(sp)
	lw a3, 40(sp)
	lw a4, 44(sp)
	lw a5, 48(sp)
	lw a6, 52(sp)
	lw a7, 56(sp)
	addi sp, sp, 60

	lw s11, 0xc(gp)				# load Output control
	andi s11, s11, 0x101		# get updated RDDONE & WRDONE
	
	lw gp, 0(sp)
	addi sp, sp, 4

	uret

# Add at least 4 NOPs to prevent don't cares from entering the pipeline
	c.nop
	c.nop
	c.nop
	c.nop
