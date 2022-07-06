//gets the packet from monitor, Generated the expected result and compares with the //actual result recived from Monitor

class scoreboard;
   
  //creating mailbox handle
  mailbox mon2scb;
  
  //Aux variables
  logic [4:0] rt;
  logic [4:0] rs;
  logic [15:0] imm;
  logic [7:0] addr_mem;
  bit [31:0] mem [0:255];// 
  bit [31:0] reg_mem [0:31];// model reg file
  //R
  logic [4:0] rd;
  logic [4:0] shamt;
  logic [5:0] func;
  logic [31:0] y; //result variable
  //j
  logic [25:0] jta; //jump target address
  logic [31:0] pc_temp;
  
  //Report variables
  int R_T=0;
  int J_T=0;
  int BEQ_T=0;
  int BNE_T=0;
  int LW_T=0;
  int SW_T=0;
  int R_E=0;
  int J_E=0;
  int BEQ_E=0;
  int BNE_E=0;
  int LW_E=0;
  int SW_E=0;
  
  //used to count the number of transactions
  int no_transactions;
  
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
    foreach(mem[i]) mem[i] = i;// inicializar
    foreach(reg_mem[i]) reg_mem[i] = i;// inicializar
    //$readmemb("data_mem.txt",mem);
    //$readmemb("regMem.txt",reg_mem);
  endfunction
  
  //Compares the Actual result with the expected result
  task main;
    transaction trans;
    forever begin
        //#10;
      mon2scb.get(trans);
      
      case (trans.extInst[31:26])
        0:  begin         				//R
                $display("R Type instruction");       
                rs=trans.extInst[25:21];
                rt=trans.extInst[20:16];                
                rd=trans.extInst[15:11];
                shamt=trans.extInst[10:6];
                func=trans.extInst[5:0];
          		$display("Function code: %d | rs=%d, rt=%d", func,rs,rt);
                case (func)
                  36: y = reg_mem[rs] & reg_mem[rt];
                  37: y = reg_mem[rs] | reg_mem[rt];
                  32: y = reg_mem[rs] + reg_mem[rt];
                  34: y = reg_mem[rs] - reg_mem[rt];
                  42: y = reg_mem[rs] < reg_mem[rt] ? 1:0;
                  default: $display("Error function code.");
                endcase
          		reg_mem[rd]=y;
          		if(y ===trans.regmem_data) begin
                  $display("Result is as Expected.\tExpected: %0d Actual: %0d", (y),trans.regmem_data);                 
          		end
                else begin
                  $error("Wrong Result.\n\tExpected: %0d Actual: %0d", (y),trans.regmem_data);
                  R_E++;
                end
          		R_T++;
        end
        2:  begin                 //Jump
                $display("Jump instruction");
                jta=trans.extInst[25:0];
          		  pc_temp=trans.pc_current+1;
          		  y={pc_temp[31:28],jta};
          		if(y==trans.pc_next) begin
                  $display("Result is as Expected.\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                end
                else begin
                  $error("Wrong Result.\n\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                  J_E++;
                end
          		J_T++;
        end
        4:  begin                 //beq
                $display("BEQ Instruction");
                imm =trans.extInst[15:0];
                rt=trans.extInst[20:16];
                rs=trans.extInst[25:21]; 
                if(reg_mem[rs]==reg_mem[rt]) begin                
                  y = trans.pc_current  + {{16{imm[15]}},imm};
                  if(y==trans.pc_next) begin
                  	$display("Result is as Expected.\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                  end
                  else begin
                  	$error("Wrong Result.\n\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                  	BEQ_E++;
                  end
                end         
                else begin
                  y = trans.pc_current + 1;
                  if(y==trans.pc_current +1) begin
                    $display("Result is as Expected.\tExpected: %0d Actual: %0d", (y),trans.pc_current+1);
                  end
                  else begin
                  	$error("Wrong Result.\n\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                  	BEQ_E++;
                  end
                end                                
          		BEQ_T++;
        end
        5:  begin                 //bne
          $display("BNE Instruction");
                imm =trans.extInst[15:0];
                rt=trans.extInst[20:16];
                rs=trans.extInst[25:21]; 
                if(reg_mem[rs]!=reg_mem[rt]) begin                
                  y = trans.pc_current + {{16{imm[15]}},imm};
				  if(y==trans.pc_next) begin
                  	$display("Result is as Expected.\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                  end
                  else begin
                    $error("Wrong Result.\n\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                    BNE_E++;
                  end
                end         
                else begin                  
                  y = trans.pc_current + 1;
                  if(y==trans.pc_current +1) begin
                    $display("Result is as Expected.\tExpected: %0d Actual: %0d", (y),trans.pc_current+1);
                  end
                  else begin
                  	$error("Wrong Result.\n\tExpected: %0d Actual: %0d", (y),trans.pc_next);
                  	BNE_E++;
                  end
                end
          		BNE_T++;
        end
        35: begin									//lw          
                $display("LW Instruction");
                imm =trans.extInst[15:0];
                rt=trans.extInst[20:16];
                rs=trans.extInst[25:21];
                addr_mem=reg_mem[rs]+{{16{imm[15]}},imm};
                reg_mem[rt]=mem[addr_mem];
                $writememb("regMem2.txt", reg_mem);
                if(reg_mem[rt]==trans.regmem_data) begin
                      $display("Result is as Expected.\n\tExpected: %d Actual: %d",reg_mem[rt],trans.regmem_data); 
                  end
                  else begin
                    $error("Wrong Result.\n\tExpected: %d Actual: %d",  reg_mem[rt],trans.regmem_data);
                    	LW_E++;
                  end
          		LW_T++;
        end
        43: begin									//sw
                $display("SW Instruction");
                imm=trans.extInst[15:0];
                rt=trans.extInst[20:16];
                rs=trans.extInst[25:21];
                addr_mem=reg_mem[rs]+{{16{imm[15]}},imm};
                mem[addr_mem]=reg_mem[rt];
                $writememb("data_mem2.txt", mem);
                if(mem[addr_mem]==trans.datamem_data) begin
                    $display("Result is as Expected.\nExpected: %d Actual: %d",  mem[addr_mem],trans.datamem_data); 
                  end
                  else begin
                      $error("Wrong Result.\n\tExpected: %d Actual: %d",  mem[addr_mem],trans.datamem_data);
                    	SW_E++;
                  end
          		SW_T++;
        end

        default:  $display("INSTRUCTION ERROR.");
        
    endcase
     // trans.display("[ Scoreboard ]");       
        no_transactions++;
      
      
    end
  endtask
  
    task stats;
      $display("\n--------------------------------------------");
      $display("------[Scoreboard statistics]------");
      $display("- Total instructions: %0d", R_T+J_T+BEQ_T+BNE_T+LW_T+SW_T);
      $display("- Total instructions with success: %0d", R_T+J_T+BEQ_T+BNE_T+LW_T+SW_T-(R_E+J_E+BEQ_E+BNE_E+LW_E+SW_E));
      $display("- Total failures found: %0d", R_E+J_E+BEQ_E+BNE_E+LW_E+SW_E);
      $display("- R-Type instructions with success: %0d Errors: %0d", R_T-R_E,R_E);
      $display("- J-instructions with success: %0d Errors: %0d", J_T-J_E,J_E);
      $display("- BEQ-instructions with success: %0d Errors: %0d", BEQ_T-BEQ_E,BEQ_E);
      $display("- BNE-instructions with success: %0d Errors: %0d", BNE_T-BNE_E,BNE_E);
      $display("- LW-instructions with success: %0d Errors: %0d", LW_T-LW_E,LW_E);
      $display("- SW-instructions with success: %0d Errors: %0d", SW_T-SW_E,SW_E);
    $display("--------------------------------------------\n");
  endtask
  
  //R_T+J_T+BEQ_T+BNE_T+LW_T+SW_T;
  
endclass