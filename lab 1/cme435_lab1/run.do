onbreak {resume}
if [file exists work] {
		vdel -all
}
vlib work
vmap work work
vlog *.v
vopt +acc test_counter -o test_counter_opt
vsim test_counter_opt
add wave /test_counter/*
add log -r /*
run 5000
