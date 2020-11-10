import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:school/util/theme_utils.dart';

class Utils {
  static KeyboardActionsConfig getKeyboardActionsConfig(BuildContext context, List<FocusNode> list){
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
//      keyboardBarColor: ThemeUtils.getKeyboardActionsColor(context),
      keyboardBarColor: ThemeUtils.getBackgroundColor(context),
      nextFocus: true,
      actions: List.generate(list.length, (i) => KeyboardAction(
        focusNode: list[i],
        closeWidget: const Padding(
          padding: const EdgeInsets.all(5.0),
          child: const Text("关闭"),
        ),
      )),
    );
  }

  //判断是否为空
  static bool isEmpty(dynamic value) {
    if((null == value) || value.isEmpty){
      return true;
    }
    return false;
  }


}