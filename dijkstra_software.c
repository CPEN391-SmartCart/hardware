/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include <stdbool.h>

int main()
{
    printf("starting");
    int i, j;
    int infinity = 10000;
    int max = 10;
    int start = 0;
    
    int map[10][10] = {
        {0, 2, infinity, infinity, infinity, infinity, infinity, infinity, infinity, infinity},
        {2, 0, 1, 3, infinity, infinity, infinity, infinity, infinity, infinity},
        {infinity, 1, 0, infinity, infinity, infinity, 2, infinity, infinity, infinity},
        {infinity, 3, infinity, 0, 4, infinity, infinity, infinity, infinity, infinity},
        {infinity, infinity, infinity, 4, 0, 2, infinity, infinity, infinity, infinity},
        {infinity, infinity, infinity, infinity, 2, 0, 4, infinity, 2, infinity},
        {infinity, infinity, 2, infinity, infinity, 4, 0, 2, infinity, infinity},
        {infinity, infinity, infinity, infinity, infinity, infinity, 2, 0, 1, infinity},
        {infinity, infinity, infinity, infinity, infinity, infinity, infinity, 1, 0, 3},
        {infinity, infinity, infinity, infinity, infinity, infinity, infinity, infinity, 3, 0},
    };

    int distance[10];
    bool shortest[10];
    int neighbor[10];
    
    for(i=0; i<max; i++)
    {
      distance[i] = map[start][i];
      shortest[i] = false;
      neighbor[i] = start;
    }
    
    shortest[start] = true;
    
    int new = 0;             // new means the new minimum-cost location
    
    for(i=1; i<max; i++)
    {
      int min_dist = infinity;
    
      for(j=0; j<max; j++)
        {
          if(!shortest[j] && min_dist>distance[j])
            {
              min_dist = distance[j];
              new      = j;
            }
      }
      
      shortest[new]=true;
      
      for(j=0; j<max; j++)
        {
          if(!shortest[j] && map[new][j]<infinity)
            {
              if(distance[new] + map[new][j] < distance[j])
                { 
                  distance[j] = distance[new] + map[new][j];
                  neighbor[j] = new;
                }
            }
        }
    }

    return 0;
}
