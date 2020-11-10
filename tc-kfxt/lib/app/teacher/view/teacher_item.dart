import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/app/teacher/page/teacher_detail_page.dart';
import 'package:school/model/teacher.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/load_image.dart';

class TeacherItemWidget extends StatelessWidget {

  final Teacher teacher;
  TeacherItemWidget(this.teacher);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        NavigatorUtils.pushResultWithParm(context,
            TeacherDetailPage(
              type: "COLUMN",
              productId: teacher.id,
              imgBg: teacher.bannerImg,
            ), (result){
            });
      },
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: ThemeUtils.getViewBgColor(context),
                width: ScreenUtil.getScreenW(context),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  teacher.title,
                  style: TextStyles.textSize16,
                  maxLines: 1,
                ),
              ),
              LoadImage(
                teacher.bannerImg,
                width: ScreenUtil.getScreenW(context),
                height: ScreenUtil.getScreenW(context)/2.5,
              ),
              Container(
                color: ThemeUtils.getViewBgColor(context),
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Gaps.hGap4,
                    Image(
                      image: ImageUtils.getAssetImage("teacher/read"),
                      width: 12,
                      height: 12,
                    ),
                    Gaps.hGap4,
                    Text(
                      teacher.hits.toString(),
                      style: TextStyle(fontSize: Dimens.font_sp10,color: Theme.of(context).textTheme.subtitle.color),
                    ),
                    Gaps.hGap8,
                    Image(
                      image: ImageUtils.getAssetImage("teacher/zan"),
                      width: 12,
                      height: 12,
                    ),
                    Gaps.hGap4,
                    Text(
                      teacher.likes.toString(),
                      style: TextStyle(fontSize: Dimens.font_sp10,color: Theme.of(context).textTheme.subtitle.color),
                    ),
                    Gaps.hGap8,
                    Image(
                      image: ImageUtils.getAssetImage("teacher/collection"),
                      width: 12,
                      height: 12,
                    ),
                    Gaps.hGap4,
                    Text(
                      teacher.collects.toString(),
                      style: TextStyle(fontSize: Dimens.font_sp10,color: Theme.of(context).textTheme.subtitle.color),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10.0,
                color: ThemeUtils.getBackgroundColor(context),
              )
            ],
          ),
          Positioned(
            right: 8,
            top: 20,
            child: Image(
              image: ImageUtils.getAssetImage((teacher.activeState == 1) ? "teacher/tuan" : (teacher.activeState == 2) ? "teacher/kan" : ""),
              width: 35,
              height: 35,
            ),
          ),
        ],
      ),
    );
  }
}
