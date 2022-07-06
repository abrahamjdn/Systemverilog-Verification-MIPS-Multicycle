`define MON_IF vif.MONITOR.monitor_cb

class monitor;
  
  //creating virtual interface handle
  virtual intf vif;
  //bit valid;
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual intf vif,mailbox mon2scb);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    
    forever begin      
      
      transaction trans;
      trans = new();
      wait(vif.valid==1);
      wait(vif.current_state==0);
      @(posedge vif.clk);    
      trans.extInst=vif.extInst;           
      case (trans.extInst[31:26])
        0: wait(vif.current_state==7);
        2: wait(vif.current_state==10);
        4: wait(vif.current_state==8);
        5: wait(vif.current_state==9);
        35: wait(vif.current_state==4);
        43: wait(vif.current_state==5);
        default: $display("ERROR OPCODE");
	  endcase
     @(negedge vif.clk);
      trans.regmem_data=vif.regmem_data;   
      trans.pc_current=vif.pc_current;        
      trans.pc_next=vif.pc_next;
      trans.regf1=vif.regf1;
      trans.regf2=vif.regf2; 
      trans.datamem_data=vif.datamem_data;
      mon2scb.put(trans);
      trans.display("[MONITOR]");
    end
  endtask
endclass
