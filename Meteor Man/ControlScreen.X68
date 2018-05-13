*-----------------------------------------------------------
* Title      :  ControlScreen.x68
* Written by :  Siddhant Ravi
* Description:  This program defines a subroutine that can
*               render the background image when the score
*               is being displayed. It uses parameters that
*               are passed to it through the stack.
*-----------------------------------------------------------
*Subroutine to render the bitmap on the screen
CS_RenderBitmap
        move.l          CS_ARGUMENT_ADDRESS(sp),a2
        move.l          a2,a0
        lea             CS_OffsetToPixelData,a4
        add.w           (a4),a0
        lea             CS_ImageHeight,a3
        move.w          (a3),d4
        move.w          (a3),d2
        sub.w           #1,CS_ARGUMENT_SCREEN_Y(sp)
        add.w           CS_ARGUMENT_SCREEN_Y(sp),d2
    CS_OuterLoop:
        cmp.w           CS_ARGUMENT_H(sp),d4
        bgt             CS_OuterLoopSkipRow
        move.w          #0,d3
        move.w          CS_ARGUMENT_SCREEN_X(sp),d1
    CS_InnerLoop:
        cmp.w           CS_ARGUMENT_X(sp),d3
        blt             CS_InnerLoopSkipPixel
        move.l          d1,d7
    CS_GetPixelColor:
        clr.l           d1
        move.b          (a0)+,d1
        swap.w          d1
        move.b          (a0)+,d1
        lsl.w           #8,d1
        move.b          (a0)+,d1
        move.l          #CS_SET_PEN_COLOR_TRAP_CODE,d0
        trap            #15
        move.l          d7,d1
    CS_DrawPixel:
        move.l          #CS_DRAW_PIXEL_TRAP_CODE,d0
        trap            #15
        add.w           #1,d1
        add.w           #1,d3
        cmp.w           CS_ARGUMENT_W(sp),d3
        bge             CS_InnerLoopCompleted
        bra             CS_InnerLoop
    CS_InnerLoopSkipPixel:
        add.l           #3,a0
        add.w           #1,d1
        add.w           #1,d3
        bra             CS_InnerLoop
    CS_InnerLoopCompleted:
        lea             CS_ImageWidth,a3
        lea             CS_Padding,a4
        move.w          (a3),d7
        move.w          (a4),d6
        move.w          CS_ARGUMENT_W(sp),d5
        sub.w           d5,d7
        mulu.w          #3,d7
        add.w           d6,d7
        add.l           d7,a0
        subi.w          #1,d4
        subi.w          #1,d2
        cmp.w           CS_ARGUMENT_Y(sp),d4
        ble             CS_OuterLoopCompleted
        bra             CS_OuterLoop
    CS_OuterLoopSkipRow:
        lea             CS_ImageWidth,a3
        lea             CS_Padding,a4
        move.w          (a3),d5
        move.w          (a4),d6
        mulu.w          #3,d5
        add.l           d6,d5
        add.l           d5,a0
        subi.w          #1,d2
        subi.w          #1,d4
        bra             CS_OuterLoop
    CS_OuterLoopCompleted:
        rts

*Subroutine to calculate the offset to the start of the pixel array in the bmp file
CS_StoreOffsetToPixelData
        lea             CS_Bitmap,a0
        add.l           #CS_OFFSET_PIXEL_DATA_OFFSET_BMP,a0
        move.l          (a0),d0
        swap.w          d0
        rol.w           #8,d0
        lea             CS_OffsetToPixelData,a1
        move.w          d0,(a1)
        rts

*Subroutine to retrieve the image width and height information from the bmp file header
CS_StoreImageWidthAndHeight
        lea             CS_Bitmap,a0
        add.l           #CS_OFFSET_IMAGE_WIDTH_BMP,a0
        move.l          (a0)+,d0
        swap.w          d0
        rol.w           #8,d0
        move.l          (a0),d1
        swap.w          d1
        rol.w           #8,d1
        lea             CS_ImageWidth,a2
        lea             CS_ImageHeight,a3
        move.w          d0,(a2)
        move.w          d1,(a3)
        rts

*Subroutine to calculate the row size of the pixel array and padding in the bmp
CS_CalculateRowSizeAndPadding
        lea             CS_Bitmap,a0
        lea             CS_ImageWidth,a1
        lea             CS_RowSize,a2
        lea             CS_Padding,a3
        add.l           #CS_OFFSET_BITS_PER_PIXEL_BMP,a0
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

*The variables and constants are defined below
CS_Bitmap                   INCBIN      "Assets/ControlScreen.bmp"                  ;The image to be rendered

CS_OffsetToPixelData        ds.w        1
CS_ImageWidth               ds.w        1
CS_ImageHeight              ds.w        1
CS_RowSize                  ds.w        1
CS_Padding                  ds.w        1


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
