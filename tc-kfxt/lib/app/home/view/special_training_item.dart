import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/app/home/page/list_comment_page.dart';
import 'package:school/app/home/page/special_training_detail_page.dart';
import 'package:school/app/teacher/page/teacher_detail_page.dart';
import 'package:school/model/offline_study.dart';
import 'package:school/model/special_training.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/util/theme_utils.dart';
import 'dart:convert' as convert;

import 'package:school/widgets/load_image.dart';

class SpecialTrainingItemWidget extends StatelessWidget {

  final SpecialTraining specialTraining;
  final String type;
  SpecialTrainingItemWidget({this.specialTraining,this.type});

  @override
  Widget build(BuildContext context) {
    String imgUrl = "";
    if(type == "SPECIAL" || type == "COLUMN"){
      imgUrl = specialTraining.bannerImg;
    }else{
      List<dynamic> bannerImg = convert.jsonDecode(specialTraining.bannerImg);
      imgUrl = bannerImg[0];
    }

    return InkWell(
      onTap: (){
        if(type == "SPECIAL" || type == "CASE"){
          NavigatorUtils.pushResultWithParm(context,
              SpecialTrainingDetailPage(
                type: type,
                productId: specialTraining.id,
              ), (result){
              });
        }else {
          NavigatorUtils.pushResultWithParm(context,
              TeacherDetailPage(
                type: type,
                productId: specialTraining.id,
                imgBg: specialTraining.bannerImg,
              ), (result){
              });
        }
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
                      child: LoadImage(imgUrl,width: 110),
                    ),
                    Gaps.hGap8,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            specialTraining.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color,
                              fontSize: Dimens.font_sp14,
                            ),
                          ),
                          Text(
                            specialTraining.contentAbstract,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.subtitle.color,
                              fontSize: Dimens.font_sp12,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            (type == "COLUMN")?((specialTraining.totalPrice <= 0.0) ? "免费": "¥${specialTraining.totalPrice.toString()}"):(specialTraining.price <= 0.0) ? "免费": "¥${specialTraining.price.toString()}",

                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimens.font_sp12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
//              Container(
//                padding: EdgeInsets.only(left: 10.0,right: 10.0),
//                width: ScreenUtil.getScreenW(context)-20,
//                height: 0.5,
//                color: Theme.of(context).dividerColor,
//              )
              Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                child: Gaps.line,
              )
            ],
          )
      ),
    );
  }
}
