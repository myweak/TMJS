import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/app/teacher/page/teacher_detail_page.dart';
import 'package:school/common/common.dart';
import 'package:school/model/teacher.dart';
import 'package:school/model/teacher_detail.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/load_image.dart';

class TeacherRulesItemWidget extends StatelessWidget {

  final CourseVOS courseVOS;
  TeacherRulesItemWidget(this.courseVOS);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Gaps.hGap10,
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Theme.of(context).dividerColor,
//                    backgroundImage: ImageUtils.getImageProvider(SpUtil.getString(Constant.headimg),holderImg: ""),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("186****9477",style: TextStyle(fontSize: Dimens.font_sp10,color: Theme.of(context).textTheme.title.color),maxLines: 1,),
                        Text("还差1人，距结束 12:09:10",style: TextStyle(fontSize: Dimens.font_sp12,color: Theme.of(context).textTheme.subtitle.color),maxLines: 1),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: 25,
                  child: FlatButton(
                    onPressed: (){

                    },
                    color: Theme.of(context).primaryColor,
                    child: Text("立即拼团",style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 25.0,
            top: 5.0,
            bottom: 5.0,
            child: Center(
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Theme.of(context).dividerColor,
                backgroundImage: ImageUtils.getImageProvider(SpUtil.getString(Constant.headimg),holderImg: ""),
              ),
            ),
          )
        ],
      ),
    );
  }
}
