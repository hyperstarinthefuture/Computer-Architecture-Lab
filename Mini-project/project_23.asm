#----------------------------------------------------------
# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project 23: Surpassing Words
#
# Surpassing words are English words for which the gap between each adjacent pair of letters strictly increases. 
# These gaps are computed without "wrapping around" from Z to A.
#-----------------------------------------------------------

#-----------------------------------------------------------
# @input: mot tu bat ky luu vao input_word
# @idea: 
#	Buoc 1: Su dung 1 vong lap for tu i = 0 cho den i = n - 2 de so sanh 2 ky tu dung lien nhau
#		Moi lan so sanh 2 ki tu lien nhau => Luu vao mang gap_length
#		Trong truong hop so am => Dao dau sang so duong
#	Buoc 2: Duyet mang gap_length kiem tra
#		Neu gap bat ki truong hop nao ma gap_length[i] > gap_length[i+1] => FALSE
#		Duyet het mang ma khong gap truong hop tren => TRUE
#-----------------------------------------------------------

.data
	# Chu y so luong phan tu cua tu
	# input_word: .asciiz "superb"
	input_word: .asciiz "excellent"
	
	true: .asciiz "True"
	false: .asciiz "False"
	gap_length: .word

.text
main:
	# addi $a0, $zero, 6	# n: So cac ki tu cua input_word
	addi $a0, $zero, 9	# n: So cac ki tu cua input_word
	
	la $a1, input_word	# vi tri cua input_word
	la $a2, gap_length	# vi tri cua gap_length

	
	jal check
	nop

	beq $v0, $zero, false_answer

true_answer:
	li $v0, 55
	la $a0, true
	syscall
	j end_main
	
false_answer:
	li $v0, 55
	la $a0, false
	syscall
	
end_main:
	li $v0, 10
	syscall
	
	
#-----------------------------------------------------------
# @check: Kiem tra xem co phai Surpassing words hay khong
#-----------------------------------------------------------


#-----------------------------------------------------------
# Buoc 1: Su dung 1 vong lap for tu i = 0 cho den i = n - 2 de so sanh 2 ky tu dung lien nhau
#	  Moi lan so sanh 2 ki tu lien nhau => Luu vao mang gap_length
#	  Trong truong hop so am => Dao dau sang so duong
#-----------------------------------------------------------

check:
	addi $t0, $zero, 0 	# i = 0	
	sub $t1, $a0, 1		# $t1 = n - 1
loop:
	
	addi $t4, $t0, 1	# j = i + 1
	
	add $s0, $a1, $t0
	lb $s0, 0($s0)		# A[i]
	
	add $s1, $a1, $t4
	lb $s1, 0($s1)		# A[i+1]
	
	sub $s2, $s0, $s1 
	
	slt $t5, $s2, $zero	# if $s2 > 0 => 0
	beq $t5, $zero, continue
	
	nor $s2, $s2, $zero	# Neu $s2 < 0 => Dao dau $s2 => Duong
	add $s2, $s2, 1
	

continue:
	add $t2, $t0, $a2
	sb $s2, 0($t2)
	
	addi $t0, $t0, 1	# i = i + 1
	slt $t3, $t0, $t1	# i < n - 1 => 1; false => 0
	beq $t3, $zero, end_loop
	j	loop
	
end_loop:

#-----------------------------------------------------------
# Buoc 2: Duyet mang gap_length kiem tra
#	  Neu gap bat ki truong hop nao ma gap_length[i] > gap_length[i+1] => FALSE
#	  Duyet het mang ma khong gap truong hop tren => TRUE
#-----------------------------------------------------------

	addi $t0, $zero, 0 	# i = 0	
	sub $t1, $a0, 2		# $t1 = n - 2

loop_2:	
	addi $t4, $t0, 1	# i + 1
	
	add $s0, $a2, $t0
	lb $s0, 0($s0)		# gap_length[i]
	
	add $s1, $a2, $t4
	lb $s1, 0($s1)		# gap_length[i+1]
	
	slt $t2, $s0, $s1	# gap_length[i] < gap_length[i+1] => 1
	beq $t2, $zero, return_false
	
	addi $t0, $t0, 1	# i = i + 1
	slt $t3, $t0, $t1	# i < n - 2 => 1; false => 0
	beq $t3, $zero, end_loop_2
	
	j   loop_2
end_loop_2:
	
return_true:
	addi $v0, $zero, 1
	jr 	$ra
return_false:
	addi $v0, $zero, 0
	jr 	$ra
	
#-----------------------------------------------------------
# END
#-----------------------------------------------------------