/*
  Tony Chan's and Luminita Vese's "Active Contours Without Edges"
  image segmentation method
  Program by Pascal Getreuer 2007

  
  This command line program runs the segmentation method on a given
  input image, for example,

      segment input.png mu=0.5 kmax=25

  runs the segmentation on "input.png" with mu=0.5 for 25 iterations.
  For further usage instructions, run the program without any inputs,
  or read PrintHelp function at the end of this file.

  
  Compiling notes:
  
  Enabling code optimization may significantly speed up the main loop
  of the program (use the -O3 flag with GCC).
  
  This program requires the libpng and zlib libraries in order to read
  and write PNG image files.  These libraries are freely avaiable at
  www.libpng.org.
*/
#include <cstdlib>
#include "array.h"


void Segment(CArray &aU0, unsigned wKMax, unsigned wKStep, double dMu,
	     double dNu, double dLambda1, double dLambda2, double dTimeStep);
void PrintHelp();


int main(int argc, char *argv[])
{
   CArray aU0;
   double dTemp;
   double dMu = 0.1, dNu = 0, dLambda1 = 1, dLambda2 = 1, dTimeStep = 0.1;
   unsigned wKMax = 100, wKStep = 0xFFFFFFFF;
   int i;
   char *cpParse;
   

   if(argc == 1 || (argc == 2 && !strcmp(argv[1],"--help")) )
   {
      PrintHelp();
      return 0;
   }

   // Parse input parameters
   for(i = 2; i < argc; i++)
      if((cpParse = strchr(argv[i], '=')))
      {
	 *cpParse = 0;
	 dTemp = atof(cpParse+1);

	 if(!strcmp(argv[i],"kmax"))
	    wKMax = (unsigned)dTemp;
	 else if(!strcmp(argv[i],"kstep"))
	    wKStep = (unsigned)dTemp;
	 else if(!strcmp(argv[i],"mu"))
	    dMu = dTemp;
	 else if(!strcmp(argv[i],"nu"))
	    dNu = dTemp;
	 else if(!strcmp(argv[i],"lambda1"))
	    dLambda1 = dTemp;
	 else if(!strcmp(argv[i],"lambda2"))
	    dLambda2 = dTemp;
	 else if(!strcmp(argv[i],"dt"))
	    dTimeStep = dTemp;
	 else
	 {
	    printf("Unknown parameter, \"%s\".\n",argv[i]);
	    return 1;
	 }
      }
      else
      {
	 printf("Invalid input syntax, \"%s\".\n",argv[i]);
	 return 1;
      }

   if(wKStep == 0xFFFFFFFF)
      wKStep = (wKMax + 3) / 4;
   
   // Open the input image
   if(aU0.ReadPNG(argv[1]))
   {
      printf("Unable to open input file, \"%s\".\n",argv[1]);
      return 1;
   }

   printf("Input image:  \"%s\" (%dx%d)\n\
Parameters:    kmax=%d  mu=%g  nu=%g  lambda1=%g  lambda2=%g  dt=%g\n\n",
	  argv[1], aU0.Width(), aU0.Height(), wKMax,
	  dMu, dNu, dLambda1, dLambda2, dTimeStep);

   // Perform the segmentation
   Segment(aU0, wKMax, wKStep, dMu, dNu, dLambda1, dLambda2, dTimeStep);
   printf("\n");
   
   return 0;
}


// Print the usage instructions
void PrintHelp()
{
   printf("\"Active Contours Without Edges\" segmentation by Tony Chan \
and Luminita Vese\n\
Implementation by Pascal Getreuer 2007\n\n\
Usage: segment file [parameter=value ...]\n\
where \"file\" is a PNG file.\n\n\
Valid parameters are\n\
\tkmax     total number of iterations (default 100)\n\
\tkstep    number of iterations between output (default kmax/4)\n\
\tmu       length penalty (default 0.25)\n\
\tnu       area penalty (default 0.0)\n\
\tlambda1  weight for fit error inside the cuve (default 1.0)\n\
\tlambda2  weight for fit error outside the curve (default 1.0)\n\
\tdt       time step (default 0.1)\n\
Parameters epsilon=1.0 and h=1.0 are hardcoded.\n\n\
The program outputs intermediate results every kstep iterations.  To output\n\
only the final results, set kstep=0.\n\n\
Example:\n\
    segment input.png kmax=20 kstep=0 mu=0.5\n");
}
