import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/app/home/page/special_training_detail_page.dart';
import 'package:school/model/case_tutorial.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/util/theme_utils.dart';

import 'dart:convert' as convert;

import 'package:school/widgets/load_image.dart';

class CaseTutorialItemWidget extends StatelessWidget {

  final CaseTutorial caseTutorial;
  final String type;
  CaseTutorialItemWidget({this.caseTutorial,this.type});


  @override
  Widget build(BuildContext context) {
    double screenWith = (ScreenUtil.getScreenW(context)-30)/3;
//    List bannerImgList = convert.jsonDecode(caseTutorial.bannerImg);
    return InkWell(
      onTap: (){
        NavigatorUtils.pushResultWithParm(context,
            SpecialTrainingDetailPage(
              type: type,
              productId: caseTutorial.id,
            ), (result){
            });
      },
      child: Container(
        color: ThemeUtils.getViewBgColor(context),
        width: ScreenUtil.getScreenW(context),
        padding: EdgeInsets.only(left: 10.0,right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: Text(
                caseTutorial.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
                  fontSize: Dimens.font_sp15,
                ),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  (caseTutorial.bannerImg.length<1) ? Container() : ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LoadImage(caseTutorial.bannerImg[0].toString(),width: screenWith,height: screenWith-10),
                  ),
                  Gaps.hGap5,
                  (caseTutorial.bannerImg.length<2) ? Container() : ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LoadImage(caseTutorial.bannerImg[1].toString(),width: screenWith,height: screenWith-10),
                  ),
                  Gaps.hGap5,
                  (caseTutorial.bannerImg.length<3) ? Container() : ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LoadImage(caseTutorial.bannerImg[2].toString(),width: screenWith,height: screenWith-10),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    caseTutorial.hits.toString()+" 预览",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle.color,
                      fontSize: Dimens.font_sp10,
                    ),
                  ),
                  Gaps.hGap10,
                  Text(
                    caseTutorial.likes.toString()+" 赞",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle.color,
                      fontSize: Dimens.font_sp10,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    (caseTutorial.price <= 0.0) ? "免费": "¥"+caseTutorial.price.toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimens.font_sp12,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.line
          ],
        ),
      ),
    );
  }
}
