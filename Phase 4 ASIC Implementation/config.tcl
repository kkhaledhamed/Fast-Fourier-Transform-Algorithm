# ========== Design Info ==========
set ::env(DESIGN_NAME) "FFT"

# RTL sources
set ::env(VERILOG_INCLUDE_DIRS) "$::env(DESIGN_DIR)/src"
set ::env(VERILOG_FILES) "$::env(DESIGN_DIR)/src/FFT.v"

# Use Verilog mode in Yosys
set ::env(SYNTH_READ_VERILOG) "v"

# ========== Clock ==========
set ::env(CLOCK_PORT) "CLK"

# ========== Floorplan ==========
set ::env(DIE_AREA) "0 0 500 500" 

