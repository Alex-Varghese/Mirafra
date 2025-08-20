`uvm_analysis_imp_decl(_from_drv)
`uvm_analysis_imp_decl(_from_mon)

class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	uvm_analysis_imp_from_drv #(sequence_item, scoreboard) driver_imp;
	uvm_analysis_imp_from_mon #(sequence_item, scoreboard) monitor_imp;

	sequence_item monitor_packet[$];
	sequence_item driver_packet[$];

  function new (string name, uvm_component parent);
    	super.new(name, parent);
			driver_imp = new("driver_imp", this);
			monitor_imp = new("monitor_imp", this);
 	endfunction

 	virtual function void write_from_mon(sequence_item seq);
  		//$display("Scoreboard is received:: Packet");
			//`uvm_info(get_type_name,"Scoreboard received packet from monitor", UVM_NONE);
			monitor_packet.push_back(seq);
 	endfunction

	virtual function void write_from_drv(sequence_item seq);
			//`uvm_info(get_type_name,"Scoreboard received packet from the driver", UVM_NONE);
			driver_packet.push_back(seq);
	endfunction

 	virtual task run_phase(uvm_phase phase);
			
   		sequence_item trans_mon, trans_drv;
		  int rot_val, match, mismatch;
			super.run_phase(phase);

	 	  forever begin

					wait((driver_packet.size() > 0) && (monitor_packet.size() > 0))
					trans_drv = driver_packet.pop_front();
					trans_mon = monitor_packet.pop_front();

	      	if(trans_drv.RST == 1) begin
						trans_drv.RES = 'bz;
						trans_drv.ERR = 'bz;
						trans_drv.COUT = 'bz;
						trans_drv.OFLOW = 'bz;
						trans_drv.E = 'bz;
						trans_drv.G = 'bz;
						trans_drv.L = 'bz;
	      	end 
	      	else if(trans_drv.CE == 1 && trans_drv.RST == 0) begin
						trans_drv.RES = 'bz;
						trans_drv.ERR = 'bz;
						trans_drv.COUT = 'bz;
						trans_drv.OFLOW = 'bz;
						trans_drv.E = 'bz;
						trans_drv.G = 'bz;
						trans_drv.L = 'bz;	
									
						case(trans_drv.INP_VALID)
							2'b00 : trans_drv.ERR = 1;
							2'b01 : if(trans_drv.MODE) begin
												case(trans_drv.CMD)
												`INC_A : trans_drv.RES = trans_drv.OPA + 1;
												`DEC_A : trans_drv.RES = trans_drv.OPA - 1;
												default : trans_drv.ERR = 1;
						   					endcase
						   				end
						   				else begin
						   					case(trans_drv.CMD)
												`NOT_A:  trans_drv.RES = {1'b0,~trans_drv.OPA};
												`SHR1_A: trans_drv.RES = trans_drv.OPA >> 1;
												`SHL1_A: trans_drv.RES = trans_drv.OPA << 1;
												default: trans_drv.ERR = 1;
						    				endcase
						   				end
							2'b10 : if(trans_drv.MODE) begin
												case(trans_drv.CMD)
												`INC_B : trans_drv.RES = trans_drv.OPB + 1;
												`DEC_B : trans_drv.RES = trans_drv.OPB - 1;
												default : trans_drv.ERR = 1;
						   					endcase
						   				end
						   				else begin
						   					case(trans_drv.CMD)
												`NOT_B  : trans_drv.RES = {1'b0,~trans_drv.OPB};
												`SHR1_B : trans_drv.RES = trans_drv.OPB >> 1;
												`SHL1_B : trans_drv.RES = trans_drv.OPB << 1;
												default : trans_drv.ERR = 1;
						    				endcase
						   				end
							2'b11 : if(trans_drv.MODE) begin
												case(trans_drv.CMD)
												`ADD : begin
															trans_drv.RES = trans_drv.OPA + trans_drv.OPB;
															trans_drv.COUT = trans_drv.RES[`WIDTH];
									   		end
												`SUB : begin
															trans_drv.RES = trans_drv.OPA - trans_drv.OPB;
															trans_drv.OFLOW = trans_drv.OPA < trans_drv.OPB;
									   		end
												`ADD_CIN : begin
															trans_drv.RES = trans_drv.OPA + trans_drv.OPB + trans_drv.CIN;
															trans_drv.COUT = trans_drv.RES[`WIDTH];
									   		end
												`SUB_CIN : begin
															trans_drv.RES = trans_drv.OPA - trans_drv.OPB - trans_drv.CIN;
															trans_drv.OFLOW = (trans_drv.OPA < trans_drv.OPB) || (trans_drv.OPA == trans_drv.OPB) && trans_drv.CIN;
									   		end
												`CMP : begin
															{trans_drv.G,trans_drv.L,trans_drv.E} = (trans_drv.OPA == trans_drv.OPB) ? 3'bzz1 : ((trans_drv.OPA > trans_drv.OPB) ? 3'b1zz : 3'bz1z) ;
									   		end
												`INC_MULT : trans_drv.RES = (trans_drv.OPA + 1) * (trans_drv.OPB + 1);
												`SH_MULT: trans_drv.RES = (trans_drv.OPA << 1) * trans_drv.OPB;
												`INC_A : trans_drv.RES = trans_drv.OPA + 1;
												`DEC_A : trans_drv.RES = trans_drv.OPA - 1;
												`INC_B : trans_drv.RES = trans_drv.OPB + 1;
												`DEC_B : trans_drv.RES = trans_drv.OPB - 1;
												default : trans_drv.ERR = 1;
						   					endcase
						   				end
						   				else begin
						   					case(trans_drv.CMD)
												`NOT_A:  trans_drv.RES = {1'b0,~trans_drv.OPA};
												`SHR1_A: trans_drv.RES = trans_drv.OPA >> 1;
												`SHL1_A: trans_drv.RES = trans_drv.OPA << 1;
												`NOT_B  : trans_drv.RES = {1'b0,~trans_drv.OPB};
												`SHR1_B : trans_drv.RES = trans_drv.OPB >> 1;
												`SHL1_B : trans_drv.RES = trans_drv.OPB << 1;
												`AND  :	trans_drv.RES = {1'b0,trans_drv.OPA & trans_drv.OPB};
												`NAND :	trans_drv.RES = {1'b0,~(trans_drv.OPA & trans_drv.OPB)};
												`OR   :	trans_drv.RES = {1'b0,trans_drv.OPA | trans_drv.OPB};
												`NOR  :	trans_drv.RES = {1'b0,~(trans_drv.OPA | trans_drv.OPB)};
												`XOR  :	trans_drv.RES = {1'b0,trans_drv.OPA ^ trans_drv.OPB};
												`XNOR :	trans_drv.RES = {1'b0,~(trans_drv.OPA ^ trans_drv.OPB)};
												`ROL_A_B : begin
																rot_val = trans_drv.OPB[`SHIFT - 1:0];
																trans_drv.RES = {1'b0,trans_drv.OPA << rot_val | trans_drv.OPA >> (`WIDTH - rot_val)};
																trans_drv.ERR = |trans_drv.OPB[`WIDTH - 1 : `SHIFT +1];
												end

 
												`ROR_A_B : begin
      								          rot_val = trans_drv.OPB[`SHIFT - 1:0];
									 							trans_drv.RES = {1'b0,trans_drv.OPA << (`WIDTH - rot_val) | trans_drv.OPA >> rot_val};
									 							trans_drv.ERR = |trans_drv.OPB[`WIDTH - 1 : `SHIFT +1];
												end
												default : trans_drv.ERR = 1;
						    				endcase
						   				end
								default : trans_drv.ERR = 1;
						endcase
					end
					else if( trans_drv.CE == 0 && trans_drv.RST == 0) begin
					    trans_drv.RST = trans_drv.RST;
					    trans_drv.OFLOW = trans_drv.OFLOW;
					    trans_drv.COUT = trans_drv.COUT;
					    trans_drv.G = trans_drv.G;
					    trans_drv.L = trans_drv.L;
					    trans_drv.E = trans_drv.E;
					    trans_drv.ERR = trans_drv.ERR;
					end
					/*
					if(trans_drv.MODE) begin
							`uvm_info(get_name(),$sformatf("@ : %0t Arithmetic : ",$time),UVM_MEDIUM);
							`uvm_info(get_name(),$sformatf("RST = %b | CE = %b |  CIN = %b | INPVALID = %b | CMD = %d | OPA = %d | OPB = %d | RES = %d | ERR = %b | OFLOW = %b | COUT = %b | GLE = %b%b%b",trans_drv.RST,trans_drv.CE,trans_drv.CIN,trans_drv.INP_VALID,trans_drv.CMD,trans_drv.OPA,trans_drv.OPB,trans_drv.RES,trans_drv.ERR,trans_drv.OFLOW,trans_drv.COUT,trans_drv.G,trans_drv.L,trans_drv.E),UVM_MEDIUM);
					end
					else begin
					    `uvm_info(get_name(),$sformatf("@ : %0t Logical : ",$time),UVM_MEDIUM);
					    `uvm_info(get_name(),$sformatf("RST = %b | CE = %b |  CIN = %b | INPVALID = %b | CMD = %d | OPA = %b | OPB = %b | RES = %d | ERR = %b | OFLOW = %b | COUT = %b | GLE = %b%b%b",trans_drv.RST,trans_drv.CE,trans_drv.CIN,trans_drv.INP_VALID,trans_drv.CMD,trans_drv.OPA,trans_drv.OPB,trans_drv.RES,trans_drv.ERR,trans_drv.OFLOW,trans_drv.COUT,trans_drv.G,trans_drv.L,trans_drv.E),UVM_MEDIUM);
					end
					*/
				  $display("Field\t\t|\tMonitor Output\t\t|\tReference Output");
					$display("--------------|-------------------------------|-----------------------------");
					$display("rst\t\t|\t\t%b\t\t|\t\t%b", trans_mon.RST, trans_drv.RST);
					$display("ce\t\t|\t\t%b\t\t|\t\t%b", trans_mon.CE, trans_drv.CE);
					$display("mode\t\t|\t\t%b\t\t|\t\t%b", trans_mon.MODE, trans_drv.MODE);
					$display("cmd\t\t|\t\t%0d\t\t|\t\t%0d", trans_mon.CMD, trans_drv.CMD);
					$display("inp_valid\t|\t\t%b\t\t|\t\t%b", trans_mon.INP_VALID, trans_drv.INP_VALID);
					$display("opa\t\t|\t\t%0d\t\t|\t\t%0d", trans_mon.OPA, trans_drv.OPA);
					$display("opb\t\t|\t\t%0d\t\t|\t\t%0d ", trans_mon.OPB, trans_drv.OPB);
					$display("cin\t\t|\t\t%b\t\t|\t\t%b", trans_mon.CIN, trans_drv.CIN);
					$display("res\t\t|\t\t%0d\t\t|\t\t%0d", trans_mon.RES, trans_drv.RES);
					$display("err\t\t|\t\t%b\t\t|\t\t%b", trans_mon.ERR, trans_drv.ERR);
					$display("oflow\t\t|\t\t%b\t\t|\t\t%b", trans_mon.OFLOW, trans_drv.OFLOW);
					$display("cout\t\t|\t\t%b\t\t|\t\t%b", trans_mon.COUT, trans_drv.COUT);
					$display("g\t\t|\t\t%b\t\t|\t\t%b", trans_mon.G, trans_drv.G);
					$display("l\t\t|\t\t%b\t\t|\t\t%b", trans_mon.L, trans_drv.L);
					$display("e\t\t|\t\t%b\t\t|\t\t%b", trans_mon.E, trans_drv.E);		
					if((trans_mon.RES === trans_drv.RES) && (trans_mon.OFLOW === trans_drv.OFLOW) && (trans_mon.ERR === trans_drv.ERR) && (trans_mon.COUT === trans_drv.COUT) && (trans_mon.G === trans_drv.G) && (trans_mon.L === trans_drv.L) && (trans_mon.E === trans_drv.E)) begin
					     match++;
					     $display("------------------------------------------------ Passed = %d --------------------------------------------",match);
					 end
					 else begin
					     mismatch++;
					     $display("------------------------------------------------ Failed = %d --------------------------------------------",mismatch);
					 end
			 end
			
	endtask
endclass
