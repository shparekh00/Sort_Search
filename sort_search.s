# Shivani Parekh

#constants
READ_INT = 5
PRINT_INT = 1
PRINT_STR = 4

    .data
arr:        .space  40
found:      .asciiz "Found at index "
notfound:   .asciiz "Not found \n"
newline:    .asciiz "\n"
  
    .text
main:
# prologue
    addiu       $sp, $sp, -20       # allocate space in stack for load function
    sw		    $ra, 16($sp)		# save return address in stack
# body
    la          $a1, arr            # pass address of arr as argument
    sw		    $a1, 12($sp)		# save arr starting address
    lw		    $s0, 12($sp)		# 
    li          $v0, READ_INT       # read max_len
    syscall
    move        $a2, $v0            # store max_len in $a2
    li		    $t1, 0		        # set len = 0
    jal		    load			    # jump to load and save position to $ra
    addiu		$a1, $s0, 0		 
    move        $a2, $v0            # move len to $a2, pass as argument to sort
    li          $t2, 1              # int i = 1 for while loop in sort
    jal		    sort				# jump to sort and save position to $ra
    syscall
    move 	    $a0, $s0		    # pass arr as argument
    addiu       $a2, $a2, -1
    jal         find
    
# epilogue
    lw		    $ra, 16($sp)		# restore return address
    addiu       $sp, $sp, 20        # restore stack
    jr		    $ra					# jump to $ra
    


load:
# end of function $v0 should have num items in array
#prologue
    addiu       $sp, $sp, -20
    sw		    $ra, 16($sp)		# save return address
    sw		    $a1, 20($sp)		# save arr address
    sw          $a2, 24($sp)        # save max_len 
#body
    lw          $a1, 20($sp)        # load address of arr
    lw          $a2, 24($sp)		# load max_len
    beq		    $a2, $zero, endLoad	# return if max_len = 0
    li          $v0, READ_INT       # read number from input
    syscall
    bltz        $v0, endLoad        # if input negative, return
    sw          $v0, 0($a1)         # store input in array
    addiu       $a1, $a1, 4         # increment arr address by 4 bytes
    addi        $a2, $a2, -1        # decrement max_len
    addiu       $t1, $t1, 1         # increment len
    addiu       $v0, $t1, 0         # put len in return value register
    j		    load				# jump to load
#epilogue   
endLoad:
    lw		    $ra, 16($sp)		# load return address
    addiu       $sp, $sp, 20        # restore stack pointer
    jr          $ra

sort:
#prologue
    addiu       $sp, $sp, -28
    sw		    $ra, 24($sp)		# save return address
    sw		    $a1, 28($sp)		# save arr address
    sw          $a2, 32($sp)        # save max_len 
#body
    lw		    $a1, 28($sp)		# load address of arr
    lw          $a2, 32($sp)		# load len
    li          $t2, 1
whilei:
    bge		    $t2, $a2, endSort	# if $t2 (i) >= $a1 (len) then endSort
    addiu       $t3, $t2, 0         # j = i
    
    j		    whilej				# jump to whilej
whilej:
    blez        $t3, continue       # j <= 0, end inner loop
    lw		    $a1, 28($sp)		# 
    sll         $t4, $t3, 2         # j * 4
    addu        $a1, $a1, $t4       # shift position in arr to j          
    lw		    $t5, 0($a1)		    # arr[j]
    lw		    $t6, -4($a1)		# arr[j-1]
    addiu       $t3, $t3, -1        # decrement j
    ble		    $t6, $t5, continue	# if $t6 <= $t5 then whilej
    sw		    $t6, 0($a1)		    # swap arr[j-1] and arr[j]
    sw		    $t5, -4($a1)		 
    j		    whilej				# jump to whilej
    

continue:
    addiu       $t2, $t2, 1         # i = i+1
    j		    whilei				# jump to whilei
    
#epilogue
endSort:
    lw		    $ra, 24($sp)   
    addiu       $sp, $sp, 28
    jr		    $ra					# jump to $ra
    



bsearch:
# Prologue  
    addiu       $sp, $sp, -28       # allocate space in stack
    sw          $ra, 24($sp)
    sw          $a0, 28($sp)       
    sw          $a1, 32($sp)
    sw          $a2, 36($sp)
    sw          $a3, 40($sp)
        
# Body
    lw          $a0, 28($sp)        # load arr
    addiu       $t0, $a0, 0         # $t0 contains address in array
    lw          $a1, 32($sp)        # load low
    lw          $a2, 36($sp)        # load high
    lw          $a3, 40($sp)        # load key
    bgt		    $a1, $a2, notFound 	# if hi > low then not found
    addu        $t1, $a1, $a2       # $t1 = low + high
    srl         $t1, $t1, 1         # divide by 2 (mid)
    sll         $t2, $t1, 2         # mid * 4 to get index in arr
    addu        $t0, $t0, $t2       # change address $t0 to adress mid
    lw		    $t3, 0($t0)		    # $t3 = arr[mid]
    bgt		    $t3, $a3, smallHalf	# if arr[mid] > key then smallHalf
    blt		    $t3, $a3, bigHalf	# if $t3 < $a3 then bigHalf
    move        $v0, $t1         # return mid
    j		    endBsearch			# jump to endBsearch
    
notFound:
    li          $v0, -1        # return -1 if not found
    j		    endBsearch			# jump to end

smallHalf:
    move 	    $a2, $t1		
    addiu       $a2, $a2, -1        # $a2 = mid - 1
    j		    bsearch				# jump to bsearch
    
bigHalf:
    move 	    $a1, $t1		    # $a2 = $t3
    addiu       $a1, $a2, 1         # low = mid + 1
    j		    bsearch				# jump to bsearch

# Epilogue    
endBsearch:
          
    lw		    $ra, 24($sp)   
    addiu       $sp, $sp, 28
    jr		    $ra					# jump to $ra
    
     
find:
# Prologue
    addiu       $sp, $sp, -28
    sw          $ra, 24($sp)
    sw          $a0, 28($sp)
    sw          $a2, 32($sp)
    sw          $s0, 20($sp)
    sw          $s1, 16($sp)
# Body
    lw		    $a0, 28($sp)		# load arr
    lw		    $a2, 32($sp)		# load len - 1
    andi        $a1, $a1, 0         # $a1 = 0 (low)
    addiu		$s0, $a1, 0		    # save low
    lw		    $s1, 32($sp)		# 
    
    li          $v0, READ_INT       # read key
    syscall
    bltz        $v0, endFind
    move 	    $a3, $v0		    # $a3 = key
    jal		    bsearch				# jump to bsearch and save position to $ra
    move 	    $t1, $v0		     
    bltz        $t1, false          # bsearch didn't find key
    la		    $a0, found		    # print "Found at index "
    li          $v0, PRINT_STR
    syscall
    move 	    $a0, $t1		    
    li          $v0, PRINT_INT      # print index
    syscall
    la 	        $a0, newline		
    li          $v0, PRINT_STR
    syscall
    move 	    $a1, $s0		    # $a1 = $t1
    move 	    $a2, $s1		    # $a2 = $s1
    j		    find				# jump to find
    
false:
    la		    $a0, notfound		    # print "not found "
    li          $v0, PRINT_STR
    syscall
    move 	    $a1, $s0		# $a0 = s01
    move 	    $a2, $s1		    # $a2 = $s1
    j		    find				# jump to endFind

# Epilogue
endFind:
    lw		    $ra, 24($sp)		# restore return address
    addiu       $sp, $sp, 28        # restore stack
    jr		    $ra				
    
    