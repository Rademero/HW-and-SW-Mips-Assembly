#Michael Romero
#maromero
#reads in one or more vectors of a specified number of dimensions,
# prints the element-wise sum of the vectors.
	.text
	#part 1
	# gets D as long as D is grater than 0
	li $v0,5#calls in new int
	syscall
	blt $v0,1,term #ends program if less than 1
	move $t1,$v0
	sw $t1,D
	# gets N as long as D is grater than 0
	li $v0,5#calls in new int
	syscall
	blt $v0,1,term #ends program if less than 1
	move $t2,$v0
	sw $t2,N
	#checks upper bound limits of the vectors
	lw $t1,D
	lw $t2,N
	mult $t1,$t2 
	mflo $t3
	bgt $t3,1000,term #ends program if the vectors need more than 1000 elements 
	
	#part 2
	# sets up total number of elements needed for this final vector
	li $t1,4 
	mult $t3,$t1
	mflo $t3
	
	li $t1,0# number of element counter 
	loop1:
		bge $t1,$t3,done1
		li $v0,5#calls in new int
	    syscall
	    sw $v0,InPutVectors($t1)
		add $t1,$t1,4#goes to next index
		b loop1
	
	#part 3
	done1:
	
	loop2:
		li $v0,5#calls in new int
		syscall
		blt $v0,0,term #ends program if less than 0
		lw $t0,N
		add $t0,$t0,-1# start at 0 catch
		bgt $v0,$t0,term #ends program if more than the number of vectors
		add $t0,$t0,1
		move $t0, $v0 #vector 1 
	
		li $v0,5#calls in new int
		syscall
		blt $v0,0,term #ends program if less than 0
		lw $t1,N
		add $t0,$t0,-1# start at 0 catch
		bgt $v0,$t1,term  #ends program if more than the number of vectors
		add $t0,$t0,1
		move $t1, $v0 #vector 2  
				#gets the start index for vector 1
				lw $t7,D
				mult $t7,$t0
				mflo $t0 #gets vector plament within array
				li $t3,4
				mult $t0,$t3
				mflo $t0#convrts to array index couter
				#gets the index for vector 2
				mult $t7,$t1
				mflo $t1#gets vector plament within array
				mult $t1,$t3
				mflo $t1#convrts to array index couter
				#finds the addition of the frist element of each vector
				lw $t2,InPutVectors($t0)
				lw $t4,InPutVectors($t1)
				add $t3,$t2,$t4
				li $t7,0
				sw $t3,ResultVectors($t7)
				#loops throught the rest of the vectors
				li $t7,0
				lw $t5,D
				add $t5,$t5,-1# balnces the offset/ how many elements are still in the array
				li $t6,4# index for results
					restOfEle:
					bge $t7,$t5,RestDone #stop if no more elements 
					#index +1 
					add $t0,$t0,4
					add $t1,$t1,4
					#safe clear of old data, had a slight problem 
					li $t2,0
					li $t4,0
					li $t3,0
					#pulls new data from the vectors
					lw $t2,InPutVectors($t0)
					lw $t4,InPutVectors($t1)
					add $t3,$t4,$t2
					#saves data into results 
					sw $t3,ResultVectors($t6)
					#adds to curent indexes
					add $t7,$t7,1
					add $t6,$t6,4
					b restOfEle
		#final print out		
	RestDone:
	li $t7,0# new counter
	lw $t6,D
	li $t5,0 # array index
		printLoop:
			bge $t7,$t6,recall
			#value
			lw $t0,ResultVectors($t5)
			li $v0,1
			move $a0, $t0
			syscall
			#space
			 li      $v0, 11      # syscall 11 prints character in $a0
    		addi    $a0, $0, 32  # ASCII code 32 is a space
    		syscall
    		add $t7,$t7,1
    		add $t5,$t5,4
    		b printLoop
	recall:	
	li      $v0, 11      # syscall 11 prints character in $a0
    addi    $a0, $0, 10  # ASCII code 10 is a line feed
    syscall
	b loop2
	
	term:
	li $v0,10
	syscall
	
	.data
	D: .word 2 #num of elements in a vector
	N: .word 2# number of vectors
	InPutVectors: .space 1000
	ResultVectors: .space 1000
