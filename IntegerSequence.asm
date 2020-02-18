#Michael Romero
#maromero@mtu.edu
#takes in inputs until a negative number than out puts 
# min, max, number of odds, number of evens, the sum of the squares of each number
li $t0,0# sums of Squares 
li $t5,0# Num of odd 
li $t4,0# Num of even 
li $t7,9999999999#min
li $t6,0#max

	li $v0,5
	syscall
	move $t1, $v0
	
	blt $t1,0,non 
	loop: 
		blt $t1,0,done 
		#adds up squares 
		mult $t1,$t1
		mflo $t2
		add $t0,$t0,$t2

		#calls min start 
		blt $t1,$t7,minS
		minSt:
		
		#calls min start 
		bgt $t1,$t6,maxS
		maxSt:
		
		#even or odd
		li $t3,2
		div $t1,$t3
		mfhi $t3
		bgt $t3,0,odd
		b even
		
		con:

		#calls new input
		li $v0,5
		syscall
		move $t1, $v0
	b loop
	
			#odd
			odd:
			addi $t5,$t5,1
			b con
			
			#even
			even:
			addi $t4,$t4,1
			b con

			#sets new min
			minS:
			move $t7,$t1
			b minSt

			#sets new min
			maxS:
			move $t6,$t1
			b maxSt

	done:

	li $v0,1
	move $a0, $t7#min
	syscall
	
	#new Line
	addi $a0, $0, 0xA 
    addi $v0, $0, 0xB 
    syscall
	
	li $v0,1
	move $a0, $t6#max
	syscall
	
	#new Line
	addi $a0, $0, 0xA 
    addi $v0, $0, 0xB 
    syscall
	
	li $v0,1
	move $a0, $t4#even
	syscall
	
	#new Line
	addi $a0, $0, 0xA 
    addi $v0, $0, 0xB 
    syscall
	
	li $v0,1
	move $a0, $t5#odd
	syscall
	
	#new Line
	addi $a0, $0, 0xA 
    addi $v0, $0, 0xB 
    syscall
	
	li $v0,1
	move $a0, $t0#num of squares
	syscall
	
	
	non:
