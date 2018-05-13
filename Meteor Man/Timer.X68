*-----------------------------------------------------------
* Title      :  Timer.x68
* Written by :  Siddhant Ravi
* Description:  The timer program is used to obtain the delta
*               time for various operations regarding physics
*-----------------------------------------------------------
*Subroutine to get the delta time and store it in the T_DeltaTime variable declared below
T_GetDeltaTime
    move.l          #T_GET_TIME_TRAP_CODE,d0                    ;Trap to get the time since midnight in hundredths of seconds
    trap            #15
    lea             T_CurrentTime,a1
    move.l          d1,(a1)                                     ;Store this time value into T_CurrentTime
    lea             T_DeltaTime,a2
    lea             T_PreviousTime,a3
    sub.l           (a3),d1                                     ;Subtract current time from previous time to get delta time
    move.w          d1,(a2)                                     ;Store the calculated delta time into the T_DeltaTime variable
    move.l          (a1),(a3)                                   ;Current time now becomes previous time for the next delta time calculation
    rts

*Subroutine to reset the value of all variables when restarting the game
T_ResetVariables
    move.l          #0,(T_PreviousTime)
    move.l          #0,(T_CurrentTime)
    rts

*Variables and constants are defined below
T_PreviousTime            dc.l        0                         ;The current time from the previous calculation is stored in this variable
T_CurrentTime             dc.l        0                         ;The current time in the present calculation is stored in this variable
T_DeltaTime               ds.w        1                         ;The calculated delta time is stored in this variable















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
