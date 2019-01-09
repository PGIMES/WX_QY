using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Xml;

/// <summary>
/// TokenModel 的摘要说明
/// </summary>
public class TokenModel
{
    public TokenModel()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    private static DateTime GetAccessToken_Time;
    /// <summary>
    /// 过期时间为7200秒
    /// </summary>
    private static int Expires_Period = 7200;
    /// <summary>
    /// 
    /// </summary>
    private static string mAccessToken;

    public static string Id = ConfigurationManager.AppSettings["Id"];
    public static string AgentId = ConfigurationManager.AppSettings["AgentId"];
    public static string Secret = ConfigurationManager.AppSettings["Secret"];
    /// <summary>
    /// 调用获取ACCESS_TOKEN,包含判断是否过期
    /// </summary>
    public static string AccessToken
    {
        get
        {
            //如果为空，或者过期，需要重新获取
            if (string.IsNullOrEmpty(mAccessToken) || HasExpired())
            {
                //获取access_token
                mAccessToken = GetAccessToken(Id, Secret);
            }

            return mAccessToken;
        }
    }
    /// <summary>
    /// 获取ACCESS_TOKEN方法
    /// </summary>
    /// <param name="appId"></param>
    /// <param name="appSecret"></param>
    /// <returns></returns>
    private static string GetAccessToken(string id, string secret)
    {
        string url = string.Format("https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={0}&corpsecret={1}", id, secret);
        string result = WeChatHelper.GetData(url);
        if (result.Contains("40164"))
        {
            LogHelper.Write("TokenModel_GetAccessToken出错：" + result);
            return null;
        }

        XmlDocument doc = JsonHelper.ParseJson(result, "root");
        XmlNode root = doc.SelectSingleNode("root");
        if (root != null)
        {
            XmlNode access_token = root.SelectSingleNode("access_token");
            if (access_token != null)
            {
                GetAccessToken_Time = DateTime.Now;
                if (root.SelectSingleNode("expires_in") != null)
                {
                    Expires_Period = int.Parse(root.SelectSingleNode("expires_in").InnerText);
                }
                return access_token.InnerText;
            }
            else
            {
                GetAccessToken_Time = DateTime.MinValue;
            }
        }

        return null;
    }
    /// <summary>
    /// 判断Access_token是否过期
    /// </summary>
    /// <returns>bool</returns>
    private static bool HasExpired()
    {
        if (GetAccessToken_Time != null)
        {
            //过期时间，允许有一定的误差，一分钟。获取时间消耗
            if (DateTime.Now > GetAccessToken_Time.AddSeconds(Expires_Period).AddSeconds(-60))
            {
                return true;
            }
        }
        return false;
    }
}