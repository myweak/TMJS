import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/common/common.dart';
import 'package:school/model/mine.dart';
import 'package:school/model/user.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/view_model/mine_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/app_indicator.dart';
import 'package:school/widgets/click_item.dart';
import 'package:school/widgets/load_image.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String name = SpUtil.getString(Constant.name);
  int offlineCount = SpUtil.getInt(Constant.offlineCount);
  int collectCount = SpUtil.getInt(Constant.collectCount);
  int status = SpUtil.getInt(Constant.status);

  @override
  Future<void> initState() {
    super.initState();
    loadSummary();
    if(status != 4){
      loadGetUser();
    }
  }

  void loadSummary() async{
    Mine mine = await AppRepository.fetchSummary();
    SpUtil.putInt(Constant.offlineCount,mine.offline_count);
    SpUtil.putInt(Constant.collectCount,mine.collect_count);
    setState(() {
      offlineCount = SpUtil.getInt(Constant.offlineCount);
      collectCount = SpUtil.getInt(Constant.collectCount);
    });
  }

  void loadGetUser() async{
    User user = await AppRepository.fetchGetUser();
    SpUtil.putInt(Constant.status,user.status);
    setState(() {
      status = SpUtil.getInt(Constant.status);
    });
  }


  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MineModel>(
      model: MineModel(),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
//        if(model.busy) {
//          return AppIndicatorNoBar();
//        }

        return Scaffold(
            body: new SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              LoadImage("mine/mybgs",width: ScreenUtil.getScreenW(context),height: ScreenUtil.getStatusBarH(context)+ScreenUtil.getScreenW(context)/2),
                              Container(
                                height: 70.0,
                                color: ThemeUtils.getViewBgColor(context),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: ScreenUtil.getStatusBarH(context)+20.0,
                          left: 20.0,
                          child: buildWidgetHead(),
                        ),
                        Positioned(
                          bottom: 90,
                          left: 10.0,
                          right: 10.0,
                          height: 40.0,
                          child: buildWidgetIdentify(),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0,right: 10.0),
                            child: Card(
                              child: Row(
                                children: <Widget>[
                                  buildWidgetTextCell(offlineCount.toString(), "报名"),
                                  Container(
                                    color: Theme.of(context).dividerColor,
                                    width: 1.0,
                                    height: 40.0,
                                  ),
                                  buildWidgetTextCell(collectCount.toString(), "收藏"),
                                  Container(
                                    color: Theme.of(context).dividerColor,
                                    width: 1.0,
                                    height: 40.0,
                                  ),
                                  buildWidgetTextCell("100", "足迹")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: ThemeUtils.getViewBgColor(context),
                      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          buildWidgetImgCell("mine/myorder", "我的订单"),
                          buildWidgetImgCell("mine/mycoupon", "优惠卷"),
                          buildWidgetImgCell("mine/mypublish", "我的发布")
                        ],
                      ),
                    ),
                    Gaps.vGap10,
                    Container(
                      child: Column(
                        children: <Widget>[
                          ClickItem(
                              imgStr: "mine/applyclass",
                              title: "申请开课",
                              onTap: (){
                                NavigatorUtils.push(context, Routes.applyClass);
                              }
                          ),
                          ClickItem(
                              imgStr: "mine/feedback",
                              title: "建议反馈",
                              onTap: (){}
                          ),
                          ClickItem(
                              imgStr: "mine/setting",
                              title: "设置",
                              onTap: (){
                                NavigatorUtils.push(context, Routes.setting);
                              }
                          ),
                        ],
                      ),
                    )
                  ],
                )
            )
        );
      },
    );
  }



  Widget buildWidgetIdentify(){
    return (status == 4)?Container():Card(
      color: Theme.of(context).dividerColor,
      child: Row(
        children: <Widget>[
          Gaps.hGap8,
          LoadImage("mine/identification",width: 15.0,height: 15.0,),
          Gaps.hGap8,
          Text(
            "完成认证可领取精选课程优惠卷～",
            style: TextStyle(fontSize: 11.0,color: Colors.white),
          ),
          Expanded(child: Container()),
          Text(
            (status == 3)?"认证失败 >":((status == 2)?"审核中 >":"去认证 >"),
            style: TextStyle(fontSize: 11.0,color: Colors.white),
          ),
          Gaps.hGap8,
        ],
      ),
    );
  }

  Widget buildWidgetHead(){
    return Container(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: (ScreenUtil.getScreenW(context)/2-20-75)/2,
            backgroundColor: Theme.of(context).dividerColor,
            backgroundImage: ImageUtils.getImageProvider(SpUtil.getString(Constant.headimg),holderImg: ""),
          ),
          Gaps.hGap8,
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  SpUtil.getString(Constant.phone),
                  style: TextStyle(fontSize: Dimens.font_sp18,fontWeight: FontWeight.bold,color: Colors.white),
                ),
                Gaps.vGap8,
                Text(
                  (status == 4)?name:((status == 3)?"认证失败 >":((status == 2)?"审核中 >":"待认证")),
                  style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildWidgetImgCell(String imgStr,String title){
    return Container(
      width: (ScreenUtil.getScreenW(context)-20)/3,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoadImage(imgStr,height: 35,fit: BoxFit.contain,),
          Gaps.vGap8,
          Text(
            title,
            style: TextStyle(fontSize: Dimens.font_sp12),
          )
        ],
      ),
    );
  }

  Widget buildWidgetTextCell(String numStr,String title){
    return Container(
      width: (ScreenUtil.getScreenW(context)-30)/3,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            numStr,
            style: TextStyles.textBold14,
          ),
          Gaps.vGap8,
          Text(
            title,
            style: TextStyle(fontSize: Dimens.font_sp12,color: Theme.of(context).textTheme.subtitle.color),
          )
        ],
      ),
    );
  }

}
