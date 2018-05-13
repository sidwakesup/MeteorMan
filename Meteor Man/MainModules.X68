*-----------------------------------------------------------
* Title      :  MainModules.x68
* Written by :  Siddhant Ravi
* Description:  The MainModules program contains definitions
*               for subroutines that are used in the Main
*               program. They are defined in this separate
*               program in an attempt to make the Main module
*               look neater and easier to understand.
*-----------------------------------------------------------
*Subroutine to clear the screen using the appropriate trap call
ClearScreen
        move.l          #CLEAR_SCREEN_TRAP_CODE,d0
        move.l          #CLEAR_SCREEN_MAGIC_VAL,d1
        trap            #15
        rts

*Subroutine to swap the frame buffers (since we are working in double buffered mode)
SwapBuffers
        move.b          #REPAINT_SCREEN_TRAP_CODE,d0
        trap            #15
        rts

*Renders the part of the background that is now no longer hidden by the player character
UpdateBitmapBasedOnSuperhero
        move.l          #16,d0
        sub.l           d0,sp
        jsr             InitializeSuperheroParameters           ;Feed the parameters for the superhero to
        jsr             BG_RenderBitmap                         ;the subroutine that renders the background
        add.l           #16,sp
        rts

*Renders the part of the background that is now no longer hidden by the meteors on screen
UpdateBitmapBasedOnMeteors
        move.l          #M_NUMBER_OF_METEORS_ON_SCREEN,(Meteor_Counter)
        lea             Meteor_ScreenX,a5
        lea             Meteor_ScreenY,a6
    Loop:
        sub.l           #1,(Meteor_Counter)
        move.l          #16,d0
        sub.l           d0,sp
        jsr             InitializeMeteorParameters              ;Feed the parameters of each meteor to
        jsr             BG_RenderBitmap                         ;the subroutine that renders the background
        add.l           #16,sp
        cmp.l           #0,(Meteor_Counter)                     ;Check whether the update has taken place for all meteors
        beq             ExitLoop
        add.l           #2,a5
        add.l           #2,a6
        bra             Loop                                    ;Do this for each meteor that is present on the screen
    ExitLoop:
        rts

*Load the parameters to render the title screen on to the stack
InitializeTitleScreenParameters
        lea             TS_Bitmap,a0
        move.l          a0,4(sp)                                ;Address of the image
        move.w          #0,8(sp)                                ;X
        move.w          #0,10(sp)                               ;Y
        move.w          #640,12(sp)                             ;W
        move.w          #480,14(sp)                             ;H
        move.w          #0,16(sp)                               ;Screen X
        move.w          #0,18(sp)                               ;Screen Y
        rts

*Load the parameters to render the controls description screen on to the stack
InitControlScreenParameters
        lea             CS_Bitmap,a0
        move.l          a0,4(sp)                                ;Address of the image
        move.w          #0,8(sp)                                ;X
        move.w          #0,10(sp)                               ;Y
        move.w          #640,12(sp)                             ;W
        move.w          #480,14(sp)                             ;H
        move.w          #0,16(sp)                               ;Screen X
        move.w          #0,18(sp)                               ;Screen Y
        rts

*Load the parameters to render the score screen on to the stack
InitScoreScreenParameters
        lea             SS_Bitmap,a0
        move.l          a0,4(sp)                                ;Address of the image
        move.w          #0,8(sp)                                ;X
        move.w          #0,10(sp)                               ;Y
        move.w          #640,12(sp)                             ;W
        move.w          #480,14(sp)                             ;H
        move.w          #0,16(sp)                               ;Screen X
        move.w          #0,18(sp)                               ;Screen Y
        rts

*Load the parameters to render the background of the game on to the stack
InitializeBackgroundParameters
        lea             BG_Bitmap,a0
        move.l          a0,4(sp)                                ;Address of the image                            
        move.w          #0,8(sp)                                ;X
        move.w          #0,10(sp)                               ;Y
        move.w          #640,12(sp)                             ;W
        move.w          #480,14(sp)                             ;H
        move.w          #0,16(sp)                               ;Screen X
        move.w          #0,18(sp)                               ;Screen Y
        rts

*Load the parameters to render the superhero on to the stack
InitializeSuperheroParameters
        lea             BG_Bitmap,a0
        lea             Superhero_ScreenX,a1
        lea             Superhero_ScreenY,a2
        move.w          (a1),d1
        asr.l           #4,d1                                   ;since screen offset of the superhero is represented in fixed point, we perform an arithmetic right shift to get the correct value to push onto the stack
        move.w          (a2),d2
        asr.l           #4,d2
        move.l          a0,4(sp)
        move.w          d1,8(sp)
        move.w          d2,10(sp)
        add.w           #SH_W,d1
        move.w          d1,12(sp)
        add.w           #SH_H,d2
        move.w          d2,14(sp)
        move.w          #0,16(sp)
        move.w          #0,18(sp)
        rts

*Load the parameters to render a meteor on to the stack
InitializeMeteorParameters
        lea             BG_Bitmap,a0
        move.w          (a5),d1
        asr.l           #4,d1
        move.w          (a6),d2
        asr.l           #4,d2                                   ;since screen offset of the superhero is represented in fixed point, we perform an arithmetic right shift to get the correct value to push onto the stack
        move.l          a0,4(sp)
        move.w          d1,8(sp)
        move.w          d2,10(sp)
        add.w           #M_W,d1
        move.w          d1,12(sp)
        add.w           #M_H,d2
        move.w          d2,14(sp)
        move.w          #0,16(sp)
        move.w          #0,18(sp)
        rts







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
