// NOT WORKING IN MIPSDEMO IN PUTTY ------------ LW , SLT , 

#include "shell.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

// R-Type Instructions 
#define ADD     0x20
#define ADDU    0x21
#define AND     0x24
#define BREAK   0x0D
#define DIV     0x1A
#define DIVU    0x1B
#define JALR    0x09
#define JR      0x08
#define MFHI    0x10
#define MFLO    0x12
#define MTHI    0x11
#define MTLO    0x13
#define MULT    0x18
#define MULTU   0x19
#define NOR     0x27
#define OR      0x25
#define SLL     0x00
#define SLLV    0x04
#define SLT     0x2A
#define SLTU    0x2B
#define SRA     0x03
#define SRAV    0x07
#define SRL     0x02
#define SRLV    0x06
#define SUB     0x22
#define SUBU    0x23
#define SYSCALL 0x0C
#define XOR     0x26

// I-Type Instructions 
#define ADDI    0x08
#define ADDIU   0x09
#define ANDI    0x0C
#define BEQ     0x04
#define BGEZ    0x01 
#define BGTZ    0x07 
#define BLEZ    0x06 
#define BLTZ    0x00
#define BLTZAL  0x10
#define BGEZAL  0x11
#define BNE     0x05
#define LB      0x20
#define LBU     0x24
#define LH      0x21
#define LHU     0x25
#define LUI     0x0F
#define LW      0x23
#define LWCL    0x31
#define ORI     0x0D
#define SB      0x28
#define SH      0x29
#define SLTI    0x0A
#define SLTIU   0x0B
#define SW      0x2B
#define SWCL    0x39
#define XORI    0x0E
#define BRANCH  0x01

// J-Type Instructions 
#define J       0x02
#define JAL     0x03

// Case definetions
#define R_TYPE  0x0
#define I_TYPE  0x1
#define J_TYPE  0x2

uint32_t get_instructions() {
    uint32_t instruction = mem_read_32(CURRENT_STATE.PC);
    return instruction;	
}

void print_values(uint32_t instruction) {
    uint32_t opcode = (instruction >> 26) & 0x3F;
    uint32_t funct;

    printf("Instruction: 0x%08X -> ", instruction);
    
    if(opcode == R_TYPE) {
        funct = instruction & 0x3F;
        uint32_t rs = (instruction >> 21) & 0x1F;
        uint32_t rt = (instruction >> 16) & 0x1F;
        uint32_t rd = (instruction >> 11) & 0x1F;
        uint32_t shamt = (instruction >> 6) & 0x1F; 
        switch(funct) {
            case ADD:     printf("ADD"); break;
            case ADDU:    printf("ADDU"); break;
            case AND:     printf("AND"); break;
            case BREAK:  printf("BREAK"); break;
            case DIV:     printf("DIV"); break;
            case DIVU:    printf("DIVU"); break;
            case JALR:    printf("JALR"); break;
            case JR:      printf("JR"); break;
            case MFHI:    printf("MFHI"); break;
            case MFLO:    printf("MFLO"); break;
            case MTHI:   printf("MTHI"); break;
            case MTLO:    printf("MTLO"); break;
            case MULT:   printf("MULT"); break;
            case MULTU:   printf("MULTU"); break;
            case NOR:    printf("NOR"); break;
            case OR:      printf("OR"); break;
            case SLL:     printf("SLL"); break;
            case SLLV:   printf("SLLV"); break;
            case SLT:     printf("SLT"); break;
            case SLTU:   printf("SLTU"); break;
            case SRA:     printf("SRA"); break;
            case SRAV:    printf("SRAV"); break;
            case SRL:     printf("SRL"); break;
            case SRLV:   printf("SRLV"); break;
            case SUB:     printf("SUB"); break;
            case SUBU:    printf("SUBU"); break;
            case SYSCALL: printf("SYSCALL"); break;
            case XOR:     printf("XOR"); break;
            default:      printf("UNKNOWN R-TYPE (funct: 0x%02X)", funct); break;
        }
        printf(" (R-type) : rt = %d | rs = %d | rd = %d | shamt = %d | PC = %x\n",rt,rs,rd,shamt,CURRENT_STATE.PC);
    }
    else if (opcode == J || opcode == JAL) {
        uint32_t target = instruction & 0x03FFFFFF;
        switch(opcode) {
            case J:   printf("J"); break;
            case JAL: printf("JAL"); break;
            default:  printf("UNKNOWN J-TYPE"); break;
        }
        printf(" (J-type) | target : %d | NEXT.PC = %x | CURRENT.PC = %x\n",target,NEXT_STATE.PC,CURRENT_STATE.PC);
    }
    else {
       uint32_t rs = (instruction >> 21) & 0x1F;
       uint32_t rt = (instruction >> 16) & 0x1F;
       int16_t immediate = (instruction & 0xFFFF);
       switch(opcode) {
            case ADDI:   printf("ADDI"); break;
            case ADDIU:  printf("ADDIU"); break;
            case ANDI:   printf("ANDI"); break;
            case BEQ:    printf("BEQ"); break;
            case BGTZ:   printf("BGTZ"); break;
            case BLEZ:   printf("BLEZ"); break;
            case BNE:    printf("BNE"); break;
            case LB:     printf("LB"); break;
            case LBU:    printf("LBU"); break;
            case LH:     printf("LH"); break;
            case LHU:    printf("LHU"); break;
            case LUI:    printf("LUI"); break;
            case LW:     printf("LW"); break;
            case LWCL:   printf("LWCL"); break;
            case ORI:    printf("ORI"); break;
            case SB:     printf("SB"); break;
            case SH:     printf("SH"); break;
            case SLTI:   printf("SLTI"); break;
            case SLTIU:  printf("SLTIU"); break;
            case SW:     printf("SW"); break;
            case SWCL:   printf("SWCL"); break;
            case XORI:   printf("XORI"); break;
            case BRANCH: 
                rt = (instruction >> 16) & 0x1F;
                switch(rt) {
                    case BLTZ:    printf("BLTZ"); break;
                    case BGEZ:    printf("BGEZ"); break;
                    case BLTZAL:  printf("BLTZAL"); break;
                    case BGEZAL:  printf("BGEZAL"); break;
                    default:      printf("UNKNOWN (rt: 0x%02X)", rt); break;
                }
                break;
            default:    printf("UNKNOWN I-TYPE (opcode: 0x%02X)", opcode); break;
        }
        printf(" (I-type) : rt = %d | rs = %d | immediate = %d | PC = %x \n",rt,rs,immediate,CURRENT_STATE.PC);
    }
}

uint32_t opcode_type(uint32_t opcode, uint32_t instr) {
    if (opcode == 0x00) {
        uint8_t funct = instr & 0x3F;
        return R_TYPE;
    }
    else if ((opcode & 0x3E) == 0x02) {
        return J_TYPE;
    }
    else {
        return I_TYPE;
    }
}

void process_instruction()
{
    uint32_t instruction = get_instructions();
    
    uint32_t opcode = (instruction >> 26) & 0x3F;

    // R-Type 
    uint32_t rs_r = (instruction >> 21) & 0x1F;
    uint32_t rt_r = (instruction >> 16) & 0x1F;
    uint32_t rd = (instruction >> 11) & 0x1F;
    uint32_t shamt = (instruction >> 6) & 0x1F;
    uint32_t funct = instruction & 0x3F;

    // I-Type 
    uint32_t rs_i = (instruction >> 21) & 0x1F;
    uint32_t rt_i = (instruction >> 16) & 0x1F;
    uint32_t immediate = (instruction & 0xFFFF);

    // J-Type 
    uint32_t target = instruction & 0x03FFFFFF;

    uint32_t type = opcode_type(opcode, instruction); // Get the type of instruction ( R - I - J )
    
    NEXT_STATE.PC = CURRENT_STATE.PC + 4;     // Incrementing PC in the beginning and overwriting the value in the switch-case 

    switch(type) {
        case R_TYPE:
                  switch( funct ) { // R type switch case used rs_r ( Source register ) , rt_r ( temporary or source register ) , rd ( destination register )
                        case ADD:
                                  NEXT_STATE.REGS[rd] = (int32_t)CURRENT_STATE.REGS[rs_r] + (int32_t)CURRENT_STATE.REGS[rt_r];
                                  print_values(instruction);
                                  break;
                        case ADDU:
                                  NEXT_STATE.REGS[rd] = (uint32_t)CURRENT_STATE.REGS[rs_r] + (uint32_t)CURRENT_STATE.REGS[rt_r];
                                  print_values(instruction);  
                                  break;
                        case AND:
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rs_r] & CURRENT_STATE.REGS[rt_r];
                                  print_values(instruction);  
                                  break;
                        case DIV:
                                  if(CURRENT_STATE.REGS[rt_r] != 0) {
                                      NEXT_STATE.LO = (int32_t)CURRENT_STATE.REGS[rs_r] / (int32_t)CURRENT_STATE.REGS[rt_r];
                                      NEXT_STATE.HI = (int32_t)CURRENT_STATE.REGS[rs_r] % (int32_t)CURRENT_STATE.REGS[rt_r];
                                  }
                                  else {
                                      printf("\n Not Valid !!! (rt) \n");
                                      NEXT_STATE.HI = 0x7F800000;
                                  }
                                  print_values(instruction); 
                                  break;
                        case DIVU:
                                  print_values(instruction);  
                                  if(CURRENT_STATE.REGS[rt_r] != 0) {
                                      NEXT_STATE.LO = (uint32_t)(CURRENT_STATE.REGS[rs_r]) / (uint32_t)(CURRENT_STATE.REGS[rt_r]);
                                      NEXT_STATE.HI = (uint32_t)(CURRENT_STATE.REGS[rs_r]) % (uint32_t)(CURRENT_STATE.REGS[rt_r]);
                                  }
                                  else {
                                      printf("\n Not Valid !!! (rt) \n");
                                      NEXT_STATE.HI = 0x7F800000;
                                  }
                                  print_values(instruction); 
                                  break;
                        case JALR:
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.PC + 8;
                                  NEXT_STATE.PC = CURRENT_STATE.REGS[rs_r];
                                  print_values(instruction); 
                                  break;
                        case JR: 
                                  NEXT_STATE.PC = CURRENT_STATE.REGS[rs_r];
                                  print_values(instruction); 
                                  break;
                        case MFHI:
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.HI;
                                  print_values(instruction); 
                                  break;
                        case MFLO: 
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.LO;
                                  print_values(instruction); 
                                  break;
                        case MTHI:
                                  NEXT_STATE.HI = CURRENT_STATE.REGS[rs_r];
                                  print_values(instruction); 
                                  break;
                        case MTLO:
                                  NEXT_STATE.LO = CURRENT_STATE.REGS[rs_r];
                                  print_values(instruction); 
                                  break;
                        case MULT:
                                  int64_t mult_i = (int32_t)CURRENT_STATE.REGS[rs_r] * (int32_t)CURRENT_STATE.REGS[rt_r];
                                  NEXT_STATE.HI = (((int64_t)mult_i) >> 32);
                                  NEXT_STATE.LO =((int64_t)mult_i) & 0xffffffff;
                                  print_values(instruction);
                                  break;
                        case MULTU:
                                  uint64_t temp = (uint32_t)CURRENT_STATE.REGS[rs_r] * (uint32_t)CURRENT_STATE.REGS[rt_r];
			          NEXT_STATE.LO = (temp & 0xFFFFFFFF);
			          NEXT_STATE.HI = (temp << 32);
			          print_values(instruction);
                                  break;
                        case NOR:  
                                  NEXT_STATE.REGS[rd] = ~(CURRENT_STATE.REGS[rs_r] | CURRENT_STATE.REGS[rt_r]);
                                  print_values(instruction); 
                                  break;
                        case OR:
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rs_r] | CURRENT_STATE.REGS[rt_r];
                                  print_values(instruction); 
                                  break;
                        case SLL:
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rt_r] << shamt;
                                  print_values(instruction); 
                                  break;
                        case SLLV:
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rt_r] << (CURRENT_STATE.REGS[rs_r] & 0x1F);
                                  print_values(instruction); 
                                  break;
                        case SLT:
                                  NEXT_STATE.REGS[rd] = ((((int32_t)CURRENT_STATE.REGS[rs_r])) < ((int32_t)CURRENT_STATE.REGS[rt_r])) ? 1 : 0;
                                  print_values(instruction); 
                                  break;
                        case SLTU:
                                  NEXT_STATE.REGS[rd] = (((uint32_t)CURRENT_STATE.REGS[rs_r]) < (uint32_t)CURRENT_STATE.REGS[rt_r]) ? 1 : 0;
                                  print_values(instruction);  
                                  break;
                        case SRA: 
                                  NEXT_STATE.REGS[rd] = (int32_t)CURRENT_STATE.REGS[rt_r] >> shamt;
                                  print_values(instruction); 
                                  break;
                        case SRAV: 
                                  NEXT_STATE.REGS[rd] = (int32_t)CURRENT_STATE.REGS[rt_r] >> ((uint32_t)CURRENT_STATE.REGS[rs_r] & 0x1F);
                                  print_values(instruction); 
                                  break;
                        case SRL:
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rt_r] >> shamt;
                                  print_values(instruction); 
                                  break;
                        case SRLV: 
                                  NEXT_STATE.REGS[rd] = (int32_t)CURRENT_STATE.REGS[rt_r] >> ((uint32_t)CURRENT_STATE.REGS[rs_r] & 0x1F);
                                  print_values(instruction); 
                                  break;
                        case SUB: 
                                  NEXT_STATE.REGS[rd] = (int32_t)CURRENT_STATE.REGS[rs_r] - (int32_t)CURRENT_STATE.REGS[rt_r];
                                  print_values(instruction); 
                                  break;
                        case SUBU:
                                  NEXT_STATE.REGS[rd] = (uint32_t)CURRENT_STATE.REGS[rs_r] - (uint32_t)CURRENT_STATE.REGS[rt_r];
                                  print_values(instruction); 
                                  break;
                        case XOR: 
                                  NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rs_r] ^ CURRENT_STATE.REGS[rt_r];
                                  print_values(instruction); 
                                  break;                          
                        case SYSCALL:
                                  if( CURRENT_STATE.REGS[2] == 10)
                                      RUN_BIT = 0;
                                  break;
                        default:
                                  printf("Unknown R-type instruction\n");
                                  break;       
                                  }
                break;                                                            
      case I_TYPE:
                switch(opcode) {                 // Switch  case for I type used rt_i ( destination register ) , rs_i ( value source ) , immediate ( constant value )
                        case ADDI:
                                  NEXT_STATE.REGS[rt_i] = (int32_t)CURRENT_STATE.REGS[rs_i] + (int16_t)(immediate);
                                  print_values(instruction); 
                                  break;
                        case ADDIU:
                                  NEXT_STATE.REGS[rt_i] = (uint32_t)CURRENT_STATE.REGS[rs_i] + (int16_t)(immediate);
                                  print_values(instruction); 
                                  break;
                        case ANDI:
                                  NEXT_STATE.REGS[rt_i] = CURRENT_STATE.REGS[rs_i] & immediate;
                                  print_values(instruction); 
                                  break;
                        case ORI:
                                  NEXT_STATE.REGS[rt_i] = CURRENT_STATE.REGS[rs_i] | immediate;
                                  print_values(instruction); 
                                  break;
                        case XORI:
                                  NEXT_STATE.REGS[rt_i] = CURRENT_STATE.REGS[rs_i] ^ immediate;
                                  print_values(instruction); 
                                  break;
                        case SLTI:
                                  NEXT_STATE.REGS[rt_i] = ((int32_t)CURRENT_STATE.REGS[rs_i] < (int16_t)immediate) ? 1 : 0;
                                  print_values(instruction); 
                                  break;
                        case SLTIU:
                                  NEXT_STATE.REGS[rt_i] = ((uint32_t)CURRENT_STATE.REGS[rs_i] < (uint16_t)immediate) ? 1 : 0;
                                  print_values(instruction); 
                                  break;
                        case BRANCH:               
                               switch(rt_i) {                                                                   // Switch case for branch where REGIMM value is 00001
                                     case BLTZ:  
                                              if((int32_t)CURRENT_STATE.REGS[rs_i] < 0) {
		                                  NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2)  ;
		                              } 
                                  		print_values(instruction); 
                                              break;
                                     case BGEZ:
                                              if((int32_t)CURRENT_STATE.REGS[rs_i] >= 0) {
		                                  NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2);
		                              } 
                                              print_values(instruction); 
                                              break;
                                     case BLTZAL:
                                              if((int32_t)CURRENT_STATE.REGS[rs_i] < 0) {
		                                  NEXT_STATE.REGS[31] = CURRENT_STATE.PC + 4;
		                                  NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2) ;
                                              } 
                                   	        print_values(instruction); 
                                              break;
                                      case BGEZAL:
                                              if((int32_t)CURRENT_STATE.REGS[rs_i] >= 0) {
                                                  NEXT_STATE.REGS[31] = CURRENT_STATE.PC + 4;
		                                  NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2);
		                              }
		                              print_values(instruction); 
                                              break;
                                } 
                        case BEQ:
                                    if(CURRENT_STATE.REGS[rs_i] == CURRENT_STATE.REGS[rt_i]) 
		                         NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2) ;
	                            print_values(instruction); 
                                    break;
                        case BNE:
                                    if(CURRENT_STATE.REGS[rs_i] != CURRENT_STATE.REGS[rt_i]) {
                                        NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2);
	                            }
	                            print_values(instruction); 
                                    break;
                        case BLEZ:
                                    if((int32_t)CURRENT_STATE.REGS[rs_i] <= 0) {
		                        NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2);
                          	    }
                          	    print_values(instruction); 
                                    break;
                        case BGTZ:
                                    if((uint32_t)CURRENT_STATE.REGS[rs_i] > 0) {
		                        NEXT_STATE.PC = CURRENT_STATE.PC + (((int16_t)immediate)<<2)  ;
		                    }
		                    print_values(instruction); 
                                    break;
                        case LUI:
                                    NEXT_STATE.REGS[rt_i] = (immediate << 16) & 0xffff0000;
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);
	                            print_values(instruction); 
                                    break;
                        case LW:
                                    NEXT_STATE.REGS[rt_i] = mem_read_32(CURRENT_STATE.REGS[rs_i] + (int16_t)immediate);
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4); 
	                            print_values(instruction); 
                                    break;
                        case SW:
                                    mem_write_32(CURRENT_STATE.REGS[rs_i]+(int16_t)immediate,CURRENT_STATE.REGS[rt_i]);
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);
	                            print_values(instruction); 
                                    break;
                        case LB:
                                    NEXT_STATE.REGS[rt_i] = (int8_t)(mem_read_32(CURRENT_STATE.REGS[rs_i] + (int16_t)immediate) & 0xFF);
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);
	                            print_values(instruction); 
                                    break;
                        case LBU:
                                    NEXT_STATE.REGS[rt_i] = (uint8_t)mem_read_32(CURRENT_STATE.REGS[rs_i] + (int16_t)immediate) & 0xFF;
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);	
                                    print_values(instruction); 
                                    break;
                        case LH:
                                    NEXT_STATE.REGS[rt_i] = (int16_t)(mem_read_32(CURRENT_STATE.REGS[rs_i] + (int16_t)immediate) & 0xFFFF);
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);
                                    print_values(instruction); 
                                    break;
                        case LHU:
                                    NEXT_STATE.REGS[rt_i] = (int16_t)mem_read_32(CURRENT_STATE.REGS[rs_i] + (int16_t)immediate) & 0xFFFF;
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);
	                            print_values(instruction); 
                                    break;
                        case SB:
                                    mem_write_32((uint32_t)(CURRENT_STATE.REGS[rs_i]+(int16_t)immediate),((int8_t)CURRENT_STATE.REGS[rt_i]&0xffff));
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);
	                            print_values(instruction); 
                                    break;
                        case SH:
                                    mem_write_32((CURRENT_STATE.REGS[rs_i]+(int16_t)immediate),((int8_t)CURRENT_STATE.REGS[rt_i]&0xffff));
	                            NEXT_STATE.PC = CURRENT_STATE.PC + (4);
	                            print_values(instruction); 
                                    break;
                        default:
                                    printf("Unknown R-type instruction\n");
                                    break;
                        }
          break;
                                  
     case J_TYPE:                 
                switch(opcode) {  // Switch case for jump type used target to jump to target and register 31
                      case J:
                            NEXT_STATE.PC = (CURRENT_STATE.PC & 0xF0000000) | (target << 2);
                            print_values(instruction);  
                            break;
                      case JAL:
                            print_values(instruction);
                            NEXT_STATE.REGS[31] = CURRENT_STATE.PC + 4;                     //  Store address of current instruction tp jump back when jr is called
                            NEXT_STATE.PC = (CURRENT_STATE.PC & 0xF0000000) | (target << 2);
                            print_values(instruction);  
                            break;
                      default:
                          printf("Unknown J-type instruction\n");
                          break;
                }
            break;
    default:
              printf("Unknown instruction type\n");
              break;
    }

}
