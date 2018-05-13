*-----------------------------------------------------------
* Title      :  InputManager.x68
* Written by :  Siddhant Ravi
* Description:  This program contains all functionalities
*               pertaining to taking input from the player
*               at different points in the game.
*-----------------------------------------------------------
*Subroutine to get the input state in the score sceen
IM_GetScoreScreenInputState
        move.l          #$20,d1
        move.l          #IM_GET_INPUT_STATE_TRAP_CODE,d0
        trap            #15
        rts

*Subroutine that makes the call to jump to the Title Screen if spacebar key is pressed in the Score Screen
IM_ScoreScreenInputFunction
        cmp.l           #$FF,d1
        bne             IM_ReturnScoreScreen
        jsr             JumpToTitleScreen
    IM_ReturnScoreScreen:
        rts

*Subroutine that gets the input state in the title screen
IM_GetTitleScreenInputState
        move.l          #$20,d1
        move.l          #IM_GET_INPUT_STATE_TRAP_CODE,d0
        trap            #15
        rts

*Subroutine that makes the call to jump to the Controls Screen if spacebar key is pressed in the Title Screen
IM_TitleScreenInputFunction
        cmp.l           #$FF,d1
        bne             IM_ReturnScoreScreen
        jsr             JumpToControlScreen
    IM_ReturnTitleScreen:
        rts

*Subroutine that gets the input state in the Controls Screen
IM_GetControlScreenInputState
        move.l          #$20,d1
        move.l          #IM_GET_INPUT_STATE_TRAP_CODE,d0
        trap            #15
        rts

*Subroutine that makes the call to jump into the actual game if spacebar key is pressed in the controls screen
IM_ControlScreenInputFunction
        cmp.l           #$FF,d1
        bne             IM_ReturnScoreScreen
        jsr             JumpToGameStart
    IM_ReturnControlScreen:
        rts

*Subroutine that the gets the input state of the player in the game loop
IM_GetInputState
        move.l          #IM_INPUT_SET,d1
        move.l          #IM_GET_INPUT_STATE_TRAP_CODE,d0
        trap            #15
        rts

*Subroutine that, based on the input state, calls appropriate subroutines
IM_PerformInputFunctions
    IM_CheckNoKeyPressed:
        cmp.l           #$0,d1
        beq             IM_Return                               ;If no key is pressed, then simply return
    IM_CheckMoveLeft:
        cmp.b           #$FF,d1                                 ;If the left key is pressed,
        bne             IM_CheckMoveRight
        jsr             SH_MoveLeft                             ;perform the function pertaining to moving left
    IM_CheckMoveRight:
        lsr.l           #8,d1
        cmp.b           #$FF,d1                                 ;If the right key is pressed,
        bne             IM_CheckMoveEsc
        jsr             SH_MoveRight                            ;perform the function pertaining to moving right
    IM_CheckMoveEsc:
        lsr.l           #8,d1
        cmp.b           #$FF,d1                                 ;If the Esc key is pressed in-game,
        bne             IM_UpdateXPosition
        jsr             JumpToTitleScreen                       ;quit to the title screen
    IM_UpdateXPosition:
        jsr             SH_UpdateSuperheroPosition              ;After the inputs have been read and corresponding functions relating to the velocity of the superhero have been performed,
    IM_Return:                                                  ;update the position of the superhero on the screen
        jsr             SH_ResetVelocity                        ;Reset the velocity for the next round of calculations
        rts
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
