*-----------------------------------------------------------
* Title      :  Meteor.x68
* Written by :  Siddhant Ravi
* Description:  This program contains all functionalities
*               pertaining to the meteors. This includes
*               making them fall and react to gravity, check
*               for collisions with the ground and the player,
*               and assign random spawn locations for each
*               wave of meteors.
*-----------------------------------------------------------
*Subroutine to store the offset to the pixel data 
M_StoreOffsetToPixelData
        lea         Meteor,a0
        add.l       #M_OFFSET_PIXEL_DATA_OFFSET_BMP,a0
        move.l      (a0),d0
        swap.w      d0
        rol.w       #8,d0
        move.w      d0,(Meteor_PixelDataOffset)
        rts

*Subroutine to retrieve the image width and height from the bmp file header
M_StoreImageWidthAndHeight
        lea         Meteor,a0
        add.l       #M_OFFSET_IMAGE_WIDTH_BMP,a0
        move.l      (a0)+,d0
        swap.w      d0
        rol.w       #8,d0
        move.l      (a0),d1
        swap.w      d1
        rol.w       #8,d1
        move.w      d0,(Meteor_Width)
        move.w      d1,(Meteor_Height)
        rts

*Subroutine to calculate the row size of the pixel array and the padding in the bmp
M_CalculateRowSizeAndPadding
        lea         Meteor,a0
        lea         Meteor_Width,a1
        lea         Meteor_RowSize,a2
        lea         Meteor_Padding,a3
        add.l       #M_OFFSET_BITS_PER_PIXEL_BMP,a0
        move.l      (a0),d0
        swap.w      d0
        rol.w       #8,d0
        mulu.w      (a1),d0
        add.l       #31,d0
        divu.w      #32,d0
        mulu.w      #4,d0
        move.w      d0,(a2)
        move.w      (a1),d2
        mulu.w      #3,d1
        sub.w       d1,d0
        move.w      d0,(a3)
        rts

*Subroutine to render the meteor bitmap using paramters passed through the stack
M_RenderBitmap
        jsr         M_StoreOffsetToPixelData
        jsr         M_StoreImageWidthAndHeight
        jsr         M_CalculateRowSizeAndPadding
        lea         Meteor,a0
        lea         Meteor_PixelDataOffset,a1
        add.w       (a1),a0
        move.w      (Meteor_Height),d4
        move.w      (Meteor_Height),d2
        move.w      4(sp),d7
        asr.l       #4,d7
        add.w       d7,d2
        sub.w       #1,d2
    M_OuterLoop:
        cmp.w       #M_H,d4
        bgt         M_OuterLoopSkipRow
        move.w      #0,d3
        move.w      6(sp),d1
        asr.l       #4,d1
    M_InnerLoop:
        cmp.w       #M_X,d3
        blt         M_InnerLoopSkipPixel
        move.l      d1,d7
    M_GetPixelColor:
        clr.l       d1
        move.b      (a0)+,d1
        swap.w      d1
        move.b      (a0)+,d1
        rol.w       #8,d1
        move.b      (a0)+,d1
        move.l      #M_GET_PIXEL_COLOR_TRAP_CODE,d0
        trap        #15
    M_DrawPixel:
        move.l      d7,d1
        move.l      #M_DRAW_PIXEL_TRAP_CODE,d0
        trap        #15
        add.w       #1,d1
        add.w       #1,d3
        cmp.w       #M_W,d3
        bge         M_InnerLoopCompleted
        bra         M_InnerLoop
    M_InnerLoopSkipPixel:
        add.l       #3,d0
        add.w       #1,d1
        add.w       #1,d3
        bra         M_InnerLoop
    M_InnerLoopCompleted:
        move.w      (Meteor_Width),d7
        sub.w       #M_W,d7
        mulu.w      #3,d7
        add.w       (Meteor_Padding),d7
        add.l       d7,a0
        sub.w       #1,d2
        sub.w       #1,d4
        cmp.w       #M_Y,d4
        ble         M_OuterLoopCompleted
        bra         M_OuterLoop
    M_OuterLoopSkipRow:
        move.w      (Meteor_Width),d5
        add.w       (Meteor_Padding),d5
        add.l       d5,a0
        sub.w       #1,d2
        sub.w       #1,d4
        bra         M_OuterLoop
    M_OuterLoopCompleted:
        rts


*Subroutine to caluclate the spawn locations of the meteors for each wave
M_AssignMeteorStartingLocations
        lea         Meteor_ScreenX,a0
        lea         Meteor_ScreenY,a1
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,d1
    M_LocLoop:
        sub.l       #1,d1
        cmpi.w      #-100<<4,(a1)
        bne         M_LoopEdits
        jsr         RNG_GetRandomWord
        move.w      (RNG_TempRandomWord),d0
        divu.w      #(M_RIGHT_SIDE_OF_THE_SCREEN),d0
        swap.w      d0
        ext.l       d0
        asl.l       #4,d0
        move.w      d0,(a0)
        move.w      #0<<4,(a1)
    M_LoopEdits:
        cmp.l       #0,d1
        beq         M_LocationsDone
        add.l       #2,a0
        add.l       #2,a1
        bra         M_LocLoop
    M_LocationsDone:
        rts

*Subroutine that calls the M_RenderBitmap subroutine for each meteor that has to be rendered at any given time
M_RenderMeteors
        lea         Meteor_ScreenX,a5
        lea         Meteor_ScreenY,a6
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,d6
    M_Loop:
        sub.l       #1,d6
        sub.l       #4,sp
        move.w      (a5),2(sp)
        move.w      (a6),(sp)
        jsr         M_RenderBitmap
        add.l       #4,sp
        cmpi.l      #0,d6
        beq         M_Done
        add.l       #2,a5
        add.l       #2,a6
        bra         M_Loop
    M_Done:
        rts
    
*Subroutine to modify the velocity of the meteor based on the gravity acting upon it        
M_MoveDown
        lea         Meteor_VelocityY,a0
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,d6
    M_MoveDownLoop:
        sub.l       #1,d6
        move.l      (a0),d0
        move.l      #M_GRAVITY,d1
        muls        (T_DeltaTime),d1
        add.l       d1,d0
        cmpi.l      #M_MAX_FALL_VELOCITY,d0
        bgt         M_OnExceedMaxVelocity
        bra         M_DoneY
    M_OnExceedMaxVelocity:
        move.l      #M_MAX_FALL_VELOCITY,d0
    M_DoneY:
        move.l      d0,(a0)
        cmpi.l      #0,d6
        beq         M_SuperDone
        add.l       #4,a0
        bra         M_MoveDownLoop
    M_SuperDone:
        rts

*Subroutine to update the position of the meteors based on their velocities at that point of time
M_UpdateMeteorPosition
        lea         Meteor_ScreenY,a5
        lea         Meteor_VelocityY,a6
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,d6
    M_UpdateLoop:
        sub.l       #1,d6
        move.w      (a5),d2
        ext.l       d2
        move.l      d0,d1
        muls        (T_DeltaTime),d1
        add.l       d1,d2
        cmp.l       #(M_BOTTOM_SIDE_OF_THE_SCREEN)<<4,d2
        bgt         M_OnExceedMaxPosition
        bra         M_DoneUpdatePosition
    M_OnExceedMaxPosition:
        move.l      #-100<<4,d2
        move.l      #0,(a6)
        bra         M_DoneUpdatePosition
    M_DoneUpdatePosition:
        move.w      d2,(a5)
        cmpi.l      #0,d6
        beq         M_SoDone
        add.l       #2,a5
        add.l       #4,a6
        bra         M_UpdateLoop
    M_SoDone:
        rts

*Subroutine to check for meteors colliding with the ground
M_CheckMeteorCollisionGround
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,(Meteor_Counter)
        lea         Meteor_ScreenX,a5
        lea         Meteor_ScreenY,a6
    M_CollisionLoop:
        sub.l       #1,(Meteor_Counter)
        *BottomProcessing
        move.w      (a5),d1
        asr.l       #4,d1
        move.w      (a6),d2
        asr.l       #4,d2
        add.w       #(M_H-1),d2
        move.l      #5,(Meteor_PixelCounter)
    M_BottomLoop:
        sub.l       #1,(Meteor_PixelCounter)
        cmpi.w      #-100<<4,(a5)
        beq         M_DoneBottomLoop
        move.l      #83,d0
        trap        #15
        cmpi.l      #M_SKY_BLUE_BMP,d0
        beq         M_BottomUpdateCoordinates
        jsr         SH_AddToScore
        move.w      #(-100)<<4,(a5)
        move.w      #(-100)<<4,(a6)
        bra         M_DoneBottomLoop
    M_BottomUpdateCoordinates:
        cmpi.l      #0,(Meteor_PixelCounter)
        beq         M_DoneBottomLoop
        add.w       #1,d1
        bra         M_BottomLoop
    M_DoneBottomLoop:
        cmpi.l      #0,(Meteor_Counter)
        beq         M_CollisionLoopDone
        add.l       #2,a5
        add.l       #2,a6
        bra         M_CollisionLoop
    M_CollisionLoopDone:
        rts

*Subroutine that checks for collisions between the meteors and the player character
M_CheckMeteorCollisionPlayer
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,(Meteor_Counter)
        lea         Meteor_ScreenX,a5
        lea         Meteor_ScreenY,a6
    M_PlayerCollisionLoop:
        sub.l       #1,(Meteor_Counter)
        *bottom processing
        move.w      (a5),d1
        asr.l       #4,d1
        move.w      (a6),d2
        asr.l       #4,d2
        add.w       #M_H,d2
        move.l      #5,(Meteor_PixelCounter)
    M_MeteorBottomLoop:
        sub.l       #1,(Meteor_PixelCounter)
        cmpi.w      #-100<<4,(a5)
        beq         M_MeteorDoneLoop
        move.l      #83,d0
        trap        #15
        cmpi.l      #M_BLACK_OUTLINE,d0
        bne         M_MeteorBottomUpdateCoordinates
        move.b      #1,(Superhero_IsDead)
        bra         M_PlayerCollisionLoopDone
    M_MeteorBottomUpdateCoordinates:
        cmpi.l      #0,(Meteor_PixelCounter)
        beq         M_MeteorDoneBottomLoop
        add.w       #1,d1
        bra         M_MeteorBottomLoop
    M_MeteorDoneBottomLoop:
        *left processing
        move.w      (a5),d1
        asr.l       #4,d1
        sub.w       #1,d1
        move.w      (a6),d2
        asr.l       #4,d2
        move.l      #5,(Meteor_PixelCounter)
    M_MeteorLeftLoop:
        sub.l       #1,(Meteor_PixelCounter)
        cmpi.w      #-100<<4,(a5)
        beq         M_MeteorDoneLoop
        move.l      #83,d0
        trap        #15
        cmpi.l      #M_BLACK_OUTLINE,d0
        bne         M_MeteorLeftUpdateCoordinates
        move.b      #1,(Superhero_IsDead)
        bra         M_PlayerCollisionLoopDone
    M_MeteorLeftUpdateCoordinates:
        cmpi.l      #0,(Meteor_PixelCounter)
        beq         M_MeteorDoneLeftLoop
        add.w       #1,d2
        bra         M_MeteorLeftLoop
    M_MeteorDoneLeftLoop:
        *right processing
        move.w      (a5),d1
        asr.l       #4,d1
        add.w       #M_W,d1
        move.w      (a6),d2
        asr.l       #4,d2
        move.l      #5,(Meteor_PixelCounter)
    M_MeteorRightLoop:
        sub.l       #1,(Meteor_PixelCounter)
        cmpi.w      #-100<<4,(a5)
        beq         M_MeteorDoneLoop
        move.l      #83,d0
        trap        #15
        cmpi.l      #M_BLACK_OUTLINE,d0
        bne         M_MeteorRightUpdateCoordinates
        move.b      #1,(Superhero_IsDead)
        bra         M_PlayerCollisionLoopDone
    M_MeteorRightUpdateCoordinates:
        cmpi.l      #0,(Meteor_PixelCounter)
        beq         M_MeteorDoneRightLoop
        add.w       #1,d2
        bra         M_MeteorRightLoop
    M_MeteorDoneRightLoop:        
    M_MeteorDoneLoop:
        cmpi.l      #0,(Meteor_Counter)
        beq         M_PlayerCollisionLoopDone
        add.l       #2,a5
        add.l       #2,a6
        bra         M_PlayerCollisionLoop
    M_PlayerCollisionLoopDone:
        rts

*Subroutine to reset all the variables pertaining to the meteors
M_ResetVariables
        *reset screenx
        lea         Meteor_ScreenX,a0
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,d0
    M_ScreenXLoop:
        sub.l       #1,d0
        move.w      #-100<<4,(a0)
        cmp.l       #0,d0
        beq         M_ScreenXReset
        add.l       #2,a0
        bra         M_ScreenXLoop
    M_ScreenXReset:
        *reset screen y
        lea         Meteor_ScreenX,a0
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,d0
    M_ScreenYLoop:
        sub.l       #1,d0
        move.w      #-100<<4,(a0)
        cmp.l       #0,d0
        beq         M_ScreenYReset
        add.l       #2,a0
        bra         M_ScreenYLoop
    M_ScreenYReset:
        *reset velocity
        lea         Meteor_VelocityY,a0
        move.l      #M_NUMBER_OF_METEORS_ON_SCREEN,d0
    M_VelocityYLoop:
        sub.l       #1,d0
        move.l      #0,(a0)
        cmp.l       #0,d0
        beq         M_VelocityYReset
        add.l       #2,a0
        bra         M_VelocityYLoop
    M_VelocityYReset:
        rts

*Variables and constants are defined below
Meteor              INCBIN          "Assets/Meteor.bmp"

Meteor_ScreenX              dc.w        -100<<4,-100<<4,-100<<4,-100<<4,-100<<4
Meteor_ScreenY              dc.w        -100<<4,-100<<4,-100<<4,-100<<4,-100<<4
Meteor_PixelDataOffset      ds.w        1
Meteor_Width                ds.w        1
Meteor_Height               ds.w        1
Meteor_RowSize              ds.w        1
Meteor_Padding              ds.w        1

Meteor_VelocityY            dc.l        0,0,0,0,0

Meteor_Counter              ds.l        1
Meteor_PixelCounter         ds.l        1




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
