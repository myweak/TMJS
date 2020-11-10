import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/app/teacher/page/teacher_detail_page.dart';
import 'package:school/model/teacher.dart';
import 'package:school/model/teacher_detail.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/view_model/teacher_model.dart';
import 'package:school/widgets/load_image.dart';

class TeacherDetailItemWidget extends StatefulWidget {
  final CourseVOS courseVOS;
  final int index;
  TeacherDetailItemWidget(this.courseVOS,this.index);

  @override
  _TeacherDetailItemWidgetState createState() => _TeacherDetailItemWidgetState();
}

class _TeacherDetailItemWidgetState extends State<TeacherDetailItemWidget> {

  @override
  Widget build(BuildContext context) {
    int isCheck = Provider.of<TeacherDetailModel>(context).checkBoxList[widget.index];
    return Container(
      padding: EdgeInsets.only(left:(widget.courseVOS.bought?10.0:0.0),right: 10.0,top: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Offstage(
                offstage: widget.courseVOS.bought,
                child: Container(
                  width: 60,
                  child: Checkbox(
                    value: ((isCheck==1)?true:false),
                    onChanged: (bool val){
                      Provider.of<TeacherDetailModel>(context).setCourseVOSList(widget.index,val,widget.courseVOS);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.courseVOS.title,
                      style: TextStyle(fontSize: Dimens.font_sp14),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "单课价格: ${(widget.courseVOS.price <= 0)?"免费":widget.courseVOS.price}",
                            style: TextStyle(fontSize: Dimens.font_sp12,color: Theme.of(context).textTheme.subtitle.color),
                          ),
                          Spacer(),
                          Offstage(
                            offstage: widget.courseVOS.bought,
                            child: LoadImage("teacher/suo",width: 25,height: 25),
                          ),
                          Offstage(
                            offstage: !widget.courseVOS.bought,
                            child: Text(
                              "已经买",
                              style: TextStyle(fontSize: Dimens.font_sp12,color: Theme.of(context).textTheme.subtitle.color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10.0),
          Divider()
        ],
      ),
    );
  }
}
