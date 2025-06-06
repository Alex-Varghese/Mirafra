module alu # ( parameter WIDTH = 8, CMD_WIDTH = 4 ) (
	input clk, rst,
	input CE,
	input CIN,
	input mode,
	input [1:0] INP_INVALID,
	input [ CMD_WIDTH-1 :0] CMD,
	input [ WIDTH-1 :0] opa,
	input [ WIDTH-1 :0] opb,
	output reg ERR, OFLOW, g , l, e, cout,
	output reg [ 2 * WIDTH :0] RES
);

    localparam ADD = 4'd0,		// arithmetic operation
	             SUB = 4'd1,
	             ADD_CIN = 4'd2,
	             SUB_CIN = 4'd3,
	             INC_A = 4'd4,
	             INC_B = 4'd5,
      	       DEC_A = 4'd6,
	             DEC_B = 4'd7,
      	       CMP = 4'd8,
	             ADD_MUL = 4'd9,
	             SHFTL_MUL = 4'd10,
	             ADD_SIG = 4'd11,
	             SUB_SIG = 4'd12;

    localparam AND = 4'd0,		// logical operation
               NAND = 4'd1,
               OR = 4'd2,
               NOR = 4'd3,
               XOR = 4'd4,
               XNOR = 4'd5,
               NOT_A = 4'd6,
               NOT_B = 4'd7,
               SHR1_A = 4'd8,
               SHL1_A = 4'd9,
               SHR1_B = 4'd10,
               SHL1_B = 4'd11,
	             ROL_A_B = 4'd12,
	             ROR_A_B = 4'd13;
	
    reg [WIDTH-1:0] opa_buf, opb_buf;   // Buffers for delay 
    reg [ 2 * WIDTH :0] res;
    reg oflow,G,L,E,COUT,err;

    localparam POW_2_N = $clog2(WIDTH); // Shifting shift amount check
    wire [POW_2_N - 1:0] SH_AMT = opb[POW_2_N - 1:0];
    
    always@( posedge clk or posedge rst ) begin
      if(rst) begin
            res <= {2*(WIDTH-1){1'b0}};
            {G, L, E, err, COUT, oflow} <= 6'b0;
      end
      else if( CE ) begin
		    if( mode ) begin // arithmetic
		      if( INP_INVALID == 2'b11 ) begin
				  res <= 0;
				  {G, L, E, err, COUT, oflow} <= 6'b0;
		          case( CMD )
		              ADD       : begin
		                              res   <= opa + opb;
		                              COUT  <= res[WIDTH];
		                              oflow <= 0;
									                err <= 0;
		                          end
		              SUB       : begin 
		                              res   <= opa - opb;
		                              COUT  <= ( opa < opb ) ? 1 : 0;
		                              oflow <= 0;
									                err <= 0;
		                          end
		              ADD_CIN   : begin
		                              res   <= opa + opb + CIN;
		                              COUT  <= res[WIDTH];
		                              oflow <= COUT;
									                err <= 0;
		                          end
		              SUB_CIN   : begin
		                              res   <= opa - opb - CIN;
		                              COUT  <= res[WIDTH];
		                              oflow <= COUT;
									                err <= 0;
		                          end
		              ADD_MUL   : begin
		                              res   <= ({{WIDTH{1'b0}},opa} + 1 ) * ({{WIDTH{1'b0}},opb} + 1 );
		                              COUT  <= 0;
		                              oflow <= 0;
									                err <= 0;
		                          end
		              CMP       : begin
									                COUT <= 0;
		                              {G,L,E} <= (opa > opb) ? 3'b100 : (opa < opb) ? 3'b010 : 3'b001;
		                          	  err <= 0;
								  end
		              SHFTL_MUL : begin
		                              res   <= {{WIDTH{1'b0}},opa << 1} * opb;
		                              COUT  <= 0;
		                              oflow <= 0;
									                err <= 0;
		                          end
		              ADD_SIG   : begin
		                              res   <= $signed(opa) + $signed(opb);
//		                              COUT  <= res[WIDTH];
//		                              oflow <= (~opa[WIDTH-1] & ~opb[WIDTH-1] & res[WIDTH-1]) | ( opa[WIDTH-1] &  opb[WIDTH-1] & ~res[WIDTH-1]);
                                  COUT = res[WIDTH];
									                {G,L,E} <= ($signed(res) > 0) ? 3'b100 : ($signed(res) > 0)  ? 3'b010 : 3'b001;
                                  oflow = (opa[WIDTH-1] == opb[WIDTH-1]) && ~res[WIDTH];
		                          	  err <= 0;
							      end
		              SUB_SIG   : begin
		                              res   <= $signed(opa) - $signed(opb);
//		                              COUT  <= res[WIDTH];
//		                              oflow <= (~opa[WIDTH-1] &  opb[WIDTH-1] & res[WIDTH-1]) | ( opa[WIDTH-1] & ~opb[WIDTH-1] & ~res[WIDTH-1]);
                                  COUT = res[WIDTH];
							              		  {G,L,E} <= ($signed(res) > 0) ? 3'b100 : ($signed(res) > 0)  ? 3'b010 : 3'b001;
                                  oflow = (opa[WIDTH-1] == opb[WIDTH-1]) && ~res[WIDTH];
		                              err <= 0;
								  end
		              default   : begin
		                              res <= {2*(WIDTH-1){1'b0}};
                                  {G, L, E, err, COUT, oflow} <= 6'b000100;
		                          end
		          endcase
		      end
		      else if( INP_INVALID == 2'b10 ) begin
		          {G, L, E, err, COUT, oflow} <= 6'b0;
				      res <= 0;
		          case( CMD )
		              INC_A     : begin
		                              res   <= opa + 1;
		                              COUT  <= res[WIDTH];
		                              oflow <= COUT;
									                err <= 0;
		                          end
		              DEC_A     : begin
		                              res <= opa - 1;
		                              COUT  <= res[WIDTH];
		                              oflow <= 0;
							              		  err <= 0;
		                          end
		              default   : begin
		                              res <= {2*(WIDTH-1){1'b0}};
                                  {G, L, E, err, COUT, oflow} <= 6'b000100;
		                          end
		          endcase
		      end
		      else if( INP_INVALID == 2'b01 ) begin
		          {G, L, E, err, COUT, oflow} <= 6'b0;
			        res <= 0;
		          case( CMD )
		              INC_B     : begin
		                              res   <= opb + 1;
		                              COUT  <= res[WIDTH];
		                              oflow <= COUT;
									                err <= 0;
		                          end
		              DEC_B     : begin
		                              res <= opb - 1;
		                              COUT  <= res[WIDTH];
		                              oflow <= 0;
							              		  err <= 0;
		                          end
		              default   : begin
		                              res <= {2*(WIDTH-1){1'b0}};
                                  {G, L, E, err, COUT, oflow} <= 6'b000100;
		                          end
		          endcase
		      end
		      else 
                res <= {2*(WIDTH-1){1'b0}};             
          end  
          else begin
              if( INP_INVALID == 2'b11 ) begin
                  {G, L, E, err, COUT, oflow} <= 6'b0;
				  res <= 0;
		          case( CMD )
		              AND       : res <= {{(WIDTH){1'b0}},(opa & opb)};
		              OR        : res <= {{(WIDTH){1'b0}},(opa | opb)};
		              NAND      : res <= {{(WIDTH){1'b0}},(~(opa & opb))};
		              XOR       : res <= {{(WIDTH){1'b0}},(opa ^ opb)};
		              NOR       : res <= {{(WIDTH){1'b0}},(~(opa | opb))};
		              XNOR      : res <= {{(WIDTH){1'b0}},(~(opa ^ opb))};
		              ROR_A_B   : begin
		                              res = {1'b0,opa << SH_AMT | opa >> (WIDTH - SH_AMT)};
                               	  res = |opb[WIDTH - 1 : POW_2_N +1];
		                          end 
		              ROL_A_B   : begin
                                      res = {1'b0,opa << (WIDTH - SH_AMT) | opa >> SH_AMT};
                                  	  res = |opb[WIDTH - 1 : POW_2_N +1];
		                          end
		              default   : begin
		                              res <= {2*(WIDTH-1){1'b0}};
                                  {G, L, E, err, COUT, oflow} <= 6'b000100;
		                          end
		          endcase
		      end
		      else if( INP_INVALID == 2'b10 ) begin                    
		          {G, L, E, err, COUT, oflow} <= 6'b0;
				      res <= 0;
		          case( CMD )
		              NOT_A     : res <= {{(WIDTH){1'b0}},(~opa)};
		              SHR1_A    : res <= {{(WIDTH){1'b0}},(opa >> 1)};
		              SHL1_A    : res <= {{(WIDTH){1'b0}},(opa << 1)};
		              default   : begin
		                              res <= {2*(WIDTH-1){1'b0}};
                                  {G, L, E, err, COUT, oflow} <= 6'b000100;
		                          end
		          endcase
		      end
		      else if( INP_INVALID == 2'b01 ) begin
		          {G, L, E, err, COUT, oflow} <= 6'b0;
		          case( CMD )
		              NOT_B     : res <= {{(WIDTH){1'b0}},(~opb)};
		              SHR1_B    : res <= {{(WIDTH){1'b0}},(opb >> 1)};
		              SHL1_B    : res <= {{(WIDTH){1'b0}},(opb << 1)};
		              default   : begin
		                              res <= {2*(WIDTH-1){1'b0}};
                                  {G, L, E, err, COUT, oflow} <= 6'b000100;
		                          end
		          endcase
		      end
		      else begin
                res <= {2*(WIDTH-1){1'b0}};
                {G, L, E, err, COUT, oflow} <= 6'b000100;
              end  
          end
       end
       end
       
       always@( * ) begin
          RES <= res;
		      cout <= COUT;
	        {g,l,e} <= {G,L,E};
		      OFLOW <= oflow;
		      ERR <= err;
       end
endmodule
