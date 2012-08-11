/*
  array.h
  Pascal Getreuer 2006-2007

  A little library for managing 2D double arrays.
  
*/

#include <math.h>
#include <png.h>

#define BLUE  101.123


class CArray
{
private:
    double *m_dpData;
    unsigned m_wWidth;
    unsigned m_wHeight;
    unsigned m_wNumEl;
public:
    inline CArray():m_dpData(0),m_wWidth(0),m_wHeight(0),m_wNumEl(0){}
    inline CArray(unsigned wNewWidth, unsigned wNewHeight):m_dpData(0)
	{Resize(wNewWidth, wNewHeight);}
    inline ~CArray()
	{
	    if(m_dpData)
		delete [] m_dpData;
	}
    void Resize(unsigned wNewWidth, unsigned wNewHeight);
    inline double* Data() const {return m_dpData;}
    inline unsigned Width() const {return m_wWidth;}
    inline unsigned Height() const {return m_wHeight;}
    inline unsigned NumEl() const {return m_wNumEl;}
    inline double& operator()(unsigned i, unsigned j)
	{return *(m_dpData + i*m_wHeight + j);}
    inline double& operator()(unsigned i)
	{return *(m_dpData + i);}
    void operator+=(double dA);
    void operator-=(double dA);
    void operator*=(double dA);
    int ReadPNG(char *cpPath);
    int WritePNG(char *cpPath);
};

double Max(const CArray &aArray);
double Min(const CArray &aArray);
