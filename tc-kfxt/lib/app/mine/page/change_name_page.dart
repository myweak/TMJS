import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/common/common.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/util/toast.dart';
import 'package:school/widgets/app_bar.dart';

class ChangeNamePage extends StatefulWidget {

  ChangeNamePage({
    Key key,
    @required this.title,
    this.content,
    this.hintText,
    this.keyboardType: TextInputType.text,
  }) : super(key : key);

  final String title;
  final String content;
  final String hintText;
  final TextInputType keyboardType;

  @override
  _ChangeNamePageState createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefAppBar(
        centerTitle: "设置昵称",
        actionName: "保存",
        onPressed: () async {
          try {
            bool isUpdateSuccess = await AppRepository.fetchUpdateUserInfo(_controller.text);
            if(isUpdateSuccess){
              Toast.show("修改成功");
              SpUtil.putString(Constant.name, _controller.text);
              NavigatorUtils.goBackWithParams(context, _controller.text);
              return true;
            }else{
              Toast.show("修改失败");
              return false;
            }
          } catch (e) {
            Toast.show(e.error.message);
            return false;
          }
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          color: ThemeUtils.getViewBgColor(context),
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: TextField(
              maxLength: 10,
              maxLines: 1,
              autofocus: true,
              controller: _controller,
              keyboardType: widget.keyboardType,
              //style: TextStyles.textDark14,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                //hintStyle: TextStyles.textGrayC14
              )
          ),
        ),
      ),
    );
  }
}
