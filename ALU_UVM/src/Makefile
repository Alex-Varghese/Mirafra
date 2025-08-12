GNORE:

# Default target: run the full suite (your original all target runs everything)
all: clean new_funct compile clear simulate coverage_report

# Original clean
clean:
	rm -rf work/ transcript

# Remove previous coverage files
new_funct:
	rm -f alu_funct_coverage.ucdb

# Original compile with coverage and logs
compile:
	vlog -sv +acc +cover +fcover -l alu.log top.sv

# Original simulate with coverage and assertions
simulate:
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do \
	"coverage save -onexit -assert -directive -cvg -codeAll alu_coverage.ucdb; run -all; exit"

# Generate HTML coverage report
coverage_report:
	vcover report -html alu_coverage.ucdb -htmldir covReport -details

# Read coverage report in terminal
read_cov:
	vcover report -details alu_funct_coverage.ucdb

# Clear screen twice
clear:
	clear
	clear

# Full test target - same as before
main: clean
	vlog -sv +acc +cover +fcover -l alu.log alu_pkg.sv top.sv
	make clear
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do \
	"coverage save -onexit -assert -directive -cvg -codeAll alu_coverage.ucdb; run -all; exit"
	vcover report -html alu_coverage.ucdb -htmldir covReport -details

# -----------------------------------
# New added targets from your request
# -----------------------------------

# Simplified clean for run target
clean_run:
	rm -rf transcript work

# Simplified compile - compile alu_pkg.sv and top.sv
compile_run:
	vlog alu_pkg.sv top.sv

# Run target depends on simplified compile_run
run: compile_run
	vsim -c top -do "run -all; quit"

