SS_RenderBitmap
        move.l          SS_ARGUMENT_ADDRESS(sp),a2
        move.l          a2,a0
        lea             SS_OffsetToPixelData,a4
        add.w           (a4),a0
        lea             SS_ImageHeight,a3
        move.w          (a3),d4
        move.w          (a3),d2
        sub.w           #1,SS_ARGUMENT_SCREEN_Y(sp)
        add.w           SS_ARGUMENT_SCREEN_Y(sp),d2
    SS_OuterLoop:
        cmp.w           SS_ARGUMENT_H(sp),d4
        bgt             SS_OuterLoopSkipRow
        move.w          #0,d3
        move.w          SS_ARGUMENT_SCREEN_X(sp),d1
    SS_InnerLoop:
        cmp.w           SS_ARGUMENT_X(sp),d3
        blt             SS_InnerLoopSkipPixel
        move.l          d1,d7
    SS_GetPixelColor:
        clr.l           d1
        move.b          (a0)+,d1
        swap.w          d1
        move.b          (a0)+,d1
        lsl.w           #8,d1
        move.b          (a0)+,d1
        move.l          #SS_SET_PEN_COLOR_TRAP_CODE,d0
        trap            #15
        move.l          d7,d1
    SS_DrawPixel:
        move.l          #SS_DRAW_PIXEL_TRAP_CODE,d0
        trap            #15
        add.w           #1,d1
        add.w           #1,d3
        cmp.w           SS_ARGUMENT_W(sp),d3
        bge             SS_InnerLoopCompleted
        bra             SS_InnerLoop
    SS_InnerLoopSkipPixel:
        add.l           #3,a0
        add.w           #1,d1
        add.w           #1,d3
        bra             SS_InnerLoop
    SS_InnerLoopCompleted:
        lea             SS_ImageWidth,a3
        lea             SS_Padding,a4
        move.w          (a3),d7
        move.w          (a4),d6
        move.w          SS_ARGUMENT_W(sp),d5
        sub.w           d5,d7
        mulu.w          #3,d7
        add.w           d6,d7
        add.l           d7,a0
        subi.w          #1,d4
        subi.w          #1,d2
        cmp.w           SS_ARGUMENT_Y(sp),d4
        ble             SS_OuterLoopCompleted
        bra             SS_OuterLoop
    SS_OuterLoopSkipRow:
        lea             SS_ImageWidth,a3
        lea             SS_Padding,a4
        move.w          (a3),d5
        move.w          (a4),d6
        mulu.w          #3,d5
        add.l           d6,d5
        add.l           d5,a0
        subi.w          #1,d2
        subi.w          #1,d4
        bra             SS_OuterLoop
    SS_OuterLoopCompleted:
        rts

SS_StoreOffsetToPixelData
        lea             SS_Bitmap,a0
        add.l           #SS_OFFSET_PIXEL_DATA_OFFSET_BMP,a0
        move.l          (a0),d0
        swap.w          d0
        rol.w           #8,d0
        lea             SS_OffsetToPixelData,a1
        move.w          d0,(a1)
        rts

SS_StoreImageWidthAndHeight
        lea             SS_Bitmap,a0
        add.l           #SS_OFFSET_IMAGE_WIDTH_BMP,a0
        move.l          (a0)+,d0
        swap.w          d0
        rol.w           #8,d0
        move.l          (a0),d1
        swap.w          d1
        rol.w           #8,d1
        lea             SS_ImageWidth,a2
        lea             SS_ImageHeight,a3
        move.w          d0,(a2)
        move.w          d1,(a3)
        rts

SS_CalculateRowSizeAndPadding
        lea             SS_Bitmap,a0
        lea             SS_ImageWidth,a1
        lea             SS_RowSize,a2
        lea             SS_Padding,a3
        add.l           #SS_OFFSET_BITS_PER_PIXEL_BMP,a0
        move.l          (a0),d3
        swap.w          d3
        rol.w           #8,d3
        mulu.w          (a1),d3
        add.l           #31,d3
        divu.w          #32,d3
        mulu.w          #4,d3
        move.w          d3,(a2)
        move.w          (a1),d1
        mulu.w          #3,d1
        sub.w           d1,d3
        move.w          d3,(a3)
        rts

* Put variables and constants here

SS_Bitmap                   INCBIN      "Assets/ScoreScreen.bmp"

SS_OffsetToPixelData        ds.w        1
SS_ImageWidth               ds.w        1
SS_ImageHeight              ds.w        1
SS_RowSize                  ds.w        1
SS_Padding                  ds.w        1


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
