
vsim_asymmetric_fifo = work/asymmetric_fifo

vsim_asymmetric_fifo_tb = work/asymmetric_fifo_tb

vsim_asymmetric_distributed_ram = work/asymmetric_distributed_ram

work :
	vlib work

$(vsim_asymmetric_fifo) : asymmetric_fifo.v work
	vlog asymmetric_fifo.v +incdir+../common

$(vsim_asymmetric_fifo_tb) : asymmetric_fifo_tb.v work
	vlog asymmetric_fifo_tb.v +incdir+../common

$(vsim_asymmetric_distributed_ram) : ../ram/asymmetric_distributed_ram.v work
	vlog ../ram/asymmetric_distributed_ram.v +incdir+../common

cleanVsim :
	rm -rf work transcript

checkVsim : work $(vsim_asymmetric_fifo_tb) $(vsim_asymmetric_fifo) $(vsim_asymmetric_distributed_ram)
	echo -e "vsim work.asymmetric_fifo_tb\nrun -all" | vsim
