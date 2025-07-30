

`include "defines.svh"

class reference;

	transaction trans;
	virtual alu_intf.REF vif;

	mailbox #(transaction) drv_ref_mail;
	mailbox #(transaction) ref_score_mail;

	function new(virtual alu_intf.REF vif, mailbox #(transaction) drv_ref_mail, mailbox #(transaction) ref_score_mail);
		this.vif = vif;
		this.drv_ref_mail = drv_ref_mail;
		this.ref_score_mail = ref_score_mail;
	endfunction

	logic [`SHIFT-1:0] rot_val;

	task start(); 
		for(int i=0;i<`no_trans;i++) begin
			trans = new();
			drv_ref_mail.get(trans);
			repeat(1) @(vif.ref_cb) begin  
				if(vif.ref_cb.rst == 1) begin
					trans.RES = 'b0;
					trans.ERR = 'b0;
					trans.COUT = 0;
					trans.OFLOW = 0;
					trans.E = 0;
					trans.G = 0;
					trans.L = 0;
				end
				else if(trans.CE == 1)
				begin
					if(((trans.MODE) && (trans.CMD < 4 || trans.CMD > 7) && (trans.CMD <11)) || ((!trans.MODE) && (trans.CMD < 6 || trans.CMD > 11 ) && (trans.CMD < 14)) && trans.INP_VALID != 2'b11) begin
						for(int i=0;i<16;i++) begin
							if(i<16) begin
								if(trans.INP_VALID != 2'b11 ) begin
									repeat(1) @(vif.ref_cb) begin
										trans.INP_VALID = vif.ref_cb.INP_VALID;
									end
								end
								else
									break;
							end 
							else
								trans.INP_VALID = 2'b00;
						end 
					end	

					if(trans.MODE) begin
						case(trans.INP_VALID)
							2'b00: trans.ERR = 1;
							2'b01:
								begin
									if(trans.CMD == `INC_A) begin
										trans.RES = trans.OPA + 1;
									end
									else if(trans.CMD == `DEC_A) begin
										trans.RES = trans.OPA - 1;
									end
									else
										trans.ERR = 1;
								end

							2'b10:
								begin
									if(trans.CMD == `INC_B) begin
										trans.RES = trans.OPB + 1;
									end
									else if(trans.CMD == `DEC_B) begin
										trans.RES = trans.OPB - 1;
									end
									else
										trans.ERR = 1;
								end

							2'b11:
								begin
									case(trans.CMD)
										`ADD:
											begin
												trans.RES = trans.OPA + trans.OPB;
												trans.COUT = trans.RES[`WIDTH];
											end

										`SUB:
											begin
												trans.RES = trans.OPA - trans.OPB;
												trans.OFLOW = trans.OPA < trans.OPB;
											end

										`ADD_CIN:
											begin
												trans.RES = trans.OPA + trans.OPB + trans.CIN;
												trans.COUT = trans.RES[`WIDTH];
											end

										`SUB_CIN:
											begin
												trans.RES = trans.OPA - trans.OPB - trans.CIN;
												trans.OFLOW = (trans.OPA < trans.OPB) || (trans.OPA == trans.OPB) && trans.CIN;
											end

										`CMP:
											begin
												trans.E = trans.OPA == trans.OPB;
												trans.G = trans.OPA > trans.OPB;
												trans.L = trans.OPA < trans.OPB;
											end

										`INC_MULT: 
											begin
												repeat(1)@(vif.ref_cb);
												trans.RES = (trans.OPA + 1) * (trans.OPB + 1);
											end

										`SH_MULT: trans.RES = (trans.OPA << 1) * trans.OPB;

										default: trans.ERR = 1;
										endcase
								end
							default: trans.ERR = 1;
							endcase
					end

					else begin
						case(trans.INP_VALID)
							2'b00: trans.ERR = 1;

							2'b01:
								begin
									case(trans.CMD)
										`NOT_A: trans.RES = {1'b0,~trans.OPA};
										`SHR1_A: trans.RES = trans.OPA >> 1;
										`SHL1_A:	 trans.RES = trans.OPA << 1;
										default:	 trans.ERR = 1;
									endcase
								end

							2'b10:
								begin
									case(trans.CMD)
										`NOT_B: trans.RES = {1'b0,~trans.OPB};
										`SHR1_B: trans.RES = trans.OPB >> 1;
										`SHL1_B: trans.RES = trans.OPB >> 1;
										default: trans.ERR = 1;
									endcase
								end

							2'b11:
								begin
									case(trans.CMD)
										`AND:			trans.RES = {1'b0,trans.OPA & trans.OPB};
										`NAND:		trans.RES = {1'b0,~(trans.OPA & trans.OPB)};
										`OR:			trans.RES = {1'b0,trans.OPA | trans.OPB};
										`NOR:			trans.RES = {1'b0,~(trans.OPA | trans.OPB)};
										`XOR:			trans.RES = {1'b0,trans.OPA ^ trans.OPB};
										`XNOR:		trans.RES = {1'b0,~(trans.OPA ^ trans.OPB)};

										`ROL_A_B:
											begin
												rot_val = trans.OPB[`SHIFT - 1:0];
												trans.RES = {1'b0,trans.OPA << rot_val | trans.OPA >> (`WIDTH - rot_val)};
												trans.ERR = |trans.OPB[`WIDTH - 1 : `SHIFT +1];
											end

										`ROR_A_B:
											begin
											  rot_val = trans.OPB[`SHIFT - 1:0];
												trans.RES = {1'b0,trans.OPA << (`WIDTH - rot_val) | trans.OPA >> rot_val};
												trans.ERR = |trans.OPB[`WIDTH - 1 : `SHIFT +1];
											end
										default: 	trans.ERR = 1;
									endcase
								end 



							default: trans.ERR = 1;
						endcase
					end
				end 
			
			if(trans.MODE)
				$display("Reference @ %0t \n CMD = %d | INP_VALID = %b | OPA = %d | OPB = %d | RES = %d | ERR = %b | COUT = %b | OFLOW = %b | G = %b | L = %b | E = %b",$time,trans.CMD,trans.INP_VALID,trans.OPA,trans.OPB,trans.RES,trans.ERR,trans.COUT,trans.OFLOW,trans.G,trans.L,trans.E);	
			else
				$display("Reference @ %0t \n CMD = %d | INP_VALID = %b | OPA = %d | OPB = %d | RES = %b | ERR = %b | COUT = %b | OFLOW = %b | G = %b | L = %b | E = %b",$time,trans.CMD,trans.INP_VALID,trans.OPA,trans.OPB,trans.RES,trans.ERR,trans.COUT,trans.OFLOW,trans.G,trans.L,trans.E);
			end
			ref_score_mail.put(trans);
		end
	endtask
endclass

