*-----------------------------------------------------------
* Title      :  SevenSegmentScoreDisplay.x68
* Written by :  Siddhant Ravi
* Description:  This program contains all the subroutines
*               that are required for printing out the final
*               score of the user in the form of a seven-
*               segment display in the score screen on the
*               console window.
*-----------------------------------------------------------
*Subroutine to get convert the score into a representation of hundreds, tens and units
SD_GetScoreSplit
        move.l      #$00ffffff,d1                               ;Set the pen color for the seven segment display
        move.l      #80,d0
        trap        #15
    SD_GetHundredsPlace:
        clr.l       d0
        move.w      (Superhero_Score),d0
        divu.w      #100,d0
        move.b      d0,(SD_Score_HundredsPlace)
    SD_GetTensPlace:
        swap.w      d0
        ext.l       d0
        divu.w      #10,d0
        move.b      d0,(SD_Score_TensPlace)
    SD_GetUnitsPlace:
        swap.w      d0
        move.b      d0,(SD_Score_UnitsPlace)
        rts

*Subroutine to draw the seven segment display of the hundreds place
SD_DrawHundredsPlace
        lea         SD_SegmentTable,a1
        move.b      (SD_Score_HundredsPlace),d0
        ext.l       d0
        move.b      (a1,d0),d5
        lea         SD_SegmentOffsets,a3
        move.b      #0,d6
    SD_LoopHundred:
        move.l      (a0,d6),a2
        btst.l      #0,d5
        beq         SD_ContinueHundred
        jsr         SD_DrawHundredsSegment
    SD_ContinueHundred:
        lsr.l       #1,d5
        add.b       #4,d6
        add.l       #8,a3
        cmpi.b      #28,d6
        blt         SD_LoopHundred
        rts

*Subroutine to draw a segment at the offset defined by the hundreds place
SD_DrawHundredsSegment
        move.w      (a3),d1
        move.w      2(a3),d2
        move.w      4(a3),d3
        move.w      6(a3),d4
        add.w       #SD_HUNDREDS_POSITION_X,d1
        add.w       #SD_HUNDREDS_POSITION_Y,d2
        add.w       #SD_HUNDREDS_POSITION_X,d3
        add.w       #SD_HUNDREDS_POSITION_Y,d4
        move.l      #84,d0
        trap        #15
        rts

*Subroutine to draw the seven segment display of the tens place
SD_DrawTensPlace
        lea         SD_SegmentTable,a1
        move.b      (SD_Score_TensPlace),d0
        ext.l       d0
        move.b      (a1,d0),d5
        lea         SD_SegmentOffsets,a3
        move.b      #0,d6
    SD_LoopTens:
        move.l      (a0,d6),a2
        btst.l      #0,d5
        beq         SD_ContinueTens
        jsr         SD_DrawTensSegment
    SD_ContinueTens:
        lsr.l       #1,d5
        add.b       #4,d6
        add.l       #8,a3
        cmpi.b      #28,d6
        blt         SD_LoopTens
        rts

*Subroutine to draw a segment at the offset defined by the tens place
SD_DrawTensSegment
        move.w      (a3),d1
        move.w      2(a3),d2
        move.w      4(a3),d3
        move.w      6(a3),d4
        add.w       #SD_TENS_POSITION_X,d1
        add.w       #SD_TENS_POSITION_Y,d2
        add.w       #SD_TENS_POSITION_X,d3
        add.w       #SD_TENS_POSITION_Y,d4
        move.l      #84,d0
        trap        #15
        rts
        
*Subroutine to draw the seven segment display of the units place
SD_DrawUnitsPlace
        lea         SD_SegmentTable,a1
        move.b      (SD_Score_UnitsPlace),d0
        ext.l       d0
        move.b      (a1,d0),d5
        lea         SD_SegmentOffsets,a3
        move.b      #0,d6
    SD_LoopUnits:
        move.l      (a0,d6),a2
        btst.l      #0,d5
        beq         SD_ContinueUnits
        jsr         SD_DrawUnitsSegment
    SD_ContinueUnits:
        lsr.l       #1,d5
        add.b       #4,d6
        add.l       #8,a3
        cmpi.b      #28,d6
        blt         SD_LoopUnits
        rts

*Subroutine to draw a segment at the offset defined by the units place
SD_DrawUnitsSegment
        move.w      (a3),d1
        move.w      2(a3),d2
        move.w      4(a3),d3
        move.w      6(a3),d4
        add.w       #SD_UNITS_POSITION_X,d1
        add.w       #SD_UNITS_POSITION_Y,d2
        add.w       #SD_UNITS_POSITION_X,d3
        add.w       #SD_UNITS_POSITION_Y,d4
        move.l      #84,d0
        trap        #15
        rts

*The variables and constants are defined below
SD_SegmentTable         dc.b    $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$6F                 ;The segment table defines the segments that are to be drawn for each digit. Each bit represents whether the corresponding segment is drawn or not

SD_SegmentOffsets       dc.w    -15,-20,15,-20
                        dc.w    17,-18,17,-3
                        dc.w    17,3,17,18
                        dc.w    -15,20,15,20
                        dc.w    -18,3,-18,18
                        dc.w    -18,-18,-18,-3
                        dc.w    -15,0,15,0

SD_Score_UnitsPlace        ds.b    1
SD_Score_TensPlace         ds.b    1
SD_Score_HundredsPlace     ds.b    1
blah                        ds.b    1













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
