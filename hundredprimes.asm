.data										    	#define variable that will be stored in Static memory location

N: .word 0										#setting variable N = input
i: .word 0										#setting variable i = number of primes so far
max: .word 100							                 	#setting variable
txt: .asciiz "First 100 prime numbers: \n"						#printing 
br: .asciiz "\n"									#line break
comma: .ascii ", "									#more printing 

.text										    	#alphanumeric identifier
.globl main										#make global for external use

main:										    	#setting variables

	li $v0, 4 									#referencing the print_string system call (4)
	la $a0, txt									#passing string
	syscall									  	#execute

	lw $s0, N								  	#s0 = N = 0
	lw $s6, i								  	#s6 = i = 0
	li $s2, 2								  	#s2 = 2
	li $s3, 1								  	#s3 = 1
	lw $s5, max									#s5 = 100

	j outer									  	#enter loop

outer:										  	#outer loop

	addi $s0, $s0, 1				  				#increment N
	slt $t0, $s6, $s5								#if i < max, t0 = 1, else t0 = 0
	bne $t0, $zero, inner								#if t0 != 0 we haven't hit 100 primes yet, go back to inner loop
	j exit									  	#else go back to main

inner: 										  	#inner loop

	jal testPrime									#testPrime(N)
	beq $s4, $s3, increment								#if Result = 1, jump to increment because we found a prime
	j outer									  	#else, try next value of N

increment:										#found a prime, increment i

	li $v0, 1								  	#referencing print int system call
	move $a0, $s0									#passing value to print int system call
	syscall									  	#execute print

	li $v0, 4 									#referencing the print_string system call (4)
	la $a0, comma									#passing string
	syscall								       	        #execute

	addi $s6, $s6, 1								#increment i
	j outer								  		#go to next value of N

exit:										    	#exit function

	li $v0, 10 									#referencing exit function
	syscall									  	#execute exit


				#---testPrime(N)---

testPrime:										#loop that finds remainder of N / (all integers < N/2)

	beq $s0, $zero, compound							#if N = 0, not prime
	beq $s0, $s3, compound								#if N = 1, not prime
	
	srl $s1, $s0, 1					  				#s1 = N/2

	j loop									  	#jump to loop

loop:										    	#iterate through divisors

	slt $t0, $s1, $s2								#if $s0 < 2, $t0 = 1, else $t0 = 0
	beq $t0, $s3, prime								#if $t0 == 1 we have tried all possible divisors, so jump to prime

	rem $t1, $s0, $s1				  				#$t1 = N % $s1

	beq $t1, $zero, compound							#if N % s0 = 0, N is not prime, so jump to compound
	addi $s1, $s1, -1								#decrement s0
	j loop									  	#jump to top of loop

prime:										        #if prime

	li $s4, 1								  	#set result to 1
	jr $ra									  	#jump back to main

compound:									  	#if not prime

	li $s4, 0								  	#set result to 0
	jr $ra									  	#jump back to main

