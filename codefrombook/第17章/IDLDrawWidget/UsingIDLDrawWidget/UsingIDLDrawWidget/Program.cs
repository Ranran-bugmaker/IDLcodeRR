;+
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
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace UsingIDLDrawWidget
{
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点。
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
