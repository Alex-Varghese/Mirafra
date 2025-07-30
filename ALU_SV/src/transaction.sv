`include "defines.svh"

class transaction;
	rand bit [`WIDTH-1:0] OPA;
	rand bit [`WIDTH-1:0] OPB;
	rand bit [`CMD_WIDTH:0] CMD;
	rand bit [1:0] INP_VALID;
	rand bit CIN, CE, MODE;

	bit OFLOW, COUT, E, G, L, ERR;
	bit [`WIDTH:0] RES;

	constraint CE_check {
		CE == 1;
	}

	constraint cmd_operation {
		if(MODE) 
			CMD inside {[0:10]};
		else 
			CMD inside {[0:13]};
	}

	constraint INP_VALID_range {
		if(((MODE) && (CMD < 4 || CMD > 7) && (CMD <11)) || ((!MODE) && (CMD < 6 || CMD > 11 ) && (CMD < 14)))
			INP_VALID == 2'b11;
		else if((MODE && ((CMD == 4) || CMD == 5)) || ( !MODE && ((CMD == 6) || (CMD == 8) || (CMD == 9))))
			INP_VALID == 2'b01;
		else if((MODE && ((CMD == 6) || CMD == 7)) || ( !MODE && ((CMD == 7) || (CMD == 10) || (CMD == 11))))
			INP_VALID == 2'b10;
		else 
			INP_VALID == 2'b00;
	}

	constraint opa_opb {
		OPA dist { 255 := 20, 0:= 20, 170:= 20, 85:= 20, [1:255] := 20};
		OPB dist { 255 := 20, 0:= 20, 170:= 20, 85:= 20, [1:255] := 20};
	}

	virtual function transaction copy();
		copy = new();
		copy.OPA = this.OPA;
		copy.OPB = this.OPB;
		copy.CMD = this.CMD;
		copy.INP_VALID = this.INP_VALID;
		copy.CIN = this.CIN;
		copy.CE = this.CE;
		copy.MODE = this.MODE;
		return copy;
	endfunction	
endclass	

class inp_valid_00 extends transaction;

	constraint inp_val {
		INP_VALID == 2'b00;
	}

	virtual function transaction copy();
		inp_valid_00 copy1 = new();
		copy1.OPA = this.OPA;
		copy1.OPB = this.OPB;
		copy1.CMD = this.CMD;
		copy1.INP_VALID = this.INP_VALID;
		copy1.CIN = this.CIN;
		copy1.CE = this.CE;
		copy1.MODE = this.MODE;
		return copy1;
        endfunction

endclass

class inp_valid_01 extends transaction;

	constraint inp_val {
		INP_VALID == 2'b01;
	}

	virtual function transaction copy();
		inp_valid_01 copy2 = new();
		copy2.OPA = this.OPA;
		copy2.OPB = this.OPB;
		copy2.CMD = this.CMD;
		copy2.INP_VALID = this.INP_VALID;
		copy2.CIN = this.CIN;
		copy2.CE = this.CE;
		copy2.MODE = this.MODE;
		return copy2;
	endfunction

endclass

class inp_valid_10 extends transaction;

	constraint inp_val {
		INP_VALID == 2'b00;
	}

	virtual function transaction copy();
		inp_valid_10 copy3 = new();
		copy3.OPA = this.OPA;
		copy3.OPB = this.OPB;
		copy3.CMD = this.CMD;
		copy3.INP_VALID = this.INP_VALID;
		copy3.CIN = this.CIN;
		copy3.CE = this.CE;
		copy3.MODE = this.MODE;
		return copy3;
	endfunction
			
endclass

class inp_valid_11 extends transaction;

 	constraint inp_val {
		INP_VALID == 2'b11;
	}
	virtual function transaction copy();
		inp_valid_11 copy4 = new();
		copy4.OPA = this.OPA;
		copy4.OPB = this.OPB;
		copy4.CMD = this.CMD;
		copy4.INP_VALID = this.INP_VALID;
		copy4.CIN = this.CIN;
		copy4.CE = this.CE;
		copy4.MODE = this.MODE;
		return copy4;
	endfunction

endclass



class min_max_inc_dec extends transaction;     
	
	constraint mode_arthi_only {
		MODE dist {0:=50,1:=50};
	}

	constraint cmd_operation { 
		if(MODE) 
			CMD inside {[0:7]};
		else
			CMD inside {[8:13]}; 
	}

	constraint cin_const {
		CIN dist {1:=8, 0:=2};
	}

	virtual function transaction copy();
    		min_max_inc_dec copy1 = new();
    		copy1.INP_VALID = INP_VALID;
    		copy1.MODE = MODE;
    		copy1.CMD = CMD;
    		copy1.CE = CE;
    		copy1.OPA = OPA;
    		copy1.OPB = OPB;
    		copy1.CIN = CIN;
    		return copy1;
  	endfunction
endclass

class cmp_check extends transaction;
	
	constraint cmd_operation {
		MODE == 1;
		CMD == 8;
	}
	
	virtual function transaction copy();
                cmp_check copy6 = new();
		copy6.OPA = this.OPA;
	        copy6.OPB = this.OPB;
	        copy6.CMD = this.CMD;
		copy6.INP_VALID = this.INP_VALID;
		copy6.CIN = this.CIN;
		copy6.CE = this.CE;
		copy6.MODE = this.MODE;
		return copy6;
	endfunction

endclass

class error extends transaction;

	constraint operation {
		CMD inside {[12:13]};
	}

	virtual function transaction copy();
		error copy5 = new();
		copy5.OPA = this.OPA;
		copy5.OPB = this.OPB;
		copy5.CMD = this.CMD;
		copy5.INP_VALID = this.INP_VALID;
		copy5.CIN = this.CIN;
		copy5.CE = this.CE;
		copy5.MODE = this.MODE;
		return copy;	
	endfunction

endclass


