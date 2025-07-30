`include "defines.svh"

class scoreboard;
	transaction trans, trans_ref;

	mailbox #(transaction) mon_score_mail;
	mailbox #(transaction) ref_score_mail;

	function new(mailbox #(transaction) mon_score_mail, mailbox #(transaction) ref_score_mail);
		this.mon_score_mail = mon_score_mail;
		this.ref_score_mail = ref_score_mail;
	endfunction	
	
	int match, mismatch;

	task start();
		for(int i=0;i<`no_trans;i++)
		begin
			trans = new;
			trans_ref = new;
			fork 
				ref_score_mail.get(trans_ref);
				mon_score_mail.get(trans);
			join
			compare_report();
			$display("----------------------------------------------------------------------------------\n");
			$display("Match    = %0d \nMismatch = %0d",match,mismatch);
			$display("\n----------------------------------------------------------------------------------\n");
		end
	endtask	

	task compare_report();
		if(trans.RES == trans_ref.RES && trans.OFLOW == trans_ref.OFLOW && trans.COUT == trans_ref.COUT && trans.G == trans_ref.G && trans.L == trans_ref.L && trans.E == trans_ref.E && trans.ERR == trans_ref.ERR)
			begin
				match++;
				$display("Scoreboard @ %0t ------------------------Passed----------------------\n\n",$time);
			end
		else 
			begin
				mismatch++;
         			$display("Scoreboard @ %0t ------------------------Failed----------------------",$time); 
        			if(!(trans.RES === trans_ref.RES)) 
           				$display(" Result mismatch : reference : %0d | monitor : %0d", trans_ref.RES, trans.RES); 
         			if(!(trans.ERR === trans_ref.ERR)) 
          			 	$display(" Error signal mismatch : reference : %0d | monitor : %0d", trans_ref.ERR, trans.ERR); 
         			if(!(trans.OFLOW === trans_ref.OFLOW)) 
           				$display(" Overflow mismatch : reference : %0d | monitor : %0d", trans_ref.OFLOW, trans.OFLOW); 
         			if(!(trans.G === trans_ref.G)) 
           				$display(" G mismatch : reference : %0d | monitor : %0d", trans_ref.G, trans.G); 
         			if(!(trans.L === trans_ref.L)) 
           				$display(" L mismatch : reference : %0d | monitor : %0d", trans_ref.L, trans.L); 
         			if(!(trans.E === trans_ref.E)) 
           				$display(" E mismatch : reference : %0d | monitor : %0d", trans_ref.E, trans.E); 
         			if(!(trans.COUT === trans_ref.COUT)) 
         				  $display(" COUT error : reference : %0d | monitor : %0d", trans_ref.COUT, trans.COUT); 
			end
	endtask	
endclass	
