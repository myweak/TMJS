import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:school/app/tab/tab_navigator.dart';
import 'package:school/common/common.dart';
import 'package:school/common/webView_page.dart';
import 'package:school/model/user.dart';
import 'package:school/net/app_api.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/util/storage_utils.dart';
import 'package:school/util/toast.dart';
import 'package:school/util/utils.dart';
import 'package:school/view_model/login_model.dart';
import 'package:school/view_model/user_model.dart';
import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/page_route_anim.dart';
import 'package:school/widgets/text_field.dart';

/// design/1注册登录/index.html
/// design/1注册登录/index.html
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool isCodeLogin = false;
  bool isAgreenment = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = SpUtil.getString(Constant.phone);
  }

  Future<void> _login() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String name = _nameController.text;
    String password = _passwordController.text;

    if (name.isEmpty || name.length < 11) {
      Toast.show("请输入正确的手机号");
      return;
    }
    if (password.isEmpty || password.length < 6) {
      Toast.show(isCodeLogin ? "请输入正确的验证码" : "请输入正确的密码");
      return;
    }
    if (!isAgreenment) {
      Toast.show("请同意仁仁德康复平台用户协议");
      return;
    }

    String pwd = isCodeLogin
        ? _passwordController.text
        : encodeBase64(_passwordController.text);

    try {
      User user = await AppRepository.fetchLogin(
          isCodeLogin ? "code" : "password", name, pwd);
      SpUtil.putString(Constant.phone, user.phone);
      SpUtil.putString(Constant.name, user.name);
      SpUtil.putInt(Constant.userid, user.id);
      SpUtil.putString(Constant.headimg, user.headimg);
      SpUtil.putInt(Constant.status, user.status);
      NavigatorUtils.push(context, Routes.tab, clearStack: true);
    } catch (e) {
      Toast.show(e.error.message);
      print('-------' + e.error.message);
    }
  }

  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: defaultTargetPlatform == TargetPlatform.iOS
            ? FormKeyboardActions(
                child: _buildBody(),
              )
            : SingleChildScrollView(
                child: _buildBody(),
              ));
  }

  Widget buildChangeLogin() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _passwordController.value = new TextEditingValue(text: "");
        if (this.mounted) {
          setState(() {
            isCodeLogin = !isCodeLogin;
          });
        }
        _nameController.value =
            new TextEditingValue(text: SpUtil.getString("loginphone"));
      },
      child: Text(
        isCodeLogin ? '手机密码登录' : '手机验证码登录',
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget buildRegister() {
    return Container(
      height: 30,
      width: 60,
      alignment: Alignment.centerRight,
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          NavigatorUtils.push(context, Routes.register);
        },
        child: Text(
          "注册",
          style: TextStyle(
              fontSize: Dimens.font_sp14,
              color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget buildAgree() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (this.mounted) {
              setState(() {
                isAgreenment = !isAgreenment;
              });
            }
          },
          child: LoadAssetImage(
            isAgreenment ? 'login/agree' : 'login/noagree',
            width: 16,
            height: 16,
          ),
        ),
        SizedBox(width: 5),
        Text(
          '我已阅读并同意遵守',
          style: TextStyle(fontSize: 10),
        ),
        Container(
          color: Colors.white,
          height: 30,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) =>
                      WebViewPage(Api().user_agreement, "用户协议")));
            },
            child: Center(
              child: Text(
                '《仁仁德康复平台用户协议》',
                style: TextStyle(fontSize: 10, color: Color(0XFF1AB27A)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: ScreenUtil.getStatusBarH(context) + 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoadImage(
            "login/logo",
            height: 150.0,
          ),
          Gaps.vGap16,
          MyTextField(
            key: const Key('phone'),
            focusNode: _nodeText1,
            controller: _nameController,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            hintText: "请输入手机号",
          ),
          Gaps.vGap15,
          Offstage(
            offstage: !isCodeLogin,
            child: MyTextField(
              key: const Key('code'),
              keyName: 'code',
              focusNode: _nodeText2,
              config: Utils.getKeyboardActionsConfig(
                  context, [_nodeText1, _nodeText2]),
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              maxLength: 6,
              hintText: "请输入验证码",
              getVCode: () async {
                if (_nameController.text.length == 11) {
                  String name = _nameController.text;
                  try {
                    bool isSendSuccess =
                        await AppRepository.fetchGetCode(name, "LOGIN");
                    if (isSendSuccess) {
                      Toast.show("获取成功");
                      return true;
                    } else {
                      Toast.show("获取失败");
                      return false;
                    }
                  } catch (e) {
                    Toast.show(e.error.message);
                    return false;
                  }
                } else {
                  Toast.show("请输入正确的手机号");
                  return false;
                }
              },
            ),
          ),
          Offstage(
            offstage: isCodeLogin,
            child: MyTextField(
              key: const Key('password'),
              keyName: 'password',
              focusNode: _nodeText2,
              config: Utils.getKeyboardActionsConfig(
                  context, [_nodeText1, _nodeText2]),
              isInputPwd: true,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              maxLength: 20,
              hintText: "请输入密码",
              goToPage: () {
                NavigatorUtils.push(context, Routes.forgetPwd);
                return;
              },
            ),
          ),
          Gaps.vGap15,
          Gaps.vGap15,
          Container(
            child: Row(
              children: <Widget>[
                buildChangeLogin(),
                Expanded(child: Container()),
                buildRegister(),
              ],
            ),
          ),
          Gaps.vGap15,
          Gaps.vGap15,
          buildAgree(),
          Gaps.vGap15,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor,
            ),
            height: 40,
            child: FlatButton(
              onPressed: _login,
              child: Text(
                '登录',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
