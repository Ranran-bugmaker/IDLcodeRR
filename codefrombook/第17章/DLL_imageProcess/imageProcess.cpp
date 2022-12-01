// imageProcess.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "idl_export.h"
#include "linearStretch.h"

#ifdef WIN32
#define IDL_LONG_RETURN extern "C" _declspec(dllexport) long
#else
#define IDL_LONG_RETURN long
#endif

IDL_LONG_RETURN ImgExtend(int argc,void *argv[])
{
	//用指针类型变量获得外部数据的地址
	BYTE *SrcBits=(BYTE *)argv[0];
	int *iw=NULL;
	iw=(int *)argv[1];
	int *ih=NULL;
	ih=(int *)argv[2];
	int *minp=NULL;
	minp=(int *)argv[3];
	int *maxp=NULL;
	maxp=(int *)argv[4];
	ClinearStretch  Img;
	return Img.ExtendImg(SrcBits,*iw,*ih,*minp,*maxp);   
}
