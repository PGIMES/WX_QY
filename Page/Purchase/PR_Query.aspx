<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PR_Query.aspx.cs" Inherits="Page_Purchase_PR_Query" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<%--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>--%>
<meta charset="utf-8">
<meta name="viewport" content="initial-scale=1, maximum-scale=1">
    <title>请购单查询</title>
    <link rel="stylesheet" href="//g.alicdn.com/msui/sm/0.6.2/css/sm.min.css">
    <script type='text/javascript' src='//g.alicdn.com/sj/lib/zepto/zepto.min.js' charset='utf-8'></script>

    <style>
        #page-infinite-scroll-bottom .bar input[type=search]{
             margin:.2rem 0;
        }
        #page-infinite-scroll-bottom .bar .button {
            top:0;
        }
        #page-infinite-scroll-bottom .bar {
            height:5.2rem;
        }
        #page-infinite-scroll-bottom .bar-nav ~ .content {
            top: 5.2rem;
        }
        #page-infinite-scroll-bottom .search-input input{
            border-radius:0;font-size:13px;
        }
         #div_list .list-block{
            font-size:13px;
            margin:.2rem 0;
        }
    </style>
    
    <script type="text/javascript">     
        $(function () {
            init_condition();


            var loading = false;
            var itemsPerLoad = 10;// 每次加载添加多少条目                
            var maxItems = 100;// 最多可加载的条目
            var lastIndex = 0;//$('.list-block').length;//.list-container li   

            $("#btn_search_m").click(function () {
                select();
            });

            function select() {
                $.showPreloader('加载中...');
                setTimeout(function () {
                    $.closeModal();
                    //首次查询需要置为初始值
                    $('#div_list').html("");
                    loading = false; itemsPerLoad = 10; lastIndex = 0;
                    var scroller = $('.native-scroll');
                    //首次查询，需要加载监听事件及加载符号
                    $('.infinite-scroll-preloader').show();
                    $.attachInfiniteScroll($('.infinite-scroll'));
                    loaddata(itemsPerLoad, lastIndex);
                    lastIndex = $('#div_list .list-block').length;// 更新最后加载的序号
                    $.refreshScroller();
                    scroller.scrollTop(0); //首次查询后，滚动条需要置为初始值0
                    if (lastIndex < itemsPerLoad) {
                        $.detachInfiniteScroll($('.infinite-scroll'));// 加载完毕，则注销无限加载事件，以防不必要的加载     
                        $('.infinite-scroll-preloader').hide();
                        if (lastIndex == 0) { $.toast("没有符合的数据！"); }
                        else { $.toast("已经加载到最后"); }
                    }
                    $.hidePreloader();
                }, 500);
            }

            //无限滚动
            $(document).on("pageInit", "#page-infinite-scroll-bottom", function (e, id, page) {
                $('.infinite-scroll-preloader').hide();
                $(page).on('infinite', function () {
                    if (loading) return;// 如果正在加载，则退出                    
                    loading = true;// 设置flag
                    $('.infinite-scroll-preloader').show();
                    $.attachInfiniteScroll($('.infinite-scroll'));
                    setTimeout(function () {
                        loading = false;// 重置加载flag
                        if (lastIndex >= maxItems || lastIndex % itemsPerLoad != 0) {
                            $.detachInfiniteScroll($('.infinite-scroll'));// 加载完毕，则注销无限加载事件，以防不必要的加载     
                            $('.infinite-scroll-preloader').hide();
                            $.toast("已经加载到最后");
                            return;
                        }
                        loaddata(itemsPerLoad, lastIndex);
                        if (lastIndex == $('#div_list .list-block').length) {
                            $.detachInfiniteScroll($('.infinite-scroll'));// 加载完毕，则注销无限加载事件，以防不必要的加载     
                            $('.infinite-scroll-preloader').hide();
                            $.toast("已经加载到最后");
                            return;
                        }                        
                        lastIndex = $('#div_list .list-block').length;// 更新最后加载的序号
                        $.refreshScroller();
                    }, 500);
                });
            });

            $("#div_list").on('click', '.item-link', function (e) {// $("#div_list")也可以换成$(document)，是基于父容器的概念               
                 var strconHTML = "";
                 var ele_id = e.currentTarget.id;
                 var id = ele_id.substring(3);
 
                 $.ajax({
                     type: "post", //要用post方式                 
                     url: "PR_Query.aspx/BindListDetail",//方法所在页面和方法名
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     data: "{'id':'" + id + "'}",
                     cache: false,
                     async: false,
                     success: function (data) {
                         var obj = eval("(" + data.d + ")");//将字符串转为json
                         //var obj_FAVORABLERATE = obj[0]["FAVORABLERATE"] == null ? "" : obj[0]["FAVORABLERATE"];
                         //var obj_VATRATE = obj[0]["VATRATE"] == null ? "" : obj[0]["VATRATE"];
                         //var obj_EXPORTREBATRATE = obj[0]["EXPORTREBATRATE"] == null ? "" : obj[0]["EXPORTREBATRATE"];
                         //var obj_GENERALRATE = obj[0]["GENERALRATE"] == null ? "" : obj[0]["GENERALRATE"];
                         //var obj_CUSTOMREGULATORY = obj[0]["CUSTOMREGULATORY"] == null ? "" : obj[0]["CUSTOMREGULATORY"];
                         //var obj_INSPECTIONREGULATORY = obj[0]["INSPECTIONREGULATORY"] == null ? "" : obj[0]["INSPECTIONREGULATORY"];
                         strconHTML = '<div class="list-block contacts-block">'
                                            +'<div class="list-group">'
                                                + '<ul>'  // style="background-color:#DFF0D8;"     
                                                    + '<li><div class="item-content"><div class="item-inner"><div class="item-title">申请人：'+obj[0]["createbyid"]+" "+ obj[0]["createbyName"]+ '</div></div></div></li>'
                                                    + '<li><div class="item-content"><div class="item-inner"><div class="item-title">申请日期：' + obj[0]["createDate"] + '</div></div></div></li>'
                                                    + '<li><div class="item-content"><div class="item-inner"><div class="item-title">申请工厂：' + obj[0]["applydept"]+" "+ obj[0]["deptname"] + '</div></div></div></li>'
                                                    + '<li><div class="item-content"><div class="item-inner"><div class="item-title">申请类别：' + obj[0]["prtype"] + '</div></div></div></li>'
                                                +'</ul>'
                                            +'</div>'
                                    + '</div>';
                         strconHTML += '<div class="card">'
                                            + '<div class="card-header">申请原因</div>'
                                            + '<div class="card-content"><div class="card-content-inner">' + obj[0]["prreason"] + '</div></div>'
                                    + '</div>';
                         strconHTML += '<div class="list-block contacts-block">'
                                            + '<div class="list-group">'
                                                + '<ul>'  // style="background-color:#DFF0D8;"     
                                                    + '<li><div class="item-content"><div class="item-inner"><div class="item-title">物料号：' + obj[0]["wlh"] + '</div></div></div></li>'
                                                    + '<li><div class="item-content"><div class="item-inner"><div class="item-title">物料名称：' + obj[0]["wlmc"] + '</div></div></div></li>'
                                                    + '<li><div class="item-content"><div class="item-inner"><div class="item-title">物料描述：' + obj[0]["wlms"] + '</div></div></div></li>'
                                                + '</ul>'
                                            + '</div>'
                                    + '</div>';
 
                     },
                     error: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数
                         //alert(XMLHttpRequest.status);
                         //alert(XMLHttpRequest.readyState);
                         //alert(textStatus);
                         alert('error...状态文本值：' + textStatus + " 异常信息：" + errorThrown);
                     }
                 });
 
                 var popupHTML = '<div class="popup">' +
                                     '<div class="content">' +//data-type='native'                                                                               
                                            strconHTML +                                               
                                            '<div class="content-block"><a href="#" class="close-popup button button-fill button-danger">返回</a></div>' +                                         
                                     '</div>' +
                                 '</div>';               
                 $.popup(popupHTML);
            });
            
            $.init();
            //----------------------------------------------------------------------------------------------------------------------------------------jquery
            function loaddata(itemsPerLoad, lastIndex) {
                $.ajax({
                    type: "post", //要用post方式                 
                    url: "PR_Query.aspx/BindList",//方法所在页面和方法名
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: "{'prtype':'" + $("#txt_prtype").val() + "','startdate':'" + $("#txt_startdate").val() + "','enddate':'" + $("#txt_enddate").val()
                        + "','start':" + lastIndex + ",'itemsPerLoad':" + itemsPerLoad + "}",
                    cache: false,
                    async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                    success: function (data) {
                        var obj = eval("(" + data.d + ")");//将字符串转为json
                        var tb = ""; var objname = "";
                        for (var i = 0; i < obj.length; i++) {
                            objname = obj[i]["wlmc"].length >= 12 ? obj[i]["wlmc"].substring(0, 12) + "..." : obj[i]["wlmc"];
                            tb = '<div class="list-block">'
                               + '<ul class="list-container">'
                               + '<li class="item-content item-link" id="li_' + obj[i]["id"] + '"><div class="item-inner"><div class="item-title">请购单号</div><div class="item-after"><font color="#0894ec">' + obj[i]["prno"] + '</font></div></div></li>'
                               + '<li class="item-content"><div class="item-inner"><div class="item-title">物料号</div><div class="item-after">' + obj[i]["wlh"] + '</div></div></li>'
                               + '<li class="item-content"><div class="item-inner"><div class="item-title">物料名称</div><div class="item-after">' + objname + '</div></div></li>'
                               + '</ul>'
                               + '</div>';
                            $('#div_list').append(tb);
                            tb = ""; objname = "";
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数
                        //alert(XMLHttpRequest.status);
                        //alert(XMLHttpRequest.readyState);
                        //alert(textStatus);
                        alert('error...状态文本值：' + textStatus + " 异常信息：" + errorThrown);
                    }
                });
            }

            function init_condition() {
                $("#txt_prtype").picker({
                    toolbarTemplate: '<header class="bar bar-nav">\
                      <button class="button button-link pull-right close-picker">确定</button>\
                      <h1 class="title">请选择类别</h1>\
                      </header>',
                    cols: [
                      {
                          textAlign: 'center',
                          values: ['存货(刀具类)', '存货(其他辅料类)', '存货(原材料及前期样件)']
                      }
                    ]
                });
                //初始化时间控件
                //var before = new Date();
                //before.setDate(before.getDate() - 3);
                //var beforeday = before.Format("yyyy-MM-dd");
                //var now = new Date();
                //var today = now.Format("yyyy-MM-dd");
                //$("#txt_startdate").val(beforeday);
                //$("#txt_startdate").calendar({ value: [beforeday] });
                //$("#txt_enddate").val(today);
                //$("#txt_enddate").calendar({ value: [today] });


                $("#txt_startdate").calendar({ });
                $("#txt_enddate").calendar({ });
            }
        });
    </script>
    
</head>
<body>    

    <div class="page-group">
        <div id="page-infinite-scroll-bottom" class="page page-current">
            <header class="bar bar-nav">
                <div class="search-input">
                    <div class="row"> 
                        <div class="col-20" style="font-size:13px;margin-top:.8rem;">类别</div>
                        <div class="col-80"><input type="search" id='txt_prtype'/></div>
                    </div>
                    <div class="row"> 
                        <div class="col-20" style="font-size:13px;margin-top:.8rem;">创建日期</div>
                        <div class="col-40"><input type="search" id='txt_startdate'/></div>
                        <div class="col-40"><input type="search" id='txt_enddate'/></div>
                    </div>
                    <div class="row">
                        <div class="col-100" ><input id="btn_search_m" type="button" value="查询"  class="open-preloader-title button button-fill" /></div>
                    </div> 
                </div>
            </header>
            <div class="content infinite-scroll native-scroll" data-distance="100">
                <div id="div_list"></div>
                <!-- 加载提示符 -->
                <div class="infinite-scroll-preloader">
                  <div class="preloader"></div>
                </div>
            </div>
        </div>
    </div>
   
    <script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm.min.js' charset='utf-8'></script>   
</body>
</html>
