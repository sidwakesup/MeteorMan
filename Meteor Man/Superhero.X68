SH_StoreOffsetToPixelData
        lea         Superhero,a0
        add.l       #SH_OFFSET_PIXEL_DATA_OFFSET_BMP,a0
        move.l      (a0),d0
        swap.w      d0
        rol.w       #8,d0
        lea         Superhero_PixelDataOffset,a1
        move.w      d0,(a1)
        rts

SH_StoreImageWidthAndHeight
        lea         Superhero,a0
        add.l       #SH_OFFSET_IMAGE_WIDTH_BMP,a0
        move.l      (a0)+,d0
        swap.w      d0
        rol.w       #8,d0
        move.l      (a0),d1
        swap.w      d1
        rol.w       #8,d1
        lea         Superhero_Width,a1
        lea         Superhero_Height,a2
        move.w      d0,(a1)
        move.w      d1,(a2)
        rts

SH_CalculateRowSizeAndPadding
        lea         Superhero,a0
        lea         Superhero_Width,a1
        lea         Superhero_RowSize,a2
        lea         Superhero_Padding,a3
        add.l       #SH_OFFSET_BITS_PER_PIXEL_BMP,a0
        move.l      (a0),d0
        swap.w      d0
        rol.w       #8,d0
        mulu.w      (a1),d0
        add.l       #31,d0
        divu.w      #32,d0
        mulu.w      #4,d0
        move.w      d0,(a2)
        move.w      (a1),d1
        mulu.w      #3,d1
        sub.w       d1,d0
        move.w      d0,(a3)
        rts

SH_RenderBitmap

        jsr         SH_StoreOffsetToPixelData
        jsr         SH_StoreImageWidthAndHeight
        jsr         SH_CalculateRowSizeAndPadding

        lea         Superhero,a0
        lea         Superhero_PixelDataOffset,a1
        add.w       (a1),a0
        lea         Superhero_Height,a1
        move.w      (a1),d4
        move.w      (a1),d2
        lea         Superhero_ScreenY,a1
        move.w      (a1),d7
        asr.l       #4,d7
        add.w       d7,d2
        sub.w       #1,d2
    SH_OuterLoop:
        cmp.w       #SH_H,d4
        bgt         SH_OuterLoopSkipRow
        move.w      #0,d3
        lea         Superhero_ScreenX,a1
        move.w      (a1),d1
        asr.l       #4,d1
    SH_InnerLoop:
        cmp.w       #SH_X,d3
        blt         SH_InnerLoopSkipPixel
        move.l      d1,d7
    SH_GetPixelColor:
        clr.l       d1
        move.b      (a0)+,d1
        swap.w      d1
        move.b      (a0)+,d1
        rol.w       #8,d1
        move.b      (a0)+,d1
        move.l      #SH_GET_PIXEL_COLOR_TRAP_CODE,d0
        trap        #15
    SH_DrawPixel:
        move.l      d7,d1
        move.l      #SH_DRAW_PIXEL_TRAP_CODE,d0
        trap        #15
        add.w       #1,d1
        add.w       #1,d3
        
        cmp.w       #SH_W,d3
        bge         SH_InnerLoopCompleted
        bra         SH_InnerLoop
    SH_InnerLoopSkipPixel:
        add.l       #3,d0
        add.w       #1,d1
        add.w       #1,d3
        bra         SH_InnerLoop
    SH_InnerLoopCompleted:
        lea         Superhero_Width,a1
        move.w      (a1),d7
        sub.w       #SH_W,d7
        mulu.w      #3,d7
        lea         Superhero_Padding,a1
        add.w       (a1),d7
        add.l       d7,a0
        sub.w       #1,d2
        sub.w       #1,d4
        cmp.w       #SH_Y,d4
        ble         SH_OuterLoopCompleted
        bra         SH_OuterLoop
    SH_OuterLoopSkipRow:
        lea         Superhero_Width,a1
        move.w      (a1),d5
        lea         Superhero_Padding,a1
        add.w       (a1),d5
        add.l       d5,a0
        sub.w       #1,d2
        sub.w       #1,d4
        bra         SH_OuterLoop
    SH_OuterLoopCompleted:
        rts


SH_MoveRight
        move.l      (Superhero_VelocityX),d0
        move.l      #SH_ACCELERATION,d1
        muls        (T_DeltaTime),d1
        add.l       d1,d0
        cmpi.l      #SH_MAX_HORIZONTAL_VELOCITY,d0
        bgt         SH_OnExceedMaxVelocity
        bra         Done
    SH_OnExceedMaxVelocity:
        move.l      #SH_MAX_HORIZONTAL_VELOCITY,d0
    Done:
        move.l      d0,(Superhero_VelocityX)
        rts



SH_MoveLeft
        move.l      (Superhero_VelocityX),d0
        move.l      #SH_ACCELERATION,d1
        muls        (T_DeltaTime),d1
        sub.l       d1,d0
        cmpi.l      #-SH_MAX_HORIZONTAL_VELOCITY,d0
        blt         SH_OnExceedMinVelocity
        bra         SH_Done
    SH_OnExceedMinVelocity:
        move.l      #-SH_MAX_HORIZONTAL_VELOCITY,d0
    SH_Done:
        move.l      d0,(Superhero_VelocityX)
        rts


SH_UpdateSuperheroPosition
        move.w      (Superhero_ScreenX),d2
        ext.l       d2
        move.l      d0,d1
        muls        (T_DeltaTime),d1
        add.l       d1,d2
        cmp.l       #(SH_RIGHT_SIDE_OF_THE_SCREEN)<<4,d2
        bgt         SH_OnExceedMaxPosition
        cmp.l       #0<<4,d2
        blt         SH_OnExceedMinPosition
        bra         SH_DoneUpdatePosition
    SH_OnExceedMaxPosition:
        move.l      #(SH_RIGHT_SIDE_OF_THE_SCREEN)<<4,d2
        move.l      #0,(Superhero_VelocityX)
        bra         SH_SoDone
    SH_OnExceedMinPosition:
        move.l      #0<<4,d2
        move.l      #0,(Superhero_VelocityX)
        bra         SH_SoDone
    SH_DoneUpdatePosition:
        move.w      d2,(Superhero_ScreenX)
    SH_SoDone:
        rts


SH_ResetVelocity
        move.l      #0,(Superhero_VelocityX)
        rts



SH_AddToScore
        add.w       #1,(Superhero_Score)
        rts


SH_CheckPlayerDead
        cmp.b       #1,(Superhero_IsDead)
        bne         SH_PlayerIsAlive
    SH_PlayerIsDead:
        jsr         JumpToScoreDisplay
    SH_PlayerIsAlive:
        rts


SH_ResetVariables
        move.w      #310<<4,(Superhero_ScreenX)
        move.w      #360<<4,(Superhero_ScreenY)
        move.l      #0,(Superhero_VelocityX)
        move.w      #0,(Superhero_Score)
        move.b      #0,(Superhero_IsDead)
        rts



* Put variables and constants here
Superhero           INCBIN      "Assets/Superhero.bmp"
Superhero_ScreenX           dc.w        310<<4
Superhero_ScreenY           dc.w        360<<4
Superhero_PixelDataOffset   ds.w        1
Superhero_Width             ds.w        1
Superhero_Height            ds.w        1
Superhero_RowSize           ds.w        1
Superhero_Padding           ds.w        1

Superhero_VelocityX         dc.l        0

Superhero_Score             dc.w        0

Superhero_IsDead            dc.b        0
blah1                       dc.b        0














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
