#include <stdio.h>
#include "graphics.h"
#include "fonts.h"

void WriteAPixel(int x, int y, int Colour)
{
    WAIT_FOR_GRAPHICS; // is graphics ready for new command

    GraphicsX1Reg = x; // write coords to x1, y1
    GraphicsY1Reg = y;
    GraphicsColourReg = Colour;     // set pixel colour
    GraphicsCommandReg = PutAPixel; // give graphics "write pixel" command
}

int ReadAPixel(int x, int y)
{
    WAIT_FOR_GRAPHICS; // is graphics ready for new command

    GraphicsX1Reg = x; // write coords to x1, y1
    GraphicsY1Reg = y;
    GraphicsCommandReg = GetAPixel; // give graphics a "get pixel" command

    WAIT_FOR_GRAPHICS;               // is graphics done reading pixel
    return (int)(GraphicsColourReg); // return the palette number (colour)
}

void HLine(int x1, int y1, int length, int Colour)
{
    WAIT_FOR_GRAPHICS; // is graphics ready for new command

    GraphicsX1Reg = x1; // write coords to x1, y1
    GraphicsY1Reg = y1;
    GraphicsX2Reg = x1 + length;
    GraphicsY2Reg = y1;
    GraphicsColourReg = Colour;     // set pixel colour
    GraphicsCommandReg = DrawHLine; // give graphics "write pixel" command
}

void VLine(int x1, int y1, int length, int Colour)
{
    WAIT_FOR_GRAPHICS; // is graphics ready for new command

    GraphicsX1Reg = x1; // write coords to x1, y1
    GraphicsY1Reg = y1;
    GraphicsX2Reg = x1;
    GraphicsY2Reg = y1 + length;
    GraphicsColourReg = Colour;     // set pixel colour
    GraphicsCommandReg = DrawVLine; // give graphics "write pixel" command
}

void DrawAnyLine(int x1, int y1, int x2, int y2, int Colour)
{
    WAIT_FOR_GRAPHICS; // is graphics ready for new command

    GraphicsX1Reg = x1;
    GraphicsY1Reg = y1;
    GraphicsX2Reg = x2;
    GraphicsY2Reg = y2;
    GraphicsColourReg = Colour;    // set pixel colour
    GraphicsCommandReg = DrawLine; // give graphics "draw line" command
}

void Rectangle(int x, int y, int width, int height, int colour, int borderThickness)
{
    FilledRectangle(x, y, borderThickness, height, colour);
    FilledRectangle(x, y, width, borderThickness, colour);
    FilledRectangle(x + width - borderThickness, y, borderThickness, height, colour);
    FilledRectangle(x, y + height - borderThickness, width, borderThickness, colour);
}

void FilledRectangle(int x, int y, int width, int height, int Colour)
{
    WAIT_FOR_GRAPHICS; // is graphics ready for new command

    GraphicsX1Reg = x; // write coords to x1, y1
    GraphicsY1Reg = y;
    GraphicsX2Reg = x + width;
    GraphicsY2Reg = y + height;
    GraphicsColourReg = Colour;         // set pixel colour
    GraphicsCommandReg = DrawRectangle; // give graphics "draw rectangle" command    
}

void ProgramPalette(int PaletteNumber, int RGB)
{
    WAIT_FOR_GRAPHICS;
    GraphicsColourReg = PaletteNumber;
    GraphicsX1Reg = RGB >> 16;                 // program red value in ls.8 bit of X1 reg
    GraphicsY1Reg = RGB;                       // program green and blue into ls 16 bit of Y1 reg
    GraphicsCommandReg = ProgramPaletteColour; // issue command
}

void Reset()
{
    FilledRectangle(0, 0, 800, 480, BLACK);
}

void DrawFontCharacter(int x, int y, int fontColour, int backgroundcolour, int c, int erase)
{
    int row, column, pixels, BitMask;
    int charIndex = c - 32; // normalize to ASCII

    for (row = 0; row < 7; row++)
    {                                   // 7 rows
        pixels = ASCII[charIndex][row]; // get a row of pixels from font
        BitMask = 16;                   // set pixel mask = 10000 to test each pixel in row
        for (column = 0; column < 5; column++)
        {
            // step through 5 columns
            // if there is a ‘1’ in the font for this row / column display it
            if ((pixels & BitMask)) // if pixel and’ed with mask = 1
                WriteAPixel(x + column, y + row, fontColour);
            else
            {
                // if pixel is part of background (a ‘0’ in the font)
                // erase the background to value of variable BackGroundColour
                if (erase)
                    WriteAPixel(x + column, y + row, backgroundcolour);
            }
            BitMask = BitMask >> 1; // shift mask to next pixel
        }
    }
}

void DrawFontLine(int x, int y, int fontColour, int backgroundcolour, char *string, int bolded, int erase)
{
    int i;

    for (i = 0; string[i] != '\0'; i++)
    {
        DrawFontCharacter(x + 7 * i, y, fontColour, backgroundcolour, string[i], erase);

        if (bolded)
        {
            DrawFontCharacter(x + 7 * i + 1, y, fontColour, backgroundcolour, string[i], erase);
        }
    }
}

void ClearTextField(int x, int y, int width, int height)
{
    FilledRectangle(x, y, width, height, WHITE);
}
