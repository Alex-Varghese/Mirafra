

class driver extends uvm_driver #(mem_sequence_item);

  virtual alu_interface vif;

  `uvm_component_utils(driver)
  
   uvm_analysis_port #(sequence_item) item_collected_port;
    
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual alu_interface)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(req);
    begin
    	repeat(1) @(vif.driver_cb);
		repeat(1) @(vif.driver_cb) begin
			vif.driver_cb.RST <= req.RST;
			vif.driver_cb.OPA <= req.OPA;
			vif.driver_cb.OPB <= req.OPB;
			vif.driver_cb.MODE <= req.MODE;
			vif.driver_cb.CMD <= req.CMD;
			vif.driver_cb.CIN <= req.CIN;
			vif.driver_cb.CE <= req.CE;
			vif.driver_cb.INP_VALID <= req.INP_VALID;
			repeat(1) @(vif.driver_cb);
			req.print();
			item_collected_port.write(req);
		end
    end
    seq_item_port.item_done();
    end
  endtask 

endclass
