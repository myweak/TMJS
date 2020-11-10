import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: ThemeUtils.isDark(context)?Colours.dark_text_gray:Colours.bg_color,
      ),
      width: ScreenUtil.getScreenW(context)-50,
      height: 34,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Gaps.hGap15,
          Image(
            image: ImageUtils.getAssetImage("search"),
            width: 12,
            height: 12,
          ),
          Gaps.hGap8,
          Text("搜索",style: TextStyle(fontSize: Dimens.font_sp14,color: ThemeUtils.isDark(context)?Colours.bg_gray:Colours.dark_bg_gray),),
        ],
      ),
    );
  }
}



class SearchTextFieldWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: ThemeUtils.isDark(context)?Colours.dark_text_gray:Colours.bg_color,
      ),
      width: ScreenUtil.getScreenW(context)-50,
      height: 34,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Gaps.hGap15,
          Image(
            image: ImageUtils.getAssetImage("search"),
            width: 12,
            height: 12,
          ),
          Gaps.hGap8,
          Text("搜索",style: TextStyle(fontSize: Dimens.font_sp14,color: ThemeUtils.isDark(context)?Colours.bg_gray:Colours.dark_bg_gray),),
        ],
      ),
    );
  }
}