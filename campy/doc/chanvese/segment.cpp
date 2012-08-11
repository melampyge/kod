// "Active Contours Without Edges" image segmentation
// Program by Pascal Getreuer 2007

#include "array.h"

#define PI              3.141592653589793238
#define DIVIDE_EPS      1E-6


void Segment(CArray &aU0, unsigned wKMax, unsigned wKStep, double dMu,
	     double dNu, double dLambda1, double dLambda2, double dTimeStep);
void ComputeAverages(CArray &aU0, CArray &aPhi,
		     double &dC1, double &dC2);
void WriteOutput(CArray &aU0, CArray &aPhi, unsigned k);


// The main routine for performing the image segmentation
void Segment(CArray &aU0, unsigned wKMax, unsigned wKStep, double dMu,
	     double dNu, double dLambda1, double dLambda2, double dTimeStep)
{
   CArray aPhi;
   double *dpPhi;
   double dC1, dC2, dDelta, dPhiX, dPhiY, dT[6];
   double dTemp;
   int i, j, k,  Width, Height;


   dTimeStep /= PI;             // Precomputation for inner loop
   Width = aU0.Width();
   Height = aU0.Height();
   aPhi.Resize(Width, Height);
    
   //// Initialization for Phi ////
   dC1 = Max(aU0);
   dC2 = Min(aU0);
   dTemp = 0.5*(dC2 + dC1);

   // Set Phi to sign( aU0 - dTemp )
   for(i = 0; i < aPhi.NumEl(); i++) {
     aPhi(i) = (aU0(i) < dTemp)?1:-1;
   }

   // Make Phi smooth
   for(k = 0; k < 10; k++)
   {
      for(i = 1; i < Width-1; i++)
      {	
	 for(j = 1; j < Height-1; j++)
	 {
	    dTemp = (4*aPhi(i,j) + aPhi(i+1,j) + aPhi(i-1,j)
		     + aPhi(i,j+1) + aPhi(i,j-1))/8;

	    if(dTemp*aPhi(i,j) > 0.0)
	       aPhi(i,j) = dTemp;
	    else
	       aPhi(i,j) *= 0.5;
	 }
      }
   }

   // Output the starting point
   if(wKStep)     
      WriteOutput(aU0, aPhi, 0);
    
   //// Main optimization loop ////
   for(k = 1; k <= wKMax; k++)
   {
      ComputeAverages(aU0, aPhi, dC1, dC2);
      dpPhi = &aPhi(1,1);
      
      for(i = 1; i < Width-1; i++, dpPhi+=2)
      {	
	 for(j = 1; j < Height-1; j++, dpPhi++)
	 {
#define PHI_C    dpPhi[0]
#define PHI_U    dpPhi[-1]
#define PHI_D    dpPhi[1]
#define PHI_L    dpPhi[-Height]
#define PHI_R    dpPhi[Height]
#define PHI_UL   dpPhi[-1-Height]
#define PHI_UR   dpPhi[-1+Height]
#define PHI_DL   dpPhi[1-Height]
#define PHI_DR   dpPhi[1+Height]
	    
	    dTemp = dTimeStep/(1.0 + PHI_C * PHI_C);

	    dPhiX = PHI_R - PHI_C;
	    dPhiY = (PHI_D - PHI_U) * 0.5;
	    dT[0] = 1.0/sqrt(DIVIDE_EPS + dPhiX*dPhiX + dPhiY*dPhiY);
	    dPhiX = PHI_C - PHI_L;
	    dPhiY = (PHI_DL - PHI_UL) * 0.5;
	    dT[1] = 1.0/sqrt(DIVIDE_EPS + dPhiX*dPhiX + dPhiY*dPhiY);
	    dPhiX = (PHI_R - PHI_L) * 0.5;
	    dPhiY = PHI_D - PHI_C;
	    dT[2] = 1.0/sqrt(DIVIDE_EPS + dPhiX*dPhiX + dPhiY*dPhiY);
	    dPhiX = (PHI_UR - PHI_UL) * 0.5;
	    dPhiY = PHI_C - PHI_U;
	    dT[3] = 1.0/sqrt(DIVIDE_EPS + dPhiX*dPhiX + dPhiY*dPhiY);
	    
	    dT[4] = aU0(i,j) - dC1;
	    dT[5] = aU0(i,j) - dC2;
    
	    PHI_C = (PHI_C + dTemp*(
			    dMu*(
			       PHI_R*dT[0] + PHI_L*dT[1] +
			       PHI_D*dT[2] + PHI_U*dT[3])
			    - dNu - dLambda1*dT[4]*dT[4]
			    + dLambda2*dT[5]*dT[5]) ) /
	    (1.0 + dTemp*dMu*(
	       dT[0] + dT[1] + dT[2] + dT[3]));
	 }
      }

      // Boundary conditions
      for(i = 1; i < Width-1; i++)
      {
	 aPhi(i,0) = aPhi(i,1);
	 aPhi(i,Height-1) = aPhi(i,Height-2);
      }
		
      for(j = 1; j < Height-1; j++)
      {
	 aPhi(0,j) = aPhi(1,j);
	 aPhi(Width-1,j) = aPhi(Width-2,j);
      }

      // Output intermediate results every wKStep number of iterations
      if(wKStep && !(k%wKStep))
	 WriteOutput(aU0, aPhi, k);
      
   } // for k

   // Output the final result
   k--;
   if(!wKStep || k%wKStep)
      WriteOutput(aU0, aPhi, k);
}


// Compute the average intensities inside and outside the contour
void ComputeAverages(CArray &aU0, CArray &aPhi,
		     double &dC1, double &dC2)
{
   double dAverage1 = 0.0, dAverage2 = 0.0;
   unsigned i, wCount1 = 0, wCount2 = 0;

   if((i = aU0.NumEl()))
   {
      double *dpU0 = aU0.Data() - 1;
      double *dpPhi = aPhi.Data() - 1;
	 
      do
      {
	 if(*(++dpPhi) > 0.0)
	 {
	    wCount1++;
	    dAverage1 += *(++dpU0);
	 }
	 else
	 {
	    wCount2++;
	    dAverage2 += *(++dpU0);
	 }
      }while(--i);
   }

   dC1 = (wCount1)?(dAverage1/wCount1):0.0;
   dC2 = (wCount2)?(dAverage2/wCount2):0.0;
}


// Output intermediate results
void WriteOutput(CArray &aU0, CArray &aPhi, unsigned k)
{
   CArray aOut(2*aU0.Width(), aU0.Height());
   double dC1, dC2, dPhiX, dPhiY;
   unsigned Width = aU0.Width(), Height = aU0.Height();
   unsigned i,j;
   char cpOutputName[64];

   ComputeAverages(aU0, aPhi, dC1, dC2);
   printf(" %4d: c1 = %.4f  c2 = %.4f\n",
	  k, dC1, dC2);

   // Draw binary image
   for(i = 0; i < aPhi.NumEl(); i++)
   {
      aOut(i) = 0;
      aOut(i+Width*Height) =
      (aPhi(i) >= 0.0)?dC1:dC2;
   }

   // Draw the contour on top of the original image 
   for(i = 1; i < Width-1; i++)
   {	
      for(j = 1; j < Height-1; j++)
      {
	 dPhiX = aOut(i+Width+1,j) - aOut(i+Width-1,j);
	 dPhiY = aOut(i+Width,j+1) - aOut(i+Width,j-1);
	 aOut(i,j) = (dPhiX*dPhiX + dPhiY*dPhiY > 0.0)?BLUE:aU0(i,j);
      }
   }

   sprintf(cpOutputName,"out-%04d.png",k);
   aOut.WritePNG(cpOutputName);
}
