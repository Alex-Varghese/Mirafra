`include "defines.svh"

class generator;

    transaction blueprint;
    mailbox #(transaction) gen_mail;

    function new( mailbox #(transaction) gen_mail );
        this.gen_mail = gen_mail;
        blueprint = new();
    endfunction

    task start();
        for( int i = 0; i < `no_of_trans; i++ ) begin
            if(blueprint.randomize()) begin
                gen_mail.put(blueprint.copy());
                $display("\n----------------------------------------------------- Randomised values --------------------------------------------------------------------- \n");
                if(blueprint.mode)
                    $display("\n Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %d | OPB = %d \n",$time,blueprint.ce,blueprint.mode,blueprint.inp_valid,blueprint.cin,blueprint.opa,blueprint.opb);
                else
                    $display("\n Time : %t | CE = %b | MODE = %b | INP_VALID = %b | CIN = %b | OPA = %b | OPB = %b \n",$time,blueprint.ce,blueprint.mode,blueprint.inp_valid,blueprint.cin,blueprint.opa,blueprint.opb);
            end
            else begin
                $error(" Generator randomization failed ")
            end
        end
    endtask

endclass
