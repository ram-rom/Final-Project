#include <stdio.h>
//#include <conio.h>
#include <stdlib.h>

int main()
{
   int n, max=1, num , c;

   printf("Enter the number of random numbers you want\n");
   scanf("%d", &n);

  // printf("Enter the maximum value of random number\n");
   //scanf("%d", &max);

   printf("%d random numbers from 0 to %d are:\n", n, max);

   //randomize(max);
   
      for (c = 1; c <= n; c++)
         {
               num = rand() & 1;
   
                     printf("%d\n",num);
                        }
   
                         // getch();
                             return 0;
                            }
   
