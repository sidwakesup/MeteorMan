*-----------------------------------------------------------
* Title      :  Utility.x68
* Written by :  Siddhant Ravi
* Description:  This program is a utility file and contains
*               all the equates (EQU) that can be used by all
*               the other programs.
*-----------------------------------------------------------
*The equates for Background.x68
BG_ARGUMENT_ADDRESS        EQU     4
BG_ARGUMENT_X              EQU     8
BG_ARGUMENT_Y              EQU     10
BG_ARGUMENT_W              EQU     12
BG_ARGUMENT_H              EQU     14
BG_ARGUMENT_SCREEN_X       EQU     16
BG_ARGUMENT_SCREEN_Y       EQU     18
BG_OFFSET_PIXEL_DATA_OFFSET_BMP    EQU     $0A
BG_OFFSET_IMAGE_WIDTH_BMP          EQU     $12
BG_OFFSET_BITS_PER_PIXEL_BMP       EQU     $1C
BG_SET_PEN_COLOR_TRAP_CODE  EQU     80
BG_DRAW_PIXEL_TRAP_CODE     EQU     82

*The equates for InputManager.x68
IM_INPUT_SET                    EQU     $001B2725
IM_GET_INPUT_STATE_TRAP_CODE    EQU     19

*The equates for Main.x68
CLEAR_SCREEN_TRAP_CODE          EQU     11
CLEAR_SCREEN_MAGIC_VAL          EQU     $FF00
DRAWING_MODE_TRAP_CODE          EQU     92
DOUBLE_BUFFERED_MODE            EQU     17
REPAINT_SCREEN_TRAP_CODE        EQU     94

*The equates for Meteor.x68
M_OFFSET_PIXEL_DATA_OFFSET_BMP      EQU     $0A
M_OFFSET_IMAGE_WIDTH_BMP            EQU     $12
M_OFFSET_BITS_PER_PIXEL_BMP         EQU     $1C
M_GET_PIXEL_COLOR_TRAP_CODE         EQU     80
M_DRAW_PIXEL_TRAP_CODE              EQU     82
M_X     EQU     0
M_Y     EQU     0
M_W     EQU     5
M_H     EQU     5
M_MAX_FALL_VELOCITY         EQU     $75
M_GRAVITY                   EQU     $1
M_RIGHT_SIDE_OF_THE_SCREEN      EQU     640-M_W+1
M_BOTTOM_SIDE_OF_THE_SCREEN     EQU     480-M_H
M_NUMBER_OF_METEORS_ON_SCREEN       EQU     5
M_SKY_BLUE_BMP          EQU     $00ff653d
M_BLACK_OUTLINE         EQU     $00000000

*The equates for RandomNumberGenerator.x68
RNG_ALL_REG         REG     d0-d7/a0-a7
RNG_GET_TIME_COMMAND        EQU     8

*The equates for SevenSegmentScoreDisplay.x68
SD_HUNDREDS_POSITION_X   EQU     220
SD_HUNDREDS_POSITION_Y   EQU     240
SD_TENS_POSITION_X       EQU     320
SD_TENS_POSITION_Y       EQU     240
SD_UNITS_POSITION_X      EQU     420
SD_UNITS_POSITION_Y      EQU     240

*The equates for Superhero.x68
SH_OFFSET_PIXEL_DATA_OFFSET_BMP     EQU     $0A
SH_OFFSET_IMAGE_WIDTH_BMP           EQU     $12
SH_OFFSET_BITS_PER_PIXEL_BMP        EQU     $1C
SH_GET_PIXEL_COLOR_TRAP_CODE        EQU     80
SH_DRAW_PIXEL_TRAP_CODE             EQU     82
SH_X        EQU     0
SH_Y        EQU     0
SH_W        EQU     20
SH_H        EQU     40
SH_MAX_HORIZONTAL_VELOCITY     EQU     $75
SH_ACCELERATION                EQU     $F
SH_RIGHT_SIDE_OF_THE_SCREEN     EQU     640-SH_W
SH_LEFT_SIDE_OF_THE_SCREEN      EQU     0
SH_TOP_SIDE_OF_THE_SCREEN       EQU     0
SH_BOTTOM_SIDE_OF_THE_SCREEN    EQU     480

*The equate for Timer.x68
T_GET_TIME_TRAP_CODE          EQU     8

*The equates for TitleScreen.x68
TS_ARGUMENT_ADDRESS        EQU     4
TS_ARGUMENT_X              EQU     8
TS_ARGUMENT_Y              EQU     10
TS_ARGUMENT_W              EQU     12
TS_ARGUMENT_H              EQU     14
TS_ARGUMENT_SCREEN_X       EQU     16
TS_ARGUMENT_SCREEN_Y       EQU     18
TS_OFFSET_PIXEL_DATA_OFFSET_BMP    EQU     $0A
TS_OFFSET_IMAGE_WIDTH_BMP          EQU     $12
TS_OFFSET_BITS_PER_PIXEL_BMP       EQU     $1C
TS_SET_PEN_COLOR_TRAP_CODE  EQU     80
TS_DRAW_PIXEL_TRAP_CODE     EQU     82

*The equates for ControlScreen.x68
CS_ARGUMENT_ADDRESS        EQU     4
CS_ARGUMENT_X              EQU     8
CS_ARGUMENT_Y              EQU     10
CS_ARGUMENT_W              EQU     12
CS_ARGUMENT_H              EQU     14
CS_ARGUMENT_SCREEN_X       EQU     16
CS_ARGUMENT_SCREEN_Y       EQU     18
CS_OFFSET_PIXEL_DATA_OFFSET_BMP    EQU     $0A
CS_OFFSET_IMAGE_WIDTH_BMP          EQU     $12
CS_OFFSET_BITS_PER_PIXEL_BMP       EQU     $1C
CS_SET_PEN_COLOR_TRAP_CODE  EQU     80
CS_DRAW_PIXEL_TRAP_CODE     EQU     82

*The equates for ScoreScreen.x68
SS_ARGUMENT_ADDRESS        EQU     4
SS_ARGUMENT_X              EQU     8
SS_ARGUMENT_Y              EQU     10
SS_ARGUMENT_W              EQU     12
SS_ARGUMENT_H              EQU     14
SS_ARGUMENT_SCREEN_X       EQU     16
SS_ARGUMENT_SCREEN_Y       EQU     18
SS_OFFSET_PIXEL_DATA_OFFSET_BMP    EQU     $0A
SS_OFFSET_IMAGE_WIDTH_BMP          EQU     $12
SS_OFFSET_BITS_PER_PIXEL_BMP       EQU     $1C
SS_SET_PEN_COLOR_TRAP_CODE  EQU     80
SS_DRAW_PIXEL_TRAP_CODE     EQU     82


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
