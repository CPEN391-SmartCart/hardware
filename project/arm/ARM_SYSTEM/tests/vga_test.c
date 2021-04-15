#include "../src/vga/graphics.h"
#include "vga_test.h"

int GraphicsTest(void){
    int i;

    Reset();

    // Blank screen
    FilledRectangle(0 , 0, 800, 480, WHITE);

    // Use horizontal lines to split the screen evenly into rows
    for(i = 0; i < 480; i += 20){
        HLine(0, i, 800, BLACK);
    }

    // Use the vertical lines to split the screen into two
    VLine(400, 0, 480, BLACK);

    // Test 1: Draw a single pixel
    DrawFontLine(50, 5, BLACK, WHITE, "TEST 1: DRAW A SINGLE PIXEL", 0, 0);
    WriteAPixel(450, 5, BLACK);

    // Test 2: Draw a line in any direction
    DrawFontLine(50, 25, BLACK, WHITE, "TEST 2: DRAW A LINE IN ANY DIRECTION", 0, 0);
    DrawAnyLine(400, 20, 800, 40, RED);

    // Test 3: Draw a rectangle
    DrawFontLine(50, 45, BLACK, WHITE, "TEST 3: DRAW A RECTANGLE", 0, 0);
    Rectangle(400, 40, 400, 20, GREEN, 3);

    // Test 4: Draw a filled rectangle
    DrawFontLine(50, 65, BLACK, WHITE, "TEST 4: DRAW A FILLED RECTANGLE", 0, 0);
    FilledRectangle(400, 60, 400, 20, BLUE);
    
    // Test 5: Draw a single character
    DrawFontLine(50, 85, BLACK, WHITE, "TEST 5: DRAW A SINGLE CHARACTER", 0, 0);
    DrawFontCharacter(450, 85, BLACK, WHITE, 'A', 0);

    // Test 6: Draw a string
    DrawFontLine(50, 105, BLACK, WHITE, "TEST 6: DRAW A STRING", 0, 0);
    DrawFontLine(450, 105, PURPLE, WHITE, "DUMMY STRING", 0, 0);

    // Test 7: Different colors
    DrawFontLine(50, 125, BLACK, CYAN, "TEST 7: DIFFERENT COLORS", 0, 0);

    for(i = 400; i < 800; i++){
        FilledRectangle(i, 120, 1, 20, i % 64);
    }
}