#include "array.h"

void CArray::Resize(unsigned wNewWidth, unsigned wNewHeight)
{
   if(m_dpData)
      delete [] m_dpData;
    
   m_wWidth = wNewWidth;
   m_wHeight = wNewHeight;
   m_dpData = new double[m_wNumEl = m_wWidth*m_wHeight];
}


void CArray::operator+=(double dA)
{
   double *dpCur = m_dpData;
   unsigned int wCount;

   if(dpCur--)
   {
      if(wCount = m_wNumEl)
	 do
	 {
	    *(++dpCur) += dA;
	 }while(--wCount);
   }    
}


void CArray::operator-=(double dA)
{
   double *dpCur = m_dpData;
   unsigned int wCount;

   if(dpCur--)
   {
      if(wCount = m_wNumEl)
	 do
	 {
	    *(++dpCur) -= dA;
	 }while(--wCount);
   }    
}


void CArray::operator*=(double dA)
{
   double *dpCur = m_dpData;
   unsigned int wCount;

   if(dpCur--)
   {
      if(wCount = m_wNumEl)
	 do
	 {
	    *(++dpCur) *= dA;
	 }while(--wCount);
   }    
}


double Max(const CArray &aArray)
{
   double *dpCur = aArray.Data();
   double dMax;
   unsigned int wCount;

   if(dpCur)
   {
      dMax = *dpCur;
      wCount = aArray.NumEl();
	
      while(--wCount)
      {
	 if(*(++dpCur) > dMax)
	    dMax = *dpCur;
      }
   }
   else
      dMax = 0.0;

   return dMax;
}


double Min(const CArray &aArray)
{
   double *dpCur = aArray.Data();
   double dMin;
   unsigned int wCount;

   if(dpCur)
   {
      dMin = *dpCur;
      wCount = aArray.NumEl();
	
      while(--wCount)
      {
	 if(*(++dpCur) < dMin)
	    dMin = *dpCur;
      }
   }
   else
      dMin = 0.0;

   return dMin;
}


int CArray::ReadPNG(char *cpPath)
{
   FILE *fp;
   png_byte header[4];
   png_structp PngPtr;
   png_infop InfoPtr;
   png_uint_32 wWidth, wHeight;
   int iBitDepth, iColorType, iInterlaceType;
   unsigned i,j;


   // Open the file and check that it is a PNG file
   if(!(fp = fopen(cpPath, "rb"))
      || fread(header, 1, 4, fp) != 4
      || png_sig_cmp(header, 0, 4))
      return -1;

   // Read the info header
   if(!(PngPtr = png_create_read_struct(PNG_LIBPNG_VER_STRING,
					 NULL, NULL, NULL))
      || !(InfoPtr = png_create_info_struct(PngPtr)))
   {
      if(PngPtr)
	 png_destroy_read_struct(&PngPtr, png_infopp_NULL, png_infopp_NULL);

      fclose(fp);
      return -1;
   }

   if(setjmp(png_jmpbuf(PngPtr)))
   {
      png_destroy_read_struct(&PngPtr, &InfoPtr, png_infopp_NULL);
      fclose(fp);
      return -1;
   }

   png_init_io(PngPtr, fp);
   png_set_sig_bytes(PngPtr, 4);
   png_read_info(PngPtr, InfoPtr);
   png_get_IHDR(PngPtr, InfoPtr, &wWidth, &wHeight, &iBitDepth, &iColorType,
		&iInterlaceType, int_p_NULL, int_p_NULL);
   
   // Set reading to convert to 8-bit grayscale, ignoring alpha   
   png_set_strip_16(PngPtr);
   png_set_strip_alpha(PngPtr);

   if(iColorType == PNG_COLOR_TYPE_RGB
      || iColorType == PNG_COLOR_TYPE_RGB_ALPHA)
      png_set_rgb_to_gray_fixed(PngPtr, 1, 21268, 71514);
   
   if(iColorType == PNG_COLOR_TYPE_GRAY && iBitDepth < 8)
      png_set_gray_1_2_4_to_8(PngPtr);

   png_set_interlace_handling(PngPtr);
   png_read_update_info(PngPtr, InfoPtr);
   
   // Allocate image memory and read the image
   png_bytep RowPtrs[wHeight];

   for (j = 0; j < wHeight; j++)
      RowPtrs[j] = new png_byte[png_get_rowbytes(PngPtr, InfoPtr)];

   png_read_image(PngPtr, RowPtrs);
   
   // Done reading the file
   png_destroy_read_struct(&PngPtr, &InfoPtr, png_infopp_NULL);
   fclose(fp);
   
   // Convert the image byte data to double data
   Resize(wWidth, wHeight);
   
   for(j = 0; j < wHeight; j++)
      for(i = 0; i < wWidth; i++)
	 m_dpData[j + i*m_wHeight] = ((double)RowPtrs[j][i])/255.0;

   // Free the byte data
   for (j = 0; j < wHeight; j++)
      delete [] RowPtrs[j];
   
   return 0;
}


int CArray::WritePNG(char *cpPath)
{
   FILE *fp;
   png_structp PngPtr;
   png_infop InfoPtr;
   png_bytep RowPtrs[m_wHeight];
   double dValue;
   unsigned i,j;
   png_byte image[m_wHeight*m_wWidth*3];
   png_byte *bypPos = image - 1;
   png_byte byValue;
   
   // Open the file
   if(!(fp = fopen(cpPath, "wb")))
      return -1;
     
   if(!(PngPtr = png_create_write_struct(PNG_LIBPNG_VER_STRING,
					  NULL, NULL, NULL))
      || !(InfoPtr = png_create_info_struct(PngPtr)))
   {
      fclose(fp);

      if(PngPtr)
	 png_destroy_write_struct(&PngPtr,  png_infopp_NULL);
      
      return -1;
   }
      
   if (setjmp(png_jmpbuf(PngPtr)))
   {
      fclose(fp);
      png_destroy_write_struct(&PngPtr, &InfoPtr);
      return -1;
   }

   // Configure output for 8-bit RGB color data
   png_init_io(PngPtr, fp);
   png_set_IHDR(PngPtr, InfoPtr, m_wWidth, m_wHeight, 8, PNG_COLOR_TYPE_RGB,
		PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE,
		PNG_FILTER_TYPE_BASE);
   png_write_info(PngPtr, InfoPtr);      

   for(j = 0; j < m_wHeight; j++)
      for(i = 0; i < m_wWidth; i++)
      {
	 dValue = m_dpData[i*m_wHeight + j];
	 
	 if(dValue == BLUE)
	 {  // output a blue pixel
	    *(++bypPos) = 0;
	    *(++bypPos) = 0;
	    *(++bypPos) = 255;
	 }
	 else
	 {
	    byValue = (dValue > 1.0)?255:(
	       (dValue < 0.0)?0:(png_byte)(dValue*255.0) );

	    // output a grayscale pixel
	    *(++bypPos) = byValue;
	    *(++bypPos) = byValue;
	    *(++bypPos) = byValue;
	 }
      }
   
   for(j = 0; j < m_wHeight; j++)
      RowPtrs[j] = image + j*m_wWidth*3;

   // Write the file
   png_write_image(PngPtr, RowPtrs);
   png_write_end(PngPtr, InfoPtr);
   fclose(fp);

   return 0;
}
