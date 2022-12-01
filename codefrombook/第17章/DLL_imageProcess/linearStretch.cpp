// linearStretch.cpp: implementation of the ClinearStretch class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "linearStretch.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

ClinearStretch::ClinearStretch()
{

}

ClinearStretch::~ClinearStretch()
{

}
//¹¦ÄÜº¯Êý
long  ClinearStretch::ExtendImg(BYTE * Bits,int width,int height,int minpixel,int maxpixel)
{
	if(minpixel<0) minpixel=0;
	if(maxpixel>255) maxpixel=255;
	if(Bits==NULL || width<0 || height<0 )
		return 0;
	float a,b;
	a=(float)255/(maxpixel-minpixel);
	b=(float)-minpixel*255/(maxpixel-minpixel);
	for(int i=0;i<width*height;i++)
	{		
		float temp=((float)Bits[i]-minpixel)/(maxpixel-minpixel)*255;
				
		if(temp<0) temp=0.0;
		if(temp>255) temp=255.0;
		Bits[i]=(BYTE)temp;	
	}
	return 1;
}
