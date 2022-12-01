using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.IO;
using System.Runtime.InteropServices;

using ESRI.ArcGIS.esriSystem;
using ESRI.ArcGIS.Carto;
using ESRI.ArcGIS.Controls;
using ESRI.ArcGIS.ADF;
using ESRI.ArcGIS.SystemUI;
//添加自定义引用
using ESRI.ArcGIS.DataSourcesRaster;
using ESRI.ArcGIS.Geodatabase;

namespace ArcGISEngineUsingENVI
{
    public sealed partial class MainForm : Form
    {
        #region class private members
        private IMapControl3 m_mapControl = null;
        private string m_mapDocumentName = string.Empty;
        #endregion

        #region class constructor
        COM_IDL_connectLib.COM_IDL_connectClass oComIDL = new COM_IDL_connectLib.COM_IDL_connectClass();
        public MainForm()
        {
            InitializeComponent();
        }
        #endregion

        private void MainForm_Load(object sender, EventArgs e)
        {
            //get the MapControl
            m_mapControl = (IMapControl3)axMapControl1.Object;

            //disable the Save menu (since there is no document yet)
            menuSaveDoc.Enabled = false;            

        }

        #region Main Menu event handlers
        private void menuNewDoc_Click(object sender, EventArgs e)
        {
            //execute New Document command
            ICommand command = new CreateNewDocument();
            command.OnCreate(m_mapControl.Object);
            command.OnClick();
        }

        private void menuOpenDoc_Click(object sender, EventArgs e)
        {
            //execute Open Document command
            ICommand command = new ControlsOpenDocCommandClass();
            command.OnCreate(m_mapControl.Object);
            command.OnClick();
        }

        private void menuSaveDoc_Click(object sender, EventArgs e)
        {
            //execute Save Document command
            if (m_mapControl.CheckMxFile(m_mapDocumentName))
            {
                //create a new instance of a MapDocument
                IMapDocument mapDoc = new MapDocumentClass();
                mapDoc.Open(m_mapDocumentName, string.Empty);

                //Make sure that the MapDocument is not readonly
                if (mapDoc.get_IsReadOnly(m_mapDocumentName))
                {
                    MessageBox.Show("Map document is read only!");
                    mapDoc.Close();
                    return;
                }

                //Replace its contents with the current map
                mapDoc.ReplaceContents((IMxdContents)m_mapControl.Map);

                //save the MapDocument in order to persist it
                mapDoc.Save(mapDoc.UsesRelativePaths, false);

                //close the MapDocument
                mapDoc.Close();
            }
        }

        private void menuSaveAs_Click(object sender, EventArgs e)
        {
            //execute SaveAs Document command
            ICommand command = new ControlsSaveAsDocCommandClass();
            command.OnCreate(m_mapControl.Object);
            command.OnClick();
        }

        private void menuExitApp_Click(object sender, EventArgs e)
        {
            //exit the application
            Application.Exit();
        }
        #endregion

        //listen to MapReplaced evant in order to update the statusbar and the Save menu
        private void axMapControl1_OnMapReplaced(object sender, IMapControlEvents2_OnMapReplacedEvent e)
        {
            //get the current document name from the MapControl
            m_mapDocumentName = m_mapControl.DocumentFilename;

            //if there is no MapDocument, diable the Save menu and clear the statusbar
            if (m_mapDocumentName == string.Empty)
            {
                menuSaveDoc.Enabled = false;
                statusBarXY.Text = string.Empty;
            }
            else
            {
                //enable the Save manu and write the doc name to the statusbar
                menuSaveDoc.Enabled = true;
                statusBarXY.Text = Path.GetFileName(m_mapDocumentName);
            }
        }

        private void axMapControl1_OnMouseMove(object sender, IMapControlEvents2_OnMouseMoveEvent e)
        {
            statusBarXY.Text = string.Format("{0}, {1}  {2}", e.mapX.ToString("#######.##"), e.mapY.ToString("#######.##"), axMapControl1.MapUnits.ToString().Substring(4));
        }

        private void enviToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //初始化ENVI
            COM_IDL_connectLib.COM_IDL_connectClass oComIDL = new COM_IDL_connectLib.COM_IDL_connectClass();
            oComIDL.CreateObject(0, 0, 0);
            //文件打开
            OpenFileDialog pOpenFile = new OpenFileDialog();
            
            pOpenFile.Title="打开栅格文件";
            //文件选择
            if (pOpenFile.ShowDialog() == DialogResult.OK)
            {
                //打开显示栅格文件
                OpenRaster(pOpenFile.FileName);
                //调用ENVI进行栅格放大2*2处理示例
                SaveFileDialog pSaveFile = new SaveFileDialog();
                pSaveFile.Title = "输出放大后影像";
                if (pSaveFile.ShowDialog() == DialogResult.OK)
                {
                    //执行重采样
                    oComIDL.ExecuteString(".compile '" + System.IO.Directory.GetCurrentDirectory() + @"\object_envi_resize__define.pro'");
                    oComIDL.ExecuteString(@"s = obj_new('object_envi_resize','"+pOpenFile.FileName+"','"+pSaveFile.FileName+"')");
                    oComIDL.ExecuteString("s.EXECUTERESIZE,2,2,0");
                    oComIDL.ExecuteString("Obj_destroy,s");
                    //加载放大后影像
                    OpenRaster(pSaveFile.FileName);
                }
            }
        }
       
        //定义栅格打开函数
        private void OpenRaster(string rasterFileName)
        {
            
            //文件名处理
            string ws = System.IO.Path.GetDirectoryName(rasterFileName);
            string fbs = System.IO.Path.GetFileName(rasterFileName);

            //创建工作空间
            IWorkspaceFactory pWork = new RasterWorkspaceFactoryClass();
            //打开工作空间路径 ，工作空间的参数是目录，不是具体的文件名
            IRasterWorkspace pRasterWS = (IRasterWorkspace)pWork.OpenFromFile(ws, 0);
            //打开工作空间下的文件，
            IRasterDataset pRasterDataset = pRasterWS.OpenRasterDataset(fbs);
            IRasterLayer pRasterLayer = new RasterLayerClass();
            pRasterLayer.CreateFromDataset(pRasterDataset);
            //添加到图层控制中
            m_mapControl.Map.AddLayer(pRasterLayer as ILayer);
        }

        
    }
}