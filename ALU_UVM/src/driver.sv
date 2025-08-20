`include "defines.svh"
class driver extends uvm_driver #(sequence_item);

  virtual alu_intf vif;
  `uvm_component_utils(driver)
 		 
  uvm_analysis_port #(sequence_item) item_collected_port;
    
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual alu_intf)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(req);
		begin
			repeat(3) @(vif.driver_cb); begin
			vif.driver_cb.RST <= req.RST;
			vif.driver_cb.OPA <= req.OPA;
			vif.driver_cb.OPB <= req.OPB;
			vif.driver_cb.MODE <= req.MODE;
			vif.driver_cb.CMD <= req.CMD;
			vif.driver_cb.CIN <= req.CIN;
			vif.driver_cb.CE <= req.CE;
			vif.driver_cb.INP_VALID <= req.INP_VALID;
			if((req.MODE) && (req.CMD == 9 || req.CMD == 10))
				repeat(3) @(vif.driver_cb); // changed from 1 to new
			else
				repeat(4) @(vif.driver_cb);			
							// req.print();
			item_collected_port.write(req);
			repeat(1) @(vif.driver_cb);
		end
    end
    if(vif.driver_cb.MODE) begin
      `uvm_info(get_name(),$sformatf("@ : %0t Arithmetic : ",$time),UVM_MEDIUM);
      `uvm_info(get_name(),$sformatf("RST = %b | CE = %b |  CIN = %b | INPVALID = %b | CMD = %d | OPA = %d | OPB = %d",vif.driver_cb.RST,vif.driver_cb.CE,vif.driver_cb.CIN,vif.driver_cb.INP_VALID,vif.driver_cb.CMD,vif.driver_cb.OPA,vif.driver_cb.OPB),UVM_MEDIUM);
    end
    else begin
      `uvm_info(get_name(),$sformatf("@ : %0t Logical : ",$time),UVM_MEDIUM);
      `uvm_info(get_name(),$sformatf("RST = %b | CE = %b |  CIN = %b | INPVALID = %b | CMD = %d | OPA = %d | OPB = %d",vif.driver_cb.RST,vif.driver_cb.CE,vif.driver_cb.CIN,vif.driver_cb.INP_VALID,vif.driver_cb.CMD,vif.driver_cb.OPA,vif.driver_cb.OPB),UVM_MEDIUM);
    end
		seq_item_port.item_done();
    end
  endtask 

endclass
