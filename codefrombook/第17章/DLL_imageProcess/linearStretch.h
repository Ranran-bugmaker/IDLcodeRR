// linearStretch.h: interface for the ClinearStretch class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_LINEARSTRETCH_H__33418675_D3BD_4DB5_BB08_628634EA08D1__INCLUDED_)
#define AFX_LINEARSTRETCH_H__33418675_D3BD_4DB5_BB08_628634EA08D1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class ClinearStretch  
{
public:
	ClinearStretch();
	virtual ~ClinearStretch();
	long  ExtendImg(BYTE * Bits,int width,int height,int minpixel,int maxpixel);
};

#endif // !defined(AFX_LINEARSTRETCH_H__33418675_D3BD_4DB5_BB08_628634EA08D1__INCLUDED_)
