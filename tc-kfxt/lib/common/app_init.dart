import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AppUtilInit {
  // 屏幕设配初始化
  static screenUtilInit(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 667, allowFontScaling: false);
  }
}
