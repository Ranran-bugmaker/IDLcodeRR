#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "imageStretch.h"
#include "export.h"
 
//过程声明
extern void IDL_CDECL IMAGESTRETCH_STRETCH(int argc, IDL_VPTR argv[], char *argk);

static char statusBuffer[256];
//这里的imageStretch和DLM文件中的过程名字要一致
//    也是IDL调用DLL的接口格式
static IDL_SYSFUN_DEF2 imageStretch_procedures[] = {
	{(IDL_FUN_RET) IMAGESTRETCH_STRETCH, "IMAGESTRETCH", 5, 5, 0, 0},
};

#if defined(WIN32)
#include <windows.h>
#endif

int IMAGESTETCH_Startup(VOID)
{
	//procedures的运行
	if (!IDL_SysRtnAdd(imageStretch_procedures, FALSE, ARRLEN(imageStretch_procedures)))
	{
		return IDL_FALSE;
    }
	
	IDL_ExitRegister(IMAGESTETCH_exit_handler);
	return(IDL_TRUE);

}

VOID IDL_CDECL IMAGESTRETCH_STRETCH(int argc,IDL_VPTR argv[],char *argk)
{		
		//元素的初始化定义	
		int numElements,width,height,minpixel,maxpixel;	
				int i;
				byte *pInArray;		
					
				IDL_ENSURE_ARRAY(argv[0]);
						
				//存储元素的总个数
				numElements =argv[0]->value.arr->n_elts;
				// ndims = argv[0]->value.arr->n_dim;	
					
				IDL_ENSURE_SCALAR(argv[1]);
				width = IDL_LongScalar(argv[1]);        	
					
				IDL_ENSURE_SCALAR(argv[2]);
				height = IDL_LongScalar(argv[2]);
							
				IDL_ENSURE_SCALAR(argv[3]);
				minpixel = IDL_LongScalar(argv[3]);
							
				IDL_ENSURE_SCALAR(argv[4]);
				maxpixel = IDL_LongScalar(argv[4]);
				
				//获取输入的byte数据
				pInArray = argv[0]->value.arr->data;  
						
				if(minpixel<0) minpixel=0;
				if(maxpixel>255) maxpixel=255;			
					
				for(i=0;i<width*height;i++)
				{			
					float temp=((float)pInArray[i]-minpixel)/(maxpixel-minpixel)*255;			
					if(temp<0) temp=0.0;
					if(temp>255) temp=255.0;	
					//计算后赋值
					pInArray[i]= (byte)temp;
				}
						
}

// 当IDL关闭时调用-析构函数
VOID IMAGESTETCH_exit_handler(VOID)
{
	//什么都不做
};

