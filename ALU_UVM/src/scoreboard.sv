
class scoreboard extends uvm_scoreboard;

	sequence_item packet_queue[$];

	bit [7:0]smem[4];

	`uvm_component_utils(scoreboard)

	uvm_analysis_imp #(sequence_item, scoreboard)  item_collected_export;

    function new (string name, uvm_component parent);
    	super.new(name, parent);
 	endfunction

  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	item_collected_export = new("item_collected_export", this);
  	endfunction
  
  	virtual function void write(sequence_item packet_1);
  		$display("Scoreboard is received:: Packet");
    	packet_queue.push_back(packet_1);
  	endfunction

  	virtual task run_phase(uvm_phase phase);
    	sequence_item trans;
	 	forever begin
	    	wait(packet_queue.size() > 0);
	      	trans = packet_queue.pop_front();
	      	if(trans.rst == 1) begin
				trans.RES = 'b0;
				trans.ERR = 'b0;
				trans.COUT = 0;
				trans.OFLOW = 0;
				trans.E = 0;
				trans.G = 0;
				trans.L = 0;
	      	end : rst_1
	      	else if(trans.CE == 1) begin
				case(trans.INP_VALID)
					2'b00 : trans.ERR = 1;
					2'b01 : if(trans.MODE) begin
							case(trans.CMD)
								`INC_A : trans.RES = trans.OPA + 1;
								`DEC_A : trans.RES = trans.OPA - 1;
								default : trans.ERR = 1;
						   	endcase
						   end
						   else begin
						   	case(trans.CMD)
								`NOT_A:  trans.RES = {1'b0,~trans.OPA};
								`SHR1_A: trans.RES = trans.OPA >> 1;
								`SHL1_A: trans.RES = trans.OPA << 1;
								default: trans.ERR = 1;
						    endcase
						   end
					2'b10 : if(trans.MODE) begin
							case(trans.CMD)
								`INC_B : trans.RES = trans.OPB + 1;
								`DEC_B : trans.RES = trans.OPB - 1;
								default : trans.ERR = 1;
						   	endcase
						   end
						   else begin
						   	case(trans.CMD)
								`NOT_B  : trans.RES = {1'b0,~trans.OPB};
								`SHR1_B : trans.RES = trans.OPB >> 1;
								`SHL1_B : trans.RES = trans.OPB << 1;
								default : trans.ERR = 1;
						    endcase
						   end
					2'b11 : if(trans.MODE) begin
							case(trans.CMD)
								`ADD : begin
										trans.RES = trans.OPA + trans.OPB;
										trans.COUT = trans.RES[`WIDTH];
									   end
								`SUB : begin
										trans.RES = trans.OPA - trans.OPB;
										trans.OFLOW = trans.OPA < trans.OPB;
									   end
								`ADD_CIN : begin
										trans.RES = trans.OPA + trans.OPB + trans.CIN;
										trans.COUT = trans.RES[`WIDTH];
									   end
								`SUB_CIN : begin
										trans.RES = trans.OPA - trans.OPB - trans.CIN;
										trans.OFLOW = (trans.OPA < trans.OPB) || (trans.OPA == trans.OPB) && trans.CIN;
									   end
								`CMP : begin
										trans.E = trans.OPA == trans.OPB;
										trans.G = trans.OPA > trans.OPB;
										trans.L = trans.OPA < trans.OPB;
									   end
								`INC_MULT : trans.RES = (trans.OPA + 1) * (trans.OPB + 1);
								`SH_MULT: trans.RES = (trans.OPA << 1) * trans.OPB;
								default : trans.ERR = 1;
						   	endcase
						   end
						   else begin
						   	case(trans.CMD)
								`AND  :	trans.RES = {1'b0,trans.OPA & trans.OPB};
								`NAND :	trans.RES = {1'b0,~(trans.OPA & trans.OPB)};
								`OR   :	trans.RES = {1'b0,trans.OPA | trans.OPB};
								`NOR  :	trans.RES = {1'b0,~(trans.OPA | trans.OPB)};
								`XOR  :	trans.RES = {1'b0,trans.OPA ^ trans.OPB};
								`XNOR :	trans.RES = {1'b0,~(trans.OPA ^ trans.OPB)};
								`ROL_A_B : begin
									rot_val = trans.OPB[`SHIFT - 1:0];
									trans.RES = {1'b0,trans.OPA << rot_val | trans.OPA >> (`WIDTH - rot_val)};
									trans.ERR = |trans.OPB[`WIDTH - 1 : `SHIFT +1];
									end
								`ROR_A_B : begin
      								 rot_val = trans.OPB[`SHIFT - 1:0];
									 trans.RES = {1'b0,trans.OPA << (`WIDTH - rot_val) | trans.OPA >> rot_val};
									 trans.ERR = |trans.OPB[`WIDTH - 1 : `SHIFT +1];
									end
								default : trans.ERR = 1;
						    endcase
						   end
					default : trans.ERR = 1;
				endcase
			end
		end
  endtask
endclass
 
