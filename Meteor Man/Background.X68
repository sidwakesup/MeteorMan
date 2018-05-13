*-----------------------------------------------------------
* Title      :  Background.x68
* Written by :  Siddhant Ravi
* Description:  This program defines a subroutine that can 
*               render the background image in the game loop
*               based on the parameters passed to it through
*               the stack.
*-----------------------------------------------------------
*Subroutine to render the bitmap on the screen
BG_RenderBitmap
        move.l          BG_ARGUMENT_ADDRESS(sp),a2
        move.l          a2,a0
        lea             BG_OffsetToPixelData,a4
        add.w           (a4),a0
        lea             BG_ImageHeight,a3
        move.w          (a3),d4
        move.w          (a3),d2
        sub.w           #1,BG_ARGUMENT_SCREEN_Y(sp)
        add.w           BG_ARGUMENT_SCREEN_Y(sp),d2
    BG_OuterLoop:
        cmp.w           BG_ARGUMENT_H(sp),d4
        bgt             BG_OuterLoopSkipRow
        move.w          #0,d3
        move.w          BG_ARGUMENT_SCREEN_X(sp),d1
    BG_InnerLoop:
        cmp.w           BG_ARGUMENT_X(sp),d3
        blt             BG_InnerLoopSkipPixel
        move.l          d1,d7
    BG_GetPixelColor:
        clr.l           d1
        move.b          (a0)+,d1
        swap.w          d1
        move.b          (a0)+,d1
        lsl.w           #8,d1
        move.b          (a0)+,d1
        move.l          #BG_SET_PEN_COLOR_TRAP_CODE,d0
        trap            #15
        move.l          d7,d1
    BG_DrawPixel:
        move.l          #BG_DRAW_PIXEL_TRAP_CODE,d0
        trap            #15
        add.w           #1,d1
        add.w           #1,d3
        cmp.w           BG_ARGUMENT_W(sp),d3
        bge             BG_InnerLoopCompleted
        bra             BG_InnerLoop
    BG_InnerLoopSkipPixel:
        add.l           #3,a0
        add.w           #1,d1
        add.w           #1,d3
        bra             BG_InnerLoop
    BG_InnerLoopCompleted:
        lea             BG_ImageWidth,a3
        lea             BG_Padding,a4
        move.w          (a3),d7
        move.w          (a4),d6
        move.w          BG_ARGUMENT_W(sp),d5
        sub.w           d5,d7
        mulu.w          #3,d7
        add.w           d6,d7
        add.l           d7,a0
        subi.w          #1,d4
        subi.w          #1,d2
        cmp.w           BG_ARGUMENT_Y(sp),d4
        ble             BG_OuterLoopCompleted
        bra             BG_OuterLoop
    BG_OuterLoopSkipRow:
        lea             BG_ImageWidth,a3
        lea             BG_Padding,a4
        move.w          (a3),d5
        move.w          (a4),d6
        mulu.w          #3,d5
        add.l           d6,d5
        add.l           d5,a0
        subi.w          #1,d2
        subi.w          #1,d4
        bra             BG_OuterLoop
    BG_OuterLoopCompleted:
        rts

*Subroutine to calculate the offset to the starting address of the pixel data array in the bmp file
BG_StoreOffsetToPixelData
        lea             BG_Bitmap,a0
        add.l           #BG_OFFSET_PIXEL_DATA_OFFSET_BMP,a0
        move.l          (a0),d0
        swap.w          d0
        rol.w           #8,d0
        lea             BG_OffsetToPixelData,a1
        move.w          d0,(a1)
        rts

*Subroutine to retrieve the image width and height information from the file header of the bmp
BG_StoreImageWidthAndHeight
        lea             BG_Bitmap,a0
        add.l           #BG_OFFSET_IMAGE_WIDTH_BMP,a0
        move.l          (a0)+,d0
        swap.w          d0
        rol.w           #8,d0
        move.l          (a0),d1
        swap.w          d1
        rol.w           #8,d1
        lea             BG_ImageWidth,a2
        lea             BG_ImageHeight,a3
        move.w          d0,(a2)
        move.w          d1,(a3)
        rts

*Subroutine to calculate the row size of the pixel array and the padding in the image
BG_CalculateRowSizeAndPadding
        lea             BG_Bitmap,a0
        lea             BG_ImageWidth,a1
        lea             BG_RowSize,a2
        lea             BG_Padding,a3
        add.l           #BG_OFFSET_BITS_PER_PIXEL_BMP,a0
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
BG_Bitmap                   INCBIN      "Assets/Background.bmp"                 ;The image to be rendered as the background

BG_OffsetToPixelData        ds.w        1
BG_ImageWidth               ds.w        1
BG_ImageHeight              ds.w        1
BG_RowSize                  ds.w        1
BG_Padding                  ds.w        1








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
