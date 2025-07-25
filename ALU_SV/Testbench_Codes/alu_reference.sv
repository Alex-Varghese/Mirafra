`include "defines.svh"

class alu_reference;

   transaction ref_trans;
	

   mailbox #(transaction) drv_ref_mail;
   mailbox #(transaction) ref_score_mail;

   virtual alu_intf.reference_cb v_intf;
   function new(mailbox #(transaction) drv_ref_mail, mailbox #(transaction) ref_score_mail, virtual alu_intf.reference_cb v_intf);
   	this.drv_ref_mail = drv_ref_mail;
   	this.ref_score_mail = ref_score_mail;
   	this.v_intf = v_intf;
   endfunction

   task start();
	event time_16;
	bit [3:0] count;
   	for(int i=0;i<`no_of_trans;i++) begin
   		ref_trans = new();
       		drv_ref_mail.get(ref_trans);
       		repeat(2) @(v_intf.reference_cb) begin
         		if(v_intf.reference_cb.rst)begin
           			ref_trans.res = 0;
           			ref_trans.err = 0;
            			ref_trans.g = 0;
            			ref_trans.e = 0;
            			ref_trans.l = 0;
            			ref_trans.oflow = 0;
            			ref_trans.cout = 0;
        		end
         		else if(ref_trans.ce && !v_intf.reference_cb.rst)begin
				if(ref_trans.inp_valid != 2'b11) 
					->time_16;
				@(time_16) begin
                        		if((ref_trans.mode && (((ref_trans.cmd < 4) || (ref_trans.cmd > 7)) && (ref_trans.cmd < 11))) || (ref_trans.mode && (((ref_trans.cmd < 6) || (ref_trans.cmd > 11)) && (ref_trans.cmd < 14)))) begin
						if(count < 16 ) begin
							if(ref_trans.inp_valid != 2'b11) begin
								repeat(1) @(v_intf.reference_cb) begin
									ref_trans = v_intf.driver_cb.inp_valid;
									count++;		
									->time_16;
								end	
							end
							else 
								break;
						else
							ref_trans.inp_valid = 2'b00;	
					end
					else 
						break;
				end
		
           			case (ref_trans.inp_valid)
                		2'b00 : begin
                  			ref_trans.err = 1'b1;
                  			ref_trans.res = 0;
					ref_trans.g = 0;
					ref_trans.e = 0;
					ref_trans.l = 0;
					ref_trans.oflow = 0;
					ref_trans.cout = 0;
                		end
                		2'b01: begin
                    			if (ref_trans.mode) begin
                        			case (ref_trans.cmd)
                            			`INC_A: begin
                                    			ref_trans.res = ref_trans.opa + 1;
                                    			ref_trans.cout = ref_trans.res[`WIDTH];
                            				end
                            			`DEC_A: begin
                                    			ref_trans.res = ref_trans.opa - 1;
                                    			ref_trans.cout = ref_trans.res[`WIDTH];
                            				end
                            			default: begin
                                			ref_trans.err = 1'b1;
                                			ref_trans.res = 0;
                            				end
                        			endcase
                    			end else begin
                        			case (ref_trans.cmd)
                          			`NOT_A: begin ref_trans.res = {1'b0, ~ref_trans.opa};end
                          			`SHR1_A: begin ref_trans.res = {1'b0, ref_trans.opa >> 1};end
                          			`SHL1_A: begin ref_trans.res = {1'b0, ref_trans.opa << 1};end
                            			default: begin
                               				ref_trans.err = 1'b1;
                                			ref_trans.res = 0;
                            				end
                        			endcase
                    			end
                			end
                		2'b10: begin
                    			if (ref_trans.mode) begin
                        			case (ref_trans.cmd)
                            			`INC_B: begin
                                			ref_trans.res = ref_trans.opb + 1;
                                			ref_trans.cout = ref_trans.res[`WIDTH];
                            				end
                            			`DEC_B: begin
                                			ref_trans.res = ref_trans.opb - 1;
                                			ref_trans.cout = ref_trans.res[`WIDTH];
                            				end
                            			default: begin
                                			ref_trans.err = 1'b1;
                                			ref_trans.res = 0;
                            				end
                        			endcase
                    			end else begin
                        			case (ref_trans.cmd)
                          			`NOT_B: begin ref_trans.res = {1'b0, ~ref_trans.opb};end
                          			`SHR1_B: begin ref_trans.res = {1'b0, ref_trans.opb >> 1};end
                          			`SHL1_B: begin ref_trans.res = {1'b0, ref_trans.opb << 1};end
                            			default: begin
                                			ref_trans.err = 1'b1;
                                			ref_trans.res = 0;
                            			end
                        			endcase
                    			end
                			end
                		2'b11: begin
                    			if (ref_trans.mode) begin
                        			case (ref_trans.cmd)
                            			`ADD: begin
                                		      ref_trans.res = ref_trans.opa + ref_trans.opb;
                                		      ref_trans.cout = ref_trans.res[`WIDTH];
                            			      end
                            			`SUB: begin
                                		      ref_trans.res = ref_trans.opa - ref_trans.opb;
                                		      ref_trans.oflow = ref_trans.res[`WIDTH];
                                                      end
                            			`ADD_CIN: begin
                                		      ref_trans.res = ref_trans.opa + ref_trans.opb + ref_trans.cin;
                                		      ref_trans.cout = ref_trans.res[`WIDTH];
                            			      end
                            			`SUB_CIN: begin
                                		      ref_trans.res = ref_trans.opa - ref_trans.opb - ref_trans.cin;
                                		      ref_trans.oflow = ref_trans.res[`WIDTH];
                            		              end
                            			`INC_A: begin
                                		      ref_trans.res = ref_trans.opa + 1;
                                		      ref_trans.cout = ref_trans.res[`WIDTH];
                            			      end
                            			`DEC_A: begin
                                                      ref_trans.res = ref_trans.opa - 1;
                                                      ref_trans.oflow = ref_trans.res[`WIDTH];
                            			      end
                            			`INC_B: begin
                                		      ref_trans.res = ref_trans.opb + 1;
                                		      ref_trans.cout = ref_trans.res[`WIDTH];
                            			      end
                            			`DEC_B: begin
                                		      ref_trans.res = ref_trans.opb - 1;
                               			      ref_trans.oflow = ref_trans.res[`WIDTH];
                            			      end
                            			`CMP: begin
                                		      ref_trans.l = ref_trans.opa < ref_trans.opb;
                                 		      ref_trans.e = ref_trans.opa == ref_trans.opb;
                                		      ref_trans.g = ref_trans.opa > ref_trans.opb;
                            			      end
                            			`INC_MUL: begin
                                    		      ref_trans.res = (ref_trans.opa + 1) * (ref_trans.opb + 1);
                                		      end
                            			`SHL1_A_MUL_B: begin
                                    		      ref_trans.res = (ref_trans.opa << 1) * (ref_trans.opb);
                                		      end
                            			default: begin
                                		      ref_trans.err = 1;
                                		      ref_trans.res = 0;
                            			      end
                        			endcase
                    			end else begin
                        			case (ref_trans.cmd)
                          			`AND: begin ref_trans.res = {1'b0, ref_trans.opa & ref_trans.opb};end
                          			`NAND: begin ref_trans.res ={1'b0, ~(ref_trans.opa & ref_trans.opb)};end
                          			`OR: begin ref_trans.res = {1'b0, ref_trans.opa | ref_trans.opb};end
                          			`NOR: begin ref_trans.res = {1'b0, ~(ref_trans.opa | ref_trans.opb)};end
                          			`XOR: begin ref_trans.res = {1'b0, ref_trans.opa ^ ref_trans.opb};end
                          			`XNOR: begin ref_trans.res = {1'b0, ~(ref_trans.opa ^ ref_trans.opb)};end
                          			`NOT_A: begin ref_trans.res = {1'b0, ~ref_trans.opa};end
                          			`NOT_B: begin ref_trans.res = {1'b0, ~ref_trans.opb};end
                          			`SHR1_A: begin ref_trans.res = {1'b0, ref_trans.opa >> 1};end
                          			`SHL1_A: begin ref_trans.res = {1'b0, ref_trans.opa << 1};end
                          			`SHR1_B: begin ref_trans.res = {1'b0, ref_trans.opb >> 1};end
                          			`SHL1_B: begin ref_trans.res = {1'b0, ref_trans.opb << 1};end
                            			`ROL_A_B: begin
                             				rot_val = ref_trans.opb[`rot_bits-1:0];
                                			ref_trans.res = {1'b0, (ref_trans.opa << rot_val) | (ref_trans.opa >> (`WIDTH - rot_val))};
                                			ref_trans.err = (ref_trans.opb >= `WIDTH);
                            				end
                            			`ROR_A_B: begin
                              				rot_val = ref_trans.opb[`rot_bits-1:0];
                                			ref_trans.res = {1'b0, (ref_trans.opa >> rot_val) | (ref_trans.opa << (`WIDTH - rot_val))};
                                			ref_trans.err = (ref_trans.opb >= `WIDTH);
                            				end
                            			default: begin
                                			ref_trans.res = 0;
                                			ref_trans.err = 1'b1;
                            				end
                        			endcase
                    				end
                			end
                			default: begin
                    				ref_trans.res = 0;
                    				ref_trans.err = 1'b1;
                			end
            				endcase
			
        	end
        	else begin
            		ref_trans.res = ref_trans.res;
            		ref_trans.err = 0;
            		ref_trans.g = 0;
            		ref_trans.e = 0;
            		ref_trans.l = 0;
            		ref_trans.oflow = 0;
            		ref_trans.cout = 0;
        	end
    		$display("reference op res=%d,err=%d,oflow=%d,cout=%d,g=%d,l=%d,e=%d",ref_trans.res,ref_trans.err,ref_trans.oflow,ref_trans.cout,ref_trans.g,ref_trans.l,ref_trans.e,$time);
       		end
     	ref_score_mail.put(ref_trans);
     	end
	endtask

endclass
