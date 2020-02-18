#Michael Romero
#maromero
#This lets the user see the frest object in stock, the entire list, and update data as a linked list
### START MAIN, DO NOT MODIFY ###
			.text
mainLoop:			
			li			$v0, 5						# Read integer command from user
			syscall

			bltz		$v0, mainDone				# Negative number ends program
			beq 		$v0, $0, mainFirst			# Command 0 = print first node 	
			addi		$v0, $v0, -1
			beq 		$v0, $0, mainList			# Command 1 = print entire list
			addi		$v0, $v0, -1
			beq 		$v0, $0, mainUpdate			# Command 2 = update item
			
			la			$a0, strInvalid				# Print linked list from first node
			li			$v0, 4
			syscall		
			
mainEnd:
			li      	$v0, 11      				# Print a linefeed
			addi    	$a0, $0, 10 
			syscall
			
			b			mainLoop

mainFirst:
			# Print just the first node
			la			$a0, strFirst				
			li			$v0, 4
			syscall		
			
			la			$a0, first					
			jal			printNode
			b			mainEnd
									
mainList:
			# Print linked list from the first node
			la			$a0, strList				
			li			$v0, 4
			syscall		
			
			la			$a0, first					
			jal			printList
			b			mainEnd
			
mainUpdate:
			# Update a specific item
			li			$v0, 5						# Read part number
			syscall
			move		$a1, $v0					
			
			li			$v0, 5						# Read quantity delta
			syscall
			move		$a2, $v0
			
			la			$a0, strUpdate				
			li			$v0, 4
			syscall		

			la			$a0, first
			jal			updateItem
			
			move		$a0, $v0					# Print result from update procedure
			li			$v0, 1
			syscall
			
			b			mainEnd

mainDone:
			# Terminate execution
			li			$v0, 10						
			syscall
			
			.data
strInvalid:	.asciiz "Invalid command!"
strFirst:   .asciiz "First  : "
strList:    .asciiz "Items  : "
strUpdate:	.asciiz "Update : "
			
			.text
### END MAIN ###

############################################################
# Prints the part number, description, and quantity
# of a given node in the list. Example output: 
#  "#955288 Buzz Lightyear (21)"
# Parameters : $a0 - address of node to print
# Returns    : n/a
############################################################
printNode:
			lw $t1,4($a0)#loads frist element into t1
			
			lw $t2,8($a0)#loads second element into t2
			
			la $t3, 12($a0)#loads third element into t3
			# prints #
			li $v0,11
			addi $a0, $0, 35
			syscall
			#prints the frist element
			li $v0,1
			move $a0, $t1
			syscall
			#prints space
			  li      $v0, 11      # syscall 11 prints character in $a0
   			 addi    $a0, $0, 32  # ASCII code 32 is a space
   			 syscall
			#prints the third element
			li $v0,4
			move $a0, $t3
			syscall
			#prints space
			  li      $v0, 11      # syscall 11 prints character in $a0
   			 addi    $a0, $0, 32  # ASCII code 32 is a space
   			 syscall
   			 # prints (
			li $v0,11
			addi $a0, $0, 40
			syscall
   			 #prints the second element
   			 li $v0,1
			move $a0, $t2
			syscall
			 # prints )
			li $v0,11
			addi $a0, $0, 41
			syscall
			jr			$ra#returns to main code
						
############################################################
# Prints list of items from given starting node in null 
# terminated linked list. Each node is printed via printNode
# procedure. Items separated by a comma and space.
#  
# Parameters : $a0 - address of node to start printing from
# Returns    : n/a
############################################################
printList:
			move $s0,$ra# saves return location
			la $t7,0($a0)#loads next node
			jal printNode#prints frist node, assuming we know there is one
				
			printListLoop:
				lw $t6,0($t7)#gets the sdress
				blt $t6,$0,printListDone#checks if end node
				 # prints ,
				li $v0,11
				addi $a0, $0, 44
				syscall
				#prints space
			 	 li      $v0, 11      # syscall 11 prints character in $a0
   			 	addi    $a0, $0, 32  # ASCII code 32 is a space
   			 	syscall
			
				move $a0,$t6#sets a0 to node adress
				jal printNode#prints node
				la $t7,0($t6)#sets to next node
				b printListLoop
				
			printListDone:
			move $ra,$s0#returns origanal pc
		    jr 		  	$ra#returns to main code

############################################################
# Finds the first item in the list matching a part  
# number and changes its quanity by a certain amount.
# Quantity is not allowed to go below 0.
#
# Parameters : $a0 - address of first node in list
#              $a1 - part number to match
#              $a2 - delta to apply to quantity
# Returns    : $v0 - new quantity, -1 if item not found
############################################################
updateItem:
				la $t7,0($a0)#put the start address into t7
				updateItemLoop:
					blt $t7,0,Error404#if t7 is invaled go to error message
					lw $t6,4($t7)#gets part number
					beq $a1,$t6,updateItemDone#if equal, stop looping
					la $t7,0($t7)#gets next node
					lw $t7,0($t7)#loads next node
					b updateItemLoop
				updateItemDone:
			lw $t0,8($t7)#gets current quantity
			add $v0,$t0,$a2#add current with delta
			blt $v0,0,defalt#if it's less than 0, go to defalt print
			sw $v0,8($t7) #saves new amount
			jr			$ra#returns to main
			defalt:
			li			$v0,0#sets new amount to 0
			sw $v0,8($t7) #saves new amount
			jr			$ra	#returns to main	
			Error404:
			li			$v0, -1#returns invaled 
			jr			$ra	#returns to main						
### START DATA ###
# You can (and should!) modify the linked list in order to test your procedures.
# However, the first node should retain the label first.
.data
first:  	.word     	node2       				# Next pointer
			.word     	955288	     				# Part number
			.word     	21							# Quantity
        	.asciiz   	"Buzz Lightyear" 			# Description
        
node2:		.word     	node3
			.word     	955285
			.word     	2
        	.asciiz   	"Genie"

node3:  	.word     	-1
			.word     	951275
			.word     	5
        	.asciiz   	"Chick-Fil-A Cow"
### END DATA ###
		
		
