#include <stdio.h>
#include <string.h>
#include "graphics.h"
#include "map.h"

void CreateStoreMap(){
    int i;
    int legendSize = 8;
    int sectionSize = 13;

    struct Legend legends[] = {
        {"FROZEN FOOD", BLUE},
        {"FRUITS AND VEGETABLES", GREEN},
        {"STAPLES", YELLOW},
        {"CONDIMENTS", PURPLE},
        {"PHARMA AND SELF-CARE", PINK},
        {"BAKERY", CYAN},
        {"BREAKFAST", BROWN},
        {"CHECKOUT COUNTERS", GREY}
    };

    struct Section sections[] = {
        {5, 45, 54, 341, BLUE},
        {72, 5, 186, 43, BLUE},
        {96, 82, 54, 233, GREEN},
        {178, 82, 54, 233, BROWN},
        {260, 82, 54, 233, YELLOW},
        {342, 82, 54, 233, PURPLE},
        {94, 384, 50, 91, PINK},
        {164, 384, 50, 91, PINK},
        {236, 430, 162, 45, CYAN},
        {454, 82, 118, 45, GREY},
        {454, 144, 118, 45, GREY},
        {454, 210, 118, 45, GREY},
        {454, 276, 118, 45, GREY}
    };

    // Blank canvas
    FilledRectangle(0, 0, 800, 480, BLACK);
    FilledRectangle(5, 5, 790, 470, WHITE);
    FilledRectangle(584, 0, 5, 480, BLACK);

    // Build section blocks
    for(i = 0; i < sectionSize; i++){
        FilledRectangle(sections[i].originX, sections[i].originY, sections[i].sectionWidth, sections[i].sectionHeight, sections[i].aisleColor);
    }

    DrawFontLine(606, 29, BLACK, WHITE, "LEGEND", 0);
    for(i = 0; i < 8; i++){
        FilledRectangle(612, 58 + 15*i, 10, 9, legends[i].color);
        DrawFontLine(625, 59 + 15*i, BLACK, WHITE, legends[i].key, 0);
    }

    DrawFontLine(606, 407, BLACK, WHITE, "BALANCE", 0);
    DrawFontLine(606, 425, BLACK, WHITE, "SUBTOTAL", 0);
    DrawFontLine(732, 425, BLACK, WHITE, "$0.00", 0);
    DrawFontLine(606, 435, BLACK, WHITE, "GST", 0);
    DrawFontLine(732, 435, BLACK, WHITE, "$0.00", 0);
    DrawFontLine(606, 445, BLACK, WHITE, "TOTAL", 0);
    DrawFontLine(732, 445, BLACK, WHITE, "$0.00", 0);
}

void UpdateBalance(double subtotal, double gstRate){
    char subtotalStr[MAX_SIZE];
    char gstStr[MAX_SIZE];
    char totalStr[MAX_SIZE];

    double gst = subtotal * gstRate;
    double total = subtotal + gst;

    sprintf(subtotalStr, "$%.2f", subtotal);
    sprintf(gstStr, "$%.2f", gst);
    sprintf(totalStr, "$%.2f", total);

    // Clears out old balance
    FilledRectangle(732, 425, 50, 30, WHITE);

    DrawFontLine(732, 425, BLACK, WHITE, subtotalStr, 0);
    DrawFontLine(732, 435, BLACK, WHITE, gstStr, 0);
    DrawFontLine(732, 445, BLACK, WHITE, totalStr, 0);
}

int main(void)
{
    printf("Clearing screen...\n");
    Reset();
    int i;
    char str[10];

    // for(i = 0; i < 32; i++){
    //     FilledRectangle(15*i, 100, 10, 10, i);

    //     sprintf(str, "%d", i);
    //     DrawFontLine(15*i, 112, WHITE, BLACK, str, 0);
    // }

    // for(i = 32; i < 64; i++){
    //     FilledRectangle(15*(i - 32), 150, 10, 10, i);

    //     sprintf(str, "%d", i);
    //     DrawFontLine(15*(i - 32), 162, WHITE, BLACK, str, 0);
    // }

    printf("Creating store map...\n");
    CreateStoreMap();
    UpdateBalance(10.15, 0.05);

    printf("Done...\n");
    return 0;
}