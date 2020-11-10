import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/app/home/page/offline_learning_detail_page.dart';
import 'package:school/model/offline_study.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/load_image.dart';

class OfflineStudyItemWidget extends StatelessWidget {

  final OfflineStudy offlineStudy;
  OfflineStudyItemWidget(this.offlineStudy);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        NavigatorUtils.pushResultWithParm(context,
            OfflineLearningDetailPage(
              offlineStudy: offlineStudy,
            ), (result){
            });
      },
      child: Container(
          color: ThemeUtils.getViewBgColor(context),
          width: ScreenUtil.getScreenW(context),
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: LoadImage(offlineStudy.bannerImg,width: 110,),
                    ),
                    Gaps.hGap8,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${offlineStudy.title}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color,
                              fontSize: Dimens.font_sp14,
                            ),
                          ),
                          Text(
                            offlineStudy.signupStarttime.substring(0,10)+"至"+offlineStudy.signupEndtime.substring(0,10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.subtitle.color,
                              fontSize: Dimens.font_sp12,
                            ),
                          ),
                          Text(
                            offlineStudy.cityName+"｜"+offlineStudy.detailAddr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.subtitle.color,
                              fontSize: Dimens.font_sp12,
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  (offlineStudy.price <= 0.0) ? "免费": "¥"+offlineStudy.price.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Dimens.font_sp12,
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 8.0,right: 8.0),
                                  width: 60,
                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(new Radius.circular(2.0)),
                                    color: (offlineStudy.signupStatus == 1)? Theme.of(context).primaryColor : (offlineStudy.signupStatus == 2 ? Colors.deepOrange[200] : (offlineStudy.signupStatus == 3) ? Colours.green_color : Colors.grey[300]) ,
                                  ),
                                  child: Text(
                                    //1：2：报名结束3：4：活动结束
//                                    "${offlineStudy.signupStatusName}",
                                    (offlineStudy.signupStatus == 1)? "即将开始" : (offlineStudy.signupStatus == 2 ? "立即报名" : (offlineStudy.signupStatus == 3 ? "报名结束" : "活动结束")) ,
                                    style: TextStyle(
                                      color: (offlineStudy.signupStatus == 4)? Theme.of(context).textTheme.subtitle.color : Colors.white ,
                                      fontSize: Dimens.font_sp10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
//          Container(
//            padding: EdgeInsets.only(left: 10.0,right: 10.0),
//            width: ScreenUtil.getScreenW(context)-20,
//            height: 0.5,
//            color: Theme.of(context).dividerColor,
//          )
              Gaps.line
            ],
          )
      )
    );
  }
}
