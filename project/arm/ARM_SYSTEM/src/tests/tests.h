
#ifndef TESTS_TESTS_H_
#define TESTS_TESTS_H_

void wifiSectionsRoutine(void);
void wifiItemRoutine(void);
void wifiLegendsRoutine(void);
void vgaRoutine(void);
void wifiNodeInfoRoutine(void);
void addToCart(void);
void delayTest(void);
void btTest(void);

void pathfindingTestNodeToNode(void);
void pathfindingTestNodeToItem(void);
void pathfindingTestItemToItem(void);

void weightScaleTestSpaghetti(void);
void weightScaleTestTuna(void);
void weightScaleTestOnion(void);
void weightScaleTestCocoa(void);

void imuTestX(void);
void imuTestY(void);
void imuTestZ(void);

/*
 * test utility function used for comparison and writing messages
 */
int testInt(char* test, int expected, int actual);
int testDouble(char* test, double expected, double actual);
int testString(char* test, char* expected, char* actual);

#endif /* TESTS_TESTS_H_ */
