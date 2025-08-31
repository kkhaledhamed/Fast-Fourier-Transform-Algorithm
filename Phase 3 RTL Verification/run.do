# ======================================================
# Cleaning work library
vdel -all
vlib work

# ======================================================
# Compile
vlog FFT.v FFT_tb.sv +cover -covercells 

# ======================================================
# ---- DUT coverage only ----
vsim -voptargs=+acc work.FFT_tb -cover -l SIM.log

do wave.do

# Save DUT coverage 
#coverage save FFT.ucdb -onexit -du work.FFT

run -all

# Exclude defaults from DUT coverage
coverage exclude -src FFT.v -line 110 -code b
coverage exclude -src FFT.v -line 121 -code b
coverage exclude -src FFT.v -line 124 -code b
coverage exclude -src FFT.v -line 145 -code b
coverage exclude -src FFT.v -line 148 -code b
coverage exclude -src FFT.v -line 150 -code b
coverage exclude -src FFT.v -line 152 -code b
coverage exclude -src FFT.v -line 210 -code b
coverage exclude -src FFT.v -line 245 -code b

coverage exclude -src FFT.v -line 110 -code c
coverage exclude -src FFT.v -line 121 -code c
coverage exclude -src FFT.v -line 124 -code c
coverage exclude -src FFT.v -line 148 -code c
coverage exclude -src FFT.v -line 150 -code c

coverage exclude -src FFT.v -line 111 -code s
coverage exclude -src FFT.v -line 122 -code s
coverage exclude -src FFT.v -line 125 -code s
coverage exclude -src FFT.v -line 146 -code s
coverage exclude -src FFT.v -line 147 -code s
coverage exclude -src FFT.v -line 149 -code s
coverage exclude -src FFT.v -line 151 -code s
coverage exclude -src FFT.v -line 153 -code s
coverage exclude -src FFT.v -line 211 -code s
coverage exclude -src FFT.v -line 212 -code s
coverage exclude -src FFT.v -line 213 -code s
coverage exclude -src FFT.v -line 214 -code s
coverage exclude -src FFT.v -line 215 -code s
coverage exclude -src FFT.v -line 216 -code s
coverage exclude -src FFT.v -line 217 -code s
coverage exclude -src FFT.v -line 218 -code s
coverage exclude -src FFT.v -line 246 -code s
coverage exclude -src FFT.v -line 247 -code s


quit -sim
vcover report FFT.ucdb -details -annotate -all -output coverage_report.txt
