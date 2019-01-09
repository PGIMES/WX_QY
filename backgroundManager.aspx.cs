using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class backgroundManager : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        //创建菜单
        createMenu();
    }

    /// <summary>
    /// 创建菜单
    /// </summary>
    private void createMenu()
    {
        string data = getMenu();
        LogHelper.Write("menu数据:" + data);
        string url = string.Format("https://qyapi.weixin.qq.com/cgi-bin/menu/create?access_token={0}&agentid={1}", TokenModel.AccessToken, TokenModel.AgentId);
        AppErrorEn error = JsonHelper.DeserializeJsonToObject<AppErrorEn>(WeChatHelper.SendHttpRequest(url, data));
        if (error.errcode == "0")
            this.Label1.Text = "创建成功";
        else
            this.Label1.Text = "创建失败:" + error.errcode + "," + error.errmsg;
    }
    /// <summary>
    /// 获取菜单数据
    /// </summary>
    /// <returns></returns>
    private string getMenu()
    {
        try
        {
            FileStream fs1 = new FileStream(System.Web.HttpContext.Current.Server.MapPath(".") + "\\file\\menu.txt", FileMode.Open);
            StreamReader sr = new StreamReader(fs1, Encoding.GetEncoding("GBK"));
            string menu = sr.ReadToEnd();
            sr.Close();
            fs1.Close();
            return menu;
        }
        catch (Exception e)
        {
            LogHelper.Write("getMenu异常：" + e.Message);
            return "";
        }
    }
}