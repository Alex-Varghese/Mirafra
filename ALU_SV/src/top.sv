`include "alu_interface.sv"
`include "alu.v"

module top( );
  import alu_package ::*; 
  bit clk;
  bit rst;

  initial
    begin
     forever #10 clk=~clk;
  end

  initial
    begin
      @(posedge clk);
      rst = 0;
      repeat(1) @(posedge clk);
      rst = 1;
  end
 
  alu_intf intf_alu(clk,rst);

  alu DUT(.opa(intf_alu.opa),
            .opb(intf_alu.opb),
	    .cmd(intf_alu.cmd),
            .ce(intf_alu.ce),
            .cin(intf_alu.cin),
            .inp_valid(intf_alu.inp_valid),
	    .mode(intf_alu.mode),
	    .g(intf_alu.g),
	    .l(intf_alu.l),
	    .e(intf_alu.e),
	    .err(intf_alu.err),
	    .cout(intf_alu.cout),
	    .oflow(intf_alu.oflow),
	    .res(intf_alu.res);
            .clk(clk),
            .rst(rst)
           );

  alu_test_bench tb = new(intf_alu.driver_modport ,intf_alu.monitor_modport ,intf_alu.reference_modport);

  initial
   begin
    tb.run();
    $finish();
  end
endmodule


