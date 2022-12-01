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
            this.axIDLDrawWidget1 = new AxIDLDRAWX3Lib.AxIDLDrawWidget();
            this.DirectGraphics = new System.Windows.Forms.Button();
            this.ObjectGraphics = new System.Windows.Forms.Button();
            this.exchange = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.axIDLDrawWidget1)).BeginInit();
            this.SuspendLayout();
            // 
            // axIDLDrawWidget1
            // 
            this.axIDLDrawWidget1.Enabled = true;
            this.axIDLDrawWidget1.Location = new System.Drawing.Point(7, 7);
            this.axIDLDrawWidget1.Name = "axIDLDrawWidget1";
            this.axIDLDrawWidget1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axIDLDrawWidget1.OcxState")));
            this.axIDLDrawWidget1.Size = new System.Drawing.Size(400, 400);
            this.axIDLDrawWidget1.TabIndex = 0;
            // 
            // DirectGraphics
            // 
            this.DirectGraphics.Location = new System.Drawing.Point(24, 433);
            this.DirectGraphics.Name = "DirectGraphics";
            this.DirectGraphics.Size = new System.Drawing.Size(114, 23);
            this.DirectGraphics.TabIndex = 1;
            this.DirectGraphics.Text = "直接图形法";
            this.DirectGraphics.UseVisualStyleBackColor = true;
            this.DirectGraphics.Click += new System.EventHandler(this.DirectGraphics_Click);
            // 
            // ObjectGraphics
            // 
            this.ObjectGraphics.Location = new System.Drawing.Point(267, 433);
            this.ObjectGraphics.Name = "ObjectGraphics";
            this.ObjectGraphics.Size = new System.Drawing.Size(110, 23);
            this.ObjectGraphics.TabIndex = 2;
            this.ObjectGraphics.Text = "对象图形法";
            this.ObjectGraphics.UseVisualStyleBackColor = true;
            this.ObjectGraphics.Click += new System.EventHandler(this.ObjectGraphics_Click);
            // 
            // exchange
            // 
            this.exchange.Location = new System.Drawing.Point(162, 433);
            this.exchange.Name = "exchange";
            this.exchange.Size = new System.Drawing.Size(87, 23);
            this.exchange.TabIndex = 3;
            this.exchange.Text = "参数传递";
            this.exchange.UseVisualStyleBackColor = true;
            this.exchange.Click += new System.EventHandler(this.exchange_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(416, 468);
            this.Controls.Add(this.exchange);
            this.Controls.Add(this.ObjectGraphics);
            this.Controls.Add(this.DirectGraphics);
            this.Controls.Add(this.axIDLDrawWidget1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.axIDLDrawWidget1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private AxIDLDRAWX3Lib.AxIDLDrawWidget axIDLDrawWidget1;
        private System.Windows.Forms.Button DirectGraphics;
        private System.Windows.Forms.Button ObjectGraphics;
        private System.Windows.Forms.Button exchange;
    }
}

