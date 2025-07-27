`include "defines.svh"

class scoreboard;
	transaction ref_score_trans, mon_score_trans;

	mailbox #(transaction) ref_score_mail;
	mailbox #(transaction) mon_score_mail;
	
	reg [ ( RESULT_WIDTH - 1  ) + 6 : 0 ] pkt_ref[ `no_of_transaction - 1 : 0 ];
	reg [ ( RESULT_WIDTH - 1  ) + 6 : 0 ] pkt_mon[ `no_of_transaction - 1 : 0 ];
	
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
			begin
				mon_score_mail.get(monitor_trans);
				$display("-----------------------------------------------------------------");
				$display("scoreboard: monitor_signals\n\n");
          			pkt_mon[i] = { 
				             monitor_trans.res  , monitor_trans.oflow , 
				             monitor_trans.cout , monitor_trans.g ,
				             monitor_trans.l    , monitor_trans.e, 
				             monitor_trans.err
				};
				$display("-----------------------------------------------------------------");
		    	end
			begin
				ref_score_mail.get(reference_trans);
				$display("-----------------------------------------------------------------");
				$display(" \nscorebord: reference_signals\n\n");
				pkt_ref[i] = { 
				             reference_trans.res  , reference_trans.oflow , 
				             reference_trans.cout , reference_trans.g ,
				             reference_trans.l    , reference_trans.e, 
				             reference_trans.err
				};
				$display("-----------------------------------------------------------------");
			end
			compare_report();
		end
	endtask

	task compare_report();
		$display(" \n-------------------------------------------------------------------------------------\n\t COMPARISION ON MON & SCB REPORT \n");	
		for(int j = 0; j < `no_of_transaction; j++) begin
			$display("INPUTS : ");
			$display("from monitor :Time : %t \n MODE : %b | OPA : %d | OPB : %d | CIN : %b | INP_VALID : %b", monitor_trans.mode, monitor_trans.opa, monitor_trans.opb, monitor_trans.cin, monitor_trans.inp_valid);
			$display("from reference :Time : %t \n MODE : %b | OPA : %d | OPB : %d | CIN : %b | INP_VALID : %b", reference_trans.mode, reference_trans.opa, reference_trans.opb, reference_trans.cin, reference_trans.inp_valid);
			if( pkt_ref[i] === pkt_mon[i] ) begin 
	            		$display("Transaction %d: Passed\n CMD = %0d",reference_trans.cmd);			
			end
			else begin
			    	$display("Transaction %d: Failed\n CMD = %0d",reference_trans.cmd);
			    	if(!(monitor_trans.res === reference_trans.res))
			    		$display(" Result error : reference : %d | monitor : %d", reference_trans.res, monitor_trans.res);
			    	if(!(monitor_trans.err === reference_trans.err))
			    		$display(" error signal mismatch : reference : %d | monitor : %d", reference_trans.err, monitor_trans.err);
				if(!(monitor_trans.oflow === reference_trans.oflow))
			    		$display(" oflow mismatch : reference : %d | monitor : %d", reference_trans.oflow, monitor_trans.oflow);
			    	if(!(monitor_trans.g === reference_trans.g))
			    		$display(" g mismatch : reference : %d | monitor : %d", reference_trans.g, monitor_trans.g);
			    	if(!(monitor_trans.l === reference_trans.l))
			    		$display(" l mismatch : reference : %d | monitor : %d", reference_trans.l, monitor_trans.l);
				if(!(monitor_trans.e === reference_trans.e))
			    		$display(" e mismatch : reference : %d | monitor : %d", reference_trans.e, monitor_trans.e);
			    	if(!(monitor_trans.cout === reference_trans.cout))
			    		$display(" cout error : reference : %d | monitor : %d", reference_trans.cout, monitor_trans.cout);    	
			end
		end

	endtask
	
endclass


 				
 

endclass
