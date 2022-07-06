//receive the stimulus generated from the generator and drive to DUT by assigning transaction class values to interface signals.
//`define DRIVER_INTF vif.DRIVER.driver_cb
class driver;
  	bit valid;
  	int no_transactions;
    //virtual interface
    virtual intf vif;
    //mailbox
    mailbox gen2driv;
  

    //constructor
    function new(virtual intf vif, mailbox gen2driv);
        this.vif=vif;
        this.gen2driv=gen2driv;
    endfunction

    task  reset;
      wait(vif.rst);
        $display("[driver]---- Reset started -----");
        vif.extInst = 32'b0; 
      	vif.valid =0;        
        wait(!vif.rst);
      	vif.valid =1;
      $display("[driver]---- Reset ended -------");
    endtask //

  
  task main;	        
    forever begin
      transaction trans;
      gen2driv.get(trans);
      
      wait(vif.valid==1);
      wait(vif.current_state==0);
      vif.extInst=trans.extInst;      
      @(posedge vif.clk);      
      no_transactions++;
      $display("Driver number transaction: %d", no_transactions);
    end
  
  endtask
endclass
