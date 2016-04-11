onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_r_search/addrb
add wave -noupdate /tb_r_search/clk
add wave -noupdate -radix unsigned /tb_r_search/dout_r
add wave -noupdate -radix unsigned /tb_r_search/dout_q
add wave -noupdate /tb_r_search/eval_end
add wave -noupdate /tb_r_search/fin_busqueda
add wave -noupdate /tb_r_search/fitness
add wave -noupdate /tb_r_search/rst
add wave -noupdate /tb_r_search/start_busqueda
add wave -noupdate /tb_r_search/start_eval
add wave -noupdate /tb_r_search/i_r_search/i_main_uc/fsm_cs
add wave -noupdate /tb_r_search/i_r_search/i_genera_cromosoma/estado_actual
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_genera_cromosoma/mutacion
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_main_uc/fitness_hijo_1
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_main_uc/fitness_hijo_2
add wave -noupdate /tb_r_search/i_r_search/i_main_uc/mejor_fitness_1
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_genera_cromosoma/cromosoma_hijo_1
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_genera_cromosoma/cromosoma_hijo_2
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_genera_cromosoma/cromosoma_padre
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_genera_cromosoma/cromosoma_mutado
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_mux/in_0
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_mux/in_1
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_mux/in_2
add wave -noupdate -radix unsigned /tb_r_search/i_r_search/i_mux/in_3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2308 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {2289 ns} {2321 ns}
