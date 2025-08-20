`include"defines.svh"

interface alu_intf(input logic clk);
  
  logic RST;
  logic [1:0] INP_VALID;
  logic MODE;
  logic [`CMD_WIDTH : 0] CMD;
  logic CE;
  logic [(`WIDTH - 1) : 0]OPA,OPB;
  logic CIN;
  logic ERR;
  logic [`WIDTH + 1: 0] RES;
  logic OFLOW,COUT;
  logic G,L,E;

  clocking driver_cb @(posedge clk);
    default input #0 output #0;
    output RST;	  
    output INP_VALID;
    output MODE;
    output CMD;
    output CE;
    output OPA;
    output OPB;
    output CIN;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #0 output #0;
    input ERR;
    input RES;
    input OFLOW;
    input COUT;
    input G,L,E;
    input INP_VALID;
    input MODE;
    input CMD;
    input CE;
    input OPA;
    input OPB;
    input CIN;
    input RST;
  endclocking

  clocking reference_cb @(posedge clk);
    default input #0 output #0;
    input RST;
    input INP_VALID;
    input MODE;
    input CMD;
    input CE;
    input OPA;
    input OPB;
    input CIN;
  endclocking

  modport driver_modport (clocking driver_cb);
  modport monitor_modport (clocking mon_cb);
  modport reference_modport (clocking reference_cb);

endinterface
