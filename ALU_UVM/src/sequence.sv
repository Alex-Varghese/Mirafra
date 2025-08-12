
class sequence_base extends uvm_sequence#(sequence_item);
  
  `uvm_object_utils(sequence_base)
  function new(string name = "sequence_base");
    super.new(name);
  endfunction


  virtual task body();
    repeat(2)begin
      req = sequence_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
    end
  endtask
  
endclass : sequence

class inp_valid_01_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(reset_sequence)
   
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.RST == 1;})
  endtask
  
  endclass : reset_sequence

class inp_valid_01_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(inp_valid_01_sequence)
   
  function new(string name = "inp_valid_01_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.INP_VALID == 2'b01;})
  endtask
  
endclass : inp_valid_01_sequence

class inp_valid_10_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(inp_valid_10_sequence)
   
  function new(string name = "inp_valid_10_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.INP_VALID == 2'b10;})
  endtask
  
endclass : inp_valid_10_sequence

class inp_valid_11_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(inp_valid_11_sequence)
   
  function new(string name = "inp_valid_11_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(10) begin
    `uvm_do_with(req,{req.inp_valid == 2'b11;})
    end
  endtask
  
endclass : inp_valid_11_sequence

class inp_valid_00_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(inp_valid_00_sequence)
   
  function new(string name = "inp_valid_00_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(10) begin
    `uvm_do_with(req,{req.inp_valid == 2'b00;})
    end
  endtask
endclass

class cmd_mode_1_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(cmd_mode_1_sequence)
  
  int i;
  
  function new(string name = "cmd_mode_1_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    for(i = 0; i < 11; i++) begin
	    repeat(10) begin
	      `uvm_do_with(req,{req.inp_valid == 2'b11;req.inp_valid == i;})
	    end
    end
  endtask
  
endclass : cmd_mode_1_sequence

class cmd_mode_0_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(cmd_mode_0_sequence)
  
  int i;
  
  function new(string name = "cmd_mode_0_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    for(i = 0; i < 14; i++) begin
	    repeat(10) begin
	      `uvm_do_with(req,{req.inp_valid == 2'b11;req.inp_valid == i;})
	    end
    end
  endtask
  
endclass : cmd_mode_0_sequence

class err_sequence extends sequence_base #(sequence_item);
  
  `uvm_object_utils(err_sequence)
 
  function new(string name = "err_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(10) begin
	`uvm_do_with(req,{req.MODE == 0;req.CMD inside {[12:13]};req.OPA inside {[0:255]};req.OPB inside {[0:255]};})
    end
    end
  endtask
endclass


class alu_regression extends sequence_base #(sequence_item);
  
  reset_sequence rst;
  inp_valid_00_sequence inp00
  inp_valid_01_sequence inp01;
  inp_valid_10_sequence inp10;
  inp_valid_11_sequence inp11;
  cmd_mode_1_sequence cmd_mode1;
  cmd_mode_0_sequence cmd_mode0;
  err_sequence err;
  
  `uvm_object_utils(mem_regression)
   
  function new(string name = "mem_regression");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do(rst)
    `uvm_do(inp00)
    `uvm_do(inp01)
    `uvm_do(inp10)
    `uvm_do(inp11)
    `uvm_do(inp11)
    `uvm_do(cmd_mode1)
    `uvm_do(cmd_mode0)
    `uvm_do(err)
  endtask
  
endclass : alu_regression
