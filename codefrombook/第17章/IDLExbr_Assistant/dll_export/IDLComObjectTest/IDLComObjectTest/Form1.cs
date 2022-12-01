using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace IDLComObjectTest
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //创建新类
            helloComExLib.helloComExClass oComTest = new helloComExLib.helloComExClass();
            //类初始化操作
            oComTest.CreateObject(0, 0, 0);
            //调用IDL下的函数
            string input = oComTest.MESSAGEFROM("C# call IDL");
            MessageBox.Show(input);
            //定义数组传递到IDL中
            int[,] inArr = new int[2, 3];
            inArr[0, 0] = 0;
            inArr[0, 1] = 1;
            inArr[0, 2] = 2;
            inArr[1, 0] = 3;
            inArr[1, 1] = 4;
            inArr[1, 2] = 5;
            Object result = oComTest.ARRAYTEST(inArr);

        }
    }
}