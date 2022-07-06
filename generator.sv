class generator;
    rand transaction trans;
    //Number of repeats
    int repeat_count;
    //mailbox 
    mailbox gen2driv;
    event ended;
    
    //Constructor
    function new(mailbox gen2driv);
        this.gen2driv=gen2driv;
    endfunction //new()

    task main();
        repeat(repeat_count) begin
            trans = new();
            if (!trans.randomize()) begin
                $fatal("Gen:: trans randomization failed");
            end
            //trans.display("[Generator]");
            gen2driv.put(trans);
        end
        -> ended; //triggering indicates the end of generation
    endtask

endclass //generator