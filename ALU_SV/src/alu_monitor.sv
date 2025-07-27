`include "defines.svh"

class monitor;

	transaction mon_trans;

	mailbox #(transaction) mon_score_mail;
	
	virtual alu_intf.monitor_modport v_intf;
	
	function new(mailbox #(transaction) mon_score_mail, virtual alu_intf.monitor_modport v_intf);
                this.mon_score_mail <= mon_score_mail;
                this.v_intf <= v_intf;
                mn_cg = new();
                // if covergroup is written create the new memory here
        endfunction
        
        covergroup mon_cg; //output coverage
                c1 : coverpoint pkt.res;
                c2 : coverpoint pkt.g;
                c3 : coverpoint pkt.l;
                c4 : coverpoint pkt.e;
                c5 : coverpoint pkt.oflow;
                c6 : coverpoint pkt.err;
                c7 : coverpoint pkt.cout;
        endgroup

	task start();
		repeat(4) @(v_intf.monitor_cb); 
		for(int i = 0; i < `no_of_trans; i++) begin
			mon_trans = new();
			repeat(1) @(v_intf.monitor_cb) begin
				mon_trans.cin <= v_intf.monitor_cb.cin;
                                mon_trans.ce <= v_intf.monitor_cb.ce;
                                mon_trans.cmd <= v_intf.monitor_cb.cmd;
                                mon_trans.opa <= v_intf.monitor_cb.opa;
                                mon_trans.opb <= v_intf.monitor_cb.opb;
                                mon_trans.inp_valid <= v_intf.monitor_cb.inp_valid;
				mon_trans.mode <= v_intf.monitor_cb.mode;
              			mon_trans.res <= v_intf.monitor_cb.res;
              			mon_trans.g <= v_intf.monitor_cb.g;
				mon_trans.l <= v_intf.monitor_cb.l;
				mon_trans.e <= v_intf.monitor_cb.e;
				mon_trans.cout <= v_intf.monitor_cb.cout;
				mon_trans.err <= v_intf.monitor_cb.err;
				mon_trans.oflow <= v_intf.monitor_cb.oflow;
             		end
			mon_score_mail.put(mon_trans);
			repeat(1) @(monitor_cb);
		end
	endtask

endclass	

