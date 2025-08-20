`include "defines.svh"

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
  
endclass : sequence_base

class reset_sequence extends sequence_base;
  
  `uvm_object_utils(reset_sequence)
   
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
					repeat(`no_trans)begin
    `uvm_do_with(req,{req.RST == 1;})
									end
	endtask
  
  endclass : reset_sequence

class INP_VALID_01_sequence extends sequence_base;
  
  `uvm_object_utils(INP_VALID_01_sequence)
   
  function new(string name = "INP_VALID_01_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
					repeat(`no_trans)begin
    `uvm_do_with(req,{req.INP_VALID == 2'b01;})
  end
	endtask
  
endclass : INP_VALID_01_sequence

class INP_VALID_10_sequence extends sequence_base;
  
  `uvm_object_utils(INP_VALID_10_sequence)
   
  function new(string name = "INP_VALID_10_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    			repeat(`no_trans)begin
					`uvm_do_with(req,{req.INP_VALID == 2'b10;})
									end
	endtask
  
endclass : INP_VALID_10_sequence

class INP_VALID_11_sequence extends sequence_base;
  
  `uvm_object_utils(INP_VALID_11_sequence)
   
  function new(string name = "INP_VALID_11_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
		repeat(`no_trans)begin
    `uvm_do_with(req,{req.INP_VALID == 2'b11;})
						end
	endtask
  
endclass : INP_VALID_11_sequence

class INP_VALID_00_sequence extends sequence_base;
  
  `uvm_object_utils(INP_VALID_00_sequence)
   
  function new(string name = "INP_VALID_00_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
		repeat(`no_trans)begin
						`uvm_do_with(req,{req.INP_VALID == 2'b00;CMD == 1;})
						end
	endtask
endclass

class AND_sequence extends sequence_base;
  
  `uvm_object_utils(AND_sequence)
  
  function new(string name = "AND_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
					repeat(`no_trans)begin
					`uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 0;})
									end
	endtask
  
endclass : AND_sequence

class NAND_sequence extends sequence_base;

	`uvm_object_utils(NAND_sequence)

	function new(string name = "NAND_sequence");
		super.new(name);
	endfunction

	virtual task body();
					repeat(`no_trans)begin
					`uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 1;})
									end
	endtask

endclass : NAND_sequence


class OR_sequence extends sequence_base;
  
  `uvm_object_utils(OR_sequence)
  
  function new(string name = "OR_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
					repeat(`no_trans)begin
					`uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 2;})
									end
	endtask
  
endclass : OR_sequence

class NOR_sequence extends sequence_base;
		
	`uvm_object_utils(NOR_sequence)

	function new(string name = "NOR_sequence");
					super.new(name);
	endfunction

	virtual task body();
					repeat(`no_trans)begin
					`uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 3;})
									end
	endtask

endclass : NOR_sequence

class XOR_sequence extends sequence_base;   

  `uvm_object_utils(XOR_sequence)

  function new(string name = "XOR_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 4;})
									end
	endtask

endclass : XOR_sequence

class XNOR_sequence extends sequence_base;   

  `uvm_object_utils(XNOR_sequence)

  function new(string name = "XNOR_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 5;})
									end
	endtask

endclass : XNOR_sequence

class NOTA_sequence extends sequence_base;   

  `uvm_object_utils(NOTA_sequence)

  function new(string name = "NOTA_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 6;})
									end
	endtask

endclass : NOTA_sequence

class NOTB_sequence extends sequence_base;   

  `uvm_object_utils(NOTB_sequence)

  function new(string name = "NOTB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 7;})
									end
	endtask

endclass : NOTB_sequence

class SRA_sequence extends sequence_base;   

  `uvm_object_utils(SRA_sequence)

  function new(string name = "SRA_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 8;})
									end
	endtask

endclass : SRA_sequence

class SRB_sequence extends sequence_base;   

  `uvm_object_utils(SRB_sequence)

  function new(string name = "SRB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 10;})
									end
	endtask

endclass : SRB_sequence

class SLA_sequence extends sequence_base;   

  `uvm_object_utils(SLA_sequence)

  function new(string name = "SLA_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 9;})
									end
	endtask

endclass : SLA_sequence

class SLB_sequence extends sequence_base;   

  `uvm_object_utils(SLB_sequence)

  function new(string name = "SLB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 11;})
									end
	endtask

endclass : SLB_sequence

class ROR_sequence extends sequence_base;   

  `uvm_object_utils(ROR_sequence)

  function new(string name = "ROR_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 13;})
									end
	endtask

endclass : ROR_sequence

class ROL_sequence extends sequence_base;   

  `uvm_object_utils(ROL_sequence)

  function new(string name = "ROL_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
				  repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 0;req.CMD == 12;})
									end
	endtask

endclass : ROL_sequence

class ADD_sequence extends sequence_base;   

  `uvm_object_utils(ADD_sequence)

  function new(string name = "ADD_sequence");
          super.new(name);     
	endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 0;})
									end
	endtask

endclass : ADD_sequence

class ADDCIN_sequence extends sequence_base;   

  `uvm_object_utils(ADDCIN_sequence)

  function new(string name = "ADDCIN_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 2;})
									end
	endtask

endclass : ADDCIN_sequence

class SUB_sequence extends sequence_base;   

  `uvm_object_utils(SUB_sequence)

  function new(string name = "SUB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 1;})
									end
	endtask

endclass : SUB_sequence

class SUBCIN_sequence extends sequence_base;   

  `uvm_object_utils(SUBCIN_sequence)

  function new(string name = "SUBCIN_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 3;})
									end
	endtask

endclass : SUBCIN_sequence

class INCA_sequence extends sequence_base;   

  `uvm_object_utils(INCA_sequence)

  function new(string name = "INCA_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 4;})
									end
	endtask

endclass : INCA_sequence

class INCB_sequence extends sequence_base;   

  `uvm_object_utils(INCB_sequence)

  function new(string name = "INCB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 6;})
									end
	endtask

endclass : INCB_sequence

class DECA_sequence extends sequence_base;   

  `uvm_object_utils(DECA_sequence)

  function new(string name = "DECA_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 5;})
									end
	endtask

endclass : DECA_sequence

class DECB_sequence extends sequence_base;   

  `uvm_object_utils(DECB_sequence)

  function new(string name = "DECB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 7;})
									end
	endtask

endclass : DECB_sequence

class CMP_sequence extends sequence_base;   

  `uvm_object_utils(CMP_sequence)

  function new(string name = "CMP_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 8;})
									end
	endtask

endclass : CMP_sequence

class MULAB_sequence extends sequence_base;   

  `uvm_object_utils(MULAB_sequence)

  function new(string name = "MULAB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();        
					repeat(`no_trans)begin					
          `uvm_do_with(req,{req.INP_VALID == 2'b11;req.MODE == 1;req.CMD == 9;})
									end
	endtask

endclass : MULAB_sequence

class LMULAB_sequence extends sequence_base;   

  `uvm_object_utils(LMULAB_sequence)

  function new(string name = "LMULAB_sequence");
          super.new(name);     
  endfunction                     

  virtual task body();   
          repeat(`no_trans)begin					
          `uvm_do_with(req,{INP_VALID == 2'b11;MODE == 1;CMD == 10;})
									end
	endtask

endclass : LMULAB_sequence

class err_sequence extends sequence_base;
  
  `uvm_object_utils(err_sequence)
 
  function new(string name = "err_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
		repeat(`no_trans)begin
	  `uvm_do_with(req,{req.MODE == 0;req.CMD inside { 12,13 };})
						end
	endtask
endclass


class alu_regression extends sequence_base;
  
  reset_sequence rst;
  INP_VALID_00_sequence inp00;
  INP_VALID_01_sequence inp01;
  INP_VALID_10_sequence inp10;
  INP_VALID_11_sequence inp11;
  AND_sequence seq1;
	NAND_sequence seq2;
	OR_sequence seq3;
	NOR_sequence seq4;
	XOR_sequence seq5;
  XNOR_sequence seq6;
  NOTA_sequence seq7;
	NOTB_sequence seq8;
	SRA_sequence seq9;
	SLA_sequence seq10;
	SLB_sequence seq11;
	SRB_sequence seq12;
	ROR_sequence seq13;
	ROL_sequence seq14;
	ADD_sequence seq15;
	ADDCIN_sequence seq16;
	SUBCIN_sequence seq17;
	MULAB_sequence seq18;
	LMULAB_sequence seq19;
	INCA_sequence seq20;
	INCB_sequence seq21;
	DECA_sequence seq22;
	DECB_sequence seq23;
	SUB_sequence seq24;
	CMP_sequence seq25;
  err_sequence err;
  
  `uvm_object_utils(alu_regression)
   
  function new(string name = "alu_regression");
    super.new(name);
  endfunction
  
  virtual task body();
    rst = reset_sequence::type_id::create("rst");
    inp00 = INP_VALID_00_sequence::type_id::create("inp00");
    inp01 = INP_VALID_01_sequence::type_id::create("inp01");
    inp10 = INP_VALID_10_sequence::type_id::create("inp10");
    inp11 = INP_VALID_11_sequence::type_id::create("inp11");
    seq1 = AND_sequence::type_id::create("seq1");
    seq2 = NAND_sequence::type_id::create("seq2");
		seq3 = OR_sequence::type_id::create("seq3");
		seq4 = NOR_sequence::type_id::create("seq4");
		seq5 = XOR_sequence::type_id::create("seq5");
		seq6 = XNOR_sequence::type_id::create("seq6");
		seq7 = NOTA_sequence::type_id::create("seq7");
	  seq8 = NOTB_sequence::type_id::create("seq8");
	  seq9 = SRA_sequence::type_id::create("seq9");
		seq10 = SLA_sequence::type_id::create("seq10");
		seq11 = SLB_sequence::type_id::create("seq11");
		seq12 = SRB_sequence::type_id::create("seq12");
		seq13 = ROR_sequence::type_id::create("seq13");
	  seq14 = ROL_sequence::type_id::create("seq14");
		seq15 = ADD_sequence::type_id::create("seq15");
		seq16 = ADDCIN_sequence::type_id::create("seq16");
    seq17 = SUBCIN_sequence::type_id::create("seq17");
		seq18 = MULAB_sequence::type_id::create("seq18");
		seq19 = LMULAB_sequence::type_id::create("seq19");
		seq20 = INCA_sequence::type_id::create("seq20");
		seq21 = INCB_sequence::type_id::create("seq21");
		seq22 = DECA_sequence::type_id::create("seq22");
		seq23 = DECB_sequence::type_id::create("seq23");
		seq24 = SUB_sequence::type_id::create("seq24");
		seq25 = CMP_sequence::type_id::create("seq25");			
		err = err_sequence::type_id::create("err");	  
    `uvm_do(rst)
    `uvm_do(inp00)
    `uvm_do(inp01)
    `uvm_do(inp10)
    `uvm_do(inp11)
    `uvm_do(seq1)
    `uvm_do(seq2)
		`uvm_do(seq3)
	  `uvm_do(seq4)
		`uvm_do(seq5)
		`uvm_do(seq6)
		`uvm_do(seq7)
		`uvm_do(seq8)
		`uvm_do(seq9)
		`uvm_do(seq10)
		`uvm_do(seq11)
		`uvm_do(seq12)
		`uvm_do(seq13)
		`uvm_do(seq14)
		`uvm_do(seq15)
		`uvm_do(seq16)
		`uvm_do(seq17)
		`uvm_do(seq18)
		`uvm_do(seq19)
		`uvm_do(seq20)
		`uvm_do(seq21)
		`uvm_do(seq22)
		`uvm_do(seq23)
		`uvm_do(seq24)
		`uvm_do(seq25)
    `uvm_do(err)
	endtask
  
endclass : alu_regression
