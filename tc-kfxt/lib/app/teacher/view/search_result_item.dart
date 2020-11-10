import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/app/home/page/offline_learning_detail_page.dart';
import 'package:school/app/home/page/special_training_detail_page.dart';
import 'package:school/app/teacher/page/search_results.dart';
import 'package:school/app/teacher/page/teacher_detail_page.dart';
import 'package:school/model/offline_study.dart';
import 'package:school/model/search_result.dart';
import 'package:school/model/special_training.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/widgets/load_image.dart';

class SearchResultItemWidget extends StatelessWidget {

  final String type;
  final SearchReslut searchReslut;
  SearchResultItemWidget(this.type,this.searchReslut);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(type == "COLUMN"){
          NavigatorUtils.pushResultWithParm(context,
              TeacherDetailPage(
                type: type,
                productId: searchReslut.id,
                imgBg: searchReslut.bannerImg,
              ), (result){
              });
        }else{
          if((searchReslut.prodType == "SPECIAL") || (searchReslut.prodType == "CASE")){ //专项培训 或 病例教程
            NavigatorUtils.pushResultWithParm(context,
                SpecialTrainingDetailPage(
                  type: searchReslut.prodType,
                  productId: searchReslut.id,
                ), (result){
                });
          }else if(type == "OFFSTUDIES"){ //线下进修
//            NavigatorUtils.pushResultWithParm(context,
//                OfflineLearningDetailPage(
//                  offlineStudy: offlineStudy,
//                ), (result){
//                });
          }
        }
      },
      child: Container(
          width: ScreenUtil.getScreenW(context),
          height: 102,
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: LoadImage(searchReslut.bannerImg.split(",")[0],width: 110),
                    ),
                    Gaps.hGap8,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            searchReslut.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.body1.color,
                              fontSize: Dimens.font_sp14,
                            ),
                          ),
                          Text(
                            searchReslut.contentAbstract,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.subtitle.color,
                              fontSize: Dimens.font_sp12,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            (searchReslut.totalPrice <= 0.0) ? "免费": "¥"+searchReslut.totalPrice.toString(),
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
              Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                width: ScreenUtil.getScreenW(context)-20,
                height: 0.5,
                color: Theme.of(context).dividerColor,
              )
            ],
          )
      ),
    );
  }
}
