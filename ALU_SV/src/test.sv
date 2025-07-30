class test;
	virtual alu_intf drv_if;
	virtual alu_intf mon_if;
	virtual alu_intf ref_if;
	environment env;

	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
		this.drv_if = drv_if;
		this.mon_if = mon_if;
		this.ref_if = ref_if;
	endfunction	

	task run();
		env = new(drv_if, mon_if, ref_if);
		env.build();
		env.start();
	endtask	
endclass

class inpvalid_00 extends test;
	inp_valid_00 inp00;
	
	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
		super.new(drv_if, mon_if, ref_if);
		inp00 = new();
	endfunction

	task run();
		env = new(drv_if, mon_if, ref_if);
		env.build(); 
	        env.gen.trans = inp00;	
		env.start();   
	endtask   

endclass

class inpvalid_10 extends test;
	inp_valid_10 inp10;

	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
		super.new(drv_if, mon_if, ref_if);
		inp10 = new();
	endfunction

	task run();     
		env = new(drv_if, mon_if, ref_if);
		env.build();                
		env.gen.trans = inp10;
		env.start();   
	endtask

endclass

class inpvalid_01 extends test;
	inp_valid_01 inp01;

	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
		super.new(drv_if, mon_if, ref_if);
		inp01 = new();
	endfunction

	task run();     
		env = new(drv_if, mon_if, ref_if);
		env.build();                
		env.gen.trans = inp01;
		env.start();   
	endtask

endclass

class inpvalid_11 extends test;
	inp_valid_11 inp11;

	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
  		super.new(drv_if, mon_if, ref_if);
		inp11 = new();
	endfunction

	task run();     
		env = new(drv_if, mon_if, ref_if);
		env.build();                
		env.gen.trans = inp11;
		env.start();   
	endtask

endclass

class A_B extends test;
        min_max_inc_dec mn;

        function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
	        super.new(drv_if, mon_if, ref_if);
		mn = new();
	endfunction

	task run();     
		env = new(drv_if, mon_if, ref_if);
		env.build();                
		env.gen.trans = mn;
		env.start();   
	endtask

endclass

class err_chk extends test;
     	error er;

	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
		super.new(drv_if, mon_if, ref_if);
		er = new();
	endfunction

	task run();
		env = new(drv_if, mon_if, ref_if);
		env.build();
		env.gen.trans = er;
		env.start();
	endtask

endclass


class cmp extends test;
	cmp_check chk;

	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
		super.new(drv_if, mon_if, ref_if);
		chk = new();
	endfunction

	task run();     
		env = new(drv_if, mon_if, ref_if);
		env.build();                
		env.gen.trans = chk;
		env.start();   
	endtask

endclass

class regress_test extends test;
	cmp_check chk;
	inp_valid_00 inp00;
	inp_valid_01 inp01;
	inp_valid_10 inp10;
	inp_valid_11 inp11;
	min_max_inc_dec mn;
	error er;

	function new(virtual alu_intf drv_if, virtual alu_intf mon_if, virtual alu_intf ref_if);
  		super.new(drv_if, mon_if, ref_if);
  		inp00 = new;
		inp01 = new;
		inp10 = new;
		inp11 = new;
		chk = new;
		mn = new;
		er = new;
      	endfunction
	    	
	task run();
		    env = new(drv_if, mon_if, ref_if);
		    env.build();
		    $display("\n\n---------------------------------------- Mormal. Cases ---------------------------------------------\n\n");

		    begin
			    env.start(); 
		    end
		    $display("\n\n---------------------------------------- Inp_Valid_00 Cases ---------------------------------------------\n\n");
			
		    begin
			    env.gen.trans = inp00;
			    env.start();
		    end
		    $display("\n\n---------------------------------------- Inp_Valid_01 Cases ---------------------------------------------\n\n");
		    begin
			    env.gen.trans = inp01;
			    env.start();
		    end
		    $display("\n\n---------------------------------------- Inp_Valid_10 Cases ---------------------------------------------\n\n");
			
		    begin
			    env.gen.trans = inp10;
			    env.start();
		    end
		    $display("\n\n---------------------------------------- Inp_Valid_11 Cases ---------------------------------------------\n\n");
		    begin
			    env.gen.trans = inp11;
			    env.start();
		    end
		    $display("\n\n---------------------------------------- Compare command Cases ---------------------------------------------\n\n");
		    begin
			    env.gen.trans = chk;
			    env.start();
		    end
		    $display("\n\n---------------------------------------- Min Max Cases ---------------------------------------------\n\n");
		    begin
		    	    env.gen.trans = mn;
		    	    env.start();
		    end
		    $display("\n\n---------------------------------------- Error Flag Cases ---------------------------------------------\n\n");
		    begin
			    env.gen.trans = er;
			    env.start();
	    	    end


	endtask	

endclass	    
