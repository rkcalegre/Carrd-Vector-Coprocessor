How-to:

Run project_run.tcl to add the files to your project.
Use your RISC-V GNU Toolchain Assembler (e.g. riscv32-unknown-elf-as) to assemble assembly files.
Use the RISC-V GNU Toolchain Objdump -d option to dump the contents of the *.out file the assembler made.
Copy the .text and .data sections over to separate text files, then run coegen.py for the datamem and dumpgen.py for the instmem, then copy the script outputs to the respective files in the project.

Note: uart_isr.s needs to be assembled and placed in the ISR for the UART interface to work.

Note 2: I strongly recommend finding a way to automate this process...
