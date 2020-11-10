
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:school/res/gaps.dart';
import 'package:school/util/theme_utils.dart';

/// 封装输入框
class TextFieldItem extends StatelessWidget {

  const TextFieldItem({
    Key key,
    this.controller,
    @required this.title,
    this.keyboardType: TextInputType.text,
    this.hintText: "",
    this.focusNode,
    this.config
  }): super(key: key);

  final TextEditingController controller;
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final KeyboardActionsConfig config;

  @override
  Widget build(BuildContext context) {
    if (config != null && defaultTargetPlatform == TargetPlatform.iOS){
      // 因Android平台输入法兼容问题，所以只配置IOS平台
      FormKeyboardActions.setKeyboardActions(context, config);
    }
    return Container(
      height: 50.0,
      padding:  const EdgeInsets.only(left: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ThemeUtils.getViewBgColor(context),
          border: Border(
            bottom: Divider.createBorderSide(context, width: 0.6),
          )
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 90,
            child: Text(title),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              focusNode: focusNode,
              keyboardType: keyboardType,
              inputFormatters: _getInputFormatters(),
              controller: controller,
              //style: TextStyles.textDark14,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none, //去掉下划线
                //hintStyle: TextStyles.textGrayC14
              )
            ),
          ),
          Gaps.hGap16
        ],
      ),
    );
  }

  _getInputFormatters(){
//    if (keyboardType == TextInputType.numberWithOptions(decimal: true)){
//      return [UsNumberTextInputFormatter()];
//    }
    if (keyboardType == TextInputType.number || keyboardType == TextInputType.phone){
      return [WhitelistingTextInputFormatter.digitsOnly];
    }
    return null;
  }
}
