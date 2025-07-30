`include "defines.svh"

class driver;
	transaction trans;
	mailbox #(transaction) gen_drv_mail;
	mailbox #(transaction) drv_ref_mail;
	virtual alu_intf.DRIVER vif;

	function new(mailbox #(transaction) gen_drv_mail, mailbox #(transaction) drv_ref_mail, virtual alu_intf.DRIVER vif);
		this.gen_drv_mail = gen_drv_mail;
		this.drv_ref_mail = drv_ref_mail;
		this.vif = vif;
	endfunction

	task start();
		repeat(2) @(vif.drv_cb); 
		for(int i=0; i<`no_trans; i++) begin
			trans = new;
               		gen_drv_mail.get(trans);
			if(vif.drv_cb.rst == 1) 
				repeat(1) @(vif.drv_cb)
				begin
					vif.drv_cb.OPA <= {`WIDTH{1'b0}};
					vif.drv_cb.OPB <= {`WIDTH{1'b0}};
					vif.drv_cb.MODE <= 1'b0;
					vif.drv_cb.CMD <= 1'b0;
					vif.drv_cb.CIN <= 1'b0;
					vif.drv_cb.CE <= 1'b0;
					vif.drv_cb.INP_VALID <= 2'b0;
					drv_ref_mail.put(trans);
					repeat(1) @(vif.drv_cb);
					$display("Driver @ %0t \n CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d ",$time,trans.CE,trans.MODE,trans.INP_VALID,trans.CIN,trans.OPA,trans.OPB);                 
				end
			else
				begin
					repeat(1) @(vif.drv_cb);
					vif.drv_cb.OPA <= trans.OPA;
					vif.drv_cb.OPB <= trans.OPB;
					vif.drv_cb.MODE <= trans.MODE;
					vif.drv_cb.CMD <= trans.CMD;
					vif.drv_cb.CIN <= trans.CIN;
					vif.drv_cb.CE <= trans.CE;
					vif.drv_cb.INP_VALID <= trans.INP_VALID;
					repeat(1) @(vif.drv_cb);
					if(trans.MODE)  
						$display("Arithmetic : \nDriver : @ %0t \n CE = %b | MODE = %b | CMD = %d | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d ",$time,trans.CE,trans.MODE,trans.CMD,trans.INP_VALID,trans.CIN,trans.OPA,trans.OPB);                 
					else
						$display("Logical : \nDriver : @ %0t \n CE = %b | MODE = %b | CMD = %d | INP_VALID = %b | CIN = %b | OPA = %b | OPB = %b ",$time,trans.CE,trans.MODE,trans.CMD,trans.INP_VALID,trans.CIN,trans.OPA,trans.OPB);                 
					drv_ref_mail.put(trans);
					repeat(1)@(vif.drv_cb);
					if(trans.MODE && trans.CMD==9)	begin
						repeat(3)@(vif.drv_cb); 
					end
				end
		end
//		$display("\n\n----------------------------------------------- Driver end @ : %0t ------------------------------------------------\n\n",$time);
	endtask
endclass

