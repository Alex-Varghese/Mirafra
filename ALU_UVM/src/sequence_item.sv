`include "defines.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class sequence_item extends uvm_sequence_item;
  
  rand logic [`WIDTH-1:0] OPA,OPB;
  rand logic CIN, MODE, RST, CE;
  rand logic [`CMD_WIDTH-1:0] CMD;
  rand logic [1:0] INP_VALID;
  logic [`WIDTH:0] RES;
  logic G, L, E, ERR, OFLOW, COUT;
 /* 
  `uvm_object_utils_begin(sequence_item)
  
    `uvm_field_int(RST,UVM_BIN | UVM_ALL_ON)
    `uvm_field_int(CE,UVM_BIN | UVM_ALL_ON) 
    `uvm_field_int(OPA,UVM_DEC | UVM_ALL_ON)
    `uvm_field_int(OPB,UVM_DEC | UVM_ALL_ON)
    `uvm_field_int(CMD,UVM_DEC | UVM_ALL_ON)
    `uvm_field_int(INP_VALID,UVM_DEC | UVM_ALL_ON)
    `uvm_field_int(CIN,UVM_BIN | UVM_ALL_ON)
    `uvm_field_int(MODE,UVM_BIN | UVM_ALL_ON)
  
  `uvm_object_utils_end
  */
  `uvm_object_utils(sequence_item)
	constraint ce_val { soft CE == 1; }
  //constraint ce_before_mode { solve CE before MODE; }
  //constraint mode_before_cmd { solve MODE before CMD; }
  //constraint inp_valid_before_cmd { solve INP_VALID before CMD; }
	constraint rst_val { soft RST == 0; }  
	constraint cmd_val { 
					if(MODE) 
									CMD inside {[0:10]}; 
					else CMD inside {[0:13]}; 
	}  
	function new(string name = "sequence_item");
    super.new(name);
  endfunction
                                                                                   
endclass
