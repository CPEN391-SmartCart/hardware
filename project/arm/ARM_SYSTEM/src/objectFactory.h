#include "vga/map.h"

Section sections[] = {
	{132, 135, 81, 18, GREY},
	{132, 171, 81, 18, GREY},
	{132, 207, 81, 18, GREY},
	{132, 28, 81, 17, GREY},
	{132, 64, 81, 17, GREY},
	{132, 99, 81, 17, GREY},
	{151, 243, 62, 17, YELLOW},
	{151, 328, 62, 17, YELLOW},
	{151, 360, 62, 18, YELLOW},
	{151, 394, 62, 17, YELLOW},
	{151, 428, 62, 17, YELLOW},
	{260, 264, 13, 61, RED},
	{260, 29, 21, 160, RED},
	{260, 327, 13, 96, RED},
	{290, 264, 13, 61, BROWN},
	{290, 327, 13, 96, BROWN},
	{299, 123, 61, 18, BROWN},
	{299, 171, 61, 18, BROWN},
	{299, 29, 61, 17, BROWN},
	{299, 77, 61, 17, BROWN},
	{319, 264, 12, 61, BLUE},
	{319, 327, 12, 96, BLUE},
	{287, 216, 98, 17, BLUE},
	{34, 135, 59, 18, BLUE},
	{34, 171, 59, 18, BLUE},
	{34, 207, 59, 18, BLUE},
	{34, 243, 98, 17, BLUE},
	{34, 28, 59, 17, BLUE},
	{34, 328, 98, 17, BLUE},
	{34, 360, 79, 18, BLUE},
	{34, 394, 79, 17, BLUE},
	{34, 428, 79, 17, BLUE},
	{34, 64, 59, 17, BLUE},
	{34, 99, 59, 17, BLUE},
	{45, 278, 19, 33, BLUE},
	{92, 285, 39, 18, BLUE},
	{429, 29, 21, 160, BLUE},
	{347, 264, 13, 61, GREEN},
	{347, 327, 13, 96, GREEN},
	{381, 264, 21, 71, GREEN},
	{381, 29, 21, 160, GREEN},
	{381, 373, 21, 72, GREEN},
	{431, 216, 98, 17, PURPLE},
	{431, 264, 19, 71, PURPLE},
	{431, 373, 19, 72, PURPLE},
	{478, 264, 20, 71, CYAN},
	{478, 29, 20, 160, CYAN},
	{478, 373, 20, 72, CYAN},
	{527, 264, 19, 71, PINK},
	{527, 29, 19, 160, PINK},
	{527, 373, 19, 72, PINK},
	
};

Legend legends[] = {
    {"FROZEN FOOD", BLUE},
    {"FRUITS AND VEGETABLES", GREEN},
    {"STAPLES", YELLOW},
    {"CONDIMENTS", PURPLE},
    {"PHARMA AND SELF-CARE", PINK},
    {"BAKERY", CYAN},
    {"BREAKFAST", BROWN},
    {"CHECKOUT COUNTERS", GREY}
};

Item shoppingList[] = {
    {171, 323, NULL, "Brown Rice 2 kg"},
    {151, 225, NULL, "Mint Gum 5pc/pack"},
    {320, 211, NULL, "Frozen Lasagna 250g"}
};

PathVertex itemOnePath[] = {
	{238, 464},
	{238, 319},
	{173, 319},
	{173, 323}
};

PathVertex itemTwoPath[] = {
	{173, 327},
	{173, 314},
	{140, 314},
	{140, 236},
	{153, 236},
	{153, 230}
};

PathVertex itemThreePath[] = {
	{153, 225},
	{153, 234},
	{239, 234},
	{239, 208},
	{322, 208},
	{322, 210}
};