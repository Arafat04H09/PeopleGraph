############## Arafat Hossain ##############
############## 113764123 #################
############## arhossain ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person: #java -jar munit.jar tests/Hw4Test.class hw4.asm
lw $t0, 0($a0) #max nodes
lw $t1, 16($a0)    #current number nodes

beq $t0, $t1, full #check if network is full

addi $t3, $t1, 1
sb $t3, 16($a0) #increment count by 1

lw $t2, 8($a0) #size of node
mul $t2, $t1, $t2 #hold the current space taken

addi $t2, $t2, 36
add $a0, $a0, $t2

li $t2, 0
sb $t2, 0($a0) #create person

move $v0, $a0
j done1

full:
li $v0, -1

done1:
  jr $ra

.globl is_person_exists
is_person_exists:
lw $t0, 8($a0) #size of each node 
lw $t1, 16($a0) #number of nodes

addi $a0, $a0, 36 

checkLoop:
beqz $t1, DNE #gone to the end without it existing
beq $a1, $a0, exists #node is found
add $a0, $a0, $t0
addi $t1, $t1, -1
j checkLoop

exists:
li $v0, 1
j done2

DNE: 
li $v0, 0

done2:
  jr $ra

.globl is_person_name_exists
is_person_name_exists:
lw $t0, 8($a0)
lw $t1, 16($a0)

addi $t2, $a0, 36
move $t3, $a1
li $t5, 0

checkName:
lb $t6, 0($t3)
beqz $t6, goNextStep
addi $t5, $t5, 1
addi $t3, $t3, 1
j checkName

goNextStep:
beqz $t1, notFound
li $t6, 0
add $t6, $t5, $t6
li $t4, 0
add $t4, $t4, $t2
li $t3, 0
add $t3, $t3, $a1

checkName2:
lb $t7, 0($t4)
lb $t8, 0($t3)
beqz $t7, checkNext
bne $t7, $t8, checkNext
addi $t6, $t6, -1
addi $t4, $t4, 1
addi $t3, $t3, 1
j checkName2
checkNext:
beqz $t6, found
notDone:
addi $t1, $t1, -1
add $t2, $t2, $t0
j goNextStep

found:
bne $t7, $0, notDone
move $v1, $t2
li $v0, 1
j done3

notFound:
li $v0, 0

done3:
jr $ra

.globl add_person_property
add_person_property:
move $s3, $a0
move $s4, $a1
move $s5, $a2
move $s6, $a3
move $s7, $ra

li $t0, 'N'
lb $t1, 0($a2)
bne $t0, $t1, errorOne
li $t0, 'A'
lb $t1, 1($a2)
bne $t0, $t1, errorOne
li $t0, 'M'
lb $t1, 2($a2)
bne $t0, $t1, errorOne
li $t0, 'E'
lb $t1, 3($a2)
bne $t0, $t1, errorOne

jal is_person_exists

beqz $v0, errorTwo
move $a0, $s3
move $a1, $s4
move $a2, $s5
move $a3, $s6
move $ra, $s7

move $t0, $a3
li $t1, 0 #count
countLoop:
lb $t2, 0($t0)
beqz $t2, doneCount
addi $t1, $t1, 1
addi $t0, $t0, 1
j countLoop

doneCount:
lw $t0, 8($a0)
bge $t1, $t0, errorThree
move $t6, $t1

move $a1, $a3
jal is_person_name_exists
bnez $v0, errorFour
move $a0, $s3
move $a1, $s4
move $a2, $s5
move $a3, $s6
move $ra, $s7

saveLoop:
beqz $t6, done44
lb $t2, 0($a3)
sb $t2, 0($a1)
addi $t6, $t6, -1
addi $a3, $a3, 1
addi $a1, $a1, 1
j saveLoop

done44:
li $v0, 1
j done4
errorOne:
li $v0, 0
j done4

errorTwo:
li $v0, -1
j done4

errorThree:
li $v0, -2
j done4

errorFour:
li $v0, -3 

done4:
move $ra, $s7
jr $ra

.globl get_person
get_person:
addi $sp, $sp, -4
sw $ra, 0($sp)

jal is_person_name_exists

beqz $v0, noPerson

move $v0, $v1
j done5

noPerson:
li $v0, 0

done5:
lw $ra, 0($sp)
addi $sp, $sp, 4

jr $ra

.globl is_relation_exists
is_relation_exists:
lw $s0, 20($a0) #num edges
lw $t0, 8($a0) #size of node
lw $t1, 0($a0) #num nodes

mul $t1, $t1, $t0 #size of node array

addi $t2, $a0, 36
add $t2, $t2 $t1 #gone to start od edge array

checkEdgeLoop:
beqz $s0, noRelation
lw $t0, 0($t2) #first person
lw $t1, 4($t2) #second person

beq $t0, $a1, checkSecond 
beq $t0, $a2, checkFirst
j goNext

checkSecond:
beq $t1, $a2, found6
j goNext

checkFirst:
beq $t1, $a1, found6
j goNext

goNext:
addi $s0, $s0, -1
addi $t2, $t2, 12 
j checkEdgeLoop

found6:
li $v0, 1
j done6

noRelation:
li $v0, 0

done6:
li $s0, 0
 jr $ra

.globl add_relation
add_relation:
move $s3, $a0
move $s4, $a1
move $s5, $a2
move $s6, $ra

#condition 1
move $a0, $a0
move $a1, $a1
jal is_person_exists
beqz $v0, error1
move $a0, $s3
move $a1, $s4
move $a2, $s5
move $ra, $s6

move $a1, $a2
jal is_person_exists
beqz $v0, error1
move $a0, $s3
move $a1, $s4
move $a2, $s5
move $ra, $s6

#condition 2
lb $t5, 4($a0)
lb $t6, 20($a0)

beq $t5, $t6, error2

#condition 3
jal is_relation_exists
move $a0, $s3
move $a1, $s4
move $a2, $s5
move $ra, $s6
bnez $v0, error3

#condition 4
beq $a1, $a2, error4

#no error so continue
lw $t5, 8($a0)
lw $t6, 0($a0)

mul $t5, $t6, $t5

addi $t7, $a0, 36 #start of node array
add $t7, $t7, $t5 #end of node array

lw $t5, 20($a0)
li $t6, 12
mul $t5, $t6, $t5

add $t7, $t7, $t5 #end of edge array

sw $a1, 0($t7)
sw $a2, 4($t7)
lw $t5, 20($a0)
addi $t5, $t5,1
sw $t5, 20($a0)
li $v0, 1

j done7

error1:
li $v0, 0
j done7
error2:
li $v0, -1
j done7
error3:
li $v0, -2
j done7
error4:
li $v0, -3
j done7

done7:
li $s3, 0
li $s4, 0
move $ra, $s6
li $s5, 0
li $s6, 0
jr $ra

.globl add_relation_property
add_relation_property:
move $s3, $a0
move $s4, $a1
move $s5, $a2
move $s6, $a3
move $s7, $ra

jal is_relation_exists
beqz $v0, error11
move $a0, $s3
move $a1, $s4
move $a2, $s5
move $a3, $s6
move $ra, $s7

li $t0, 'F'
lb $t1, 0($a3)
bne $t0, $t1, error22
li $t0, 'R'
lb $t1, 1($a3)
bne $t0, $t1, error22
li $t0, 'I'
lb $t1, 2($a3)
bne $t0, $t1, error22
li $t0, 'E'
lb $t1, 3($a3)
bne $t0, $t1, error22
li $t0, 'N'
lb $t1, 4($a3)
bne $t0, $t1, error22
li $t0, 'D'
lb $t1, 5($a3)
bne $t0, $t1, error22

#ELSE ADD RELATION

li $t1, 1
sw $t1, 8($t2)
j done8

error11:
li $v0, 0
j done8

error22:
li $v0, -1

done8:
move $ra, $s7

  jr $ra

.globl is_friend_of_friend
is_friend_of_friend:
move $s3, $a0
move $s4, $a1
move $s5, $a2
move $s6, $ra
jal is_person_name_exists 
beqz $v0, doesNotExist
move $s4, $v1
move $a0, $s3
move $a1, $s4
move $a2, $s5

move $a1, $a2
jal is_person_name_exists
beqz $v0, doesNotExist
move $s5, $v1  
move $a0, $s3
move $a1, $s4
move $a2, $s5

jal is_relation_exists
lw $t4, 8($t2)
bnez, $t4, notFound9
move $a0, $s3
move $a1, $s4
move $a2, $s5

move $t0, $a0
lw $t1, 0($a0)
lw $t2, 8($a0)
lw $t7, 20($a0) #count of edges
mul $t1, $t1, $t2

addi $t5, $t0, 36
add $t5, $t5, $t1 #go to edge array

checkEdges:
beqz $t7, notFound9

lw $t4, 0($t5) #first edge
beq $t4, $a1, case1
beq $t4, $a2, case2
lw $t4, 4($t5)
beq $t4, $a1, case3
beq $t4, $a2, case4
j goNextEdge

case1:
lw $t4, 4($t5)
move $a1, $t4
jal is_relation_exists
beqz $v0, goNextEdge
li $t0, 1
lw $t1, 8($t2)
beq $t1, $t0, found9
j goNextEdge

case2:
lw $t4, 4($t5)
move $a2, $t4
jal is_relation_exists
beqz $v0, goNextEdge
li $t0, 1
lw $t1, 8($t2)
beq $t1, $t0, found9
j goNextEdge

case3:
lw $t4, 0($t5)
move $a1, $t4
jal is_relation_exists
beqz $v0, goNextEdge
li $t0, 1
lw $t1, 8($t2)
beq $t1, $t0, found9
j goNextEdge

case4:
lw $t4, 0($t5)
move $a2, $t4
jal is_relation_exists
beqz $v0, goNextEdge
li $t0, 1
lw $t1, 8($t2)
beq $t1, $t0, found9
j goNextEdge

goNextEdge:
move $a0, $s3
move $a1, $s4
move $a2, $s5
addi $t5, $t5, 12
addi $t7, $t7, -1
j checkEdges

doesNotExist:
li $v0, -1
j done9

found9:
li $v0, 1
j done9

notFound9:
li $v0, 0
j done9

done9:
move $ra, $s6
  jr $ra
