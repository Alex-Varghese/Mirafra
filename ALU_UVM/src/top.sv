`include "uvm_macros.svh"
`include "interface.sv"
`include "test.sv"
import uvm_pkg::*;    
 
module top;
  bit clk = 0;
  
  always #5 clk = ~clk;
  
  initial begin
    repeat(3)@(posedge clk);
  end
  alu_intf vif(clk,RST);
  
  alu_design DUT(
    .CLK(vif.clk),
    .RST(vif.RST),
    .CE(vif.CE),
    .MODE(vif.MODE),
    .CIN(vif.CIN),
    .INP_VALID(vif.INP_VALID),
    .CMD(vif.CMD),
    .OPA(vif.OPA),
    .OPB(vif.OPB),
    .RES(vif.RES),
    .ERR(vif.ERR),
    .OFLOW(vif.OFLOW),
    .COUT(vif.COUT),
    .G(vif.G),
    .L(vif.L),
    .E(vif.E)
   );
  
  initial begin 
    uvm_config_db#(virtual alu_intf)::set(null,"*","vif",vif);
    $dumpfile("dump.vcd");
	$dumpvars;
  end
  
  initial begin 
    run_test("test");
    #1000 $finish;
  end
endmodule
    
