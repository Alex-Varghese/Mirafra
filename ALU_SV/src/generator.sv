`include "defines.svh"

class generator;
	transaction trans;
	mailbox #(transaction) gen_drv_mail;

	function new (mailbox #(transaction) gen_drv_mail);
		this.gen_drv_mail = gen_drv_mail;
		trans = new;
	endfunction	

	int ID; 

	task start();
		$display("\n\n----------------------------------------------- Generator start @ : %0t ------------------------------------------------\n\n",$time);
		for(int i=0;i<`no_trans;i++) begin
			if(!(trans.randomize)) $fatal("Generator randomization failed");    
      gen_drv_mail.put(trans.copy()); 
			
			if(trans.MODE) begin
				$display("Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d ",$time,trans.CE,trans.MODE,trans.INP_VALID,trans.CIN,trans.OPA,trans.OPB); 				
				// ID++;	
			end
			else begin
				$display("Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d ",$time,trans.CE,trans.MODE,trans.INP_VALID,trans.CIN,trans.OPA,trans.OPB); 				
				// ID++;
			end
		end
		$display("\n\n----------------------------------------------- Generator end @ : %0t ------------------------------------------------\n\n",$time);
	endtask	
endclass	
