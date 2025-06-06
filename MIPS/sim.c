/*
uint32_t logicalshiftright_i(uint32_t instruction, int shiftamt){
	instruction = instruction >> 1;
	uint32_t mask = 0x7fffffff;
	instruction &= mask;
	instruction = instruction >> shiftamt-1;
	return instruction;
}

//extracts the value of the RS field bits (bits 21-25)
uint8_t RS_FIELD(uint32_t instruction){
	instruction = instruction << 6;
	instruction = logicalshiftright_i(instruction, 27);
	return (uint8_t) instruction;
}

//extracts the value of the RT field bits (bits 16-20)
uint8_t RT_FIELD(uint32_t instruction){
	instruction = instruction << 11;
	instruction = logicalshiftright_i(instruction, 27);
	return (uint8_t) instruction;
}

//extracts the value of the immediate field bits
uint16_t IMM_FIELD(uint32_t instruction){
	instruction = instruction << 16;
	instruction = logicalshiftright_i(instruction, 16);
	return (uint16_t) instruction;
}

uint32_t logicalshiftright(uint32_t instruction, int shiftamt){
	instruction = instruction >> 1;
	uint32_t mask = 0x7fffffff;
	instruction &= mask;
	instruction = instruction >> shiftamt-1;
	return instruction;
}

uint8_t ADDR_FIELD(uint32_t instruction){
	instruction = instruction << 6;
	instruction = logicalshiftright(instruction, 6);
	return (uint8_t) instruction;
}

void j(uint32_t instruction){
	uint32_t address = ADDR_FIELD(instruction);
	NEXT_STATE.PC = (uint32_t) ((CURRENT_STATE.PC + 0x00000004) & 0xf0000000) | (address << 2);
}

void jal(uint32_t instruction){
	uint32_t address = ADDR_FIELD(instruction);
	CURRENT_STATE.REGS[31] = (uint32_t)(CURRENT_STATE.PC + 0x00000004);
	NEXT_STATE.PC = (uint32_t) ((CURRENT_STATE.PC + 0x00000004) & 0xf0000000) | (address << 2);
}

//Extracts the value of the RS field bits (bits 21-25)
uint8_t RS_FIELD(uint32_t instruction){
	instruction = instruction << 6;
	instruction = logicalshiftright(instruction, 27);
	return (uint8_t) instruction;
}

//extracts the value of the RT field bits (bits 16-20)
uint8_t RT_FIELD(uint32_t instruction){
	instruction = instruction << 11;
	instruction = logicalshiftright(instruction, 27);
	return (uint8_t) instruction;
}

//extracts the value of the RD field bits (bits 11-15)
uint8_t RD_FIELD(uint32_t instruction){
	instruction = instruction << 16;
	instruction = logicalshiftright(instruction, 27);
	return (uint8_t) instruction;
}

//extracts the value of the shamt field bits
uint8_t SHAMT_FIELD(uint32_t instruction){
	instruction = instruction << 21;
	instruction = logicalshiftright(instruction, 27);
	return (uint8_t) instruction;
}

void jr(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	NEXT_STATE.PC = (uint32_t) CURRENT_STATE.REGS[rs];
}

void jalr(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	CURRENT_STATE.REGS[31] = (uint32_t) (CURRENT_STATE.PC + (uint32_t) 0x00000004);
	NEXT_STATE.PC = (uint32_t) CURRENT_STATE.REGS[rs];
}

void mfhi(uint32_t instruction){
	uint8_t rd = RD_FIELD(instruction);
	NEXT_STATE.REGS[rd] = (uint32_t) CURRENT_STATE.HI;
}

void mflo(uint32_t instruction){
	uint8_t rd = RD_FIELD(instruction);
	NEXT_STATE.REGS[rd] = (uint32_t) CURRENT_STATE.LO;
}
*/

//int32_t sign_extend(uint32_t val){
//	return ((int32_t) val << 32) >> 32;
//}

/*
int32_t sign_extend_8(uint8_t immediate){
	return ((int32_t) immediate << 24) >> 24;
}

uint32_t zero_extend(uint16_t immediate){
	return ((uint32_t) immediate << 16) >> 16;
}

uint32_t zero_extend_8(uint8_t immediate){
	return ((uint32_t) immediate << 24) >> 24;
}


void addi(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) ((int32_t) CURRENT_STATE.REGS[rs] + (int32_t) sign_extend(imm)); 
                    
}

void addiu(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm));
                    
}

void andi(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] & (uint32_t) zero_extend(imm));            
}

void ori(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] | (uint32_t) zero_extend(imm));            
}

void xori(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] ^ (uint32_t) zero_extend(imm));            
}

void slti(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        if((int32_t) CURRENT_STATE.REGS[rs] < (int32_t) sign_extend(imm)){
            CURRENT_STATE.REGS[rt] = (uint32_t) 0x00000001;                    
        } else {
            CURRENT_STATE.REGS[rt] = (uint32_t) 0x00000000;
        }        
}

void sltiu(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        if((uint32_t) CURRENT_STATE.REGS[rs] < (uint32_t) sign_extend(imm)){
            CURRENT_STATE.REGS[rt] = (uint32_t) 0x00000001;                    
        } else {
            CURRENT_STATE.REGS[rt] = (uint32_t) 0x00000000;               
                }
}

void beq(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        if((uint32_t) CURRENT_STATE.REGS[rs] == (uint32_t) CURRENT_STATE.REGS[rt]){
            NEXT_STATE.PC = pc + (uint32_t) 0x00000004 + (uint32_t) (sign_extend(imm) << 2);                    
                }
}

void bne(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        if((uint32_t) CURRENT_STATE.REGS[rs] != (uint32_t) CURRENT_STATE.REGS[rt]){
            NEXT_STATE.PC = pc + (uint32_t) 0x00000004 + (uint32_t) (sign_extend(imm) << 2);                    
                }
}

void lb(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) sign_extend_8(memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))]); 
                    
}

void lbu(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) zero_extend_8(memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))]); 
                    
}

void lh(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        uint16_t * temp = (uint16_t *) &memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))];
        CURRENT_STATE.REGS[rt] = (uint32_t) sign_extend((uint16_t) *temp);
                        
}

void lhu(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        uint16_t * temp = (uint16_t *) &memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))];     
        CURRENT_STATE.REGS[rt] = (uint32_t) zero_extend((uint16_t) *temp);
                        
}

void lw(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        uint32_t * temp = (uint32_t *) &memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))];
        CURRENT_STATE.REGS[rt] = (uint32_t) *temp;                        
}

void lui(uint32_t instruction){
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        CURRENT_STATE.REGS[rt] = (uint32_t) (imm << 16);
                
}

void sb(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))] = (uint8_t) CURRENT_STATE.REGS[rt];            
}

void sh(uint32_t instruction){
        uint32_t rs = RS_FIELD(instruction);
        uint32_t rt = RT_FIELD(instruction);
        uint16_t imm = IMM_FIELD(instruction);
        uint16_t * mlocation = (uint16_t *) &memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))];
        *mlocation = (uint16_t) CURRENT_STATE.REGS[rt];
                        
}

void sw(uint32_t instruction){
       uint32_t rs = RS_FIELD(instruction);
       uint32_t rt = RT_FIELD(instruction);
       uint16_t imm = IMM_FIELD(instruction);
       uint32_t * mlocation = (uint32_t *) &memory[(CURRENT_STATE.REGS[rs] + (uint32_t) sign_extend(imm))];
       *mlocation = (uint32_t) CURRENT_STATE.REGS[rt];
                        
}

uint8_t SHAMT_FIELD(uint32_t instruction){
       instruction = instruction << 21;
       instruction = logicalshiftright(instruction, 27);
       return (uint8_t) instruction;
                
}

void add(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	//printf("In add function\n");
	CURRENT_STATE.REGS[rd] = (uint32_t) ((int32_t) CURRENT_STATE.REGS[rs] + (int32_t) CURRENT_STATE.REGS[rt]);
}

void addu(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	//printf("In addu function\n");
	CURRENT_STATE.REGS[rd] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] + (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void sub(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((int32_t) CURRENT_STATE.REGS[rs] - (int32_t) CURRENT_STATE.REGS[rt]);
} 

void subu(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] - (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void mult(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	//printf("In mult function\n");
	int64_t result = (int64_t)((int32_t) CURRENT_STATE.REGS[rs]) * (int64_t)((int32_t) CURRENT_STATE.REGS[rt]);
	LO = (uint32_t) result;
	//HI = (uint32_t) logicalShiftRight(result, 32);
	HI = (uint32_t) (result >> 32);
} 

void multu(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint64_t result = (uint64_t) CURRENT_STATE.REGS[rs] * (uint64_t) CURRENT_STATE.REGS[rt]; 
	NEXT_STATE.LO = (uint32_t) result;
	NEXT_STATE.HI = (uint32_t) logicalshiftright(result, 32);
} 

void div(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	NEXT_STATE.LO = (uint32_t)((int32_t)CURRENT_STATE.REGS[rs] / (int32_t)CURRENT_STATE.REGS[rt]);
	NEXT_STATE.HI = (uint32_t)((int32_t)CURRENT_STATE.REGS[rs] % (int32_t)CURRENT_STATE.REGS[rt]);
} 

void divu(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	NEXT_STATE.LO = (uint32_t) ((uint32_t)CURRENT_STATE.REGS[rs] / (uint32_t)CURRENT_STATE.REGS[rt]);
	NEXT_STATE.HI = (uint32_t) ((uint32_t)CURRENT_STATE.REGS[rs] % (uint32_t)CURRENT_STATE.REGS[rt]);
} 

void and(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] & (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void nor(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ~((uint32_t) CURRENT_STATE.REGS[rs] | (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void or(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] | (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void xor(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] ^ (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void sll(uint32_t instruction){
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	uint8_t shamt = SHAMT_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rt] << shamt);
} 

void sllv(uint32_t instruction){
	uint8_t rs = RT_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((uint32_t) CURRENT_STATE.REGS[rs] << (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void srl(uint32_t instruction){
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	uint8_t shamt = SHAMT_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) logicalShiftRight((uint32_t) CURRENT_STATE.REGS[rt], shamt);
} 

void sra(uint32_t instruction){
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	uint8_t shamt = SHAMT_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((int32_t) CURRENT_STATE.REGS[rt] >> shamt);
} 

void srlv(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) logicalShiftRight((uint32_t) CURRENT_STATE.REGS[rs], CURRENT_STATE.REGS[rt]);
} 

void srav(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	CURRENT_STATE.REGS[rd] = (uint32_t) ((int32_t) CURRENT_STATE.REGS[rs] >> (uint32_t) CURRENT_STATE.REGS[rt]);
} 

void slt(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	if((int32_t) CURRENT_STATE.REGS[rs] < (int32_t) CURRENT_STATE.REGS[rt]){
		CURRENT_STATE.REGS[rd] = (uint32_t) 0x00000001;
	}
	else {
		CURRENT_STATE.REGS[rd] = (uint32_t) 0x00000000;
	}
} 

void sltu(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	uint8_t rt = RT_FIELD(instruction);
	uint8_t rd = RD_FIELD(instruction);
	if((uint32_t) CURRENT_STATE.REGS[rs] < (uint32_t) CURRENT_STATE.REGS[rt]){
		NEXT_STATE.REGS[rd] = (uint32_t) 0x00000001;
	}
	else {
		NEXT_STATE.REGS[rd] = (uint32_t) 0x00000000;
	}
} 

void jr(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	//printf("In jr procedure\n");
	NEXT_STATE.PC = (uint32_t) CURRENT_STATE.REGS[rs];
} 

void jalr(uint32_t instruction){
	uint8_t rs = RS_FIELD(instruction);
	CURRENT_STATE.REGS[31] = (uint32_t)(CURRENT_STATE.PC + (uint32_t) 0x00000004);
	//printf("In jalr procedure\n");
	NEXT_STATE.PC = (uint32_t) CURRENT_STATE.REGS[rs];
} 

void mfhi(uint32_t instruction){
	uint8_t rd = RD_FIELD(instruction);
	NEXT_STATE.REGS[rd] = (uint32_t)CURRENT_STATE.HI;
} 

void mflo(uint32_t instruction){
	uint8_t rd = RD_FIELD(instruction);
	NEXT_STATE.REGS[rd] = (uint32_t)CURRENT_STATE.LO;
} 


*/
