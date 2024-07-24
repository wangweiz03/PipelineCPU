#special inst for my mips processor
	addu $a1,$zero,$zero #the address of the sequence 
 	addi $a0,$a1,4 #&buffer[1]
 	lw $a1,0($a1) #N=buffer[0]
 	
 	jal insertion_sort
 	#finished main
 	addi $a1,$a1,1
 	sll $a1,$a1,2
 	addi $s6,$zero,1
 	sw $s6,0($a1)
 	addi $a1,$a1,4 #saving current sorted data
 	
 	lui $s0,0x4000
 	
 	addi $s0,$s0,16 #40000010
 	addi $t1,$zero,5 ####################################
 	
rounding:
	lw $s1,0($a1) #s1 0xabcd,renewed every second
	add $t0,$zero,$zero #zero,count 100000 then break
bcd4:#lowest
	addi $t0,$t0,1
	andi $s2,$s1,0x0000000f #get lowest 4 bits
	jal judging
	addi $s3,$s3,256 #add ano lowest
	sw $s3,0($s0)
	bne $t0,$t1,bcd4
	
	add $t0,$zero,$zero #zero,count 100000 then break
bcd3:	
	addi $t0,$t0,1
	andi $s2,$s1,0x000000f0 #get 2-lowest 4 bits
	srl $s2,$s2,4
	jal judging
	addi $s3,$s3,512
	sw $s3,0($s0)
	bne $t0,$t1,bcd3
	
	add $t0,$zero,$zero #zero,count 100000 then break
bcd2:
	addi $t0,$t0,1
	andi $s2,$s1,0x00000f00 #get 2-highest 4 bits
	srl $s2,$s2,8
	jal judging
	addi $s3,$s3,1024
	sw $s3,0($s0)
	bne $t0,$t1,bcd2
	
	add $t0,$zero,$zero #zero,count 100000 then break
bcd1:	
	addi $t0,$t0,1
	andi $s2,$s1,0x0000f000 #get highest 4 bits
	srl $s2,$s2,12
	jal judging
	addi $s3,$s3,2048 #add ano highest
	sw $s3,0($s0)
	bne $t0,$t1,bcd1
	
	j rounding

judging:
	beq $s2,15,f
	beq $s2,14,e
	beq $s2,13,d
	beq $s2,12,c
	beq $s2,11,B
	beq $s2,10,a
	beq $s2,9,ni
	beq $s2,8,ei
	beq $s2,7,se
	beq $s2,6,si
	beq $s2,5,fi
	beq $s2,4,fo
	beq $s2,3,th
	beq $s2,2,tw
	beq $s2,1,on
	beq $s2,0,ze
	
f:	addi $s3,$zero,113 #0111 0001
	jr $ra
e:	addi $s3,$zero,121 
	jr $ra
d:	addi $s3,$zero,94
	jr $ra
c:	addi $s3,$zero,57
	jr $ra
B:	addi $s3,$zero,124
	jr $ra
a:	addi $s3,$zero,119
	jr $ra
ni:	addi $s3,$zero,111
	jr $ra
ei:	addi $s3,$zero,127
	jr $ra
se:	addi $s3,$zero,7
	jr $ra
si:	addi $s3,$zero,125
	jr $ra
fi:	addi $s3,$zero,109
	jr $ra
fo:	addi $s3,$zero,102
	jr $ra
th:	addi $s3,$zero,79
	jr $ra
tw:	addi $s3,$zero,91
	jr $ra
on:	addi $s3,$zero,6
	jr $ra
ze:	addi $s3,$zero,63
	jr $ra
 	
    insertion_sort: #a0,a1
    	subi $sp,$sp,4 #stack
    	sw $ra,0($sp)
    	
    	addi $a2,$zero,1 #i=1
    	isfor:
    	    jal search
    	    jal insert
    	    addi $a2,$a2,1
    	    bne $a2,$a1,isfor
    	lw $ra,0($sp)
    	addi $sp,$sp,4
    	nop
    	nop
    	jr $ra
 	
    search: #a0,a2
    	subi $sp,$sp,4
    	sw $ra,0($sp)
 
    	sll $s1,$a2,2
    	addu $s1,$a0,$s1 #v[n] addr
    	lw $t0,0($s1) #tmp=v[n]
    	subi $s2,$a2,1 #i=n-1=0
    	sfor:
    	    sll $s1,$s2,2
    	    addu $s1,$a0,$s1
    	    lw $t1,0($s1) #get v[i]
    	    nop
    	    nop
    	    nop
    	    beq $t1,$t0,sreturn #=
    	    slt $t2,$t1,$t0
    	    beq $t2,1,sreturn #<
    	    subi $s2,$s2,1
    	    bne $s2,-1,sfor
    	sreturn:
    	    addi $a3,$s2,1 #a3 as return val
    	    lw $ra,0($sp)
    	    addi $sp,$sp,4
    	    nop
    	    nop
    	    jr $ra
    	    
    insert: #a0,a3,a2
    	subi $sp,$sp,4
    	sw $ra,0($sp)
    	
    	sll $s1,$a2,2
    	addu $s1,$a0,$s1 #v[n] addr
    	lw $t0,0($s1) #tmp=v[n]
    	subi $s2,$a2,1 #i=n-1
    	ifor:
    	    sll $s1,$s2,2
    	    addu $s1,$a0,$s1 #v[i] addr
    	    lw $t3,0($s1) #t3=v[i]
    	    addi $s1,$s1,4
    	    sw $t3,0($s1) #v[i+1]=v[i]
    	    slt $t4,$s2,$a3
    	    subi $s2,$s2,1
    	    beq $t4,1,ireturn #< break
    	    nop
    	    beq $s2,$a3,ifor #= continue
    	    nop
    	    bne $s2,$a3,ifor #> continue
    	ireturn:
    	    sll $s1,$a3,2
    	    addu $s1,$a0,$s1
    	    sw $t0,0($s1) #v[k]=tmp
    	    lw $ra,0($sp)
            addi $sp,$sp,4
            nop
            nop
    	    jr $ra
