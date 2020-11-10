import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/app/mine/page/change_name_page.dart';
import 'package:school/app/mine/view/exit_dialog.dart';
import 'package:school/common/common.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/click_item.dart';
import 'package:school/widgets/load_image.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _nickName = SpUtil.getString(Constant.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefAppBar(
        centerTitle: "设置",
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClickItem(
                      title: "头像",
                      onTap: (){}
                  ),
                  Positioned(
                    right: 40.0,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).dividerColor,
                      backgroundImage: ImageUtils.getImageProvider(SpUtil.getString(Constant.headimg),holderImg: ""),
                    ),
                  )
                ],
              ),
              ClickItem(
                  title: "昵称",
                  content: _nickName.length<=0 ? "请输入昵称" : _nickName,
                  onTap: (){
                    NavigatorUtils.pushResultWithParm(context,
                        ChangeNamePage(
                          title: "设置昵称",
                          hintText: "请输入昵称…",
                          content: _nickName,
                        ), (result){
                          setState(() {
                            _nickName =result.toString();
                          });
                        });
                  }
              ),
              ClickItem(
                  title: "修改密码",
                  onTap: (){}
              ),
              Gaps.vGap10,
              ClickItem(
                  title: "清除缓存",
                  content: "15.2MB",
                  onTap: (){}
              ),
              ClickItem(
                  title: "关于我们",
                  onTap: (){}
              ),
              ClickItem(
                  title: "当前版本",
                  content: "3.0.0",
                  onTap: (){}
              ),
              Gaps.vGap10,
              Container(
                width: ScreenUtil.getScreenW(context),
                height: 45.0,
                child: FlatButton(
                  color: ThemeUtils.getViewBgColor(context),
                  onPressed: (){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => ExitDialog()
                    );
                  },
                  child: Text(
                    "退出登陆",
                    style: TextStyle(fontSize: Dimens.font_sp15,color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
