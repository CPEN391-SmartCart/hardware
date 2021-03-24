#include <stdio.h>
#include <string.h>
#include "map.h"

void CreateStoreMap(int sectionSize, Section sections[], int legendSize, Legend legends[]){
	size_t i;
	FilledRectangle(0, 0, RES_WIDTH, RES_HEIGHT, WHITE);

	for(i = 0; i < sectionSize; i++){
		Section section = sections[i];
		FilledRectangle(section.originX, section.originY, section.sectionWidth, section.sectionHeight, section.aisleColor);
		Rectangle(section.originX, section.originY, section.sectionWidth, section.sectionHeight, BLACK, 2);
	}
    return;
}

void CreateSidePanel(int legendSize, Legend legends[]){
	size_t i;
	FilledRectangle(SIDEPANEL_SPLITTER_X, 0, 2, 480, BLACK);

    DrawFontLine(SIDEPANEL_HEADER_X, 29, BLACK, WHITE, "LEGEND:", 1, 0);
    for(i = 0; i < legendSize; i++){
        FilledRectangle(SIDEPANEL_HEADER_X + 10, 58 + 15*i, 10, 9, legends[i].color);
        Rectangle(SIDEPANEL_HEADER_X + 10, 58 + 15*i, 10, 9, BLACK, 1);
        DrawFontLine(SIDEPANEL_HEADER_X + 30, 59 + 15*i, BLACK, WHITE, legends[i].key, 0, 0);
    }

    DrawFontLine(SIDEPANEL_HEADER_X, 280, BLACK, WHITE, "BLUETOOTH COMMAND RECEIVED:", 1, 0);
    
	DrawFontLine(SIDEPANEL_HEADER_X, 350, BLACK, WHITE, "NEXT ITEM ALONG THE PATH:", 1, 0);

    DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y, BLACK, WHITE, "BALANCE:", 1, 0);
    DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y + 20, BLACK, WHITE, "SUBTOTAL", 0, 0);
    DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 20, BLACK, WHITE, "$0.00", 0, 0);
    DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y + 30, BLACK, WHITE, "GST", 0, 0);
    DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 30, BLACK, WHITE, "$0.00", 0, 0);
    DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y + 40, BLACK, WHITE, "TOTAL", 0, 0);
    DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 40, BLACK, WHITE, "$0.00", 0, 0);

    return;
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

    // Clear out old balance
	ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 20, SIDEPANEL_TEXT_WIDTH, 7);
	ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 30, SIDEPANEL_TEXT_WIDTH, 7);
	ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 40, SIDEPANEL_TEXT_WIDTH, 7);

    // Draw updated balances
    DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 20, BLACK, WHITE, subtotalStr, 0, 0);
    DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 30, BLACK, WHITE, gstStr, 0, 0);
    DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 40, BLACK, WHITE, totalStr, 0, 0);
}

void LoadItemColors(int listSize, Item shoppingList[]){
    size_t i;

    for(i = 0; i < listSize; i++){
        shoppingList[i].aisleColor = ReadAPixel(shoppingList[i].x, shoppingList[i].y);
    }
}

void ShowItem(Item item){
    FilledRectangle(item.x, item.y, 5, 5, RED);
}

void HideItem(Item item){
    FilledRectangle(item.x, item.y, 5, 5, item.aisleColor);
}

void HideAllItems(int listSize, Item shoppingList[]){
	int i;

	for(i = 0; i < listSize; i++){
		HideItem(shoppingList[i]);
	}
}

void ShowNextItem(char* itemName){
	ClearTextField(SIDEPANEL_HEADER_X, 368, SIDEPANEL_TEXT_WIDTH, 7);
    DrawFontLine(SIDEPANEL_HEADER_X, 368, BLACK, WHITE, itemName, 0, 0);
}

void DrawItemPath(int oldPathSize, PathVertex oldPath[], int newPathSize, PathVertex newPath[]){
	int i;
	PathVertex corner0, corner1;

	// Clear old path
	for(i = 0; i < oldPathSize - 1; i++){
		corner0 = oldPath[i];
		corner1 = oldPath[i + 1];

		DrawAnyLine(corner0.x, corner0.y, corner1.x, corner1.y, WHITE);
	}

	// Draw new path
	for(i = 0; i < newPathSize - 1; i++){
		corner0 = newPath[i];
		corner1 = newPath[i + 1];

		DrawAnyLine(corner0.x, corner0.y, corner1.x, corner1.y, RED);
	}
}
