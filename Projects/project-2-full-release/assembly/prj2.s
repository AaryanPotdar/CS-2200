! Spring 2024 Revisions

! This program executes pow as a test program using the LC 3300 calling convention
! Check your registers ($v0) and memory to see if it is consistent with this program

! vector table
vector0:
        .fill 0x00000000                        ! device ID 0
        .fill 0x00000000                        ! device ID 1
        .fill 0x00000000                        ! ...
        .fill 0x00000000
        .fill 0x00000000
        .fill 0x00000000
        .fill 0x00000000
        .fill 0x00000000                        ! device ID 7
        ! end vector table

main:	lea $sp, initsp                         ! initialize the stack pointer
        lw $sp, 0($sp)                          ! finish initialization

        addi $t0, $zero, -1                     ! Test shifts and FABs functionality (you can ignore this)
        fabs $t0                                
        addi $t1, $zero, 2                      
        srl $t1, $t0, $t1                       

        lea $t1, ticks                          ! Test additional shifts (you can ignore this)
        lw $t1, 0($t1)                                  
        addi $t0, $zero, 16                     !$t0 = 16
        ror $t1, $t1, $t0                       !$t1 = 0xFFFF0000



        add $zero, $zero, $zero                 ! TODO FIX ME: Install timer interrupt handler into vector table
        lea $t0, timer_handler
        lea $t1, vector0
        sw $t0, 0($t1)

        add $zero, $zero, $zero                 ! TODO FIX ME: Install distance tracker interrupt handler into vector table
        lea $t0, distance_tracker_handler
        lea $t1, vector0
        sw $t0, 1($t1)

        lea $t0, minval
        lw $t0, 0($t0)
	lea $t1, INT_MAX 			! store 0x7FFFFFFF into minval (to initialize)
	lw $t1, 0($t1)
        sw $t1, 0($t0)

        ei                                      ! Enable interrupts

        lea $a0, BASE                           ! load base for pow
        lw $a0, 0($a0)
        lea $a1, EXP                            ! load power for pow
        lw $a1, 0($a1)
        lea $at, POW                            ! load address of pow
        jalr $at, $ra                           ! run pow
        lea $a0, ANS                            ! load base for pow
        sw $v0, 0($a0)

        halt                                    ! stop the program here
        addi $v0, $zero, -1                     ! load a bad value on failure to halt

BASE:   .fill 2
EXP:    .fill 8
ANS:	.fill 0                                 ! should come out to 256 (BASE^EXP)

INT_MAX: .fill 0x7FFFFFFF

POW:    addi $sp, $sp, -1                       ! allocate space for old frame pointer
        sw $fp, 0($sp)

        addi $fp, $sp, 0                        ! set new frame pointer

        bgt $a1, $zero, BASECHK                 ! check if $a1 is zero
        beq $zero, $zero, RET1                  ! if the exponent is 0, return 1

BASECHK:bgt $a0, $zero, WORK                    ! if the base is 0, return 0
        beq $zero, $zero, RET0

WORK:   addi $a1, $a1, -1                       ! decrement the power
        lea $at, POW                            ! load the address of POW
        addi $sp, $sp, -2                       ! push 2 slots onto the stack
        sw $ra, -1($fp)                         ! save RA to stack
        sw $a0, -2($fp)                         ! save arg 0 to stack
        jalr $at, $ra                           ! recursively call POW
        add $a1, $v0, $zero                     ! store return value in arg 1
        lw $a0, -2($fp)                         ! load the base into arg 0
        lea $at, MULT                           ! load the address of MULT
        jalr $at, $ra                           ! multiply arg 0 (base) and arg 1 (running product)
        lw $ra, -1($fp)                         ! load RA from the stack
        addi $sp, $sp, 2

        beq $zero, $zero, FIN                   ! unconditional branch to FIN

RET1:   add $v0, $zero, $zero                   ! return a value of 0
	addi $v0, $v0, 1                        ! increment and return 1
        beq $zero, $zero, FIN                   ! unconditional branch to FIN

RET0:   add $v0, $zero, $zero                   ! return a value of 0

FIN:	lw $fp, 0($fp)                          ! restore old frame pointer
        addi $sp, $sp, 1                        ! pop off the stack
        jalr $ra, $zero

MULT:   add $v0, $zero, $zero                   ! return value = 0
        addi $t0, $zero, 0                      ! sentinel = 0
AGAIN:  add $v0, $v0, $a0                       ! return value += argument0
        addi $t0, $t0, 1                        ! increment sentinel
        bgt $a1, $t0, AGAIN                     ! while sentinel < argument, loop again
        jalr $ra, $zero                         ! return from mult

timer_handler:
        add $zero, $zero, $zero                 ! TODO FIX ME
        addi $sp, $sp, -1
        sw $k0, 0($sp)

        ei

        addi $sp, $sp, -16                      ! save processor registers
        sw $ra, 0($sp)
        sw $fp, 1($sp)
        sw $sp, 2($sp)
        sw $k0, 3($sp)
        sw $s2, 4($sp)
        sw $s1, 5($sp)
        sw $s0, 6($sp)
        sw $t2, 7($sp)
        sw $t1, 8($sp)
        sw $t0, 9($sp)
        sw $a2, 10($sp)
        sw $a1, 11($sp)
        sw $a0, 12($sp)
        sw $v0, 13($sp)
        sw $at, 14($sp)
        sw $zero, 15($sp)

        lea $t0, ticks                          ! update clock counter by 1
        lw $t0, 0($t0)
        lw $t1, 0($t0)
        addi $t1, $t1, 1
        sw $t1, 0($t0)

teardown1:                                      ! restore processor registers
        lw $ra, 0($sp)
        lw $fp, 1($sp)
        lw $sp, 2($sp)
        lw $k0, 3($sp)
        lw $s2, 4($sp)
        lw $s1, 5($sp)
        lw $s0, 6($sp)
        lw $t2, 7($sp)
        lw $t1, 8($sp)
        lw $t0, 9($sp)
        lw $a2, 10($sp)
        lw $a1, 11($sp)
        lw $a0, 12($sp)
        lw $v0, 13($sp)
        lw $at, 14($sp)
        lw $zero, 15($sp)
        addi $sp, $sp, 16

        di                                      ! disable interrupts

        lw $k0, 0($sp)                          ! restore $k0 for RETI
        addi $sp, $sp, 1

        reti


distance_tracker_handler:
        add $zero, $zero, $zero                 ! TODO FIX ME
        addi $sp, $sp, -1
        sw $k0, 0($sp)

        ei

        addi $sp, $sp, -9
        sw $s2, 0($sp)
        sw $s1, 1($sp)
        sw $s0, 2($sp)
        sw $t2, 3($sp)
        sw $t1, 4($sp)
        sw $t0, 5($sp)
        sw $a2, 6($sp)
        sw $a1, 7($sp)
        sw $a0, 8($sp)

        in $t0, 1

	lea $s0, minval
        lw $s0, 0($s0)
        lw $s0, 0($s0)                          ! $s0 holds minval

        lea $t1, maxval
        lw $t1, 0($t1)
        lw $t1, 0($t1)                          ! $t1 holds maxval
	
	lea $a0, INT_MAX
	lw $a0, 0($a0)                          ! lea holds INT_MAX

	beq $a0, $s0, init                      ! check for first Interrut call: minval == INT_MAX

        bgt $t0, $t1, update_max

	bgt $s0, $t0, update_min

	beq $zero, $zero, calc_range


init:
        lea $s0, minval
        lw $s0, 0($s0)
	sw $t0, 0($s0)

        lea $t1, maxval
        lw $t1, 0($t1)
	sw $t0, 0($t1)

	beq $zero, $zero, teardown2

update_max:
        lea $t1, maxval
        lw $t1, 0($t1)
        sw $t0, 0($t1)
        beq $zero, $zero, calc_range


update_min:
        lea $s0, minval
        lw $s0, 0($s0)
        sw $t0, 0($s0)
        beq $zero, $zero, calc_range

calc_range:
        lea $s0, minval
        lw $s0, 0($s0)
        lw $s0, 0($s0)
        nand $s0, $s0, $s0
        addi $s0, $s0, 1

        lea $t1, maxval
        lw $t1, 0($t1)
        lw $t1, 0($t1)
        add $t0, $s0, $t1

        lea $t2, range
        lw $t2, 0($t2)
        sw $t0, 0($t2)

teardown2:
        lw $s2, 0($sp)
        lw $s1, 1($sp)
        lw $s0, 2($sp)
        lw $t2, 3($sp)
        lw $t1, 4($sp)
        lw $t0, 5($sp)
        lw $a2, 6($sp)
        lw $a1, 7($sp)
        lw $a0, 8($sp)
        addi $sp, $sp, 9

        di

        lw $k0, 0($sp)
        addi $sp, $sp, 1
        
        reti                                    ! return from interrupt

initsp: .fill 0xA000
ticks:  .fill 0xFFFF
range:  .fill 0xFFFE
maxval: .fill 0xFFFD
minval: .fill 0xFFFC