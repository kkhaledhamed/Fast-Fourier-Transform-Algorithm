onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/clk
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/rst_n
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/f_in_imag
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/f_in_real
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/f_out_imag
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/f_out_real
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/REF_imag
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/REF_real
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/test_count
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/total_abs_error_imag
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/total_abs_error_real
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/total_fail
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/total_pass
add wave -noupdate -expand -group {Testbench Signals} /FFT_tb/total_samples
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x0_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x0_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x1_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x1_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x2_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x2_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x3_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x3_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x4_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x4_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x5_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x5_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x6_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x6_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x7_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/x7_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/X_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Inputs in time} /FFT_tb/X_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y0_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y0_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y1_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y1_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y2_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y2_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y3_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y3_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y4_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y4_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y5_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y5_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y6_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y6_real
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y7_imag
add wave -noupdate -expand -group {Testbench Signals} -expand -group {Outputs in frequency} /FFT_tb/y7_real
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5980000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {7381500 ps}
