////////////////////////////////////////////////////////////////////////////////
// Description =>  SEQUENTIAL STATES MACHINE CONTROL FSM
////////////////////////////////////////////////////////////////////////////////

module control_fsm (
  
  	/*----------Input Variables---------------*/
  
  	input 	    clk, rst,
    input [5:0] Opcode,
  
  
    /*----------Multiplexer Selects-----------*/
  
    output reg 		  MemtoReg, RegDst, ALUSrcA,
  	output reg	[1:0] ALUSrcB, PCSrc,
  
  
    /*----------Register enables--------------*/
  
    output reg 	IRWrite, MemWrite, PCWrite, BEQ, BNE, RegWrite,
  
  
    /*----------ALU control------------------*/
  
  	output reg	[1:0] ALUOp,
  
  	output reg [3:0] current_state
  
);

  
  reg [3:0] state;
  reg [3:0] next_state;
  
  
  // 1. CODIFICATION

  //States
  parameter Fetch           = 4'd0;
  parameter Decode          = 4'd1;
  parameter MemAdr          = 4'd2;
  parameter Mem_Read        = 4'd3;
  parameter Mem_Writeback   = 4'd4;
  parameter Mem_Write       = 4'd5;
  parameter Execute         = 4'd6;
  parameter ALU_Writeback   = 4'd7;
  parameter Branch_BEQ      = 4'd8;
  parameter Branch_BNE      = 4'd9;
  parameter Jump            = 4'd10;
  
  //Opcodes
  parameter Op_R            = 6'd0;
  parameter Op_LW           = 6'd35;
  parameter Op_SW           = 6'd43;
  parameter Op_BEQ          = 6'd4;
  parameter Op_BNE          = 6'd5;
  parameter Op_Jump         = 6'd2;
  

  // 2. STATE REGISTER
  always @(posedge clk, posedge rst)
    begin
      if ( rst )
        state <= Fetch;
      else
        state <= next_state;
    end
  
  
  // 3. NEXT STATE PROCESS
  always @(state, Opcode)
    begin
      case(state)
        
        
////////// STATES FOR EACH OPTION FROM THE INPUT //////////
        
        // RESET MAIN VALUES
        Fetch : next_state = Decode;
        

        // INPUT STATE
        Decode : begin
          
          if ( Opcode == Op_LW | Opcode == Op_SW ) // lw sw
                      next_state = MemAdr;

          else if ( Opcode == Op_R ) // TYPE - R
                      next_state = Execute;

          else if ( Opcode == Op_BEQ ) // BEQ
                      next_state = Branch_BEQ;

          else if ( Opcode == Op_BNE ) // BNE
                      next_state = Branch_BNE;

          else if ( Opcode == Op_Jump ) // JUMP
                      next_state = Jump;
          
          else        next_state = Fetch;
        end
        
        
        // SW OR LW STATE
        MemAdr : begin
          
          if ( Opcode == Op_LW ) 
                      next_state = Mem_Read;
          
          else if ( Opcode == Op_SW ) 
                      next_state = Mem_Write;
          
          else        next_state = Fetch;
        end
        
        
        // LW READ STATE
        Mem_Read :  next_state = Mem_Writeback;
        
        
        // LW FINAL STATE
        Mem_Writeback : next_state = Fetch;
        
        
        // SW STATE
        Mem_Write : next_state = Fetch;
        
        
        // R - TYPE STATE
        Execute : next_state = ALU_Writeback;
        
        
        // ALU WRITEBACK STATE
        ALU_Writeback : next_state = Fetch;
        
        
        // BRANCH IF EQUAL STATE
        Branch_BEQ : next_state = Fetch;
        
        
        // BRANCH IF NOT EQUAL STATE
        Branch_BNE : next_state = Fetch;
        
        
        // JUMP STATE
        Jump : next_state = Fetch;
        
        
        default : next_state = Fetch;
        
      endcase
    end
  
  
  
  // 4. OUTPUT LOGIC PROCESS
  always @(state)
    
      case (state)
        
        Decode : begin
            PCSrc      = 2'b00;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b10;
            ALUSrcA    = 1'b0;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
        
        MemAdr : begin
            PCSrc      = 2'b00;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b10;
            ALUSrcA    = 1'b1;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
        
        Mem_Read : begin
            PCSrc      = 2'b00;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b0;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end

        Mem_Writeback : begin
            PCSrc      = 2'b00;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b0;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b1;
            MemtoReg   = 1'b1;
            RegDst     = 1'b0;
        end
        
        Mem_Write : begin
            PCSrc      = 2'b00;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b0;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b1;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
        
        Execute : begin
            PCSrc      = 2'b00;
            ALUOp      = 2'b10;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b1;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
        
        ALU_Writeback : begin
            PCSrc      = 2'b00;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b0;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b1;
            MemtoReg   = 1'b0;
            RegDst     = 1'b1;
        end
        
        Branch_BEQ : begin
            PCSrc      = 2'b01;
            ALUOp      = 2'b01;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b1;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b1;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
        
        Branch_BNE : begin
            PCSrc      = 2'b01;
            ALUOp      = 2'b01;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b1;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b0;
            BEQ        = 1'b0;
            BNE        = 1'b1;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
        
        Jump : begin
            PCSrc      = 2'b10;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b00;
            ALUSrcA    = 1'b0;
          	IRWrite    = 1'b0;
            MemWrite   = 1'b0;
            PCWrite    = 1'b1;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
        
        default : begin//Fetch 
            PCSrc      = 2'b00;
            ALUOp      = 2'b00;
            ALUSrcB    = 2'b01;
            ALUSrcA    = 1'b0;
          	IRWrite    = 1'b1;
            MemWrite   = 1'b0;
            PCWrite    = 1'b1;
            BEQ        = 1'b0;
            BNE        = 1'b0;
            RegWrite   = 1'b0;
            MemtoReg   = 1'b0;
            RegDst     = 1'b0;
        end
          
      endcase
  
  assign current_state=state;

endmodule
