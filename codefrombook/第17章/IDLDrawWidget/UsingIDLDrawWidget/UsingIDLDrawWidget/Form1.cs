/*;+
; 《IDL语言程序设计》
; --数据快速可视化与ENVI二次开发
;
; 示例程序
;
; 作者: 董彦卿
;
; 联系方式：sdlcdyq@sina.com
;
;-
*/
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace UsingIDLDrawWidget
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //定义IDL控件的路径
            this.axIDLDrawWidget1.IdlPath = @"I:\Program Files\ITT\IDL\IDL82\bin\bin.x86";
            //控件初始化
            int n = axIDLDrawWidget1.InitIDL((int)this.Handle);
            if (n == 0)
            {
                MessageBox.Show("IDL初始化失败", "IDL初始化失败，无法继续！");
                return ;
            }

        }

        private void DirectGraphics_Click(object sender, EventArgs e)
        {
            //如果已经创建且不是直接图形法则先销毁
            if ((axIDLDrawWidget1.DrawId != -1) && (axIDLDrawWidget1.GraphicsLevel != 1))
            {
                axIDLDrawWidget1.DestroyDrawWidget();
            }
            //组件参数设置为直接图形法显示
            axIDLDrawWidget1.GraphicsLevel = 1;
            //初始化IDL界面
            axIDLDrawWidget1.CreateDrawWidget();
            //执行IDL的语句
            axIDLDrawWidget1.ExecuteStr("Widget_Control," + axIDLDrawWidget1.DrawId.ToString() + ",Get_Value = WinID");
            //执行Wset来控制显示在显示窗口上
            axIDLDrawWidget1.ExecuteStr("WSet,WinID");
            axIDLDrawWidget1.ExecuteStr("tv,dist(400)");

        }

        private void ObjectGraphics_Click(object sender, EventArgs e)
        {
            //如果已经创建且不是对象图形法则先销毁
            if ((axIDLDrawWidget1.DrawId != -1) && (axIDLDrawWidget1.GraphicsLevel != 2))
            {
                axIDLDrawWidget1.DestroyDrawWidget();
            }
            //组件参数设置为直接图形法显示
            axIDLDrawWidget1.GraphicsLevel = 2;
            //初始化IDL界面
            axIDLDrawWidget1.CreateDrawWidget();
            //编译源码文件
            axIDLDrawWidget1.ExecuteStr(@".compile 'c:\temp\IDLDrawWidget_ObjectShow.pro'");
            axIDLDrawWidget1.ExecuteStr("IDLDrawWidget_ObjectShow," + axIDLDrawWidget1.DrawId.ToString());

        }

        private void exchange_Click(object sender, EventArgs e)
        {
            //初始化定义变量
            object objStr = "abc";
            object objOri, objNow;
            //定义变量
            this.axIDLDrawWidget1.SetNamedData("var", objStr);
            //编译IDL功能代码并传入单个变量
            this.axIDLDrawWidget1.ExecuteStr(@".compile 'exchangevar.pro'");
            this.axIDLDrawWidget1.ExecuteStr("exchangevar, var = var");
            //将IDL中修改过的变量获得并对话框显示
            objStr = this.axIDLDrawWidget1.GetNamedData("var");
            //显示IDL程序中更改后的值
            MessageBox.Show("C#中的变量值为：" + objStr.ToString());
            //定义数组
            int[,] dataarr = new int[3, 2] { { 6, 4 }, { 12, 9 }, { 18, 5 } };
            //将数组内容copy到IDL下的变量arr中
            this.axIDLDrawWidget1.SetNamedArray("arr", dataarr, true);
            //编译IDL功能代码并传入数组
            this.axIDLDrawWidget1.ExecuteStr(".compile 'exchangeArr.pro'");
            this.axIDLDrawWidget1.ExecuteStr("exchangeArr,arr,oriArr= oriArr");
            //通过CopyNameArray方法直接复制获取IDL中的数组
            objOri = this.axIDLDrawWidget1.CopyNamedArray("oriarr");
            //通过CopyNameArray方法直接复制获取IDL中的数组
            objNow = this.axIDLDrawWidget1.CopyNamedArray("arr");
            //弹出第一个元素的值            
            MessageBox.Show("C#中的数组值为：" + ((Array)objNow).GetValue(0, 0));

        }
    }
}
