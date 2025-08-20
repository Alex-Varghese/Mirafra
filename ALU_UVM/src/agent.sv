 
class agent extends uvm_agent;

  sequencer seq;
  driver drv;
  monitor mon;
   
  `uvm_component_utils(agent) 
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    endfunction : new
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    if(get_is_active == UVM_ACTIVE) begin
		drv = driver::type_id::create("drv",this);
		seq = sequencer::type_id::create("seq",this);  
	end
    mon = monitor::type_id::create("mon",this);
  endfunction: build_phase
    
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seq.seq_item_export);
  endfunction : connect_phase

endclass : agent
    
      
