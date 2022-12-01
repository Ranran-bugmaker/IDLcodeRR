#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "imageStretch.h"
#include "export.h"

//初始化定义错误变量
static IDL_MSG_DEF msg_arr[]=
{	
	{	"imageStretch_ERROR",					"%NError:%s."},
	{	"imageStretch_NOSTRINGARRAY",			"%Nstring arrays not allowed %s"}
};

IDL_MSG_BLOCK msg_block;

//IDL接口
int IDL_Load(VOID)
{
	
	if(!(msg_block = IDL_MessageDefineBlock("imageStretch",ARRLEN(msg_arr),
		msg_arr))) {
		return IDL_FALSE ;
	}
	// 调用IDLtoC_scalarExamplesStartup()
	if(!IMAGESTETCH_Startup()) {
		IDL_MessageFromBlock(msg_block,imageStretch_ERROR,
			IDL_MSG_RET,"初始化程序失败!");
	}
	return IDL_TRUE;
	
}
