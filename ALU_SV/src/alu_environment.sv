
`include "defines.sv"
class alu_environment;
	virtual alu_intf drv_vif;
	virtual alu_intf mon_vif;
	virtual alu_intf ref_vif;

	mailbox #(transaction) gen_drv_mail;
	mailbox #(transaction) drv_mail;
	mailbox #(transaction) ref_score_mail;
	mailbox #(transaction) mon_score_mail;

	generator           gen;
	driver              drv;
	monitor             mon;
	reference        ref_sb;
	scoreboard          scb;

	function new (virtual alu_intf drv_vif, virtual alu_intf mon_vif, virtual alu_intf ref_vif); 
		this.drv_vif = drv_vif;
		this.mon_vif = mon_vif;
		this.ref_vif = ref_vif;
	endfunction

	task build();
		begin
		gen_drv_mail = new();
		drv_mail = new();
		ref_score_mail = new();
		mon_score_mail = new();

		gen = new(gen_drv_mail);
		drv = new(gen_drv_mail,drv_mail,drv_vif);
		mon = new(mon_vif,mon_score_mail);
		ref_sb = new(drv_mail,ref_score_mail,ref_vif);
		scb = new(ref_score_mail,mon_score_mail);
		end
	endtask

	task start();
		fork
			gen.start();
			drv.start();
			mon.start();
			scb.start();
			ref_sb.start();
		join
			scb.compare_report();
	endtask
endclass

