transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/labsyns/lab3 {E:/labsyns/lab3/ram2.v}
vlog -sv -work work +incdir+E:/labsyns/lab3 {E:/labsyns/lab3/fifo.sv}
vlog -sv -work work +incdir+E:/labsyns/lab3 {E:/labsyns/lab3/top_lab3.sv}
vlog -sv -work work +incdir+E:/labsyns/lab3 {E:/labsyns/lab3/lfshr.sv}
vlog -vlog01compat -work work +incdir+E:/labsyns/lab3 {E:/labsyns/lab3/fifoctrl.v}
vlog -sv -work work +incdir+E:/labsyns/lab3 {E:/labsyns/lab3/bcdtohex.sv}

