
#ifndef MAP_H_
#define MAP_H_

#include "graphics.h"
#include "../common.h"

/*
 * VGA constants
 */
#define MAX_SIZE 50
#define RES_HEIGHT 480
#define RES_WIDTH 800
#define SIDEPANEL_HEADER_X 590
#define SIDEPANEL_BALANCE_X 740
#define SIDEPANEL_BALANCE_Y 420
#define SIDEPANEL_SPLITTER_X 576
#define SIDEPANEL_TEXT_WIDTH 224
#define SIDEPANEL_WEIGHT_COMMAND_Y 190
#define SIDEPANEL_WEIGHT_Y 370
#define SIDEPANEL_ITEMS_Y 230
#define SIDEPANEL_NEXT_ITEM_Y 385
#define PAYMENT_CONFIRMATION_X 200
#define PAYMENT_CONFIRMATION_Y 140
#define CARTSIZE 10

/*
 * Sets up the store map and sidebar for a new session
 */
void SetupMap(int sectionSize, Section sections[], int legendSize, Legend legends[]);

/*
 * Draws the store map on the VGA
 */
void CreateStoreMap(int sectionSize, Section sections[], int legendSize, Legend legends[]);

/*
 * Draws the side panel on the VGA
 */
void CreateSidePanel(int legendSize, Legend legends[]);

/*
 * Adds an item to cart and displays it on the VGA cart
 */
void AddItemToCart(Item item);

/*
 * Displays the location on next item on the map
 */
void ShowNextItem(char* itemName);

/*
 * Displays the weight of a scaled item on the VGA sidepanel
 */
void ShowItemWeight(char *itemWeight);

/*
 * Draws the shortest path between items provided by the path planning
 * hardware accelerator. It also clears the old path drawn.
 */
void DrawItemPath(int oldPathSize, coord_t oldPath[], int newPathSize, coord_t newPath[], int colour);

/*
 * Restores overwritten pixels by the two ends of the path line
 */
void DrawReconstructionPixels();

/*
 * Displays weight scale related commands for users on the VGA sidepanel
 */
void DisplayWeighCommand(int mode);

/*
 * Displays transaction confirmation message on VGA and terminates session.
 */
void DisplayPaymentConfirmation();

/*
 * Code reference to convert floating point value to string 
 * in C: https://www.geeksforgeeks.org/convert-floating-point-number-string/.
 * Afterpoint determines the precision of the floating point value.
 * Setting dollarBool adds a dollar sign to the string.
 */

void FloatToString(float n, char* res, int afterpoint, int dollarBool);

/*
 * Reverses a character array
 */
void Reverse(char* str, int len);

/*
 * Converts an integer to a string.
 * Setting dollarBool adds a dollar sign to the string.
 * Setting negativeBool handles negative integer values.
 */
int IntegerToString(int x, char str[], int d, int dollarBool, int negativeBool);

#endif /* MAP_H_ */
