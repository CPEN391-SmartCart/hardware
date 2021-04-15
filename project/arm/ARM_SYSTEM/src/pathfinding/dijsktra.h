
#ifndef DIJKSTRA_H_
#define DIJKSTRA_H_


#include "../common.h"

#define PATH_GOAL_SET (volatile unsigned int *)(0xFF200200)

#define START_NODE_ID (volatile unsigned int *)(0xFF200210)
#define NEIGHBOUR_ID (volatile unsigned int *)(0xFF200230)
#define NEIGHBOUR (volatile unsigned int *)(0xFF200220)
#define PATH_FINISHED (volatile unsigned int *)(0xFF200240)

/**
 * Populates "path" with the shortest path between the given start node id and goal node id
 * Returns the length of the path
 */
int generate_path(int start_node_id, int goal_node_id, coord_t *path);


#endif /* DIJKSTRA_H_ */
