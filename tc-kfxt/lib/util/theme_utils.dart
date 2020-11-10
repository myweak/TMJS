import 'package:flutter/material.dart';
import 'package:school/res/colors.dart';

class ThemeUtils {
  static bool isDark(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getDarkColor(BuildContext context, Color darkColor){
    return isDark(context) ? darkColor : null;
  }

  static Color getIconColor(BuildContext context){
    return isDark(context) ? Colours.dark_text : null;
  }

  static Color getBackgroundColor(BuildContext context){
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getDialogBackgroundColor(BuildContext context){
    return Theme.of(context).canvasColor;
  }

//  static Color getBgGrayColor(BuildContext context){
//    return isDark(context) ? Colours.dark_bg_gray_ : Colours.bg_gray_;
//  }
  static Color getViewBgColor(BuildContext context){
    return isDark(context) ? Colours.dark_bg_gray_ : Colors.white;
  }

  static Color getDialogTextFieldColor(BuildContext context){
    return isDark(context) ? Colours.dark_bg_gray_ : Colours.bg_gray;
  }

  static Color getKeyboardActionsColor(BuildContext context){
    return isDark(context) ? Colours.dark_bg_color : Colors.grey[200];
  }

  static Color getGrayColor(BuildContext context){
    return isDark(context) ? Colours.text : Colours.text_gray;
  }
}