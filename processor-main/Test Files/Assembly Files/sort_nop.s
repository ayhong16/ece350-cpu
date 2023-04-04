nop             # Sort
nop             # Author: Jack Proudfoot
init:
addi $29, $zero, 256        # $29 = 256
addi $27, $zero, 3840       # $27 = 3840 address for bottom of heap
addi $8, $zero, 50
addi $9, $zero, 3
sw $9, 0($8)
addi $9, $zero, 1
sw $9, 1($8)
addi $9, $zero, 4
sw $9, 2($8)
addi $9, $zero, 2
sw $9, 3($8)
add $4, $zero, $8
j main
malloc:                     # $4 = number of words to allocate
sub $27, $27, $4           # allocate $4 words of memory
blt $29, $27, mallocep      # check for heap overflow
mallocep:
add $2, $27, $zero
jr $31
buildlist:                  # $4 = memory address of input data
sw $31, 0($29)
addi $29, $29, 1
add $8, $4, $zero         # index of input data
add $9, $zero, $zero       # current list pointer
addi $4, $zero, 0
jal malloc
addi $11, $2, -3           # list head pointer
lw $10, 0($8)              # load first data value
j blguard
blstart:
addi $4, $zero, 3
jal malloc
sw $10, 0($2)              # set new[0] = data
sw $9, 1($2)              # set new[1] = prev
sw $zero, 2($2)            # set new[2] = next
sw $2, 2($9)              # set curr.next = new
addi $8, $8, 1            # increment input data index
lw $10, 0($8)              # load next input data value
add $9, $zero, $2         # set curr = new
blguard:
bne $10, $zero, blstart
add $2, $11, $zero         # set $2 = list head
addi $29, $29, -1
lw $31, 0($29)
jr $31
sort:                       # $4 = head of list
sw $31, 0($29)
addi $29, $29, 1
sortrecur:
addi $15, $zero, 0          # $15 = 0
add $8, $4, $zero         # $8 = head
add $9, $8, $zero         # $9 = current
j siguard
sortiter:
lw $10, 0($9)              # $10 = current.data
lw $11, 0($14)              # $11 = current.next.data
blt $10, $11, sinext
addi $15, $zero, 1          # $15 = 1
lw $12, 1($9)              # $12 = current.prev
bne $12, $zero, supprev
j supprevd
supprev:
sw $14, 2($12)              # current.prev.next = current.next
supprevd:
sw $12, 1($14)              # current.next.prev = current.prev
lw $13, 2($14)              # $13 = current.next.next
bne $13, $zero, supnnprev
j supnnprevd
supnnprev:
sw $9, 1($13)              # current.next.next.prev = current
supnnprevd:
sw $13, 2($9)              # current.next = current.next.next
sw $9, 2($14)              # current.next.next = current
sw $14, 1($9)              # current.prev = current.next
bne $8, $9, sinext
add $8, $14, $zero         # head = current.next
sinext:
add $9, $14, $zero         # $9 = current.next
siguard:
lw $14, 2($9)              # $14 = current.next
bne $14, $zero, sortiter
add $4, $8, $zero
bne $15, $zero, sortrecur
add $2, $8, $zero         # $2 = head
addi $29, $29, -1
lw $31, 0($29)
jr $31
main:
jal buildlist
add $8, $2, $zero         # $8 = head of list
add $4, $8, $zero         # $4 = head of list
jal sort
add $8, $2, $zero         # $8 = head of sorted list
add $13, $zero, $zero
add $14, $zero, $zero
add $9, $8, $zero
j procguard
proclist:
lw $10, 0($9)
add $13, $13, $10
sll $14, $14, 3
add $14, $14, $13
lw $9, 2($9)
procguard:
bne $9, $zero, proclist
stop:
nop
nop
nop
j stop