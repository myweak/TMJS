
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/app/login/page/login_page.dart';
import 'package:school/common/common.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/widgets/base_dialog.dart';

class ExitDialog extends StatefulWidget{

  ExitDialog({
    Key key,
  }) : super(key : key);

  @override
  _ExitDialog createState() => _ExitDialog();
  
}

class _ExitDialog extends State<ExitDialog>{

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: "提示",
      child: const Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: const Text("您确定要退出登录吗？", style: TextStyles.textSize16),
      ),
      onPressed: (){
        SpUtil.putString(Constant.token, "");
        NavigatorUtils.push(context, Routes.login, clearStack: true);
//        NavigatorUtils.push(context, RouteName.login, clearStack: true);
//        NavigatorUtils.pushAndRemoveUntil(context, LoginPage());
      },
    );
  }
}