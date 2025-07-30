
`include "alu.v"
`include "interface.sv"
`include "coverage.sv"

module top;
	
	import alu_pkg::*;

	bit clk = 0;
	bit rst;

	initial forever #10 clk = ~clk;

	/*
	initial begin
		@(posedge clk); 
		rst = 1;
		repeat(1) @(posedge clk); 
		rst = 0;
	end
	*/

	alu_intf intf(clk, reset);

	ALU_DESIGN DUT(
		.OPA(intf.OPA),
		.OPB(intf.OPB),
		.CMD(intf.CMD),
		.CE(intf.CE),
		.CIN(intf.CIN),
		.INP_VALID(intf.INP_VALID),
		.MODE(intf.MODE),
		.G(intf.G),
		.L(intf.L),
		.E(intf.E),
		.ERR(intf.ERR),
		.COUT(intf.COUT),
		.OFLOW(intf.OFLOW),
		.RES(intf.RES),
		.CLK(clk),
		.RST(rst)
	);
	
	cover_age alu_cover(clk,rst,intf.CE,intf.MODE,intf.CMD,intf.INP_VALID,intf.OPA,intf.OPB,intf.CIN,intf.RES);

	test tb;

	initial begin
		tb = new(intf.DRV, intf.MON, intf.REF);
		tb.run();
		$finish;
	end
endmodule
