`include "agent.sv"
`include "scoreboard.sv"

class environment extends uvm_env;
  
  alu_coverage subscriber;
  agent agnt;
  scoreboard scb;
  
  `uvm_component_utils(environment)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt = agent::type_id::create("agnt",this);
    scb = scoreboard::type_id::create("scb",this);
	subscriber = alu_coverage::type_id::create("subscriber", this);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
	agnt.mon.item_collected_port.connect(scb.item_collected_export);
	agnt.drv.item_collected_port.connect(subscr.aport_drv);	
	agnt.mon.item_collected_port.connect(subscr.aport_mon);	
  endfunction : connect_phase
    
 endclass : env
    
    
