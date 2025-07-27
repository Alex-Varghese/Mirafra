class transaction;
    
    rand bit ce;
    rand bit mode;
    rand bit cin;
    rand bit [CMD_WIDTH-1:0] cmd;
    rand bit [1:0] inp_valid;
    rand logic [WIDTH-1:0] opa;
    rand logic [WIDTH-1:0] opb;
    logic [WIDTH:0] res;
    logic [2*WIDTH-1:0] res_mul;
    logic g, l, e;
    logic oflow, cout, err;

    constraint inpvalid_11 {
        inp_valid == 2'b11;
    }

    constraint cmd_range {
        if(mode)
            cmd inside {[0:10]};
        else
            cmd inside {[0:13]};
    }

    constraint signed_unsigned_spec {
        opa inside {[0:2**WIDTH]};
        opb inside {[0:2**WIDTH]};
    }

    constraint clock_enable {
        ce == 1;
    }
     
    virtual function transaction copy();
        copy = new();
        copy.opa = this.opa;
        copy.opb = this.opb;
        copy.cmd = this.cmd;
        copy.inp_valid = this.inp_valid;
        copy.ce = this.ce;
        copy.mode = this.mode
        copy.cin = this.cin;
        return copy;
    endfunction

endclass

class transaction_01 extends transaction;
    
    constraint inpvalid_01 {
        inp_valid == 2'b01;
    }

    virtual function transaction copy();
        copy1 = new();
        copy1.opa = this.opa;
        copy1.opb = this.opb;
        copy1.cmd = this.cmd;
        copy1.inp_valid = this.inp_valid;
        copy1.ce = this.ce;
        copy1.mode = this.mode
        copy1.cin = this.cin;
        return copy1;
    endfunction

endclass

class transaction_2 extends transaction;
    
    constraint inpvalid_10 {
        inp_valid == 2'b10;
    }

    virtual function transaction copy();
        copy2 = new();
        copy2.opa = this.opa;
        copy2.opb = this.opb;
        copy2.cmd = this.cmd;
        copy2.inp_valid = this.inp_valid;
        copy2.ce = this.ce;
        copy2.mode = this.mode
        copy2.cin = this.cin;
        return copy2;
    endfunction

endclass

class transaction_3 extends transaction;
    
    constraint inpvalid_00 {
        inp_valid == 2'b00;
    }

    virtual function transaction copy();
        copy3 = new();
        copy3.opa = this.opa;
        copy3.opb = this.opb;
        copy3.cmd = this.cmd;
        copy3.inp_valid = this.inp_valid;
        copy3.ce = this.ce;
        copy3.mode = this.mode
        copy3.cin = this.cin;
        return copy3;
    endfunction

endclass

