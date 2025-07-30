
`include "defines.svh"

class monitor;
	transaction trans;
	mailbox #(transaction) mon_score_mail;
	virtual alu_intf.MON vif;
	
	function new(mailbox #(transaction) mon_score_mail, virtual alu_intf.MON vif);
		this.mon_score_mail = mon_score_mail;
		this.vif = vif;
	endfunction
	task start();
		repeat(2) @(vif.mon_cb);  
		for(int i=0; i<`no_trans; i++) begin
			trans = new;
			repeat(3) @(vif.mon_cb)
			if(vif.mon_cb.MODE && vif.mon_cb.CMD ==9) 
				repeat(1)@(vif.mon_cb);
			begin
				trans.RES = vif.mon_cb.RES;
				trans.OFLOW = vif.mon_cb.OFLOW;
				trans.COUT = vif.mon_cb.COUT;
				trans.E = vif.mon_cb.E;
				trans.G = vif.mon_cb.G;
				trans.L = vif.mon_cb.L;
				trans.ERR = vif.mon_cb.ERR;
				trans.MODE = vif.mon_cb.MODE;
				trans.CMD = vif.mon_cb.CMD;
				trans.OPA = vif.mon_cb.OPA;
				trans.OPB = vif.mon_cb.OPB;
				trans.INP_VALID = vif.mon_cb.INP_VALID;
			end
			if(trans.MODE) begin
				$display("Monitor @ %0t \n CMD = %d | INP_VALID = %b | OPA = %d | OPB = %d | RES = %d | ERR = %b | COUT = %b | OFLOW = %b | G = %b | L = %b | E = %b",$time,trans.CMD,trans.INP_VALID,trans.OPA,trans.OPB,trans.RES,trans.ERR,trans.COUT,trans.OFLOW,trans.G,trans.L,trans.E);                 
			end
			else begin
				$display("Monitor @ %0t \n CMD = %d | INP_VALID = %b | OPA = %b | OPB = %b | RES = %b | ERR = %b | COUT = %b | OFLOW = %b | G = %b | L = %b | E = %b",$time,trans.CMD,trans.INP_VALID,trans.OPA,trans.OPB,trans.RES,trans.ERR,trans.COUT,trans.OFLOW,trans.G,trans.L,trans.E); 
			end
			mon_score_mail.put(trans);
		end
	endtask
endclass


