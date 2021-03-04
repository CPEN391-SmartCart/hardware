#include <stdio.h>

// graphics register addresses

#define GraphicsCommandReg              (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsStatusReg               (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsX1Reg                   (*(volatile unsigned short int *)(0xFF210002))
#define GraphicsY1Reg                   (*(volatile unsigned short int *)(0xFF210004))
#define GraphicsX2Reg                   (*(volatile unsigned short int *)(0xFF210006))
#define GraphicsY2Reg                   (*(volatile unsigned short int *)(0xFF210008))
#define GraphicsColourReg               (*(volatile unsigned short int *)(0xFF21000E))
#define GraphicsBackGroundColourReg     (*(volatile unsigned short int *)(0xFF210010))

/************************************************************************************************
** This macro pauses until the graphics chip status register indicates that it is idle
***********************************************************************************************/

#define WAIT_FOR_GRAPHICS                          \
    while ((GraphicsStatusReg & 0x0001) != 0x0001) \
        ;

// #defined constants representing values we write to the graphics 'command' register to get
// it to draw something. You will add more values as you add hardware to the graphics chip
// Note DrawHLine, DrawVLine and DrawLine at the moment do nothing - you will modify these

#define DrawHLine 1
#define DrawVLine 2
#define DrawLine 3
#define PutAPixel 0xA
#define GetAPixel 0xB
#define ProgramPaletteColour 0x10

// defined constants representing colours pre-programmed into colour palette
// there are 256 colours but only 8 are shown below, we write these to the colour registers
//
// the header files "Colours.h" contains constants for all 256 colours
// while the course file "ColourPaletteData.c" contains the 24 bit RGB data
// that is pre-programmed into the palette

// #define BLACK 0
// #define WHITE 1
// #define RED 2
// #define LIME 3
// #define BLUE 4
// #define YELLOW 5
// #define CYAN 6
// #define MAGENTA 7

#define BLACK 0
#define WHITE 1
#define RED 22
#define GREEN 46
#define BLUE 15
#define YELLOW 30
#define PURPLE 13
#define CYAN 63
#define PINK 23
#define BROWN 10
#define GREY 9

void WriteAPixel(int x, int y, int Colour);
int ReadAPixel(int x, int y);
void ProgramPalette(int PaletteNumber, int RGB);
void HLine(int x1, int y1, int length, int Colour);
void VLine(int x1, int y1, int length, int Colour);
void Rectangle(int x, int y, int width, int height, int Colour);
void FilledRectangle(int x, int y, int width, int height, int Colour);
void Reset();
void DrawFontCharacter(int x, int y, int fontColour, int backgroundcolour, int c, int Erase);
void DrawFontLine(int x, int y, int fontColour, int backgroundcolour, char *string, int Erase);