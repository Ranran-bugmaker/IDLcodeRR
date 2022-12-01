using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace COM_FX
{
    public partial class Form1 : Form
    {
        string oriDir = Application.StartupPath;

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //文件夹选择操作
            FolderBrowserDialog oSelect = new FolderBrowserDialog();
            oSelect.SelectedPath = oriDir;
            
            if (oSelect.ShowDialog() == DialogResult.OK)
            {
                inputDir.Text = oSelect.SelectedPath.ToString();
                oriDir = oSelect.SelectedPath.ToString();
            }
        }

        private void objectrule_Click(object sender, EventArgs e)
        {
            //规则文件选择操作
            OpenFileDialog ofd = new OpenFileDialog();
            ofd.InitialDirectory = oriDir;
            ofd.Filter = "规则.xml|*.xml|所有文件|*.*";     
            if (ofd.ShowDialog() == DialogResult.OK)
            {
                rulefile.Text = ofd.FileName.ToString(); 
            }
        }       

        private void selectsaveDir_Click(object sender, EventArgs e)
        {

            //文件夹选择操作
            FolderBrowserDialog oSelect = new FolderBrowserDialog();
            oSelect.SelectedPath = oriDir;
            if (oSelect.ShowDialog() == DialogResult.OK)
            {
                saveDir.Text = oSelect.SelectedPath.ToString();
                oriDir = oSelect.SelectedPath.ToString();
            }

        }

        private void ENVI_FX_Click(object sender, EventArgs e)
        {
            //新建COM_IDL_CONNECT对象
            COM_IDL_connectLib.COM_IDL_connect oComIDL = new COM_IDL_connectLib.COM_IDL_connect();
            //对象初始化
            oComIDL.CreateObject(0, 0, 0);
            //满足条件则调用功能
            if ((inputDir.Text != "") && (rulefile.Text != "") && (saveDir.Text != ""))
            {
                //编译IDL代码
                oComIDL.ExecuteString(".compile 'd:\\ENVI_FX.pro'");
                //根据输入参数定义执行字符串
                string tmp = "envi_fx,'" + inputDir.Text.ToString() + "','" + rulefile.Text.ToString() + "','" + saveDir.Text.ToString() + "'";
                //执行功能
                oComIDL.ExecuteString(tmp);
               

            }
            //销毁对象
            oComIDL.DestroyObject();

        }
    }
}