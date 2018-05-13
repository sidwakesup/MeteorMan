*-----------------------------------------------------------
* Title      :  Main.x68
* Written by :  Siddhant Ravi
* Description:  This program contains the actual game loop
*               and uses the subrountines of the other program
*               files by including them as shown below.
*-----------------------------------------------------------
    ORG    $1000                                                ;Set the origin of the source code
*Include all the x68 files that contain the required subroutines
    INCLUDE     "Utility.x68"
    INCLUDE     "ControlScreen.x68"
    INCLUDE     "ScoreScreen.x68"
    INCLUDE     "MainModules.x68"
    INCLUDE     "TitleScreen.x68"
    INCLUDE     "InputManager.x68"
    INCLUDE     "Background.x68"
    INCLUDE     "Timer.x68"
    INCLUDE     "RandomNumberGenerator.x68"
    INCLUDE     "Superhero.x68"
    INCLUDE     "Meteor.x68"
    INCLUDE     "SevenSegmentScoreDisplay.x68"
*The actual program starts here
START                                                           ;First line of source
        move.b          #DRAWING_MODE_TRAP_CODE,d0              ;We set the drawing mode of the screen to
        move.b          #DOUBLE_BUFFERED_MODE,d1                ;double buffered mode
        trap            #15
*This section of code pertains to the first screen that loads up in the game - the Title Screen.
    TitleScreen:
        jsr             ClearScreen                             ;Clear the screen by using the appropriate trap call
        move.l          #16,d0                                  ;We need this much space on the stack for parameters
        sub.l           d0,sp                                   ;Offset the stack pointer by this required amount
        jsr             TS_StoreOffsetToPixelData               ;Store the offset to the starting location of the pixel data array in the bmp file
        jsr             TS_StoreImageWidthAndHeight             ;Retrieve the image width and height from the file format of the bmp file
        jsr             TS_CalculateRowSizeAndPadding           ;Use the information in the file header to calculate the row size of the pixel array and the padding in the bmp file
        jsr             InitializeTitleScreenParameters         ;Push the parameters required to render the bmp onto the stack to be used by the respective subroutine
        jsr             TS_RenderBitmap                         ;Subroutine to render the bitmap with specifications provided as parameters in the stack
        add.l           #16,sp                                  ;Reset the stack pointer
        jsr             SwapBuffers                             ;Subroutine to swap the frame buffer (due to double buffered mode)
*This section of code pertains to waiting for the user to press the spacebar key to trigger the transition to the next screen
    GetTitleScreenInput:
        jsr             IM_GetTitleScreenInputState             ;Subroutine to check whether the user is pressing the spacebar key
        jsr             IM_TitleScreenInputFunction             ;If user is pressing the spacebar key, move on to the controls description screen
        bra             GetTitleScreenInput                     ;If not, continue checking whether user is pressing spacebar key until it is pressed
*This section of code pertains to the screen that provides a description of the controls - the Control Screen
    ControlScreen:
        jsr             ClearScreen                             ;Clear the screen by using the appropriate trap call
        move.l          #16,d0                                  ;We need this much space on the stack for parameters
        sub.l           d0,sp                                   ;Offset the stack pointer by this required amount
        jsr             CS_StoreOffsetToPixelData               ;Store the offset to the starting location of the pixel data array in the bmp file
        jsr             CS_StoreImageWidthAndHeight             ;Retrieve the image width and height from the file format of the bmp file
        jsr             CS_CalculateRowSizeAndPadding           ;Use the information in the file header to calculate the row size of the pixel array and the padding in the bmp file
        jsr             InitControlScreenParameters             ;Push the parameters required to render the bmp onto the stack to be used by the respective subroutine
        jsr             CS_RenderBitmap                         ;Subroutine to render the bitmap with specifications provided as parameters in the stack
        add.l           #16,sp                                  ;Reset the stack pointer
        jsr             SwapBuffers                             ;Subroutine to swap the frame buffer (due to double buffered mode)
*This section of code pertains to waiting for the user to press the spacebar key to trigger the transition to the actual game
    GetControlScreenInput:
        jsr             IM_GetControlScreenInputState           ;Subroutine to check whether the user is pressing the spacebar key
        jsr             IM_ControlScreenInputFunction           ;If user is pressing the spacebar key, move on to the actual game loop
        bra             GetControlScreenInput                   ;If not, continue checking whether user is pressing spacebar key until it is pressed
*This section of code pertains to setting up the first frame before the game loop starts. It includes certain intializations and trap calls
    GameStart:
        jsr             ClearScreen                             ;Clear the screen by using the appropriate trap call
        jsr             RNG_PumpTheRandomNumberGenerator        ;Subroutine to make the random number generator improve its randomization capabilities
        move.l          #16,d0                                  ;We need this much space on the stack for parameters
        sub.l           d0,sp                                   ;Offset the stack pointer by this required amount        
        jsr             BG_StoreOffsetToPixelData               ;Store the offset to the starting location of the pixel data array in the bmp file
        jsr             BG_StoreImageWidthAndHeight             ;Retrieve the image width and height from the file format of the bmp file
        jsr             BG_CalculateRowSizeAndPadding           ;Use the information in the file header to calculate the row size of the pixel array and the padding in the bmp file
        jsr             InitializeBackgroundParameters          ;Push the parameters required to render the bmp onto the stack to be used by the respective subroutine                
        jsr             BG_RenderBitmap                         ;Subroutine to render the bitmap with specifications provided as parameters in the stack
        add.l           #16,sp                                  ;Reset the stack pointer
        jsr             SwapBuffers                             ;Subroutine to swap the frame buffer (due to double buffered mode)
        move.l          #T_GET_TIME_TRAP_CODE,d0                ;Trap code to get the time in hundredths of seconds since midnight
        trap            #15
        move.l          d1,(T_PreviousTime)                     ;We store this time in T_PreviousTime to calculate T_DeltaTime for the first time
*The actual game loop. This entire section of code keeps looping until the game over condition (death of the player character) is satisfied
    GameLoop:
        jsr             T_GetDeltaTime                          ;Subroutine to get the delta time
        jsr             UpdateBitmapBasedOnSuperhero            ;Renders the part of the background that is now no longer hidden by the player character sprite
        jsr             UpdateBitmapBasedOnMeteors              ;Renders the parts of the background that are now no longer hidden by the meteors on the screen
        jsr             M_AssignMeteorStartingLocations         ;Checks if there are any meteors with an unassigned starting location and assigns them a random spawn location at the top of the screen
        jsr             M_MoveDown                              ;Updates the velocity of the meteors by applying gravity to each of them
        jsr             M_UpdateMeteorPosition                  ;Updates the position of the meteors based on their current velocity
        jsr             M_CheckMeteorCollisionGround            ;Checks if any of the meteors are colliding with the ground
        jsr             IM_GetInputState                        ;Tracks a set of keys and checks whether they are being pressed by the user
        jsr             IM_PerformInputFunctions                ;Based on the keys pressed, this function performs respective functions
        jsr             SH_RenderBitmap                         ;Renders the superhero (player character) bitmap
        jsr             M_RenderMeteors                         ;Renders the meteors
        jsr             M_CheckMeteorCollisionPlayer            ;Checks whether any of the meteors are colliding with the player, which can lead to a potential game over condition
        jsr             SH_CheckPlayerDead                      ;Checks if the player is alive or dead
        jsr             SwapBuffers                             ;Subroutine to swap the frame buffer (due to double buffered mode)
        bra             GameLoop                                ;Branch back to the beginning of the game loop
*This section of code is triggered once the game over condition is met in the GameLoop
    ScoreScreen:
        jsr             ClearScreen                             ;Clear the screen by using the appropriate trap call
        move.l          #16,d0                                  ;We need this much space on the stack for parameters
        sub.l           d0,sp                                   ;Offset the stack pointer by this required amount
        jsr             SS_StoreOffsetToPixelData               ;Store the offset to the starting location of the pixel data array in the bmp file
        jsr             SS_StoreImageWidthAndHeight             ;Retrieve the image width and height from the file format of the bmp file
        jsr             SS_CalculateRowSizeAndPadding           ;Use the information in the file header to calculate the row size of the pixel array and the padding in the bmp file
        jsr             InitScoreScreenParameters               ;Push the parameters required to render the bmp onto the stack to be used by the respective subroutine
        jsr             SS_RenderBitmap                         ;Subroutine to render the bitmap with specifications provided as parameters in the stack
        add.l           #16,sp                                  ;Reset the stack pointer
        jsr             SD_GetScoreSplit                        ;Separate the score into units, tens and hundreds place
        jsr             SD_DrawHundredsPlace                    ;Draw the seven segment display for the hundreds place,
        jsr             SD_DrawTensPlace                        ;tens place, and
        jsr             SD_DrawUnitsPlace                       ;units place
        jsr             SwapBuffers                             ;Swap the buffers
*This section of code waits for the user to press the spacebar key at the score display screen to go back to the title screen
    GetScoreScreenInput:
        jsr             IM_GetScoreScreenInputState             ;Subroutine to check whether the user is pressing the spacebar key
        jsr             IM_ScoreScreenInputFunction             ;If user is pressing the spacebar key, move on to the controls description screen
        bra             GetScoreScreenInput                     ;If not, continue checking whether user is pressing spacebar key until it is pressed

*Subroutine that makes the transition back to the Title Screen
JumpToTitleScreen
        jsr             M_ResetVariables                        ;Resets the values of all the variables in the Meteor program
        jsr             SH_ResetVariables                       ;Resets the values of all the variables in the Superhero program
        jsr             T_ResetVariables                        ;Resets the values of all the variables in the Timer program
        bra             TitleScreen                             ;Branch back to the TitleScreen
        rts

*Subroutine that makes the transition to the Score Screen
JumpToScoreDisplay
        bra             ScoreScreen                             ;Branch to the ScoreScreen
        rts

*Subroutine that makes the transition to the Game Start
JumpToGameStart
        bra             GameStart                               ;Branch to the GameStart
        rts

*Subroutine that makes the transition to the Controls Screen
JumpToControlScreen
        bra             ControlScreen                           ;Branch to the ControlScreen
        rts

    END    START                                                ;Last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
