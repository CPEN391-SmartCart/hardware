#include "graphics.h"

#define MAX_SIZE 50
#define RES_HEIGHT 480
#define RES_WIDTH 800
#define SIDEPANEL_HEADER_X 590
#define SIDEPANEL_BALANCE_X 732
#define SIDEPANEL_BALANCE_Y 410
#define SIDEPANEL_SPLITTER_X 576
#define SIDEPANEL_TEXT_WIDTH 224

typedef struct Legend
{
    char key[MAX_SIZE];
    int color;
} Legend;

typedef struct Section
{
    int originX;
    int originY;
    int sectionWidth;
    int sectionHeight;
    int aisleColor;
} Section;

typedef struct Line
{
    int x1;
    int y1;
    int x2;
    int y2;
} Line;

typedef struct PathVertex
{
    int x;
    int y;
} PathVertex;

typedef struct Item
{
	char *barcode;
	int section_id;
	double cost;
    int x;
    int y;
    int aisleColor;
    char *name;
} Item;

void CreateStoreMap(int sectionSize, Section sections[], int legendSize, Legend legends[]);
void CreateSidePanel(int legendSize, Legend legends[]);
void UpdateBalance(double subtotal, double gstRate);
void LoadItemColors(int listSize, Item shoppingList[]);
void ShowItem(Item item);
void HideItem(Item item);
void HideAllItems(int listSize, Item shoppingList[]);
void ShowNextItem(char* itemName);
void DrawItemPath(int oldPathSize, PathVertex oldPath[], int newPathSize, PathVertex newPath[]);

