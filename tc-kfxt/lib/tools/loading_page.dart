import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:school/util/toast.dart';

class LoadingPage {
  LoadingPage() {
    //每次的默认值
    /// [showSuccess] [showError] [showInfo]的展示时间, 默认2000ms.
// Duration displayDuration;
    // EasyLoading.instance.displayDuration = Duration(milliseconds: 3000);
  }

  static show({String status}) {
    EasyLoading.show(status: status);
  }

  static showToast({String toast}) {
    EasyLoading.showToast(toast);
  }

  static showProgress(
    double value, {
    String status,
  }) {
    EasyLoading.showProgress(value, status: status);
  }

  static showSuccess({String success}) {
    EasyLoading.showSuccess(success);
  }

  static showError({String error}) {
    EasyLoading.showError(error);
  }

  static showInfo({String info}) {
    EasyLoading.showInfo(info);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }
}

int flag = 0;

///打开loading
void showLoad(BuildContext context, {bool isTap = false}) {
  showDialog(
    context: context,
    barrierDismissible: isTap,
    builder: (context) {
      return SpinKitFadingCircle(
        color: Colors.white,
      );
    },
  ).then((value) {
    closeLoad(value);
  });
}

///关闭loading
void closeLoad(BuildContext context) {
  Navigator.of(context).pop();
}

//简单的SimpleDialog
void showMyMaterialDialog(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              child: new Text("确认"),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              child: new Text("取消"),
            ),
          ],
        );
      });
}

//IOS风格的AlertDialog
void showMyCupertinoDialog(BuildContext context, String title, String content) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return new CupertinoAlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop("点击了确定");
              },
              child: new Text("确定"),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop("点击了取消");
              },
              child: new Text("取消"),
            ),
          ],
        );
      });
}

//弹出"版本更新"对话框
void showNewVersionAppDialogs(BuildContext context) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("这是一个iOS风格的对话框"),
          content: SizedBox(
            height: 100.0,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("第1行"),
                  Text("第2行"),
                  Text("第3行"),
                  Text("第4行"),
                  Text("第5行"),
                  Text("第6行"),
                  Text("第7行"),
                  Text("第8行"),
                  Text("第9行"),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
                print("取消");
              },
            ),
            CupertinoDialogAction(
              child: Text("确定"),
              onPressed: () {
                print("确定");
              },
            ),
          ],
        );
      });
}
