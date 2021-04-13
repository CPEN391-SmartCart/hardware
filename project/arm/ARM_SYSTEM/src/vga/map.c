#include <stdio.h>
#include <string.h>
#include <math.h>
#include "map.h"

Item cart[CARTSIZE];
int numberOfItems = 0;
double subtotal = 0.0;
double gstRate = 0.05;

// Arrow head reconstruction
int reconstructionGoalX;
int reconstructionGoalY;
int reconstructionPixelGoal[30][30];

int reconstructionStartX;
int reconstructionStartY;
int reconstructionPixelStart[30][30];

int reconstructionFlag = 0;

// private helper functions
void UpdateBalance(double itemCost);
void DrawItemPathHelper(int pathSize, coord_t path[], int colour, int clear);
void DrawArrowHead(int pathSize, coord_t path[], int colour);

void SetupMap(int sectionSize, Section sections[], int legendSize, Legend legends[])
{
	CreateStoreMap(sectionSize, sections, legendSize, legends);
	CreateSidePanel(legendSize, legends);

	// Clear cart
	numberOfItems = 0;
	subtotal = 0.0;
}

void CreateStoreMap(int sectionSize, Section sections[], int legendSize, Legend legends[])
{
	size_t i;
	FilledRectangle(0, 0, SIDEPANEL_SPLITTER_X, RES_HEIGHT, WHITE);

	for (i = 0; i < sectionSize; i++)
	{
		Section section = sections[i];
		FilledRectangle(section.originX, section.originY, section.sectionWidth, section.sectionHeight, section.aisleColor);
		Rectangle(section.originX, section.originY, section.sectionWidth, section.sectionHeight, BLACK, 2);
	}
	return;
}

void CreateSidePanel(int legendSize, Legend legends[])
{
	size_t i;
	FilledRectangle(SIDEPANEL_SPLITTER_X, 0, RES_WIDTH - SIDEPANEL_SPLITTER_X, RES_HEIGHT, WHITE);
	FilledRectangle(SIDEPANEL_SPLITTER_X, 0, 2, 480, BLACK);

	DrawFontLine(SIDEPANEL_HEADER_X, 15, BLACK, WHITE, "LEGEND:", 1, 0);
	for (i = 0; i < legendSize; i++)
	{
		FilledRectangle(SIDEPANEL_HEADER_X + 10, 30 + 15 * i, 10, 9, legends[i].color);
		Rectangle(SIDEPANEL_HEADER_X + 10, 30 + 15 * i, 10, 9, BLACK, 1);
		DrawFontLine(SIDEPANEL_HEADER_X + 30, 31 + 15 * i, BLACK, WHITE, legends[i].key, 0, 0);
	}

	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_ITEMS_Y, BLACK, WHITE, "ITEMS IN CART (RECENT 10):", 1, 0);
	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_WEIGHT_Y, BLACK, WHITE, "WEIGHT OF ITEM:", 1, 0);
	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_NEXT_ITEM_Y, BLACK, WHITE, "NEXT ITEM:", 1, 0);
	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y, BLACK, WHITE, "BALANCE:", 1, 0);
	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y + 20, BLACK, WHITE, "SUBTOTAL", 0, 0);
	DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 20, BLACK, WHITE, "$0.00", 0, 0);
	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y + 30, BLACK, WHITE, "GST", 0, 0);
	DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 30, BLACK, WHITE, "$0.00", 0, 0);
	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_BALANCE_Y + 40, BLACK, WHITE, "TOTAL", 0, 0);
	DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 40, BLACK, WHITE, "$0.00", 0, 0);

	return;
}

void AddItemToCart(Item item)
{
	int i;
	int vgaIndex;
	int size;
	char name[MAX_SIZE];
	char cost[MAX_SIZE];
	char truncatedName[13];

	cart[numberOfItems % CARTSIZE] = item;
	numberOfItems++;
	size = numberOfItems > CARTSIZE ? CARTSIZE : numberOfItems;
	UpdateBalance(item.cost);

	// Clear weight commands
	ClearTextField(SIDEPANEL_HEADER_X, SIDEPANEL_WEIGHT_COMMAND_Y, SIDEPANEL_TEXT_WIDTH, 7);
	ClearTextField(SIDEPANEL_HEADER_X, SIDEPANEL_WEIGHT_COMMAND_Y + 15, SIDEPANEL_TEXT_WIDTH, 7);
	//ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_WEIGHT_Y, SIDEPANEL_TEXT_WIDTH, 7);

	// Display items on vga
	for (i = 0; i < size; i++)
	{
		vgaIndex = numberOfItems > CARTSIZE ? numberOfItems - CARTSIZE + i + 1 : i + 1;

		if (strlen(cart[i].name) < 12)
		{
			sprintf(name, "%d) %s", vgaIndex, cart[i].name);
		}
		else
		{
			memcpy(truncatedName, cart[i].name, 12);
			truncatedName[12] = '\0';
			sprintf(name, "%d) %s...", vgaIndex, truncatedName);
		}

		FloatToString(cart[i].cost, cost, 2, 1);

		ClearTextField(SIDEPANEL_HEADER_X, SIDEPANEL_ITEMS_Y + 15 + 10 * i, SIDEPANEL_TEXT_WIDTH, 7);
		DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_ITEMS_Y + 15 + 10 * i, BLACK, WHITE, name, 0, 0);
		DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_ITEMS_Y + 15 + 10 * i, BLACK, WHITE, cost, 0, 0);
	}
}

void UpdateBalance(double itemCost)
{
	char subtotalStr[MAX_SIZE];
	char gstStr[MAX_SIZE];
	char totalStr[MAX_SIZE];

	subtotal += itemCost;
	double gst = subtotal * gstRate;
	double total = subtotal + gst;

	FloatToString(subtotal, subtotalStr, 2, 1);
	FloatToString(gst, gstStr, 2, 1);
	FloatToString(total, totalStr, 2, 1);

	// Clear out old balance
	ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 20, SIDEPANEL_TEXT_WIDTH, 7);
	ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 30, SIDEPANEL_TEXT_WIDTH, 7);
	ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 40, SIDEPANEL_TEXT_WIDTH, 7);

	// Draw updated balances
	DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 20, BLACK, WHITE, subtotalStr, 0, 0);
	DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 30, BLACK, WHITE, gstStr, 0, 0);
	DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_BALANCE_Y + 40, BLACK, WHITE, totalStr, 0, 0);
}

void ShowNextItem(char *itemName)
{
	ClearTextField(SIDEPANEL_HEADER_X, SIDEPANEL_NEXT_ITEM_Y + 15, SIDEPANEL_TEXT_WIDTH, 7);
	DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_NEXT_ITEM_Y + 15, BLACK, WHITE, itemName, 0, 0);
}

void ShowItemWeight(char *itemWeight)
{
	ClearTextField(SIDEPANEL_BALANCE_X, SIDEPANEL_WEIGHT_Y, SIDEPANEL_TEXT_WIDTH, 7);
	DrawFontLine(SIDEPANEL_BALANCE_X, SIDEPANEL_WEIGHT_Y, BLACK, WHITE, itemWeight, 0, 0);
}

void DrawItemPath(int oldPathSize, coord_t oldPath[], int newPathSize, coord_t newPath[], int colour)
{
	// Clear old path
	DrawItemPathHelper(oldPathSize, oldPath, WHITE, 1);

	// Draw new path
	DrawItemPathHelper(newPathSize, newPath, colour, 0);
	FilledRectangle(newPath[newPathSize - 1].x - 3, newPath[newPathSize - 1].y - 3, 8, 8, colour);
}

void DrawItemPathHelper(int pathSize, coord_t path[], int colour, int clear)
{
	int i;
	coord_t corner0, corner1;

	if (!clear)
	{
		DrawArrowHead(pathSize, path, colour);
	}

	for (i = 0; i < pathSize - 1; i++)
	{
		corner0 = path[i];
		corner1 = path[i + 1];

		DrawAnyLine(corner0.x, corner0.y, corner1.x, corner1.y, colour);
		DrawAnyLine(corner0.x + 1, corner0.y + 1, corner1.x + 1, corner1.y + 1, colour);
	}

	if (clear && reconstructionFlag)
	{
		DrawReconstructionPixels();
	}
}

void DrawReconstructionPixels()
{
	int i;
	int j;

	for (i = 0; i < 30; i++)
	{
		for (j = 0; j < 30; j++)
		{
			WriteAPixel(reconstructionGoalX - 15 + i, reconstructionGoalY - 15 + j, reconstructionPixelGoal[i][j]);
			WriteAPixel(reconstructionStartX - 15 + i, reconstructionStartY - 15 + j, reconstructionPixelStart[i][j]);
		}
	}
}

void DrawArrowHead(int pathSize, coord_t path[], int colour)
{
	int i;
	int j;
	double arrowLength = 1;
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

	coord_t goal = path[0];
	coord_t goalPrev = path[1];

	// store pixels for section reconstruction
	reconstructionGoalX = goal.x;
	reconstructionGoalY = goal.y;

	reconstructionStartX = path[pathSize - 1].x;
	reconstructionStartY = path[pathSize - 1].y;

	for (i = 0; i < 30; i++)
	{
		for (j = 0; j < 30; j++)
		{
			reconstructionPixelGoal[i][j] = ReadAPixel(reconstructionGoalX - 15 + i, reconstructionGoalY - 15 + j);
			reconstructionPixelStart[i][j] = ReadAPixel(reconstructionStartX - 15 + i, reconstructionStartY - 15 + j);
		}
	}

	reconstructionFlag = 1;

	FilledRectangle(goal.x - 3, goal.y - 3, 8, 8, RED);

	// deltaX = goal.x - goalPrev.x;
	// deltaY = goal.y - goalPrev.y;

	// if (goalPrev.x < goal.x)
	// {
	// 	coordArrowBaseX = goal.x - arrowLength;
	// }
	// else
	// {
	// 	coordArrowBaseX = goal.x + arrowLength;
	// }

	// if (!deltaX && !deltaY)
	// {
	// 	return;
	// }
	// else if (!deltaY)
	// { // Horizontal
	// 	coordArrow1X = coordArrowBaseX;
	// 	coordArrow1Y = goal.y + arrowLength;
	// 	coordArrow2X = coordArrowBaseX;
	// 	coordArrow2Y = goal.y - arrowLength;
	// }
	// else if (!deltaX)
	// { // Vertical
	// 	coordArrow1X = goal.x + arrowLength;
	// 	coordArrow1Y = coordArrowBaseY;
	// 	coordArrow2X = goal.x - arrowLength;
	// 	coordArrow2Y = coordArrowBaseY;
	// }
	// else
	// {
	// 	grad = deltaY / deltaX;
	// 	gradPerpendicular = -1 / grad;

	// 	coordArrowBaseY = grad * (coordArrowBaseX - goal.x) + goal.y;
	// 	coordArrow1X = coordArrowBaseX - grad * arrowLength;
	// 	coordArrow1Y = gradPerpendicular * (coordArrow1X - coordArrowBaseX) + coordArrowBaseY;
	// 	coordArrow2X = coordArrowBaseX + grad * arrowLength;
	// 	coordArrow2Y = gradPerpendicular * (coordArrow2X - coordArrowBaseX) + coordArrowBaseY;
	// }

	// for (i = 0; i < 3; i++)
	// {
	// 	DrawAnyLine(coordArrow1X + i, coordArrow1Y, goal.x + i, goal.y, colour);
	// 	DrawAnyLine(coordArrow2X + i, coordArrow2Y, goal.x + i, goal.y, colour);
	// }
}

// mode: 0 - request weighing, 1 - invalid weight
void DisplayWeighCommand(int mode)
{
	char *requestWeighing1 = "PLEASE PLACE ITEM IN CART";
	char *requestWeighing2 = "TO WEIGH SCANNED ITEM!";

	char *invalidWeight1 = "PLEASE REMOVE ITEM PLACED";
	char *invalidWeight2 = "IN CART AND SCAN AGAIN!";

	if (!mode)
	{
		DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_WEIGHT_COMMAND_Y, RED, WHITE, requestWeighing1, 1, 0);
		DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_WEIGHT_COMMAND_Y + 15, RED, WHITE, requestWeighing2, 1, 0);
	}
	else
	{
		DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_WEIGHT_COMMAND_Y, RED, WHITE, invalidWeight1, 1, 0);
		DrawFontLine(SIDEPANEL_HEADER_X, SIDEPANEL_WEIGHT_COMMAND_Y + 15, RED, WHITE, invalidWeight2, 1, 0);
	}
}

void DisplayPaymentConfirmation()
{
	char *string1 = "We have processed and confirmed your transaction.";
	char *string2 = "A copy of the receipt has been sent to your app.";
	char *string3 = "Thank you for shopping with us. See you soon.";

	FilledRectangle(PAYMENT_CONFIRMATION_X, PAYMENT_CONFIRMATION_Y, 400, 200, WHITE);
	Rectangle(PAYMENT_CONFIRMATION_X, PAYMENT_CONFIRMATION_Y, 400, 200, BLACK, 2);

	DrawFontLine(PAYMENT_CONFIRMATION_X + 30, SIDEPANEL_WEIGHT_COMMAND_Y + 10, BLACK, WHITE, string1, 1, 0);
	DrawFontLine(PAYMENT_CONFIRMATION_X + 30, SIDEPANEL_WEIGHT_COMMAND_Y + 40, BLACK, WHITE, string2, 1, 0);
	DrawFontLine(PAYMENT_CONFIRMATION_X + 30, SIDEPANEL_WEIGHT_COMMAND_Y + 70, BLACK, WHITE, string3, 1, 0);
}

/*
 * Code reference to convert floating point value to string 
 * in C: https://www.geeksforgeeks.org/convert-floating-point-number-string/
 */

void Reverse(char *str, int len)
{
	int i = 0, j = len - 1, temp;
	while (i < j)
	{
		temp = str[i];
		str[i] = str[j];
		str[j] = temp;
		i++;
		j--;
	}
}

int IntegerToString(int x, char str[], int d, int dollarBool, int negativeBool)
{
	int i = 0;

	if (!x && dollarBool)
		str[i++] = '0';

	while (x)
	{
		str[i++] = (x % 10) + '0';
		x = x / 10;
	}

	while (i < d)
		str[i++] = '0';

	if (negativeBool)
		str[i++] = '-';

	if (dollarBool)
		str[i++] = '$';

	Reverse(str, i);
	str[i] = '\0';
	return i;
}

void FloatToString(float n, char *res, int afterpoint, int dollarBool)
{
	int negativeBool;
	float absoluteFloat;

	if (n < 0)
	{
		negativeBool = 1;
		absoluteFloat = n * -1.0;
	}
	else
	{
		negativeBool = 0;
		absoluteFloat = n;
	}

	int ipart = (int)absoluteFloat;
	float fpart = absoluteFloat - (float)ipart;
	int i = IntegerToString(ipart, res, 0, dollarBool, negativeBool);

	if (afterpoint != 0)
	{
		res[i] = '.';
		fpart = fpart * pow(10, afterpoint);

		IntegerToString((int)fpart, res + i + 1, afterpoint, 0, 0);
	}
}
