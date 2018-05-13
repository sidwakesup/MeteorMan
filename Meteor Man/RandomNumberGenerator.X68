*-----------------------------------------------------------
* Title      :  RandomNumberGenerator.x68
* Written by :  Siddhant Ravi
* Description:  This program has subroutines that are
*               capable of generating random bytes and
*               random words.
*-----------------------------------------------------------
*Subroutine to make the random number generator improve its randomization capabilities
RNG_PumpTheRandomNumberGenerator
        jsr         RNG_SeedRandomNumber
        clr.l       d6
        jsr         RNG_GetRandomByteIntoD6
        clr.l       d6
        jsr         RNG_GetRandomByteIntoD6
        clr.l       d6
        jsr         RNG_GetRandomByteIntoD6
        clr.l       d6
        jsr         RNG_GetRandomByteIntoD6
        clr.l       d6
        jsr         RNG_GetRandomByteIntoD6
        clr.l       d6
        jsr         RNG_GetRandomByteIntoD6
        clr.l       d6
        rts

*Subroutine that assigns the seed for the algorithm to generate random numbers. We use time as a seed here
RNG_SeedRandomNumber
        movem.l     RNG_ALL_REG,-(sp)
        clr.l       d6
        move.b      #RNG_GET_TIME_COMMAND,d0
        trap        #15
        move.l      d1,RNG_RandomVal
        movem.l     (sp)+,RNG_ALL_REG
        rts

*Subroutine to get a random byte
RNG_GetRandomByteIntoD6
        movem.l     d0,-(sp)
        movem.l     d1,-(sp)
        movem.l     d2,-(sp)
        move.l      RNG_RandomVal,d0
        moveq       #$AF-$100,d1
        moveq       #18,d2
    Ninc0:
        add.l       d0,d0
        bcc         Ninc1
        eor.b       d1,d0
    Ninc1:
        dbf         d2,Ninc0
        move.l      d0,RNG_RandomVal
        clr.l       d6
        move.b      d0,d6
        movem.l     (sp)+,d2
        movem.l     (sp)+,d1
        movem.l     (sp)+,d0
        rts

*Subroutine to get a random word
RNG_GetRandomWord
        movem.l     RNG_ALL_REG,-(sp)
        jsr         RNG_GetRandomByteIntoD6
        move.b      d6,d5
        jsr         RNG_GetRandomByteIntoD6
        lsl.l       #8,d5
        move.b      d6,d5
        move.w      d5,RNG_TempRandomWord
        movem.l     (sp)+,RNG_ALL_REG
        rts

*Variables and constants are defined below
RNG_RandomVal       ds.l        1                                   ;Used in generating random bytes
RNG_TempRandomWord  ds.w        1                                   ;The random word is stored in this variable
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
