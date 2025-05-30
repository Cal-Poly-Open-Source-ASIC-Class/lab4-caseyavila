puts "\[INFO\]: Creating Clocks"
create_clock [get_ports w_clk] -name w_clk -period 12
set_propagated_clock w_clk
create_clock [get_ports r_clk] -name r_clk -period 20
set_propagated_clock r_clk

set_clock_groups -asynchronous -group [get_clocks {w_clk r_clk}]

puts "\[INFO\]: Setting Max Delay"

set write_period    [get_property -object_type clock [get_clocks {w_clk}] period]
set read_period     [get_property -object_type clock [get_clocks {r_clk}] period]
set min_period      [expr {min(${read_period}, ${write_period})}]

set_max_delay -from [get_pins w_ptr[*]*df*/CLK] -to [get_pins sync_wptr.q1[*]*df*/D] $min_period
set_max_delay -from [get_pins r_ptr[*]*df*/CLK] -to [get_pins sync_rptr.q1[*]*df*/D] $min_period
