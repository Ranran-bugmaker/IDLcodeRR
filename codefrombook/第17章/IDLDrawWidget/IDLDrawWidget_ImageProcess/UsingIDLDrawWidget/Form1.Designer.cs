namespace UsingIDLDrawWidget
{
    partial class Form1
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.文件FToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.打开文件OToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.图像增强ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.灰度拉伸ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.直方图均衡化ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.均值平滑ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.中值平滑ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.锐化ToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.域变换ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.hough变换ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.radonToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.图像处理PToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.平滑ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.锐化ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sobelToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.robertsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.噪声去除ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.hANNINGToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.lEEFILTToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.边缘检测ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.cannyToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.robertsToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.sobelToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.prewittToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.shiftDiffToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.edgeDogToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.embossToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.形状提取ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.腐蚀ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.膨胀ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.开运算ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.闭运算ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.峰值亮度ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.分水岭边界ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.图像识别ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.边缘检测ToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.图像距离图ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.图像细化ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.帮助HToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.关于ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.OpenFile = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripButton1 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton2 = new System.Windows.Forms.ToolStripButton();
            this.toolStripButton3 = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripButton4 = new System.Windows.Forms.ToolStripButton();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.axIDLDrawWidget1 = new AxIDLDRAWX3Lib.AxIDLDrawWidget();
            this.menuStrip1.SuspendLayout();
            this.toolStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.axIDLDrawWidget1)).BeginInit();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.文件FToolStripMenuItem,
            this.图像增强ToolStripMenuItem,
            this.域变换ToolStripMenuItem,
            this.图像处理PToolStripMenuItem,
            this.噪声去除ToolStripMenuItem,
            this.边缘检测ToolStripMenuItem,
            this.形状提取ToolStripMenuItem,
            this.帮助HToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(637, 28);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // 文件FToolStripMenuItem
            // 
            this.文件FToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.打开文件OToolStripMenuItem});
            this.文件FToolStripMenuItem.Name = "文件FToolStripMenuItem";
            this.文件FToolStripMenuItem.Size = new System.Drawing.Size(69, 24);
            this.文件FToolStripMenuItem.Text = "文件(&F)";
            // 
            // 打开文件OToolStripMenuItem
            // 
            this.打开文件OToolStripMenuItem.Name = "打开文件OToolStripMenuItem";
            this.打开文件OToolStripMenuItem.Size = new System.Drawing.Size(160, 24);
            this.打开文件OToolStripMenuItem.Text = "打开文件(&O)";
            this.打开文件OToolStripMenuItem.Click += new System.EventHandler(this.打开文件OpenFile);
            // 
            // 图像增强ToolStripMenuItem
            // 
            this.图像增强ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.灰度拉伸ToolStripMenuItem,
            this.直方图均衡化ToolStripMenuItem,
            this.均值平滑ToolStripMenuItem,
            this.中值平滑ToolStripMenuItem,
            this.锐化ToolStripMenuItem1});
            this.图像增强ToolStripMenuItem.Name = "图像增强ToolStripMenuItem";
            this.图像增强ToolStripMenuItem.Size = new System.Drawing.Size(81, 24);
            this.图像增强ToolStripMenuItem.Text = "图像增强";
            // 
            // 灰度拉伸ToolStripMenuItem
            // 
            this.灰度拉伸ToolStripMenuItem.Name = "灰度拉伸ToolStripMenuItem";
            this.灰度拉伸ToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.灰度拉伸ToolStripMenuItem.Text = "灰度拉伸";
            this.灰度拉伸ToolStripMenuItem.Click += new System.EventHandler(this.灰度拉伸ToolStripMenuItem_Click);
            // 
            // 直方图均衡化ToolStripMenuItem
            // 
            this.直方图均衡化ToolStripMenuItem.Name = "直方图均衡化ToolStripMenuItem";
            this.直方图均衡化ToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.直方图均衡化ToolStripMenuItem.Text = "直方图均衡化";
            this.直方图均衡化ToolStripMenuItem.Click += new System.EventHandler(this.直方图均衡化ToolStripMenuItem_Click);
            // 
            // 均值平滑ToolStripMenuItem
            // 
            this.均值平滑ToolStripMenuItem.Name = "均值平滑ToolStripMenuItem";
            this.均值平滑ToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.均值平滑ToolStripMenuItem.Text = "均值平滑";
            this.均值平滑ToolStripMenuItem.Click += new System.EventHandler(this.均值平滑ToolStripMenuItem_Click);
            // 
            // 中值平滑ToolStripMenuItem
            // 
            this.中值平滑ToolStripMenuItem.Name = "中值平滑ToolStripMenuItem";
            this.中值平滑ToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.中值平滑ToolStripMenuItem.Text = "中值平滑";
            this.中值平滑ToolStripMenuItem.Click += new System.EventHandler(this.中值平滑ToolStripMenuItem_Click);
            // 
            // 锐化ToolStripMenuItem1
            // 
            this.锐化ToolStripMenuItem1.Name = "锐化ToolStripMenuItem1";
            this.锐化ToolStripMenuItem1.Size = new System.Drawing.Size(168, 24);
            this.锐化ToolStripMenuItem1.Text = "锐化";
            this.锐化ToolStripMenuItem1.Click += new System.EventHandler(this.锐化ToolStripMenuItem1_Click);
            // 
            // 域变换ToolStripMenuItem
            // 
            this.域变换ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.hough变换ToolStripMenuItem,
            this.radonToolStripMenuItem});
            this.域变换ToolStripMenuItem.Name = "域变换ToolStripMenuItem";
            this.域变换ToolStripMenuItem.Size = new System.Drawing.Size(66, 24);
            this.域变换ToolStripMenuItem.Text = "域变换";
            // 
            // hough变换ToolStripMenuItem
            // 
            this.hough变换ToolStripMenuItem.Name = "hough变换ToolStripMenuItem";
            this.hough变换ToolStripMenuItem.Size = new System.Drawing.Size(158, 24);
            this.hough变换ToolStripMenuItem.Text = "Hough变换";
            this.hough变换ToolStripMenuItem.Click += new System.EventHandler(this.hough变换ToolStripMenuItem_Click);
            // 
            // radonToolStripMenuItem
            // 
            this.radonToolStripMenuItem.Name = "radonToolStripMenuItem";
            this.radonToolStripMenuItem.Size = new System.Drawing.Size(158, 24);
            this.radonToolStripMenuItem.Text = "Radon变换";
            this.radonToolStripMenuItem.Click += new System.EventHandler(this.radonToolStripMenuItem_Click);
            // 
            // 图像处理PToolStripMenuItem
            // 
            this.图像处理PToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.平滑ToolStripMenuItem,
            this.锐化ToolStripMenuItem,
            this.sobelToolStripMenuItem,
            this.robertsToolStripMenuItem});
            this.图像处理PToolStripMenuItem.Name = "图像处理PToolStripMenuItem";
            this.图像处理PToolStripMenuItem.Size = new System.Drawing.Size(69, 24);
            this.图像处理PToolStripMenuItem.Text = "滤波(&F)";
            
            // 
            // 平滑ToolStripMenuItem
            // 
            this.平滑ToolStripMenuItem.Name = "平滑ToolStripMenuItem";
            this.平滑ToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.平滑ToolStripMenuItem.Text = "低通滤波";
            this.平滑ToolStripMenuItem.Click += new System.EventHandler(this.低通滤波ToolStripMenuItem_Click);
            // 
            // 锐化ToolStripMenuItem
            // 
            this.锐化ToolStripMenuItem.Name = "锐化ToolStripMenuItem";
            this.锐化ToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.锐化ToolStripMenuItem.Text = "高通滤波";
            this.锐化ToolStripMenuItem.Click += new System.EventHandler(this.高通滤波ToolStripMenuItem_Click);
            // 
            // sobelToolStripMenuItem
            // 
            this.sobelToolStripMenuItem.Name = "sobelToolStripMenuItem";
            this.sobelToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.sobelToolStripMenuItem.Text = "方向滤波";
            this.sobelToolStripMenuItem.Click += new System.EventHandler(this.方向滤波ToolStripMenuItem_Click);
            // 
            // robertsToolStripMenuItem
            // 
            this.robertsToolStripMenuItem.Name = "robertsToolStripMenuItem";
            this.robertsToolStripMenuItem.Size = new System.Drawing.Size(168, 24);
            this.robertsToolStripMenuItem.Text = "拉普拉斯滤波";
            this.robertsToolStripMenuItem.Click += new System.EventHandler(this.拉普拉斯滤波ToolStripMenuItem_Click);
            // 
            // 噪声去除ToolStripMenuItem
            // 
            this.噪声去除ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.hANNINGToolStripMenuItem,
            this.lEEFILTToolStripMenuItem});
            this.噪声去除ToolStripMenuItem.Name = "噪声去除ToolStripMenuItem";
            this.噪声去除ToolStripMenuItem.Size = new System.Drawing.Size(81, 24);
            this.噪声去除ToolStripMenuItem.Text = "噪声去除";
            // 
            // hANNINGToolStripMenuItem
            // 
            this.hANNINGToolStripMenuItem.Name = "hANNINGToolStripMenuItem";
            this.hANNINGToolStripMenuItem.Size = new System.Drawing.Size(152, 24);
            this.hANNINGToolStripMenuItem.Text = "HANNING";
            this.hANNINGToolStripMenuItem.Click += new System.EventHandler(this.hANNINGToolStripMenuItem_Click);
            // 
            // lEEFILTToolStripMenuItem
            // 
            this.lEEFILTToolStripMenuItem.Name = "lEEFILTToolStripMenuItem";
            this.lEEFILTToolStripMenuItem.Size = new System.Drawing.Size(152, 24);
            this.lEEFILTToolStripMenuItem.Text = "LEEFILT";
            this.lEEFILTToolStripMenuItem.Click += new System.EventHandler(this.lEEFILTToolStripMenuItem_Click);
            // 
            // 边缘检测ToolStripMenuItem
            // 
            this.边缘检测ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.cannyToolStripMenuItem,
            this.robertsToolStripMenuItem1,
            this.sobelToolStripMenuItem1,
            this.prewittToolStripMenuItem,
            this.shiftDiffToolStripMenuItem,
            this.edgeDogToolStripMenuItem,
            this.embossToolStripMenuItem});
            this.边缘检测ToolStripMenuItem.Name = "边缘检测ToolStripMenuItem";
            this.边缘检测ToolStripMenuItem.Size = new System.Drawing.Size(81, 24);
            this.边缘检测ToolStripMenuItem.Text = "边界提取";
            // 
            // cannyToolStripMenuItem
            // 
            this.cannyToolStripMenuItem.Name = "cannyToolStripMenuItem";
            this.cannyToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.cannyToolStripMenuItem.Text = "Canny";
            this.cannyToolStripMenuItem.Click += new System.EventHandler(this.cannyToolStripMenuItem_Click);
            // 
            // robertsToolStripMenuItem1
            // 
            this.robertsToolStripMenuItem1.Name = "robertsToolStripMenuItem1";
            this.robertsToolStripMenuItem1.Size = new System.Drawing.Size(153, 24);
            this.robertsToolStripMenuItem1.Text = "Roberts";
            this.robertsToolStripMenuItem1.Click += new System.EventHandler(this.robertsToolStripMenuItem1_Click);
            // 
            // sobelToolStripMenuItem1
            // 
            this.sobelToolStripMenuItem1.Name = "sobelToolStripMenuItem1";
            this.sobelToolStripMenuItem1.Size = new System.Drawing.Size(153, 24);
            this.sobelToolStripMenuItem1.Text = "Sobel";
            this.sobelToolStripMenuItem1.Click += new System.EventHandler(this.sobelToolStripMenuItem1_Click);
            // 
            // prewittToolStripMenuItem
            // 
            this.prewittToolStripMenuItem.Name = "prewittToolStripMenuItem";
            this.prewittToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.prewittToolStripMenuItem.Text = "Prewitt";
            this.prewittToolStripMenuItem.Click += new System.EventHandler(this.prewittToolStripMenuItem_Click);
            // 
            // shiftDiffToolStripMenuItem
            // 
            this.shiftDiffToolStripMenuItem.Name = "shiftDiffToolStripMenuItem";
            this.shiftDiffToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.shiftDiffToolStripMenuItem.Text = "Shift_Diff";
            this.shiftDiffToolStripMenuItem.Click += new System.EventHandler(this.shiftDiffToolStripMenuItem_Click);
            // 
            // edgeDogToolStripMenuItem
            // 
            this.edgeDogToolStripMenuItem.Name = "edgeDogToolStripMenuItem";
            this.edgeDogToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.edgeDogToolStripMenuItem.Text = "Edge_Dog";
            this.edgeDogToolStripMenuItem.Click += new System.EventHandler(this.edgeDogToolStripMenuItem_Click);
            // 
            // embossToolStripMenuItem
            // 
            this.embossToolStripMenuItem.Name = "embossToolStripMenuItem";
            this.embossToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.embossToolStripMenuItem.Text = "Emboss";
            this.embossToolStripMenuItem.Click += new System.EventHandler(this.embossToolStripMenuItem_Click);
            // 
            // 形状提取ToolStripMenuItem
            // 
            this.形状提取ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.腐蚀ToolStripMenuItem,
            this.膨胀ToolStripMenuItem,
            this.开运算ToolStripMenuItem,
            this.闭运算ToolStripMenuItem,
            this.峰值亮度ToolStripMenuItem,
            this.分水岭边界ToolStripMenuItem,
            this.图像识别ToolStripMenuItem,
            this.边缘检测ToolStripMenuItem1,
            this.图像距离图ToolStripMenuItem,
            this.图像细化ToolStripMenuItem});
            this.形状提取ToolStripMenuItem.Name = "形状提取ToolStripMenuItem";
            this.形状提取ToolStripMenuItem.Size = new System.Drawing.Size(81, 24);
            this.形状提取ToolStripMenuItem.Text = "形状提取";
            // 
            // 腐蚀ToolStripMenuItem
            // 
            this.腐蚀ToolStripMenuItem.Name = "腐蚀ToolStripMenuItem";
            this.腐蚀ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.腐蚀ToolStripMenuItem.Text = "腐蚀";
            this.腐蚀ToolStripMenuItem.Click += new System.EventHandler(this.腐蚀ToolStripMenuItem_Click);
            // 
            // 膨胀ToolStripMenuItem
            // 
            this.膨胀ToolStripMenuItem.Name = "膨胀ToolStripMenuItem";
            this.膨胀ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.膨胀ToolStripMenuItem.Text = "膨胀";
            this.膨胀ToolStripMenuItem.Click += new System.EventHandler(this.膨胀ToolStripMenuItem_Click);
            // 
            // 开运算ToolStripMenuItem
            // 
            this.开运算ToolStripMenuItem.Name = "开运算ToolStripMenuItem";
            this.开运算ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.开运算ToolStripMenuItem.Text = "开运算";
            this.开运算ToolStripMenuItem.Click += new System.EventHandler(this.开运算ToolStripMenuItem_Click);
            // 
            // 闭运算ToolStripMenuItem
            // 
            this.闭运算ToolStripMenuItem.Name = "闭运算ToolStripMenuItem";
            this.闭运算ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.闭运算ToolStripMenuItem.Text = "闭运算";
            this.闭运算ToolStripMenuItem.Click += new System.EventHandler(this.闭运算ToolStripMenuItem_Click);
            // 
            // 峰值亮度ToolStripMenuItem
            // 
            this.峰值亮度ToolStripMenuItem.Name = "峰值亮度ToolStripMenuItem";
            this.峰值亮度ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.峰值亮度ToolStripMenuItem.Text = "峰值亮度";
            this.峰值亮度ToolStripMenuItem.Click += new System.EventHandler(this.峰值亮度ToolStripMenuItem_Click);
            // 
            // 分水岭边界ToolStripMenuItem
            // 
            this.分水岭边界ToolStripMenuItem.Name = "分水岭边界ToolStripMenuItem";
            this.分水岭边界ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.分水岭边界ToolStripMenuItem.Text = "分水岭边界";
            this.分水岭边界ToolStripMenuItem.Click += new System.EventHandler(this.分水岭边界ToolStripMenuItem_Click);
            // 
            // 图像识别ToolStripMenuItem
            // 
            this.图像识别ToolStripMenuItem.Name = "图像识别ToolStripMenuItem";
            this.图像识别ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.图像识别ToolStripMenuItem.Text = "图像识别";
            this.图像识别ToolStripMenuItem.Click += new System.EventHandler(this.图像识别ToolStripMenuItem_Click);
            // 
            // 边缘检测ToolStripMenuItem1
            // 
            this.边缘检测ToolStripMenuItem1.Name = "边缘检测ToolStripMenuItem1";
            this.边缘检测ToolStripMenuItem1.Size = new System.Drawing.Size(153, 24);
            this.边缘检测ToolStripMenuItem1.Text = "边缘检测";
            this.边缘检测ToolStripMenuItem1.Click += new System.EventHandler(this.边缘检测ToolStripMenuItem1_Click);
            // 
            // 图像距离图ToolStripMenuItem
            // 
            this.图像距离图ToolStripMenuItem.Name = "图像距离图ToolStripMenuItem";
            this.图像距离图ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.图像距离图ToolStripMenuItem.Text = "图像距离图";
            this.图像距离图ToolStripMenuItem.Click += new System.EventHandler(this.图像距离图ToolStripMenuItem_Click);
            // 
            // 图像细化ToolStripMenuItem
            // 
            this.图像细化ToolStripMenuItem.Name = "图像细化ToolStripMenuItem";
            this.图像细化ToolStripMenuItem.Size = new System.Drawing.Size(153, 24);
            this.图像细化ToolStripMenuItem.Text = "图像细化";
            this.图像细化ToolStripMenuItem.Click += new System.EventHandler(this.图像细化ToolStripMenuItem_Click);
            // 
            // 帮助HToolStripMenuItem
            // 
            this.帮助HToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.关于ToolStripMenuItem});
            this.帮助HToolStripMenuItem.Name = "帮助HToolStripMenuItem";
            this.帮助HToolStripMenuItem.Size = new System.Drawing.Size(73, 24);
            this.帮助HToolStripMenuItem.Text = "帮助(&H)";
            // 
            // 关于ToolStripMenuItem
            // 
            this.关于ToolStripMenuItem.Name = "关于ToolStripMenuItem";
            this.关于ToolStripMenuItem.Size = new System.Drawing.Size(108, 24);
            this.关于ToolStripMenuItem.Text = "关于";
            this.关于ToolStripMenuItem.Click += new System.EventHandler(this.关于ToolStripMenuItem_Click);
            // 
            // toolStrip1
            // 
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.OpenFile,
            this.toolStripSeparator1,
            this.toolStripButton1,
            this.toolStripButton2,
            this.toolStripButton3,
            this.toolStripSeparator2,
            this.toolStripButton4});
            this.toolStrip1.Location = new System.Drawing.Point(0, 28);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(637, 25);
            this.toolStrip1.TabIndex = 1;
            this.toolStrip1.Text = "toolStrip1";
            this.toolStrip1.Click += new System.EventHandler(this.缩小);
            // 
            // OpenFile
            // 
            this.OpenFile.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.OpenFile.Image = ((System.Drawing.Image)(resources.GetObject("OpenFile.Image")));
            this.OpenFile.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.OpenFile.Name = "OpenFile";
            this.OpenFile.Size = new System.Drawing.Size(23, 22);
            this.OpenFile.Text = "打开文件";
            this.OpenFile.Click += new System.EventHandler(this.打开文件OpenFile);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripButton1
            // 
            this.toolStripButton1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton1.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton1.Image")));
            this.toolStripButton1.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton1.Name = "toolStripButton1";
            this.toolStripButton1.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton1.Text = "平移图像";
            this.toolStripButton1.Click += new System.EventHandler(this.平移Pan);
            // 
            // toolStripButton2
            // 
            this.toolStripButton2.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton2.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton2.Image")));
            this.toolStripButton2.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton2.Name = "toolStripButton2";
            this.toolStripButton2.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton2.Text = "放大";
            this.toolStripButton2.Click += new System.EventHandler(this.放大);
            // 
            // toolStripButton3
            // 
            this.toolStripButton3.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton3.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton3.Image")));
            this.toolStripButton3.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton3.Name = "toolStripButton3";
            this.toolStripButton3.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton3.Text = "缩小";
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripButton4
            // 
            this.toolStripButton4.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButton4.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton4.Image")));
            this.toolStripButton4.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButton4.Name = "toolStripButton4";
            this.toolStripButton4.Size = new System.Drawing.Size(23, 22);
            this.toolStripButton4.Text = "恢复";
            this.toolStripButton4.Click += new System.EventHandler(this.重置);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // axIDLDrawWidget1
            // 
            this.axIDLDrawWidget1.Enabled = true;
            this.axIDLDrawWidget1.Location = new System.Drawing.Point(0, 56);
            this.axIDLDrawWidget1.Name = "axIDLDrawWidget1";
            this.axIDLDrawWidget1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axIDLDrawWidget1.OcxState")));
            this.axIDLDrawWidget1.Size = new System.Drawing.Size(637, 427);
            this.axIDLDrawWidget1.TabIndex = 2;
            this.axIDLDrawWidget1.MouseDownEvent += new AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseDownEventHandler(this.axIDLDrawWidget1_MouseDownEvent);
            this.axIDLDrawWidget1.MouseUpEvent += new AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseUpEventHandler(this.axIDLDrawWidget1_MouseUpEvent);
            this.axIDLDrawWidget1.MouseMoveEvent += new AxIDLDRAWX3Lib._DIDLDrawX3Events_MouseMoveEventHandler(this.axIDLDrawWidget1_MouseMoveEvent);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(637, 507);
            this.Controls.Add(this.axIDLDrawWidget1);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form1";
            this.Text = "图像处理Demo";
            this.MinimumSizeChanged += new System.EventHandler(this.Form1_ResizeEnd);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            this.Resize += new System.EventHandler(this.Form1_ResizeEnd);
            this.ResizeEnd += new System.EventHandler(this.Form1_ResizeEnd);
            this.MaximumSizeChanged += new System.EventHandler(this.Form1_ResizeEnd);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.axIDLDrawWidget1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem 文件FToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 图像处理PToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 帮助HToolStripMenuItem;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton OpenFile;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.ToolStripMenuItem 打开文件OToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripButton toolStripButton1;
        private System.Windows.Forms.ToolStripButton toolStripButton2;
        private AxIDLDRAWX3Lib.AxIDLDrawWidget axIDLDrawWidget1;
        private System.Windows.Forms.ToolStripButton toolStripButton3;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripButton toolStripButton4;
        private System.Windows.Forms.ToolStripMenuItem 平滑ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 锐化ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sobelToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem robertsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 域变换ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem hough变换ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem radonToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 图像增强ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 灰度拉伸ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 直方图均衡化ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 均值平滑ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 中值平滑ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 锐化ToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem 噪声去除ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem hANNINGToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem lEEFILTToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 边缘检测ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem edgeDogToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem embossToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem prewittToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem robertsToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem shiftDiffToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem sobelToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem 形状提取ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 腐蚀ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 膨胀ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 开运算ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 闭运算ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 峰值亮度ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 分水岭边界ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 边缘检测ToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem 图像距离图ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 图像细化ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 关于ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem cannyToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem 图像识别ToolStripMenuItem;
    }
}

