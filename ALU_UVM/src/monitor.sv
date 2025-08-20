

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
    if(!uvm_config_db#(virtual alu_intf)::get(this, "", "vif", vif))
    
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
  	super.run_phase(phase);
    forever begin
    //repeat(2) @(vif.mon_cb);  
		repeat(5) @(vif.mon_cb);
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
   if(vif.mon_cb.MODE) begin      
	`uvm_info(get_name(),$sformatf("@ : %0t Arithmetic : ",$time),UVM_MEDIUM);
	`uvm_info(get_name(),$sformatf("RST = %b | CE = %b |  CIN = %b | INPVALID = %b | CMD = %d | OPA = %d | OPB = %d | RES = %d | ERR = %b | OFLOW = %b | COUT = %b | GLE = %b%b%b",seq.RST,seq.CE,seq.CIN,seq.INP_VALID,seq.CMD,seq.OPA,seq.OPB,seq.RES,seq.ERR,seq.OFLOW,seq.COUT,seq.G,seq.L,seq.E),UVM_MEDIUM);
    end
    else begin
	`uvm_info(get_name(),$sformatf("@ : %0t Logical : ",$time),UVM_MEDIUM);
	    `uvm_info(get_name(),$sformatf("RST = %b | CE = %b |  CIN = %b | INPVALID = %b | CMD = %d | OPA = %b | OPB = %b | RES = %d | ERR = %b | OFLOW = %b | COUT = %b | GLE = %b%b%b",seq.RST,seq.CE,seq.CIN,seq.INP_VALID,seq.CMD,seq.OPA,seq.OPB,seq.RES,seq.ERR,seq.OFLOW,seq.COUT,seq.G,seq.L,seq.E),UVM_MEDIUM);
   end
	 if((vif.mon_cb.MODE) && (vif.mon_cb.CMD == 9 || vif.mon_cb.CMD == 10))
	 		repeat(2)@(vif.mon_cb);		
	 else			
		  repeat(3)@(vif.mon_cb);
	 item_collected_port.write(seq);

   end
  endtask
  
endclass
