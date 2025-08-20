
class test extends uvm_test;

  `uvm_component_utils(test)
  
  environment env;
  alu_regression regress;
  
  function new(string name = "test", uvm_component parent = null); 
    super.new(name,parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = environment::type_id::create("env",this);
    regress = alu_regression::type_id::create("regress");
  endfunction : build_phase
  
  virtual task run_phase(uvm_phase phase); 
    phase.raise_objection(this,"Raised Objection");
    regress.start(env.agnt.seq);
    phase.drop_objection(this,"Objection dropped");
  endtask : run_phase
  
  virtual function void end_of_elaboration();
    // uvm_top.print_topology();
  endfunction
	
endclass : test
    	
