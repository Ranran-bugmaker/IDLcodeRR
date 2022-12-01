namespace COM_FX
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
            this.button1 = new System.Windows.Forms.Button();
            this.inputDir = new System.Windows.Forms.TextBox();
            this.objectrule = new System.Windows.Forms.Button();
            this.rulefile = new System.Windows.Forms.TextBox();
            this.selectsaveDir = new System.Windows.Forms.Button();
            this.saveDir = new System.Windows.Forms.TextBox();
            this.ENVI_FX = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(32, 36);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(94, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "数据文件夹";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // inputDir
            // 
            this.inputDir.Location = new System.Drawing.Point(141, 37);
            this.inputDir.Name = "inputDir";
            this.inputDir.Size = new System.Drawing.Size(347, 25);
            this.inputDir.TabIndex = 1;
            // 
            // objectrule
            // 
            this.objectrule.Location = new System.Drawing.Point(32, 88);
            this.objectrule.Name = "objectrule";
            this.objectrule.Size = new System.Drawing.Size(94, 23);
            this.objectrule.TabIndex = 2;
            this.objectrule.Text = "对象规则";
            this.objectrule.UseVisualStyleBackColor = true;
            this.objectrule.Click += new System.EventHandler(this.objectrule_Click);
            // 
            // rulefile
            // 
            this.rulefile.Location = new System.Drawing.Point(141, 85);
            this.rulefile.Name = "rulefile";
            this.rulefile.Size = new System.Drawing.Size(347, 25);
            this.rulefile.TabIndex = 3;
            // 
            // selectsaveDir
            // 
            this.selectsaveDir.Location = new System.Drawing.Point(32, 146);
            this.selectsaveDir.Name = "selectsaveDir";
            this.selectsaveDir.Size = new System.Drawing.Size(94, 23);
            this.selectsaveDir.TabIndex = 4;
            this.selectsaveDir.Text = "结果文件夹";
            this.selectsaveDir.UseVisualStyleBackColor = true;
            this.selectsaveDir.Click += new System.EventHandler(this.selectsaveDir_Click);
            // 
            // saveDir
            // 
            this.saveDir.Location = new System.Drawing.Point(141, 143);
            this.saveDir.Name = "saveDir";
            this.saveDir.Size = new System.Drawing.Size(347, 25);
            this.saveDir.TabIndex = 5;
            // 
            // ENVI_FX
            // 
            this.ENVI_FX.Location = new System.Drawing.Point(199, 195);
            this.ENVI_FX.Name = "ENVI_FX";
            this.ENVI_FX.Size = new System.Drawing.Size(99, 23);
            this.ENVI_FX.TabIndex = 6;
            this.ENVI_FX.Text = "提取";
            this.ENVI_FX.UseVisualStyleBackColor = true;
            this.ENVI_FX.Click += new System.EventHandler(this.ENVI_FX_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(501, 244);
            this.Controls.Add(this.ENVI_FX);
            this.Controls.Add(this.saveDir);
            this.Controls.Add(this.selectsaveDir);
            this.Controls.Add(this.rulefile);
            this.Controls.Add(this.objectrule);
            this.Controls.Add(this.inputDir);
            this.Controls.Add(this.button1);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Form1";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "面向对象特征提取";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox inputDir;
        private System.Windows.Forms.Button objectrule;
        private System.Windows.Forms.TextBox rulefile;
        private System.Windows.Forms.Button selectsaveDir;
        private System.Windows.Forms.TextBox saveDir;
        private System.Windows.Forms.Button ENVI_FX;
    }
}

