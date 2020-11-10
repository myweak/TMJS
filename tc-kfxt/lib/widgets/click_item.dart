
import 'package:flutter/material.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/load_image.dart';

class ClickItem extends StatelessWidget {

  const ClickItem({
    Key key,
    this.onTap,
    @required this.title,
    this.imgStr: "",
    this.content: "",
    this.textAlign: TextAlign.start,
    this.maxLines: 1
  }): super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String imgStr;
  final String content;
  final TextAlign textAlign;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        constraints: BoxConstraints(
            maxHeight: double.infinity,
            minHeight: 50.0
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            color: ThemeUtils.getViewBgColor(context),
            border: Border(
              bottom: Divider.createBorderSide(context, width: 0.6),
            )
        ),
        child: Row(
          //为了数字类文字居中
          crossAxisAlignment: maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Offstage(
              offstage: imgStr.length<=0,
              child: Padding(
                padding: EdgeInsets.only(left: 5.0,right: 15.0),
                child: LoadImage(imgStr,width: 16.0,height: 16.0),
              )
            ),
            Text(
              title,
              style: TextStyle(fontSize: Dimens.font_sp15),
            ),
            const Spacer(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16.0),
                child: Text(
                  content,
                  maxLines: maxLines,
                  textAlign: maxLines == 1 ? TextAlign.right : textAlign,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: Dimens.font_sp14)
                ),
              ),
            ),
            Opacity(
              // 无点击事件时，隐藏箭头图标
              opacity: onTap == null ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
                child: LoadImage("ic_arrow_right",width: 16.0,height: 16.0,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
