#ifndef IDL_C_H
#define IDL_C_H
#include "export.h"
/* 信息数量......*/
#define imageStretch_ERROR 0
#define imageStretch_NOSTRINGARRAY -1

/*宏*/
#define ARRLEN(arr) (sizeof(arr)/sizeof(arr[0])) 

extern IDL_MSG_BLOCK msg_block;

/*定义将C函数添加到IDL中的功能和退出*/
extern void IMAGESTETCH_exit_handler(void);
extern int IMAGESTETCH_Startup(void);

#endif