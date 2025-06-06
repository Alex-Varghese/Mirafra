`include "alu.v"

`define PASS 1'b1
`define FAIL 1'b0
`define testcases 116
`define DATA_WIDTH 8 
`define CMD_WIDTH 4

module alu_tb();
	reg clk, rst;
	reg CE;
	reg CIN;
	reg MODE;
        reg [1:0] INP_VALID;
	reg [`CMD_WIDTH-1:0] CMD;
	reg [`DATA_WIDTH-1:0] OPA;
	reg [`DATA_WIDTH-1:0] OPB;
        wire ERR, OFLOW, G, L, E, COUT;
	wire [(2*`DATA_WIDTH):0] RES;
	
	alu #(`DATA_WIDTH,`CMD_WIDTH) DUT(.clk(clk),.rst(rst),.CE(CE),.CIN(CIN),.mode(MODE),.INP_INVALID(INP_VALID),.CMD(CMD),.opa(OPA),.opb(OPB),.ERR(ERR),.OFLOW(OFLOW),.g(G),.l(L),.e(E),.cout(COUT),.RES(RES));
	 
	 
	reg [56:0] current_test_case = 55'b0;
	reg [80:0] response_packet; // {dut_output,current_test_case}
	reg [21:0] expected_output; // from stimulus
        reg [21:0] dut_output;
	reg [8:0] result_expected;
	reg [2:0] gle_expected;


	reg [7:0] ID, temp;
	reg cout, oflow, err,reserved_bit;

	integer i,j;
	event fetch_stimulus;    	
	
	integer stimulus_mem_ptr = 0, scb_mem_ptr = 0, fid = 0 , pointer = 0;
	
	reg [56:0] stimulus_data [0:`testcases-1]; // for stimulus data
   	reg [52:0] scoreboard_stimulus_mem [0:`testcases-1];
	
	task read_stimulus();
	   	begin
	    		#10 $readmemb("stimulus.txt",stimulus_data);
               end
        endtask
        
        task dut_reset();
		begin
			CE = 1;
		        #10 rst = 1;
			#20 rst = 0;
		end
	endtask
	
	task init();
		begin
			current_test_case = 57'b0;
			response_packet = 80'b0;
			stimulus_mem_ptr = 0;
		end
	endtask
	
	task driver ();
		begin
       	->fetch_stimulus;
		@(posedge clk);
	        ID    = current_test_case[56:49];
		rst   = current_test_case[48];
		INP_VALID = current_test_case[47:46];
		OPA   = current_test_case[45:38];
		OPB   = current_test_case[37:30];
		CMD   = current_test_case[29:26];
	        CIN   = current_test_case[25];
	        CE    = current_test_case[24];
		MODE  = current_test_case[23];
	        result_expected = current_test_case[22:7];
	        cout  = current_test_case[6];
	        gle_expected = current_test_case[5:3];
	        oflow = current_test_case[2];
	        err = current_test_case[1];
	        reserved_bit = current_test_case[0];
		expected_output = {result_expected,cout,gle_expected,oflow,err};
	        if( MODE ) begin
				$display("\n---------------------------------------------------------- Expected result from stimulus start ------------------------------------------------------------\n");
				$display("\nAt Time : %t | Arithmetic Operation : ",$time);
				$display("\n MODE | INP_VALID |    OPA    |    OPB     | CMD | STIMULUS RESULT | COUT | GLE | OFLOW | ERR | Reserved_bit");
				$display("  %b   |     %2b    | %b  |  %b  | %d  |  %b    |   %b  | %3b |   %b   |  %b  |     %b\n",MODE,INP_VALID,OPA,OPB,CMD,result_expected,cout,gle_expected,oflow,err,reserved_bit);
				$display("\n---------------------------------------------------------- Expected result from stimulus end ------------------------------------------------------------\n");
			end
			else if (MODE == 0 && CE) begin
				$display("\nAt Time : %t | Logical Operation : ",$time);
                		$display("\n MODE | INP_VALID |    OPA    |    OPB     | CMD |  STIMULUS RESULT | COUT | GLE | OFLOW | ERR | Reserved_bit");			
				$display("  %b   |     %2b    | %b  |  %b  | %d  |  %b    |   %b  | %3b |   %b   |  %b  |     %b\n",MODE,INP_VALID,OPA,OPB,CMD,result_expected,cout,gle_expected,oflow,err,reserved_bit);
				$display("\n---------------------------------------------------------- Expected result from stimulus end ------------------------------------------------------------\n");
			end
			else begin
				$display("\nAt Time : %t | Initial test : ",$time);
                		$display("\n MODE | INP_VALID |    OPA    |    OPB     | CMD |  STIMULUS RESULT | COUT | GLE | OFLOW | ERR | Reserved_bit");			
				$display("  %b   |     %2b    | %b  |  %b  | %d  |  %b    |   %b  | %3b |   %b   |  %b  |     %b\n",MODE,INP_VALID,OPA,OPB,CMD,result_expected,cout,gle_expected,oflow,err,reserved_bit);
				$display("\n---------------------------------------------------------- Expected result from stimulus end ------------------------------------------------------------\n");
			end
		end
	endtask
	
	task monitor ();
            begin
	        repeat(4)@(posedge clk);
			#5 response_packet[56:0] = current_test_case;
		        response_packet[58]	= ERR;
			response_packet[59]	= OFLOW;
			response_packet[62:60]	= {G,L,E};
			response_packet[63]	= COUT;
			response_packet[79:64]	= RES;
	        	response_packet[57]	= current_test_case[0]; // Reserved Bit
	        	dut_output = {RES,COUT,{G,L,E},OFLOW,ERR};
			if(expected_output === dut_output) begin
			if(MODE) begin
				$display("\n-------------------------------------------------- DUT OUTPUT START---------------------------------------------------------------");
				$display(" \nMODE | INP_VALID | OPA  |  OPB  | CMD | DUT RESULT | COUT | GLE | OFLOW | ERR | Reserved_bit");
				$display("  %b   |     %2b    | %d  |  %d  | %d  |  %d    |   %b  | %3b |   %b   |  %b  |     %b\n",MODE,INP_VALID,OPA,OPB,CMD,RES,COUT,{G,L,E},OFLOW,ERR,reserved_bit);
				$display("\n-------------------------------------------------- DUT OUTPUT DONE---------------------------------------------------------------");
			end
			else begin
				$display("-------------------------------------------------- DUT OUTPUT ---------------------------------------------------------------");
				$display(" \nMODE | INP_VALID |    OPA    |    OPB     | CMD |       DUT RESULT      | COUT | GLE | OFLOW | ERR | Reserved_bit");
                		$display("  %b   |     %2b    | %b  |  %b  | %d  |  %b    |   %b  | %3b |   %b   |  %b  |     %b\n",MODE,INP_VALID,OPA,OPB,CMD,RES,COUT,{G,L,E},OFLOW,ERR,reserved_bit);
             	    	        $display("\n-------------------------------------------------- DUT OUTPUT DONE---------------------------------------------------------------");
			end	
		end
	end
	endtask
	
	task score_board();
		   begin
	        #5;
			// $display("\n---------------- Expected Result --------------||------------------ DUT Output-------------------||------Result------");
	     	 if(expected_output === dut_output) begin
			//	 $display("\t\t %15b \t\t ||\t\t %15b\t\t  || \t   PASS",expected_output, dut_output);
	    	     scoreboard_stimulus_mem[scb_mem_ptr] = {ID, expected_output, dut_output, `PASS};
    		 end
	  	 else begin
	    	     scoreboard_stimulus_mem[scb_mem_ptr] = {ID, expected_output, dut_output, `FAIL};
				  // $display("\t\t %15b \t\t ||\t\t %15b  \t\t ||  \t  FAIL",expected_output, dut_output);
		 end
		 scb_mem_ptr = scb_mem_ptr + 1;
	end
	endtask
	
	task gen_report;
	       integer file_id,file_id_2,pointer;
	       reg [52:0] status;
	       begin
  	       file_id = $fopen("pass_results.txt", "w");
	       file_id_2 = $fopen("fail_results.txt","w");
               for( pointer = 0; pointer <= `testcases-1 ; pointer = pointer + 1 )
               begin
  		    status = scoreboard_stimulus_mem[pointer];
  		    if(status[0])
    		    	$fdisplay(file_id, "Feature ID %d : PASS", status[52:45]);
  		    else
    			$fdisplay(file_id_2, "Feature ID %d : FAIL", status[52:45]);
       		    end
		end
	endtask
	 
        initial
		begin 
			clk = 0;
			forever #10 clk = ~clk;
		end
		
        always@(fetch_stimulus)
		begin
			current_test_case = stimulus_data[stimulus_mem_ptr];
			temp = current_test_case[56:49];
			$display("\n--------------------------------------------------------- ID : %d -----------------------------------------------------------",temp);
			stimulus_mem_ptr = stimulus_mem_ptr + 1;
		end
		
	initial
	       begin
	        #10;
		init();
	      	dut_reset();
            	read_stimulus();
   		for(j=0;j<=`testcases-1;j=j+1)
			begin
                	fork
                       	if(j == 0) begin
		  		driver(); #20;
			end
			else
				driver();
                       		monitor();
                    	join
			score_board();
            	end
            	gen_report();
            	$fclose(fid);
		$fclose(fid);
	        #300 $finish();
	end
endmodule

