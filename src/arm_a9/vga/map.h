#define MAX_SIZE 50

void CreateStoreMap();
void UpdateBalance(double subtotal, double gstRate);

struct Legend
{
    char key[MAX_SIZE];
    int color;
};

struct Section
{
    int originX;
    int originY;
    int sectionWidth;
    int sectionHeight;
    int aisleColor;
};
