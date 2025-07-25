`include "defines.svh"svh

class driver;
	
	transaction driver_trans;
	
	int cycles_delay;

	mailbox #(transaction) drv_ref_mail;
	mailbox #(transaction) gen_drv_ref_mail;

	virtual alu_intf.driver_modport v_intf;

	function new(mailbox #(transaction) drv_ref_mail, mailbox #(transaction) gen_drv_mail, virtual alu_intf.driver_modport v_intf);
		this.drv_ref_mail = drv_ref_mail;
		this.gen_drv_ref_mail = gen_drv_mail;
		this.v_intf = v_intf;
		// if covergroup is written create the new memory here
	endfunction

	task start();
		repeat(1) @(driver_cb);
		for( int i = 0; i < `no_of_trans; i++ ) begin
			driver_trans = new();
			gen_drv_ref_mail.get(driver_trans);
			if( v_intf.driver_cb.rst == 1 ) 
				repeat(1) @( v_intf.driver_cb ) begin
                                        v_intf.driver_cb.ce = 1;
                                        v_intf.driver_cb.cin = 0;
                                        v_intf.driver_cb.opa = {`WIDTH{1'b0}};
                                        v_intf.driver_cb.opb = {`WIDTH{1'b0}};
                                        v_intf.driver_cb.cmd = {`CMD_WIDTH{1'b0}};
                                        v_intf.driver_cb.mode = 0;
                                        v_intf.driver_cb.inp_valid = 2'b00;
                                        repeat(1) @(driver_cb);
					$display("\n Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d \n",$time,v_intf.driver_cb.ce,v_intf.driver_cb.mode,v_intf.driver_cb.inp_valid,v_intf.driver_cb.cin,v_intf.driver_cb.opa,v_intf.driver_cb.opb);
				end
			else
				repeat(1) @( v_intf.driver_cb ) begin
					v_intf.driver_cb.ce = driver_trans.ce;
					v_intf.driver_cb.cin = driver_trans.cin;
					v_intf.driver_cb.opa = driver_trans.opa;
					v_intf.driver_cb.opb = driver_trans.opb;
					v_intf.driver_cb.cmd = driver_trans.cmd;
					v_intf.driver_cb.mode = driver_trans.mode;
					if( inp_valid != 2'b11 ) begin 
						cycles_delay = $urandom(0,20);
							repeat(
						end
						v_intf.driver_cb.inp_valid = driver_trans.inp_valid;
					repeat(6) @(driver_cb);
					driver_trans.inp_valid = 2'b10;
					v_intf.driver_cb.inp_valid = driver_trans.inp_valid;
					repeat(12) @(driver_cb);
                                        driver_trans.inp_valid = 2'b11;
                                        v_intf.driver_cb.inp_valid = driver_trans.inp_valid;
					repeat(1) @(driver_cb);
					$display("\n------------------------------------------- Driver -------------------------------------------\n");
					if(v_intf.driver_cb.mode)
			                    $display("\n Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d \n",$time,v_intf.driver_cb.ce,v_intf.driver_cb.mode,v_intf.driver_cb.inp_valid,v_intf.driver_cb.cin,v_intf.driver_cb.opa,v_intf.driver_cb.opb);                    
                			else
                    			    $display("\n Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %b | OPB = %b \n",$time,v_intf.driver_cb.ce,v_intf.driver_cb.mode,v_intf.driver_cb.inp_valid,v_intf.driver_cb.cin,v_intf.driver_cb.opa,v_intf.driver_cb.opb);                    
					drv_ref_mail.put(driver_trans);
					// coverage sample here
				end
		end
	endtask

endclass

