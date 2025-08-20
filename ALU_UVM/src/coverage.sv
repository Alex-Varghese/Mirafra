`include "defines.svh"
`uvm_analysis_imp_decl(_mon_cg)
`uvm_analysis_imp_decl(_drv_cg)

class alu_coverage extends uvm_component;

	`uvm_component_utils(alu_coverage)
	  
	uvm_analysis_imp_mon_cg #(sequence_item, alu_coverage) aport_mon1;
	uvm_analysis_imp_drv_cg #(sequence_item, alu_coverage) aport_drv1;

	sequence_item txn_drv1;
	real mon1_cov,drv1_cov;

	covergroup driver_cov;
	  RST_CP : coverpoint txn_drv1.RST { bins RST_ON = {1}; bins RST_OFF = {0}; }
	  MODE_CP : coverpoint txn_drv1.MODE { bins MODE_ON = {1}; bins MODE_OFF = {0}; } 
	  CIN_CP : coverpoint txn_drv1.CIN { bins CIN_ON = {1}; bins CIN_OFF = {0}; }
	  CE_CP : coverpoint txn_drv1.CE { bins CE_ON = {1}; bins CE_OFF = {0}; }
	  INPVALID_CP : coverpoint txn_drv1.INP_VALID {
	    bins INP_VALID_00  = {0};
	    bins INP_VALID_01  = {1};
	    bins INP_VALID_10 = {2};
	    bins INP_VALID_11  = {3};
	  }
	  CMD_ARITHMETIC_CP : coverpoint txn_drv1.CMD iff (txn_drv1.MODE) {
	    bins ADD = {0};
	    bins SUB = {1};
	    bins ADD_CIN = {2};
	    bins SUB_CIN = {3};
	    bins INC_A = {4};
	    bins INC_B = {5};
	    bins DEC_A = {6};
	    bins DEC_B = {7};
	    bins CMP = {8};
	    bins INC_A_B_MUL = {9};
	    bins LFT_SHIFT_MUL = {10};
	   }
	  CMD_LOGICAL_CP : coverpoint txn_drv1.CMD iff (!txn_drv1.MODE) {   
	    bins AND = {0};
	    bins NAND = {1};
	    bins OR = {2};
	    bins NOR = {3};
	    bins XOR = {4};
	    bins XNOR = {5};
	    bins NOT_A = {6};
	    bins NOT_B = {7};
	    bins SRA1 = {8};
	    bins SLA1 = {9};
	    bins SRB1 = {10};
	    bins SLB1 = {11};
	    bins ROL = {12};
	    bins ROR = {13};
	  }
	  OPA_CP : coverpoint txn_drv1.OPA {
	    bins OPA_VAL = {[0:2**`WIDTH-1]};
	  }
	  OPB_CP : coverpoint txn_drv1.OPB {
	    bins OPB_VAL = {[0:2**`WIDTH-1]};
	  }
		CMD_ARITHMETIC_CPxINPVALID_CP : cross CMD_ARITHMETIC_CP,INPVALID_CP;
	  CMD_LOGICAL_CPxINPVALID_CP : cross CMD_LOGICAL_CP,INPVALID_CP;
	endgroup : driver_cov

	covergroup monitor_cov;
	   COUT_CP : coverpoint txn_drv1.COUT iff ((txn_drv1.CMD == 0)&&(txn_drv1.MODE)) { bins COUT_ON = {1}; bins COUT_OFF = {0}; }
	   OFLOW_CP : coverpoint txn_drv1.OFLOW { bins OFLOW_ON = {1}; bins OFLOW_OFF = {0}; }
	   G_CP : coverpoint txn_drv1.G iff ((txn_drv1.CMD == 8)&&(txn_drv1.MODE)) { bins G_ON = {1}; bins G_OFF = {0}; }
	   L_CP : coverpoint txn_drv1.L iff ((txn_drv1.CMD == 8)&&(txn_drv1.MODE)) { bins L_ON = {1}; bins L_OFF = {0}; }
	   ERR_CP : coverpoint txn_drv1.ERR { bins ERR_ON = {1}; bins ERR_OFF = {0}; }
	   E_CP : coverpoint txn_drv1.E iff ((txn_drv1.CMD == 8)&&(txn_drv1.MODE)) { bins E_ON = {1}; bins E_OFF = {0}; }
	   RES_CP : coverpoint txn_drv1.RES { bins RES_VAL = {[0:2**`WIDTH]}; }
	endgroup : monitor_cov

	function new(string name = "", uvm_component parent);
	  super.new(name, parent);
	  monitor_cov = new;
	  driver_cov = new;
	  aport_drv1=new("aport_drv1", this);
	  aport_mon1 = new("aport_mon1", this);
	endfunction
	  
	function void write_drv_cg(sequence_item t);
	  txn_drv1 = t;
	  driver_cov.sample();
	endfunction


	function void write_mon_cg(sequence_item t);
	  txn_mon1 = t;
	  monitor_cov.sample();
	endfunction
	  

	function void extract_phase(uvm_phase phase);
	  super.extract_phase(phase);
	  drv1_cov = driver_cov.get_coverage();
	  mon1_cov = monitor_cov.get_coverage();
	endfunction

	function void report_phase(uvm_phase phase);
	  super.report_phase(phase);
	  `uvm_info(get_type_name, $sformatf("[DRIVER] Coverage ------> %0.2f%%,", drv1_cov), UVM_MEDIUM);
	  `uvm_info(get_type_name, $sformatf("[MONITOR] Coverage ------> %0.2f%%", mon1_cov), UVM_MEDIUM);
	  endfunction

endclass : alu_coverage

