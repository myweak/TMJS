import 'package:flutter_screenutil/screenutil.dart';

lxWidth(double value) {
  return ScreenUtil().setWidth(value);
}

lxHeight(double value) {
  return ScreenUtil().setHeight(value);
}

screenWidth() {
  return ScreenUtil.screenWidth; //设备宽度
}

screenHeight() {
  return ScreenUtil.screenHeight; //设备高度
}

bottomBarHeight() {
  return ScreenUtil.bottomBarHeight; //底部安全区距离，适用于全面屏下面有按键的
}

statusBarHeight() {
  return ScreenUtil.statusBarHeight; //状态栏高度 刘海屏会更高  单位px
}
