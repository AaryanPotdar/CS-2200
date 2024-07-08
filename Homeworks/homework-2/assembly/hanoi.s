!============================================================
! CS 2200 Homework 2 Part 2: Tower of Hanoi
!
! Apart from initializing the stack,
! please do not edit mains functionality. You do not need to
! save the return address before jumping to hanoi in
! main.
!============================================================

main:
    add     $zero, $zero, $zero     ! TODO: Here, you need to get the address of the stack
                                    ! using the provided label to initialize the stack pointer.
    lea     $sp, stack              ! load the label address into $sp and in the next instruction,
    lw      $sp, 0($sp)             ! use $sp as base register to load the value (0xFFFF) into $sp.


    lea     $at, hanoi              ! loads address of hanoi label into $at - (Target address reg)

    lea     $a0, testNumDisks2      ! loads address of number into $a0
    lw      $a0, 0($a0)             ! loads value of number into $a0 --> $a0 holds n

    jalr    $at, $ra                ! jump to hanoi, set $ra to return addr
    halt                            ! when we return, just halt

hanoi:                              ! hanoi is callee. Main is caller
                                    ! (A) callee stores prev frame pointer
                                    ! then (B) copies contents of stack pointer into frame pointer
    add     $zero, $zero, $zero     ! 
    sw      $fp, -1($sp)            ! (A) put current frame pointer on stack
    addi    $sp, $sp, -1            ! allocate space for return address
    add     $fp, $sp, $zero         ! (B) set frame pointer to stck ptr (top of stack)

    addi    $t0, $a0, 0
    addi    $t1, $zero, 1           ! t0 holds value 1 -> compare this value to a0
    beq     $t0, $t1, base          ! IF ($a0 == 1) GOTO base
                                    !    
    beq     $zero, $zero, else      ! ELSE GOTO else
                                    !    

else:
    add     $zero, $zero, $zero
    addi    $a0, $a0, -1            ! $a0 holds value of n. Decrement by 1 -> (n-1)
                                    !
    lea     $at, hanoi              ! load address of hanoi into Target Address register
    addi    $sp, $sp, -1            ! allocate space for return address again
    sw      $ra, 0($sp)             ! save previous return address
    
    jalr    $at, $ra                ! jump to hanoi routine (recursive call on (n-1))
    
    lw      $ra, 0($sp)             ! return address from stack restored
    addi    $sp, $sp, 1             ! restore stack pointer

    addi    $t2, $zero, 1
    sll     $v0, $v0, $t2           ! TODO: Implement the following pseudocode in assembly:
    addi    $v0, $v0, 1             ! $v0 = 2 * $v0 + 1 
    beq     $zero, $zero, teardown  ! RETURN $v0

base:
    add     $zero, $zero, $zero
    addi    $v0, $zero, 1           ! Return 1. Note: $v0 stores the return value
    beq     $zero, $zero, teardown

teardown:
    add     $sp, $fp, $zero         ! stack pointer points to where frame pointer is (start of activation record)
    lw      $fp, 0($sp)             ! load frame ptr (stck ptr now points to it)
    addi    $sp, $sp, 1             ! pop stack ptr to de-allocte space
    jalr    $ra, $zero              ! return to caller with simple jump -> returning to address in $ra. $zero has no effect



stack: .word 0xFFFF                 ! the stack begins here


! Words for testing \/

! 1
testNumDisks1:
    .word 0x0001

! 10
testNumDisks2:
    .word 0x000a

! 20
testNumDisks3:
    .word 0x0014
