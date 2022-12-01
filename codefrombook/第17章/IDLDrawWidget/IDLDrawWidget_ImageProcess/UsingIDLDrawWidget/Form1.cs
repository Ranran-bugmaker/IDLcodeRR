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


namespace UsingIDLDrawWidget
{
    public partial class Form1 : Form
    {
        //界面间隔参数
        int xSpace = 0;
        int ySpace = 0;
        int initFlag = 0;
        int y = 0;
        //鼠标操作状态
        byte mouseType = 1;
        
        //鼠标按下状态
        byte clickState = 0;
        ToolStripLabel tsl = new ToolStripLabel();
 
        public Form1()
        {
            InitializeComponent();
            //增加滚轮滚动事件
            ((Control)this).MouseWheel+=new MouseEventHandler(Form1_MouseWheel);
        }      
  
        
        
        private void Form1_Load(object sender, EventArgs e)
        {
            
            int n;
            //读取注册表获取IDL8.0或IDL7.1或IDL7.0的目录
            RegistryKey rsg = null;
               
            rsg = Registry.LocalMachine.OpenSubKey("SOFTWARE\\ITT\\IDL\\8.0", true);

            if (rsg.GetValue("InstallDir") != null) //读取失败返回null
            {                    
                //初始化IDL80路径
                axIDLDrawWidget1.IdlPath = Path.Combine(rsg.GetValue("InstallDir").ToString(), @"IDL80\bin\bin.x86\idl.dll");
            }     

            //初始化
            n = axIDLDrawWidget1.InitIDL((int)this.Handle);
            if (n == 0)
            {
                MessageBox.Show("IDL初始化失败", "IDL初始化失败，无法继续！");
                return;
            }

            //对象法程序显示
            axIDLDrawWidget1.GraphicsLevel = 2;
        
            //初始化界面
            axIDLDrawWidget1.CreateDrawWidget();
            //编译IDL功能代码
            axIDLDrawWidget1.ExecuteStr(".compile " + "'imageprocess__define.pro'");

              //计算组件偏移量                
            this.xSpace = this.Width - axIDLDrawWidget1.Width;
            this.ySpace = this.Height - axIDLDrawWidget1.Height;
            //添加状态栏鼠标状态信息
            StatusStrip sb = new StatusStrip();
            

            tsl.Text = " 鼠标状态：";
            ToolStripItem[] tsi = new ToolStripItem[1];
            tsi[0] = tsl;
            sb.Items.AddRange(tsi);
            this.Controls.Add(sb);

        }

        private void 打开文件OpenFile(object sender, EventArgs e)
        {
            string fileName ="";
            //新建打开文件对话框
            OpenFileDialog ofd = new OpenFileDialog();

            ofd.Filter = "JPEG文件(*.jpg)|*.jpg|BMP文件(*.bmp)|*.bmp|TIFF文件(*.tif)|*.tif|PNG文件(*.png)|*.png|所有文件(*.*)|*.*";//设置打开文件类型

            //
            if (ofd.ShowDialog(this) == DialogResult.OK)
            {
                fileName = ofd.FileName;                
            }
            //文件是否存在
            if (!File.Exists(fileName)) return;
            //停止组件的鼠标按键点击及移动的自动事件，传递事件给C#
            axIDLDrawWidget1.RegisterForEvents(3);
            axIDLDrawWidget1.OnDblClick = "obj->DbClick";
            axIDLDrawWidget1.OnExpose = "obj->RefreshDraw"; 

            axIDLDrawWidget1.ExecuteStr("if Obj_Valid(obj) then Obj_Destroy, obj");
            axIDLDrawWidget1.ExecuteStr("obj = Obj_New('imageprocess','" + fileName + "'," + axIDLDrawWidget1.DrawId.ToString() + ")");
            axIDLDrawWidget1.ExecuteStr("obj ->GetProperty,initFlag=initFlag");
            string tmp = axIDLDrawWidget1.GetNamedData("initFlag").ToString();
            initFlag = Convert.ToInt16(tmp);
            tsl.Text = " 鼠标状态：";

        }
        //鼠标按下平移事件
        private void 平移Pan(object sender, EventArgs e)
        {
            mouseType = 1;
            tsl.Text = " 鼠标状态：平移";
            if (initFlag == 0) return;
            axIDLDrawWidget1.ExecuteStr("obj->SetProperty, mouseType="+mouseType.ToString());

        }
        //鼠标滚轮事件
        void Form1_MouseWheel(object sender, MouseEventArgs e)
        {
            //
            y = axIDLDrawWidget1.Height - (e.Y-axIDLDrawWidget1.Location.Y);
            
            if (initFlag == 0) return;
            axIDLDrawWidget1.ExecuteStr("obj->WheelEvents," + e.Delta.ToString() + ","
                + (e.X-axIDLDrawWidget1.Location.X).ToString() + "," + y.ToString());
            
        }
        //组件上鼠标的点击事件处理
        private void axIDLDrawWidget1_MouseDownEvent(object sender, AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseDownEvent e)
        {
            if (initFlag == 0) return;
            
            y = axIDLDrawWidget1.Height - e.y;
            clickState = 1;
            axIDLDrawWidget1.ExecuteStr("obj->MousePress,"
                + e.x.ToString() + "," + y.ToString());

        }
        //组件上鼠标的移动事件处理
        private void axIDLDrawWidget1_MouseMoveEvent(object sender, AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseMoveEvent e)
        {
            if (initFlag == 0) return;
            y = axIDLDrawWidget1.Height - e.y;
            if (clickState == 1) axIDLDrawWidget1.ExecuteStr("obj->MouseMotion," 
                    + e.x.ToString() + "," + y.ToString());
        }
        //组件上鼠标的弹起事件处理
        private void axIDLDrawWidget1_MouseUpEvent(object sender, AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseUpEvent e)
        {
            if (initFlag == 0) return;
            axIDLDrawWidget1.ExecuteStr("obj.MouseRelease,"
                    + e.x.ToString() + "," + y.ToString());
            clickState = 0;
        }  
       
        //界面大小改变结束时的事件
        private void Form1_ResizeEnd(object sender, EventArgs e)
        {
            axIDLDrawWidget1.Height = this.Height - this.ySpace;
            axIDLDrawWidget1.Width = this.Width - this.xSpace;
            if (initFlag == 0) return;
            axIDLDrawWidget1.ExecuteStr("obj->ChangeDrawSize," + axIDLDrawWidget1.Width + "," + axIDLDrawWidget1.Height);
            
        }

        private void 放大(object sender, EventArgs e)
        {
            tsl.Text = " 鼠标状态：拉框放大"; 
            if (initFlag == 0) return;
            mouseType = 2;           
            axIDLDrawWidget1.ExecuteStr("obj->SetProperty, mouseType=" + mouseType.ToString());
        }
        private void 缩小(object sender, EventArgs e)
        {
            tsl.Text = " 鼠标状态：拉框缩小";
            if (initFlag == 0) return; 
            mouseType = 3;
            axIDLDrawWidget1.ExecuteStr("obj->SetProperty, mouseType=" + mouseType.ToString());

        }

        private void 重置(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            mouseType = 1;
            axIDLDrawWidget1.ExecuteStr("obj->originalShow");
            axIDLDrawWidget1.ExecuteStr("obj->SetProperty, mouseType=" + mouseType.ToString());
            tsl.Text = " 鼠标状态：平移";
        } 

        private void 灰度拉伸ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Byte'");
        }

        private void 直方图均衡化ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Hist_Equal'");
        }

        private void 均值平滑ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Smooth'");
        }

        private void 中值平滑ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MEDIAN'");
        }

        private void 锐化ToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Sharpen'");
        }

        private void hough变换ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Hough'");
        }

        private void radonToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Radon'");
        }

        private void 低通滤波ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'LowPass'");
        }

        private void 高通滤波ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'HighPass'");
        }

        private void 方向滤波ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Direction'");
        }

        private void 拉普拉斯滤波ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Laplacian'");
        }

        private void hANNINGToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'Hanning'");
        }

        private void lEEFILTToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'LEEFILT'");
        }

        private void robertsToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'roberts'");
        }

        private void sobelToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'SOBEL'");
        }

        private void cannyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'CANNY'");
        }

        private void prewittToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'PREWITT'");
        }

        private void shiftDiffToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag == 0) return; 
            axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'SHIFT_DIFF'");
        }

        private void edgeDogToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'EDGE_DOG'");
        }

        private void embossToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'EMBOSS'");
        }

        private void 腐蚀ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'DILATE'");
        }

        
        private void 膨胀ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'ERODE'");
        }

        private void 开运算ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MORPH_OPEN'");
        }

        private void 闭运算ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MORPH_CLOSE'");
        }

        private void 峰值亮度ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MORPH_TOPHAT'");
        }

        private void 分水岭边界ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'WATERSHED'");
        }

        private void 图像识别ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MORPH_HITORMISS'");
        }

        private void 边缘检测ToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MORPH_GRADIENT'");
        }

        private void 图像距离图ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MORPH_DISTANCE'");
        }

        private void 图像细化ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (initFlag != 0) axIDLDrawWidget1.ExecuteStr("obj->imageprocesso,type = 'MORPH_THIN'");
        }

        private void 关于ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("   C#下调用IDL的IDLDrawWidget组件示例程序！\n"
                + "   作者：DYQ", "关于本程序");
        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            axIDLDrawWidget1.ExecuteStr("IF Obj_Valid(obj) then Obj_Destroy,obj");
            axIDLDrawWidget1.DestroyDrawWidget();
        }

       
        
    }
}