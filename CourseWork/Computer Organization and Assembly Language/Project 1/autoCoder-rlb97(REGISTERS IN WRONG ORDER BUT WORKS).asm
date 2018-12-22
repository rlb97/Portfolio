.data
welcome: .asciiz "Welcome to Auto Coder!\n"
opcodes: .asciiz "The opcode (1-9 : 1=add, 2=addi, 3=or, 4=ori, 5=lw, 6=sw, 7=j, 8=beq, 9=bne)\n"
please1: .asciiz "Please enter the 1st opcode: "
please2: .asciiz "Please enter the 2nd opcode: "
please3: .asciiz "Please enter the 3rd opcode: "
please4: .asciiz "Please enter the 4th opcode: "
please5: .asciiz "Please enter the 5th opcode: "
newLine: .asciiz "\n"
noLabelSpace: .asciiz "       " ### 7 spaces
zerox: .asciiz "     0x"
comma: .asciiz ", "
leftP: .asciiz "("
rightP: .asciiz ")"
line100: .asciiz "L100:  "
jumpLine100: .asciiz "L100"	### Is used when need to attach to end of J/BEQ/BNE
line101: .asciiz "L101:  "
jumpLine101: .asciiz "L101"
line102: .asciiz "L102:  "
jumpLine102: .asciiz "L102"
line103: .asciiz "L103:  "
jumpLine103: .asciiz "L103"
line104: .asciiz "L104:  "
jumpLine104: .asciiz "L104"
completed: .asciiz "\n\nThe completed code is\n"
opAdd: .asciiz "add "
opAddi: .asciiz "addi "
opOr: .asciiz "or "
opOri: .asciiz "ori "
opLw: .asciiz "lw "
opSw: .asciiz "sw "
opJ: .asciiz "j "
opBeq: .asciiz "beq "
opBne: .asciiz "bne "
opT0: .asciiz "$t0"
opT1: .asciiz "$t1"
opT2: .asciiz "$t2"
opT3: .asciiz "$t3"
opT4: .asciiz "$t4"
opT5: .asciiz "$t5"
opT6: .asciiz "$t6"
opT7: .asciiz "$t7"
opT8: .asciiz "$t8"
opT9: .asciiz "$t9"
machineCode: .asciiz "The machine code is\n"
.align 2
instruction1: .space 32 #Will encode as we go
instruction2: .space 32
instruction3: .space 32
instruction4: .space 32
instruction5: .space 32
finishedString: .space 128

.text
### Step 1: Print out and recieve opcodes [save opcodes to stack]
addi $v0, $zero, 4
la $a0, welcome
syscall
addi $v0, $zero, 4
la $a0, opcodes
syscall
addi $v0, $zero, 4
la $a0, please1
syscall
addi $v0, $zero, 5	### Read in Opcode 1
syscall
addi $sp, $sp, -4
sb $v0, 0($sp)		### Transfer opcode 1 to 0(sp)
addi $v0, $zero, 4
la $a0, please2
syscall
addi $v0, $zero, 5	### Read in Opcode 2
syscall
addi $sp, $sp, -1
sb $v0, 0($sp)		### Opcode 2 = -1(sp)
addi $v0, $zero, 4
la $a0, please3
syscall
addi $v0, $zero, 5	### Read in Opcode 3	
syscall
addi $sp, $sp, -1
sb $v0, 0($sp)		### Opcode 3 = -2(sp)
addi $v0, $zero, 4
la $a0, please4
syscall
addi $v0, $zero, 5	### Read in Opcode 4
syscall
addi $sp, $sp, -1
sb $v0, 0($sp)		### Opcode 4 = -3(sp)
addi $v0, $zero, 4
la $a0, please5
syscall
addi $v0, $zero, 5	### Read in Opcode 5
syscall
addi $sp, $sp, -1	
sb $v0, 0($sp)		### Opcode 5 = -4(sp)
addi $sp, $sp, 4	### Reset stack pointer to the first opcode (sub 1 per iteration)

### Print Display
addi $v0, $zero, 4
la $a0, completed
syscall

mainLoop:
	addi $t1, $zero, 0x00000000	### Reset our encoding
	addi $t9, $t9, 1    	### T9 keeps track of our total iteration / which opcode we're on
	beq $t9, 6, displayMachine
	lb $t5, 0($sp)	    	### T5 holds our opcode instruction
	addi $sp, $sp, -1
	lb $s0, 0($sp)
	checkLabel:		### Is our next instruction going to require us to branch/jump to our current instruction?
		jal checkLabel2	
	beq $t5, 1, bAdd		### 1=add, 2=addi, 3=or, 4=ori, 5=lw, 6=sw, 7=j, 8=beq, 9=bne
	beq $t5, 2, bAddi
	beq $t5, 3, bOr
	beq $t5, 4, bOri
	beq $t5, 5, bLw
	beq $t5, 6, bSw
	beq $t5, 7, bJ
	beq $t5, 8, bBeq
	beq $t5, 9, bBne
	### End of valid inputs	

displayMachine:	### Loop through all five allocated instruction spaces and print out the corresponding hexadecimal instruction. Yes, this is brute force, i have no idea how to otherwise do this.
	addi $t9, $zero, 0	###Incrementor, once we reach 6 we're done	
	addi $t8, $zero, 0	### T8 will now hold the byte extracted from T0
	#addi $t7, $zero, 0xfffffff0 ###Use to isolate the first byte [want to xor with 0xfffffff0]
	#addi $t6, $zero, 0xffffff0f ### Use to isolate the second byte [want to xor with 0xffffff0f] WANT TO PRINT THIS ONE FIRST TO PRESERVER ORDERING
	addi $t4, $zero, 0
	### Some whitespace formatting
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	addi $v0, $zero, 4
	la $a0, machineCode
	syscall
	primaryLoop:
		addi $t5, $zero, 4
		addi $t9, $t9, 1
		jal checkNewLine	### For formatting sakes
		beq $t9, 6, exit
		### Print 0x
		addi $v0, $zero, 4
		la $a0, zerox
		syscall
		jal getMachineInstruction	### $t0 will now be holding address to the location in memory
		secondaryLoop:
			addi $t5, $t5, -1	### Decrement our position
			beq $t5, -1, primaryLoop
			add $t4, $t0, $t5	### t4 will hold where we load from
			lbu $t3, 0($t4)		### t3 holds 0x000000XX
			andi $t2, $t3, 0x0000000f ###$t2 now holds the isolated 2nd bit
			andi $t1, $t3, 0x000000f0 ####$t1 now holds the isolated 1st bit	PRINT THIS ONE FIRST
			### Determine which value it is and print it out
			jal findCharacter1
			jal findCharacter2
			j secondaryLoop
exit:
	addi $v0, $zero, 10
	syscall
	
###PROCEDURE CODE
checkNewLine:
	bne $t9, 1, printNewLine
	jr $ra
printNewLine:
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	jr $ra

findCharacter1:
	beq $t1, 0x00, print0
	beq $t1, 0x10, print1
	beq $t1, 0x20, print2
	beq $t1, 0x30, print3
	beq $t1, 0x40, print4
	beq $t1, 0x50, print5
	beq $t1, 0x60, print6
	beq $t1, 0x70, print7
	beq $t1, 0x80, print8
	beq $t1, 0x90, print9
	beq $t1, 0xA0, printA
	beq $t1, 0xB0, printB
	beq $t1, 0xC0, printC
	beq $t1, 0xD0, printD
	beq $t1, 0xE0, printE
	beq $t1, 0xF0, printF
findCharacter2:
	beq $t2, 0x0, print0
	beq $t2, 0x1, print1
	beq $t2, 0x2, print2
	beq $t2, 0x3, print3
	beq $t2, 0x4, print4
	beq $t2, 0x5, print5
	beq $t2, 0x6, print6
	beq $t2, 0x7, print7
	beq $t2, 0x8, print8
	beq $t2, 0x9, print9
	beq $t2, 0xA, printA
	beq $t2, 0xB, printB
	beq $t2, 0xC, printC
	beq $t2, 0xD, printD
	beq $t2, 0xE, printE
	beq $t2, 0xF, printF
print0:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x30
	syscall
	jr $ra
print1:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x31
	syscall
	jr $ra
print2:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x32
	syscall
	jr $ra
print3:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x33
	syscall
	jr $ra
print4:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x34
	syscall
	jr $ra
print5:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x35
	syscall
	jr $ra
print6:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x36
	syscall
	jr $ra
print7:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x37
	syscall
	jr $ra
print8:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x38
	syscall
	jr $ra
print9:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x39
	syscall
	jr $ra
printA:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x41
	syscall
	jr $ra
printB:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x42
	syscall
	jr $ra
printC:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x43
	syscall
	jr $ra
printD:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x44
	syscall
	jr $ra
printE:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x45
	syscall
	jr $ra
printF:
	addi $v0, $zero, 11
	addi $a0, $zero, 0x46
	syscall
	jr $ra
	
checkLabel2:	### Do we need to add a label to this instruction?
	beq $s0, 7, addLabel
	beq $s0, 8, addLabel
	beq $s0, 9, addLabel	
	j noLabel
	
addLabel:	### Add a label to this instruction
	beq $t9, 1, addLabel100
	beq $t9, 2, addLabel101
	beq $t9, 3, addLabel102
	beq $t9, 4, addLabel103
	beq $t9, 5, addLabel104
	
addLabel100:	### Since our next instruction will be jumping/branching to our current instruction, we need to give it a label
	addi $v0, $zero, 4
	la $a0, line100
	syscall
	jr $ra
addLabel101:
	addi $v0, $zero, 4
	la $a0, line101
	syscall
	jr $ra
addLabel102:
	addi $v0, $zero, 4
	la $a0, line102
	syscall
	jr $ra
addLabel103:
	addi $v0, $zero, 4
	la $a0, line103
	syscall
	jr $ra
addLabel104:
	addi $v0, $zero, 4
	la $a0, line104
	syscall
	jr $ra
noLabel:
	addi $v0, $zero, 4
	la $a0, noLabelSpace
	syscall
	jr $ra
	
getMachineInstruction:		### which instruction are we encoding?
	beq $t9, 1, getMachineInstruction1
	beq $t9, 2, getMachineInstruction2
	beq $t9, 3, getMachineInstruction3
	beq $t9, 4, getMachineInstruction4
	beq $t9, 5, getMachineInstruction5
getMachineInstruction1:
	la $t0, instruction1	### We will save our binary-to-encode to instruction1
	jr $ra
getMachineInstruction2:
	la $t0, instruction2
	jr $ra
getMachineInstruction3:
	la $t0, instruction3
	jr $ra
getMachineInstruction4:
	la $t0, instruction4
	jr $ra
getMachineInstruction5:
	la $t0, instruction5
	jr $ra
	
bAdd:	###R-type instruction
	jal getMachineInstruction
	bne $t8, 0, bAddLink	### T8 holds whether we have to link the previous destination register as a source register [1=yes, 2=no]
	### Print add
	addi $v0, $zero, 4
	la $a0, opAdd
	syscall
	### Encode add opcode and funct
	addi $t1, $t1, 0x00000000	###opcode 
	addi $t1, $t1, 0x00000020	###funct code
	### Print destination register
	jal addRegister
	jal encodeRegisterRD	### must encode an r-type destination register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t7, 0	### save our destination register in case we need to link it to a source register
	addi $t7, $t7, 1	### We are now on 1 register higher
	### Print source register
	jal addRegister
	jal encodeRegisterRS	### We must encode an r-type source register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t7, $t7, 1	### Increment register number
	### Print target register
	jal addRegister
	jal encodeRegisterRT
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	addi $t7, $t7, 1
	### We will link registers after this
	addi $t8, $zero, 1
	sw $t1, ($t0)
	j mainLoop
bAddLink:
	jal getMachineInstruction
	### Print add
	addi $v0, $zero, 4
	la $a0, opAdd
	syscall
	### Encode add opcode and funct
	addi $t1, $t1, 0x00000000	###opcode 
	addi $t1, $t1, 0x00000020	###funct code
	### Print destination register
	jal addRegister
	jal encodeRegisterRD
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t3, $t7, 0	### save our destination register for future link (MUST move this to $t4 before ending addLink)
	addi $t7, $t7, 1	### Increment to next register
	### Print source register (Linked)
	jal addRegisterLinked
	jal encodeRegisterRSLinked
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t3, 0	### Register we used as destination will now be linked to source
	### Print target register
	jal addRegister
	jal encodeRegisterRT
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	addi $t7, $t7, 1
	### We will link registers after this
	addi $t8, $zero, 1
	sw $t1, 0($t0)	### save our binary encoding
	j mainLoop

bAddi:	###I-type instruction
	jal getMachineInstruction
	bne $t8, 0, bAddiLink
	### Print addi
	addi $v0, $zero, 4
	la $a0, opAddi
	syscall
	###Encode addi opcode
	addi $t1, $t1, 0x20000000	### Opcode
	### Print destination register
	jal encodeRegisterID
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t7, 0 ### Save our destination register in case link for source
	addi $t7, $t7, 1 ### Increment register +1
	### Print source register
	jal encodeRegisterIS
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t7, $t7, 1 ### Increment register
	### Print constant [#t6 holds constant value X]
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1 ### increment our X value
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will link registers after this
	addi $t8, $zero, 1
	sw $t1, 0($t0) ###Save our binary encoding of the instruction
	j mainLoop
bAddiLink:
	jal getMachineInstruction
	### Print addi
	addi $v0, $zero, 4
	la $a0, opAddi
	syscall
	###Encode addi opcode
	addi $t1, $t1, 0x20000000	### Opcode
	### Print destination register
	jal encodeRegisterID
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t3, $t7, 0 	### Save our destination in case of link (MUST move to $t4)
	addi $t7, $t7, 1
	### Print source register (LINKED)
	jal encodeRegisterISLinked
	jal addRegisterLinked
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t3, 0 	### Update the register to be linked
	### Print constant
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1	### Increment our X value
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will link registers after this
	addi $t8, $zero, 1
	sw $t1, 0($t0)		### Save our encoding of the instruction
	j mainLoop
	
bOr:	###R-type instruction
	jal getMachineInstruction
	bne $t8, 0, bOrLink
	### Print or
	addi $v0, $zero, 4
	la $a0, opOr
	syscall
	### Encode Or opcode/funct
	addi $t1, $t1, 0x00000000	### Opcode
	addi $t1, $t1, 0x00000025	### Funct
	### Print destination register
	jal encodeRegisterRD
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t7, 0 ### Save our destination register to be linked as source
	addi $t7, $t7, 1 ### Increment next register to use
	### Print source register
	jal encodeRegisterRS
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t7, $t7, 1	### Increment future register to use
	### Print Target register
	jal encodeRegisterRT
	jal addRegister
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	addi $t7, $t7, 1
	### We will link registers after this
	addi $t8, $zero, 1
	sw $t1, 0($t0)	### Save our encoded instruction
	j mainLoop
bOrLink:
	jal getMachineInstruction
	### Print or
	addi $v0, $zero, 4
	la $a0, opOr
	syscall
	### Encode Or opcode/funct
	addi $t1, $t1, 0x00000000	### Opcode
	addi $t1, $t1, 0x00000025	### Funct
	### Print destination register
	jal encodeRegisterRD
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t3, $t7, 0 ### Save destination register for future link (MUST BE MOVED TO $T4)
	addi $t7, $t7, 1
	### Print source register (LINKED)
	jal encodeRegisterRSLinked
	jal addRegisterLinked
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t3, 0 ### Update our destination register for Link
	### Print Target register
	jal encodeRegisterRT
	jal addRegister
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	addi $t7, $t7, 1	### increment register to use
	### We will link registers
	addi $t8, $zero, 1
	sw $t1, 0($t0)
	j mainLoop
	
bOri:	### I-Type
	jal getMachineInstruction
	bne $t8, 0, bOriLink
	### Print ori
	addi $v0, $zero, 4
	la $a0, opOri
	syscall
	### Encode Ori opcode/funct
	addi $t1, $t1, 0x34000000	### Opcode
	### Print destination register
	jal encodeRegisterID
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t7, 0	### Update our destination register for future link
	addi $t7, $t7, 1	### Increment future to use register
	### Print source register
	jal encodeRegisterIS
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t7, $t7, 1	### Increment to ue register
	### Print immediate ($t6 holds X)
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1	### Increment X constant
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will Linked after this
	addi $t8, $zero, 1
	sw $t1, 0($t0)		### Save our encoded instruction
	j mainLoop
bOriLink:
	jal getMachineInstruction
	### Print ori
	addi $v0, $zero, 4
	la $a0, opOri
	syscall
	### Encode Ori opcode/funct
	addi $t1, $t1, 0x34000000	### Opcode
	### Print destinaion register
	jal encodeRegisterID
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t3, $t7, 0 	### Save destination register for future link (MUST be moved to $t4)
	addi $t7, $t7, 1
	### Print source register (LINKED)
	jal encodeRegisterISLinked
	jal addRegisterLinked
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t3, 0	### move linked register to $t4
	### Print immediate/constant
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1	### Increment X register
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will link after this
	addi $t8, $zero, 1
	sw $t1, 0($t0)		### Save our encoded instruction
	j mainLoop
	
bLw:	###I-type
	jal getMachineInstruction
	bne $t8, 0, bLwLink
	###Print lw
	addi $v0, $zero, 4
	la $a0, opLw
	syscall
	### Encode Lw opcode
	addi $t1, $t1, 0x8C000000	### Opcode
	### Print destination register
	jal encodeRegisterID
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t4, $t7, 0	### save destination register for future use
	addi $t7, $t7, 1	### increment to use register
	### print immediate offset
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1	### increment X register
	### print source register *($Tx)
	jal encodeRegisterIS
	addi $v0, $zero, 4
	la $a0, leftP
	syscall
	jal addRegister
	addi $v0, $zero, 4
	la $a0, rightP
	syscall
	addi $t7, $t7, 1	### Increment to use register
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will link this destination in the future
	addi $t8, $zero, 1
	sw $t1, 0($t0)	### Save our encoded instruction
	j mainLoop
bLwLink:
	jal getMachineInstruction
	### print lw
	addi $v0, $zero, 4
	la $a0, opLw
	syscall
	### Encode Lw opcode
	addi $t1, $t1, 0x8C000000	### Opcode
	### Print destination register
	jal encodeRegisterID
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t3, $t7, 0	### Saving destination register for future link (MUST move to #t4)
	addi $t7, $t7, 1	### Incrementing register
	### Print immediate / offset
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1	### Increment X register
	### Print source register (LINKED)
	jal encodeRegisterISLinked
	addi $v0, $zero, 4
	la $a0, leftP
	syscall
	jal addRegisterLinked
	addi $t4, $t3, 0 	### Move destination register to $t4
	addi $v0, $zero, 4
	la $a0, rightP
	syscall
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will link destination in future
	addi $t8, $zero, 1
	sw $t1, 0($t0)	### save our encoded instruction
	j mainLoop
	
bSw:	### I-type
	jal getMachineInstruction
	bne $t8, 0, bSwLink
	### Print Sw
	addi $v0, $zero, 4
	la $a0, opSw
	syscall
	### Encode Sw opcode
	addi $t1, $t1, 0xAC000000	### Opcode
	### Print source register
	jal encodeRegisterIS
	jal addRegister
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	addi $t7, $t7, 1 	### Increment future register
	###  Print Immediate / Offset
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1	### Increment X register
	### Print destination register
	jal encodeRegisterID
	addi $v0, $zero, 4
	la $a0, leftP
	syscall
	jal addRegister
	addi $t4, $t7, 0	### Save destination register for future link
	addi $t7, $t7, 1	### Increment to use register
	addi $v0, $zero, 4
	la $a0, rightP
	syscall
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will be linking destination
	addi $t8, $zero, 1
	sw $t1, 0($t0)	### Save our encoded instruction
	j mainLoop
bSwLink:	### I-type
	jal getMachineInstruction
	### Print sw
	addi $v0, $zero, 4
	la $a0, opSw
	syscall
	### Encode Sw opcode
	addi $t1, $t1, 0xAC000000	### Opcode
	### Print source register (LINKED)
	jal encodeRegisterISLinked
	jal addRegisterLinked
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print immediate / offset
	jal encodeImmediate
	addi $v0, $zero, 1
	addi $a0, $t6, 100
	syscall
	addi $t6, $t6, 1	### Increment X register
	### print destination Register
	jal encodeRegisterID
	addi $v0, $zero, 4
	la $a0, leftP
	syscall
	jal addRegister
	addi $t4, $t7, 0	### Must save destination register for future link
	addi $t7, $t7, 1	### must increment future to use register
	addi $v0, $zero, 4
	la $a0, rightP
	syscall
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will use this destination for future link
	addi $t8, $zero, 1
	sw $t1, 0($t0)	### Save our encoded instruction
	j mainLoop

bJ:	###J-type
	jal getMachineInstruction
	### Print j
	addi $v0, $zero, 4
	la $a0, opJ
	syscall
	### Encode J opcode
	addi $t1, $t1, 0x08000000	### Opcode
	### Print label
	jal encodeAddress
	addi $s1, $t9, 0	### Save the $t9 register state
	addi $t9, $t9, -1	### decrement $t9 by 1 so we can use already made procedure addLabel
	jal addJumpLabel
	add $t9, $zero, $s1	### restore $t9
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We will not be linking anything here (BREAKS CHAIN)
	addi $t8, $zero, 0
	sw $t1, 0($t0)		### Save our encoded instruction
	j mainLoop
	
bBeq:	###I type
	jal getMachineInstruction
	bne $t8, 0, bBeqLink
	### Print beq
	addi $v0, $zero, 4
	la $a0, opBeq
	syscall
	### Encode beq opcode
	addi $t1, $t1, 0x10000000	### Opcode
	### Print first source
	jal encodeRegisterIS
	jal addRegister
	addi $t7, $t7, 1	### Increment future to use register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print target source
	jal encodeRegisterID
	jal addRegister
	addi $t7, $t7, 1	### Increment future to use register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print label
	jal encodeBranchAddress
	addi $s1, $t9, 0	### Save the $t9 register state
	addi $t9, $t9, -1	### decrement $t9 by 1 so we can use already made procedure addlabel
	jal addJumpLabel
	add $t9, $zero, $s1	### restore $t9
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We have no destination register to link
	addi $t8, $zero, 0
	sw $t1, 0($t0)
	j mainLoop
bBeqLink:
	jal getMachineInstruction
	### Print beq
	addi $v0, $zero, 4
	la $a0, opBeq
	syscall
	### Encode beq opcode
	addi $t1, $t1, 0x10000000 ### Opcode
	### Print first source register (LINKED)
	jal encodeRegisterISLinked
	jal addRegisterLinked
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print second source register
	jal encodeRegisterID
	jal addRegister
	addi $t7, $t7, 1	### Increment future to use register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print label
	jal encodeBranchAddress
	addi $s1, $t9, 0	### Save the $t9 register state
	addi $t9, $t9, -1	### decrement $t9 by 1 so we can use already made procedure addlabel
	jal addJumpLabel
	add $t9, $zero, $s1	### restore $t9
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We have no destination register to link
	addi $t8, $zero, 0
	sw $t1, 0($t0)
	j mainLoop
	
bBne:
	jal getMachineInstruction
	bne $t8, 0, bBneLink
	### Print BNE
	addi $v0, $zero, 4
	la $a0, opBne
	syscall
	### Encode bne opcode
	addi $t1, $t1, 0x14000000	### Opcode
	### print source register
	jal encodeRegisterIS
	jal addRegister
	addi $t7, $t7, 1	### Increment future to use register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print target register
	jal encodeRegisterID
	jal addRegister
	addi $t7, $t7, 1	### increment future to use register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print Label
	jal encodeBranchAddress
	addi $s1, $t9, 0	### Save the $t9 register state
	addi $t9, $t9, -1	### decrement $t9 by 1 so we can use already made procedure addlabel
	jal addJumpLabel
	add $t9, $zero, $s1	### restore $t9
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We have no destination register to link
	addi $t8, $zero, 0
	sw $t1, 0($t0)
	j mainLoop
bBneLink:
	jal getMachineInstruction
	### Print BNE
	addi $v0, $zero, 4
	la $a0, opBne
	syscall
	### Encode bne opcode
	addi $t1, $t1, 0x14000000	### Opcode
	### Print source Register (LINKED)
	jal encodeRegisterISLinked
	jal addRegisterLinked
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print second source
	jal encodeRegisterID
	jal addRegister
	addi $t7, $t7, 1	### Increment future to use register
	addi $v0, $zero, 4
	la $a0, comma
	syscall
	### Print Label
	jal encodeBranchAddress
	addi $s1, $t9, 0	### Save the $t9 register state
	addi $t9, $t9, -1	### decrement $t9 by 1 so we can use already made procedure addlabel
	jal addJumpLabel
	add $t9, $zero, $s1	### restore $t9
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	### We have no destination register to link
	addi $t8, $zero, 0
	sw $t1, 0($t0)
	j mainLoop

encodeBranchAddress: ###Branch is relative to current PC address, so we'll be going backwards one line each time so it should always be the same thing...
	addi $t1, $t1, 0x15CDFFFE
	jr $ra

encodeAddress:
	beq $t9, 1, encodeAddress100
	beq $t9, 2, encodeAddress100
	beq $t9, 3, encodeAddress101
	beq $t9, 4, encodeAddress102
	beq $t9, 5, encodeAddress103
encodeAddress100:
	addi $t1, $t1, 0x00100000
	jr $ra
encodeAddress101:
	addi $t1, $t1, 0x00100001
	jr $ra
encodeAddress102:
	addi $t1, $t1, 0x00100002
	jr $ra
encodeAddress103:
	addi $t1, $t1, 0x00100003
	jr $ra
			
addJumpLabel:
	beq $t9, 1, addJumpLabel100
	beq $t9, 2, addJumpLabel101
	beq $t9, 3, addJumpLabel102
	beq $t9, 4, addJumpLabel103
	beq $t9, 5, addJumpLabel104
addJumpLabel100:
	addi $v0, $zero, 4
	la $a0, jumpLine100
	syscall
	jr $ra
addJumpLabel101:
	addi $v0, $zero, 4
	la $a0, jumpLine101
	syscall
	jr $ra
addJumpLabel102:
	addi $v0, $zero, 4
	la $a0, jumpLine102
	syscall
	jr $ra
addJumpLabel103:
	addi $v0, $zero, 4
	la $a0, jumpLine103
	syscall
	jr $ra
addJumpLabel104:
	addi $v0, $zero, 4
	la $a0, jumpLine104
	syscall
	jr $ra

encodeImmediate:	### T6 holds our X constant immediate value.  If we've used it once already then 10x = 101. maximum of 4 times 
	beq $t6, 0, encode100
	beq $t6, 1, encode101
	beq $t6, 2, encode102
	beq $t6, 3, encode103
	beq $t6, 4, encode104
encode100:
	addi $t1, $t1, 0x00000064	### add the immediate binary value to our 32-bit string
	jr $ra
encode101:
	addi $t1, $t1, 0x00000065	
	jr $ra
encode102:
	addi $t1, $t1, 0x00000066	
	jr $ra
encode103:
	addi $t1, $t1, 0x00000067
	jr $ra
encode104:
	addi $t1, $t1, 0x00000068	
	jr $ra

encodeRegisterIS:
	beq $t7, 0, encodeIST0  ### T7 holds which register we are currently on
	beq $t7, 1, encodeIST1
	beq $t7, 2, encodeIST2
	beq $t7, 3, encodeIST3
	beq $t7, 4, encodeIST4
	beq $t7, 5, encodeIST5
	beq $t7, 6, encodeIST6
	beq $t7, 7, encodeIST7
	beq $t7, 8, encodeIST8
	beq $t7, 9, encodeIST9
encodeRegisterISLinked:
	beq $t4, 0, encodeIST0  ### T4 holds register are linking
	beq $t4, 1, encodeIST1
	beq $t4, 2, encodeIST2
	beq $t4, 3, encodeIST3
	beq $t4, 4, encodeIST4
	beq $t4, 5, encodeIST5
	beq $t4, 6, encodeIST6
	beq $t4, 7, encodeIST7
	beq $t4, 8, encodeIST8
	beq $t4, 9, encodeIST9
encodeIST0:
	addi $t1, $t1, 0x01000000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST1:
	addi $t1, $t1, 0x01200000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST2:
	addi $t1, $t1, 0x01400000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST3:
	addi $t1, $t1, 0x01600000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST4:
	addi $t1, $t1, 0x01800000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST5:
	addi $t1, $t1, 0x01A00000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST6:
	addi $t1, $t1, 0x01C00000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST7:
	addi $t1, $t1, 0x01E00000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST8:
	addi $t1, $t1, 0x03000000	### add the register binary value to our 32-bit string
	jr $ra
encodeIST9:
	addi $t1, $t1, 0x03200000	### add the register binary value to our 32-bit string
	jr $ra
	
encodeRegisterID:
	beq $t7, 0, encodeIDT0  ### T7 holds which register we are currently on
	beq $t7, 1, encodeIDT1
	beq $t7, 2, encodeIDT2
	beq $t7, 3, encodeIDT3
	beq $t7, 4, encodeIDT4
	beq $t7, 5, encodeIDT5
	beq $t7, 6, encodeIDT6
	beq $t7, 7, encodeIDT7
	beq $t7, 8, encodeIDT8
	beq $t7, 9, encodeIDT9
encodeIDT0:
	addi $t1, $t1, 0x00080000	### add the register binary value to our 32-bit string
	jr $ra
encodeIDT1:
	addi $t1, $t1, 0x00090000
	jr $ra
encodeIDT2:
	addi $t1, $t1, 0x000A0000	
	jr $ra
encodeIDT3:
	addi $t1, $t1, 0x000B0000	
	jr $ra
encodeIDT4:
	addi $t1, $t1, 0x000C0000	
	jr $ra
encodeIDT5:
	addi $t1, $t1, 0x000D0000	
	jr $ra
encodeIDT6:
	addi $t1, $t1, 0x000E0000
	jr $ra
encodeIDT7:
	addi $t1, $t1, 0x000F0000	
	jr $ra
encodeIDT8:
	addi $t1, $t1, 0x00180000	
	jr $ra
encodeIDT9:	
	addi $t1, $t1, 0x00190000	
	jr $ra

encodeRegisterRT:
	beq $t7, 0, encodeRTT0  ### T7 holds which register we are currently on
	beq $t7, 1, encodeRTT1
	beq $t7, 2, encodeRTT2
	beq $t7, 3, encodeRTT3
	beq $t7, 4, encodeRTT4
	beq $t7, 5, encodeRTT5
	beq $t7, 6, encodeRTT6
	beq $t7, 7, encodeRTT7
	beq $t7, 8, encodeRTT8
	beq $t7, 9, encodeRTT9
encodeRTT0:
	addi $t1, $t1, 0x00080000	### add the register binary value to our 32-bit string
	jr $ra
encodeRTT1:
	addi $t1, $t1, 0x00090000	
	jr $ra
encodeRTT2:
	addi $t1, $t1, 0x000A0000	
	jr $ra
encodeRTT3:
	addi $t1, $t1, 0x000B0000
	jr $ra
encodeRTT4:
	addi $t1, $t1, 0x000C0000
	jr $ra
encodeRTT5:
	addi $t1, $t1, 0x000D0000
	jr $ra
encodeRTT6:
	addi $t1, $t1, 0x000E0000
	jr $ra
encodeRTT7:
	addi $t1, $t1, 0x000F0000
	jr $ra
encodeRTT8:
	addi $t1, $t1, 0x00180000
	jr $ra
encodeRTT9:
	addi $t1, $t1, 0x00190000
	jr $ra
	
encodeRegisterRS:
	beq $t7, 0, encodeRST0  ### T7 holds which register we are currently on
	beq $t7, 1, encodeRST1
	beq $t7, 2, encodeRST2
	beq $t7, 3, encodeRST3
	beq $t7, 4, encodeRST4
	beq $t7, 5, encodeRST5
	beq $t7, 6, encodeRST6
	beq $t7, 7, encodeRST7
	beq $t7, 8, encodeRST8
	beq $t7, 9, encodeRST9
encodeRegisterRSLinked:
	beq $t4, 0, encodeRST0  ### T4 holds which register we are linking from
	beq $t4, 1, encodeRST1
	beq $t4, 2, encodeRST2
	beq $t4, 3, encodeRST3
	beq $t4, 4, encodeRST4
	beq $t4, 5, encodeRST5
	beq $t4, 6, encodeRST6
	beq $t4, 7, encodeRST7
	beq $t4, 8, encodeRST8
	beq $t4, 9, encodeRST9
encodeRST0:
	addi $t1, $t1, 0x01000000	### add the register binary value to our 32-bit string
	jr $ra
encodeRST1:
	addi $t1, $t1, 0x01200000	
	jr $ra
encodeRST2:
	addi $t1, $t1, 0x01400000	
	jr $ra
encodeRST3:
	addi $t1, $t1, 0x01600000	
	jr $ra
encodeRST4:
	addi $t1, $t1, 0x01800000	
	jr $ra
encodeRST5:
	addi $t1, $t1, 0x01A00000	
	jr $ra
encodeRST6:
	addi $t1, $t1, 0x01C00000	
	jr $ra
encodeRST7:
	addi $t1, $t1, 0x01E00000	
	jr $ra
encodeRST8:
	addi $t1, $t1, 0x03000000	
	jr $ra
encodeRST9:
	addi $t1, $t1, 0x03200000	
	jr $ra
	
encodeRegisterRD:		### Encode the Destination register for an instruction of type-R
	beq $t7, 0, encodeRDT0  ### T7 holds which register we are currently on
	beq $t7, 1, encodeRDT1
	beq $t7, 2, encodeRDT2
	beq $t7, 3, encodeRDT3
	beq $t7, 4, encodeRDT4
	beq $t7, 5, encodeRDT5
	beq $t7, 6, encodeRDT6
	beq $t7, 7, encodeRDT7
	beq $t7, 8, encodeRDT8
	beq $t7, 9, encodeRDT9
encodeRDT0:
	addi $t1, $t1, 0x00004000	### add the register binary value to our 32-bit string
	jr $ra
encodeRDT1:
	addi $t1, $t1, 0x00004800
	jr $ra
encodeRDT2:
	addi $t1, $t1, 0x00005000
	jr $ra
encodeRDT3:
	addi $t1, $t1, 0x00005800
	jr $ra
encodeRDT4:
	addi $t1, $t1, 0x00006000
	jr $ra
encodeRDT5:
	addi $t1, $t1, 0x00006800
	jr $ra
encodeRDT6:
	addi $t1, $t1, 0x00007000
	jr $ra
encodeRDT7:
	addi $t1, $t1, 0x00007800
	jr $ra
encodeRDT8:
	addi $t1, $t1, 0x0000C000
	jr $ra
encodeRDT9:
	addi $t1, $t1, 0x0000C800
	jr $ra

addRegister:
	beq $t7, 0, addT0 ### T7 holds which register we are currently on
	beq $t7, 1, addT1
	beq $t7, 2, addT2
	beq $t7, 3, addT3
	beq $t7, 4, addT4
	beq $t7, 5, addT5
	beq $t7, 6, addT6
	beq $t7, 7, addT7
	beq $t7, 8, addT8
	beq $t7, 9, addT9
addRegisterLinked:	  ## T4 holds which register we linked
	beq $t4, 0, addT0
	beq $t4, 1, addT1
	beq $t4, 2, addT2
	beq $t4, 3, addT3
	beq $t4, 4, addT4
	beq $t4, 5, addT5
	beq $t4, 6, addT6
	beq $t4, 7, addT7
	beq $t4, 8, addT8
	beq $t4, 9, addT9
addT0:
	addi $v0, $zero, 4
	la $a0, opT0
	syscall
	jr $ra
addT1:
	addi $v0, $zero, 4
	la $a0, opT1
	syscall
	jr $ra
addT2:
	addi $v0, $zero, 4
	la $a0, opT2
	syscall
	jr $ra
addT3:
	addi $v0, $zero, 4
	la $a0, opT3
	syscall
	jr $ra
addT4:
	addi $v0, $zero, 4
	la $a0, opT4
	syscall
	jr $ra
addT5:
	addi $v0, $zero, 4
	la $a0, opT5
	syscall
	jr $ra
addT6:
	addi $v0, $zero, 4
	la $a0, opT6
	syscall
	jr $ra
addT7:
	addi $v0, $zero, 4
	la $a0, opT7
	syscall
	jr $ra
addT8:
	addi $v0, $zero, 4
	la $a0, opT8
	syscall
	jr $ra
addT9:
	addi $v0, $zero, 4
	la $a0, opT9
	syscall
	jr $ra