.data										    	#define variable that will be stored in Static memory location

N:	.word 0										#setting variable
Ni: .word 1										#setting variable
txt: .ascii "Input of: "									#printing
br: .asciiz "\n"										#line break
res: .ascii "Returns: "									#more printing

.text										    	#alphanumeric identifier
.globl main										#make global for external use

main:										    	#setting values

	lw $s0, N								   	#s0 = N = 13
	li $s2, 2								   	#s2 = 2
	li $s3, 1								  	#s3 = 1


	jal testPrime									#jump to testPrime, link address
	jal printing									#go print results
	
	lw $s0, Ni									#s0 = N = 29

	jal testPrime									#testPrime again
	jal printing									#print result

	li $v0, 10 									#referencing exit function
	syscall									  	#execute exit

					#---testPrime(N)---

testPrime:										#loop that finds remainder of N / (all integers < N/2)

	beq $s0, $zero, compound							#if N = 0, not prime
	beq $s0, $s3, compound								#if N = 1, not prime
	
	srl $s1, $s0, 1									#s1 = N/2
	
	j loop									  	#jump to loop

loop:										     	#iterate through divisors

	slt $t0, $s1, $s2				  				#if $s0 < 2, $t0 = 1, else $t0 = 0
	beq $t0, $s3, prime								#if $t0 == 1 we have tried all possible divisors, so jump to prime

	rem $t1, $s0, $s1								#$t1 = N % $s1

	beq $t1, $zero, compound							#if N % s0 = 0, N is not prime, so jump to compound
	addi $s1, $s1, -1								#decrement s0
	j loop									  	#jump to top of loop

prime:									  		#if prime

	li $s4, 1								  	#set result to 1
	jr $ra									  	#jump back to main

compound:									  	#if not prime

	li $s4, 0								  	#set result to 0
	jr $ra									  	#jump back to main

					#---print function---

printing:

	li $v0, 4 									#referencing the print_string system call (4)
	la $a0, txt									#passing string
	syscall									  	#execute

	li $v0, 1							  		#referencing print int system call
	move $a0, $s0									#passing value to print int system call
	syscall									  	#execute print

	li $v0, 4 									#referencing the print_string system call (4)
	la $a0, br									#passing string
	syscall									  	#execute


	li $v0, 4 									#referencing the print_string system call (4)
	la $a0, res									#passing string
	syscall									  	#execute

	li $v0, 1								  	#referencing print int system call
	move $a0, $s4									#passing value to print int system call
	syscall								  		#execute print
	
	li $v0, 4 									#referencing the print_string system call (4)
	la $a0, br									#passing string
	syscall									  	#execute

	jr $ra									  	#jump back to main

