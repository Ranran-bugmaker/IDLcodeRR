/*
 ;+
; 《IDL语言程序设计》
; --数据可视化与ENVI二次开发
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
using System.Text;
using System.Windows.Forms;
//使用注册表操作
using Microsoft.Win32;
using System.IO;

namespace MixProgram
{
    public partial class Form1 : Form
    {
        //界面间隔参数
        int xSpace = 0;
        int ySpace = 0;
        int y = 0;
        //鼠标按下状态
        byte clickState = 0;

        public Form1()
        {
            InitializeComponent();
            //增加滚轮滚动事件
            ((Control)this).MouseWheel += new MouseEventHandler(Form1_MouseWheel);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
             
            //读取注册表获取IDL8.0或IDL7.1或IDL7.0的目录
            RegistryKey rsg = null;

            rsg = Registry.LocalMachine.OpenSubKey("SOFTWARE\\ITT\\IDL\\8.2", true);

            if (rsg.GetValue("InstallDir") != null) //读取失败返回null
            {
                //初始化IDL80路径
                axIDLDrawWidget1.IdlPath = Path.Combine(rsg.GetValue("InstallDir").ToString(), @"IDL82\bin\bin.x86\idl.dll");
            }
            this.IDLDrawWidgetCreate();

        }

        private void IDLDrawWidgetCreate()
        {
            int n;
            //初始化
            n = axIDLDrawWidget1.InitIDL((int)this.Handle);
            if (n == 0)
            {
                MessageBox.Show("IDL初始化失败", "IDL初始化失败，无法继续！");
                return;
            }


            //对象法程序显示
            axIDLDrawWidget1.GraphicsLevel = 2;


            //编译源码文件
            axIDLDrawWidget1.ExecuteStr(".compile 'imgprocess.pro'");
            axIDLDrawWidget1.ExecuteStr(".compile 'SetMapParamet__Define.pro'");
            axIDLDrawWidget1.ExecuteStr(".compile 'PROJECTIONSHOW__DEFINE.pro'");

            //计算组件偏移量                
            this.xSpace = this.Width - axIDLDrawWidget1.Width;
            this.ySpace = this.Height - axIDLDrawWidget1.Height;
            //指定事件由C#响应
            axIDLDrawWidget1.RegisterForEvents(3);

            axIDLDrawWidget1.OnExpose = "if Obj_Valid(oProj) eq 1 then oProj.Draw";
            //
            //初始化界面
            axIDLDrawWidget1.CreateDrawWidget();
        }

        private void Form1_ResizeEnd(object sender, EventArgs e)
        {
            axIDLDrawWidget1.Height = this.Height - this.ySpace;
            axIDLDrawWidget1.Width = this.Width - this.xSpace;
            //
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oProj) eq 1 then oProj.ChangeDrawSize, " + axIDLDrawWidget1.Width + "," + axIDLDrawWidget1.Height);
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oImg) eq 1 then oImg.ChangeDrawSize, " + axIDLDrawWidget1.Width + "," + axIDLDrawWidget1.Height);

        }
        //图像处理显示原图
        private void buttonItem14_Click(object sender, EventArgs e)
        {
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oImg) eq 0 then oImg = Obj_New('ImgShow'," + axIDLDrawWidget1.DrawId.ToString() + ")");     

        }
        //图像处理-平滑处理
        private void process_ItemClick(object sender, EventArgs e)
        {
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oImg) eq 1 then oImg.process,type = 'Smooth'");
        }
        //图像处理-边界提取
        private void buttonItem1_Click(object sender, EventArgs e)
        {
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oImg) eq 1 then oImg.process,type = 'CANNY'");
        }
        //投影界面初始显示
        private void ribbonBar3_ItemClick(object sender, EventArgs e)
        {     
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oProj) eq 0 then oProj = Obj_New('PROJECTIONShow'," + axIDLDrawWidget1.DrawId.ToString() + ") else oProj.oriShow");
        }
        //投影类型选择
        private void buttonItem5_Click(object sender, EventArgs e)
        {
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oProj) eq 1 then oProj.SELECTMAPPROJECTION");
        }
        //组件上鼠标的点击事件处理
        private void axIDLDrawWidget1_MouseDownEvent(object sender, AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseDownEvent e)
        {
            y = axIDLDrawWidget1.Height - e.y;
            clickState = 1;
            axIDLDrawWidget1.ExecuteStr("if obj_Valid(oimg) EQ 1 then oImg.MousePress,"+ e.x.ToString() + "," + y.ToString());
            axIDLDrawWidget1.ExecuteStr("if obj_Valid(oProj)  EQ 1 then oProj.MousePress," + e.x.ToString() + "," + y.ToString());

        }
        //组件上鼠标的移动事件处理
        private void axIDLDrawWidget1_MouseMoveEvent(object sender, AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseMoveEvent e)
        {
            y = axIDLDrawWidget1.Height - e.y;            
            if (clickState == 1) axIDLDrawWidget1.ExecuteStr("if obj_Valid(oimg) then oImg.MouseMotion," + e.x.ToString() + "," + y.ToString());
            if (clickState == 1) axIDLDrawWidget1.ExecuteStr("if obj_Valid(oProj) then oProj.MouseMotion," + e.x.ToString() + "," + y.ToString());            
        }
        //组件上鼠标的弹起事件处理
        private void axIDLDrawWidget1_MouseUpEvent(object sender, AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseUpEvent e)
        {
            axIDLDrawWidget1.ExecuteStr("if obj_Valid(oimg) then oImg.MouseRelease," + e.x.ToString() + "," + y.ToString());
            axIDLDrawWidget1.ExecuteStr("if obj_Valid(oProj) then oProj.MouseRelease," + e.x.ToString() + "," + y.ToString());
            clickState = 0;
        }
        //鼠标滚轮事件
        void Form1_MouseWheel(object sender, MouseEventArgs e)
        {
            //
            y = axIDLDrawWidget1.Height - (e.Y - axIDLDrawWidget1.Location.Y);            
            axIDLDrawWidget1.ExecuteStr("if obj_Valid(oimg) then oImg.WheelEvents," + e.Delta.ToString() + ","
                + (e.X - axIDLDrawWidget1.Location.X).ToString() + "," + y.ToString());
            axIDLDrawWidget1.ExecuteStr("if obj_Valid(oProj) then oProj.WheelEvents," + e.Delta.ToString() + ","
                + (e.X - axIDLDrawWidget1.Location.X).ToString() + "," + y.ToString());
        }
        //切换图像显示
        private void ImageProcess_Click(object sender, EventArgs e)
        {           
        }
        //切换投影显示
        private void ribbonTabItem1_Click(object sender, EventArgs e)
        {
            //axIDLDrawWidget1.DestroyDrawWidget();
            //axIDLDrawWidget1.CreateDrawWidget();
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oimg) then Obj_Destroy,oimg");
            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(oProj) then Obj_Destroy,oProj");
            //axIDLDrawWidget1.ExecuteStr("oProj = Obj_New('PROJECTIONShow'," + axIDLDrawWidget1.DrawId.ToString() + ")");
        }
        
        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            //
        }


        private void Form1_FormClosing_1(object sender, FormClosingEventArgs e)
        {
            e.Cancel =  MessageBox.Show("你确认要退出吗？", "提醒", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation) == DialogResult.No;
            // 
        }

        
    }
}