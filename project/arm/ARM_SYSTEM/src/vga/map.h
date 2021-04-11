
#ifndef MAP_H_
#define MAP_H_

#include "graphics.h"
#include "../common.h"

#define MAX_SIZE 50
#define RES_HEIGHT 480
#define RES_WIDTH 800
#define SIDEPANEL_HEADER_X 590
#define SIDEPANEL_BALANCE_X 740
#define SIDEPANEL_BALANCE_Y 420
#define SIDEPANEL_SPLITTER_X 576
#define SIDEPANEL_TEXT_WIDTH 224
#define SIDEPANEL_WEIGHT_COMMAND_Y 165
#define SIDEPANEL_ITEMS_Y 210
#define SIDEPANEL_NEXT_ITEM_Y 385
#define PAYMENT_CONFIRMATION_X 200
#define PAYMENT_CONFIRMATION_Y 140
#define CARTSIZE 15

void SetupMap(int sectionSize, Section sections[], int legendSize, Legend legends[]);
void CreateStoreMap(int sectionSize, Section sections[], int legendSize, Legend legends[]);
void CreateSidePanel(int legendSize, Legend legends[]);
void AddItemToCart(Item item);
void ShowNextItem(char* itemName);
void DrawItemPath(int oldPathSize, coord_t oldPath[], int newPathSize, coord_t newPath[], int colour);
void DrawReconstructionPixels();
void DisplayWeighCommand(int mode);
void DisplayPaymentConfirmation();
void FloatToString(float n, char* res, int afterpoint, int dollarBool);
void Reverse(char* str, int len);
int IntegerToString(int x, char str[], int d, int dollarBool, int negativeBool);
#endif /* MAP_H_ */
