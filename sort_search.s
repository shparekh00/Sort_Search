# Shivani Parekh

#constants
READ_INT = 5
PRINT_INT = 1
PRINT_STR = 4

    .data
arr:        .space  40
max_len:    .word   10
found:      .asciiz "Found at index "
notfound:   .asciiz "Not found \n"
newline:    .asciiz "\n"
  
    .text
main:
# prologue
    addiu       $sp, $sp, -20       # allocate space in stack for load function
    sw		    $ra, 16($sp)		# save return address in stack
# body
    la          $a0, arr            # pass address of arr as argument
    la          $a1, max_len        # load max_len 
    lw	    	$a1, 0($a1)		     
    jal		    load			    # jump to load and save position to $ra
    
    move        $a2, $v0            # move len to $a2, pass as argument to sort
    jal		    sort				# jump to sort and save position to $ra

    jal         find
    
# epilogue
    lw		    $ra, 16($sp)		# restore return address
    addiu       $sp, $sp, 20        # restore stack
    jr		    $ra					# jump to $ra
    


load:
    addiu       $sp, $sp, -4
    sw		    $ra, 0($sp)
    
    li          $s0, 0      # len
    addiu       $t1, $a0, 0    # $t1 = arr
    j           loop

loop:
    beq		    $a1, $zero, endLoad	# if $a1 == $zero then target
    li          $v0, READ_INT       # read number from input
    syscall 
    bltz        $v0, endLoad 
    sw          $v0, 0($t1)
    addiu       $t1, $t1, 4         # add to arr
    addiu       $a1, $a1, -1        # decrement max_len
    addiu       $s0, $s0, 1
    j		    loop				# jump to loop
    
endLoad:
    move 	    $v0, $s0		    # $v0 = $s0
    lw		    $ra, 0($sp)		    # load return address
    addiu       $sp, $sp, 4         # restore stack
    jr          $ra
    
sort:
#prologue
    addiu       $sp, $sp, -4
    sw		    $ra, 0($sp)		# save return address
#body

    li          $t2, 1

whilei:
    bge		    $t2, $a2, endSort	# if $t2 (i) >= $a1 (len) then endSort
    addiu       $t3, $t2, 0         # j = i
    
    j		    whilej				# jump to whilej

whilej:
    blez        $t3, continue       # j <= 0, end inner loop
    sll         $t4, $t3, 2         # j * 4
    addu        $t1, $a0, $t4       # shift position in arr to j          
    lw		    $t5, 0($t1)		    # arr[j]
    lw		    $t6, -4($t1)		# arr[j-1]
    addiu       $t3, $t3, -1        # decrement j
    ble		    $t6, $t5, continue	# if $t6 <= $t5 then continue
    sw		    $t6, 0($t1)		    # swap arr[j-1] and arr[j]
    sw		    $t5, -4($t1)		 
    j		    whilej				# jump to whilej
    

continue:
    addiu       $t2, $t2, 1         # i = i+1
    j		    whilei				# jump to whilei
    
#epilogue
endSort:
    lw		    $ra, 0($sp)   
    addiu       $sp, $sp, 4
    jr		    $ra					# jump to $ra
    



bsearch:
# Prologue  
    addiu       $sp, $sp, -20       # allocate space in stack
    sw          $ra, 16($sp)
    sw          $a0, 20($sp)       
    sw          $a1, 24($sp)
    sw          $a2, 28($sp)
    sw          $a3, 32($sp)
        
# Body
    lw          $a0, 20($sp)        # load arr
    addiu       $t4, $a0, 0         # $t0 contains address in array
    lw          $a1, 24($sp)        # load low
    lw          $a2, 28($sp)        # load high
    lw          $a3, 32($sp)        # load key
    bgt		    $a1, $a2, notFound 	# if hi > low then not found
    
    addu        $t1, $a1, $a2       # $t1 = low + high
    srl         $t1, $t1, 1         # divide by 2 (mid)
    sll         $t2, $t1, 2         # mid * 4 to get index in arr
    addu        $t4, $t4, $t2       # change address $t0 to adress mid
    lw		    $t3, 0($t4)		    # $t3 = arr[mid]
    
    bgt		    $t3, $a3, smallHalf	# if arr[mid] > key then smallHalf
    blt		    $t3, $a3, bigHalf	# if $t3 < $a3 then bigHalf
    beq		    $t3, $a3, returnMiddle	# if $t3 == $a3 then returnMiddle

 returnMiddle:   
    move        $v0, $t1            # return mid
    j		    endBsearch			# jump to endBsearch
    
notFound:
    li          $v0, -1             # return -1 if not found
    j		    endBsearch			# jump to end

smallHalf:
    move 	    $a2, $t1		
    addiu       $a2, $a2, -1        # $a2 = mid - 1
    jal		    bsearch				# jump to bsearch
    j		    endBsearch				# jump to endBsearch
     

bigHalf:
    move 	    $a1, $t1		    # $a2 = $t1
    addiu       $a1, $a1, 1         # low = mid + 1
    jal		    bsearch				# jump to bsearch
    j		    endBsearch				# jump to endBsearch
    
# Epilogue    
endBsearch:
          
    lw		    $ra, 16($sp)   
    addiu       $sp, $sp, 20
    jr		    $ra					# jump to $ra
    
     
find:
# Prologue
    addiu       $sp, $sp, -20
    sw          $ra, 16($sp)
    sw          $a0, 20($sp)        # arr
    sw          $a2, 24($sp)        # len
    sw          $s0, 12($sp)
    sw          $s1, 8($sp)
    sw          $s2, 4($sp)
# Body
    lw		    $a0, 20($sp)		# arr
    move 	    $a1, $zero		    # low = 0
    lw          $a2, 24($sp)
    addiu       $a2, $a2, -1        # hi = len - 1
    move 	    $s0, $a1
    move        $s1, $a2            # save hi and low
    lw          $s2, 20($sp)        # save address

    j		    whileLoop			# jump to whileLoop
    
whileLoop:
    li          $v0, READ_INT       # read key
    syscall	
    bltz        $v0, endFind

    move        $a0, $s2
    move        $a1, $s0
    move        $a2, $s1            # restore hi and low values
    move        $a3, $v0            # pass input as key to bsearch
    jal		    bsearch				# jump to bsearch and save position to $ra
    move        $t1, $v0
    bltz        $t1, false
    
    # key was found
    la		    $a0, found		    # print "Found at index "
    li          $v0, PRINT_STR
    syscall
    
    move 	    $a0, $t1
    li          $v0, PRINT_INT      # print index
    syscall
   
    la 	        $a0, newline		
    li          $v0, PRINT_STR
    syscall
    
    j		    whileLoop				# jump to whileLoop
    
 false:
    la		    $a0, notfound		# print "not found "
    li          $v0, PRINT_STR
    syscall
    j		    whileLoop				# jump to whileLoop

# Epilogue
endFind:
    lw		    $ra, 16($sp)		# restore return address
    addiu       $sp, $sp, 20        # restore stack
    jr		    $ra				
    
    