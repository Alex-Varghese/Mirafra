

class monitor extends uvm_monitor;

  virtual alu_intf vif;
  sequence_item seq;
  
  uvm_analysis_port #(sequence_item) item_collected_port;
  
  `uvm_component_utils(monitor)

  function new (string name, uvm_component parent = null);
    super.new(name, parent);
    seq = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_interface)::get(this, "", "vif", vif))
    
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
  	super.run_phase(phase);
    forever begin
      repeat(2) @(vif.mon_cb);  
	  repeat(3) @(vif.mon_cb)
	  if(vif.mon_cb.MODE && vif.mon_cb.CMD == 9) 
	  	repeat(1)@(vif.mon_cb);
	  begin
		seq.RES = vif.mon_cb.RES;
		seq.OFLOW = vif.mon_cb.OFLOW;
		seq.COUT = vif.mon_cb.COUT;
		seq.E = vif.mon_cb.E;
		seq.G = vif.mon_cb.G;
		seq.L = vif.mon_cb.L;
		seq.ERR = vif.mon_cb.ERR;
		seq.MODE = vif.mon_cb.MODE;
		seq.CMD = vif.mon_cb.CMD;
		seq.OPA = vif.mon_cb.OPA;
		seq.OPB = vif.mon_cb.OPB;
		seq.INP_VALID = vif.mon_cb.INP_VALID;
		seq.CE  = vif.mon_cb.CE;
		seq.RST = vif.mon_cb.RST;
		seq.CIN = vif.mon_cb.CIN;
	 end
   item_collected_port.write(seq);
   seq.print();
   end
  endtask
  
endclass
