#include "graphics.h"
#include "../common.h"

#define MAX_SIZE 50
#define RES_HEIGHT 480
#define RES_WIDTH 800
#define SIDEPANEL_HEADER_X 590
#define SIDEPANEL_BALANCE_X 732
#define SIDEPANEL_BALANCE_Y 410
#define SIDEPANEL_SPLITTER_X 576
#define SIDEPANEL_TEXT_WIDTH 224

typedef struct path_t
{
    short x;
    short y;
} path_t;


void CreateStoreMap(int sectionSize, Section sections[], int legendSize, Legend legends[]);
void CreateSidePanel(int legendSize, Legend legends[]);
void UpdateBalance(double subtotal, double gstRate);
void LoadItemColors(int listSize, Item shoppingList[]);
void ShowItem(Item item);
void HideItem(Item item);
void HideAllItems(int listSize, Item shoppingList[]);
void ShowNextItem(char* itemName);
void DrawItemPath(int oldPathSize, path_t oldPath[], int newPathSize, path_t newPath[], int colour);
void DrawItemPathHelper(int pathSize, path_t path[], int colour);
void DrawArrowHead(int pathSize, path_t path[], int colour);
//void DrawPathOnMap();

