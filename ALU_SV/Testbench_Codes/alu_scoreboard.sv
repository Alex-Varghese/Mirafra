`include "defines.svh"

class scoreboard;
	transaction ref_score_trans, mon_score_trans;

	mailbox #(transaction) ref_score_mail;
	mailbox #(transaction) mon_score_mail;
	
	int match, mismatch;
	
	function new( mailbox #(transaction) ref_score_mail, mailbox #(transaction) mon_score_mail );
		this.ref_score_mail <= ref_score_mail;
		this.mon_score_mail <= mon_score_mail;
	endfunction

	task start();
		for( int i = 0; i < `no_of_trans; i++ ) begin 
			ref_score_mail = new();
			mon_score_mail = new();
			fork
				ref_score_mail.get(ref_score_trans);
				mon_score_mail.get(mon_score_trans);
			join
			compare_report();
		end
	endtask
	
	sequence inp_valid_16_cycles {
		if( inp_valid == 2'b01 || inp_valid == 2'b10 )
			##[1:16] inp_valid == 2'b11;
	}	


	task compare_report();


 				
 

endclass
