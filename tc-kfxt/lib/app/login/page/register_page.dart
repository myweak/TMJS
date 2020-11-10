
import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:school/app/tab/tab_navigator.dart';
import 'package:school/common/common.dart';
import 'package:school/model/user.dart';
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
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/page_route_anim.dart';
import 'package:school/widgets/text_field.dart';

/// design/1注册登录/index.html
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _rePwdController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  bool isAgreenment = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = SpUtil.getString(Constant.phone);
  }
  
  Future<void> _login() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String name = _nameController.text;
    String code = _codeController.text;
    String pwd = _pwdController.text;
    String rePwd = _rePwdController.text;

    if (name.isEmpty || name.length < 11) {
      Toast.show("请输入正确的手机号");
      return;
    }
    if (code.isEmpty || code.length < 6) {
      Toast.show("请输入正确的验证码");
      return;
    }
    if (pwd.isEmpty || pwd.length < 6) {
      Toast.show("请输入密码,且密码不能少于6位");
      return;
    }
    if (rePwd.isEmpty || rePwd.length < 6) {
      Toast.show("请输入确认密码,且密码不能少于6位");
      return;
    }
    if (rePwd != pwd) {
      Toast.show("两次输入的密码不一致");
      return;
    }
    if(!isAgreenment){
//      closeLoad(context);
      Toast.show("请同意仁仁德康复平台用户协议");
      return;
    }

    String pwdBase64 = encodeBase64(_pwdController.text);
    try {
      bool isRegisterSuccess = await AppRepository.fetchRegister(name, pwdBase64 ,code);
      if(isRegisterSuccess){
        Toast.show("注册成功");
        NavigatorUtils.goBack(context);
      }else{
        Toast.show("注册失败");
      }
    } catch (e) {
      Toast.show(e.error.message);
    }
  }

  static String encodeBase64(String data){
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefAppBar(
        centerTitle: "注册",
      ),
      body: defaultTargetPlatform == TargetPlatform.iOS ? FormKeyboardActions(
        child: _buildBody(),
      ) : SingleChildScrollView(
        child: _buildBody(),
      ) 
    );
  }

  Widget buildAgree(){
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            if(this.mounted){
              setState(() {
                isAgreenment = !isAgreenment;
              });
            }
          },
          child: LoadAssetImage(isAgreenment?'login/agree':'login/noagree',width: 16,height: 16,),
        ),
        SizedBox(width: 5),
        Text(
          '我已阅读并同意遵守',
          style: TextStyle(fontSize: 10),
        ),
        GestureDetector(
          onTap: (){
//            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => WebViewPage(Api.USER_AGREEMENT,"用户协议")));
          },
          child: Text(
            '《仁仁德康复平台用户协议》',
            style: TextStyle(fontSize: 10,color: Color(0XFF1AB27A)),
          ),
        ),
      ],
    );
  }
  
  _buildBody(){
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Gaps.vGap15,
          MyTextField(
            key: const Key('phone'),
            keyName: 'phone',
            focusNode: _nodeText1,
            config: Utils.getKeyboardActionsConfig(context, [_nodeText1, _nodeText2,_nodeText3,_nodeText4]),
            controller: _nameController,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            hintText: "请输入手机号",
          ),
          Gaps.vGap15,
          MyTextField(
            key: const Key('code'),
            keyName: 'code',
            focusNode: _nodeText2,
            controller: _codeController,
            keyboardType: TextInputType.phone,
            maxLength: 6,
            hintText: "请输入验证码",
            getVCode: () async{
              if (_nameController.text.length == 11){
                String name = _nameController.text;
                try {
                  bool isSendSuccess = await AppRepository.fetchGetCode(name, "REGISTER");
                  if(isSendSuccess){
                    Toast.show("获取成功");
                    return true;
                  }else{
                    Toast.show("获取失败");
                    return false;
                  }
                } catch (e) {
                  Toast.show(e.error.message);
                  return false;
                }
              }else{
                Toast.show("请输入正确的手机号");
                return false;
              }
            },
          ),
          Gaps.vGap15,
          MyTextField(
            key: const Key('password'),
            keyName: 'password',
            focusNode: _nodeText3,
            isInputPwd: true,
            controller: _pwdController,
            keyboardType: TextInputType.visiblePassword,
            maxLength: 20,
            hintText: "请输入密码",
          ),
          Gaps.vGap15,
          MyTextField(
            key: const Key('repassword'),
            keyName: 'repassword',
            focusNode: _nodeText4,
            isInputPwd: true,
            controller: _rePwdController,
            keyboardType: TextInputType.visiblePassword,
            maxLength: 20,
            hintText: "请输入确认密码",
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
                '同意协议并注册',
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
    _codeController.dispose();
    _pwdController.dispose();
    _rePwdController.dispose();
    super.dispose();
  }

}
