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

void DrawItemPath(int oldPathSize, path_t oldPath[], int newPathSize, path_t newPath[], int colour){
	// Current location on map
	FilledRectangle(newPath[newPathSize - 1].x - 3, newPath[newPathSize - 1].y - 3, 8, 8, colour);

	// Clear old path
	DrawItemPathHelper(oldPathSize, oldPath, WHITE);

    // Draw new path
	DrawItemPathHelper(newPathSize, newPath, colour);
}

void DrawItemPathHelper(int pathSize, path_t path[], int colour){
	int i;
	path_t corner0, corner1;

	for(i = 0; i < pathSize - 1; i++){
		corner0 = path[i];
		corner1 = path[i + 1];

		DrawAnyLine(corner0.x, corner0.y, corner1.x, corner1.y, colour);
		DrawAnyLine(corner0.x + 1, corner0.y + 1, corner1.x + 1, corner1.y + 1, colour);
	}

	DrawArrowHead(pathSize, path, colour);
}

void DrawArrowHead(int pathSize, path_t path[], int colour){
	int i;
	double arrowLength = 5;
	double grad;
	double gradPerpendicular;
	double coordArrowBaseX;
	double coordArrowBaseY;
	double coordArrow1X;
	double coordArrow1Y;
	double coordArrow2X;
	double coordArrow2Y;
	double deltaX;
	double deltaY;

	path_t goal = path[0];
	path_t goalPrev = path[1];

	deltaX = goal.x - goalPrev.x;
	deltaY = goal.y - goalPrev.y;

	if(goalPrev.x < goal.x){
		coordArrowBaseX = goal.x - arrowLength;
	} else {
		coordArrowBaseX = goal.x + arrowLength;
	}

	if(!deltaX && !deltaY){
		return;

	} else if(!deltaY){ // Horizontal
		coordArrow1X = coordArrowBaseX;
		coordArrow1Y = goal.y + arrowLength;
		coordArrow2X = coordArrowBaseX;
		coordArrow2Y = goal.y - arrowLength;

	} else if(!deltaX){ // Vertical
		coordArrow1X = goal.x + arrowLength;
		coordArrow1Y = coordArrowBaseY;
		coordArrow2X = goal.x - arrowLength;
		coordArrow2Y = coordArrowBaseY;

	} else {
		grad = deltaY/deltaX;
		gradPerpendicular = -1/grad;

		coordArrowBaseY = grad * (coordArrowBaseX - goal.x) + goal.y;
		coordArrow1X = coordArrowBaseX - grad * arrowLength;
		coordArrow1Y = gradPerpendicular * (coordArrow1X - coordArrowBaseX) + coordArrowBaseY;
		coordArrow2X = coordArrowBaseX + grad * arrowLength;
		coordArrow2Y = gradPerpendicular * (coordArrow2X - coordArrowBaseX) + coordArrowBaseY;

	}

	for(i = 0; i < 3; i++){
		DrawAnyLine(coordArrow1X + i, coordArrow1Y, goal.x + i, goal.y, colour);
		DrawAnyLine(coordArrow2X + i, coordArrow2Y, goal.x + i, goal.y, colour);
	}
}



//void DrawPathOnMap(){
//    DrawShortestPath(RED);
//}
