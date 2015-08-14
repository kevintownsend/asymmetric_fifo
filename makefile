vim :
	vim -p asymmetric_fifo.v asymmetric_fifo_tb.v ../ram/asymmetric_distributed_ram.v makefile vsim.mk

sim :
	iverilog -o std_fifo_tb.vvp -I../common std_fifo_tb.v std_fifo.v
	std_fifo_tb.vvp

synth :

include xst.mk
include vsim.mk

tcl :
	vivado -mode tcl < compile.tcl

clean :
	rm -rf *.vvp *.out
