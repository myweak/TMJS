import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:school/app/mine/page/change_name_page.dart';
import 'package:school/app/mine/view/exit_dialog.dart';
import 'package:school/common/common.dart';
import 'package:school/model/apply_class.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/util/utils.dart';
import 'package:school/view_model/mine_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/app_indicator.dart';
import 'package:school/widgets/click_item.dart';
import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/text_field_item.dart';

class ApplyClassPage extends StatefulWidget {
  @override
  _ApplyClassPageState createState() => _ApplyClassPageState();
}

class _ApplyClassPageState extends State<ApplyClassPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _skillController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();
  ApplyClass applyClass;

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ApplyClassModel>(
      model: ApplyClassModel(),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if(model.busy) {
          return AppIndicator(title: "申请开课");
        }
        _nameController = TextEditingController(text: model.applyClass.name);
        _hospitalController = TextEditingController(text: model.applyClass.hospitalName);
        _positionController = TextEditingController(text: model.applyClass.jobTitle);
        _skillController = TextEditingController(text: model.applyClass.expertise);
        _phoneController = TextEditingController(text: model.applyClass.contact);
//        _remarkController = TextEditingController(text: model.applyClass.name);

        return Scaffold(
            appBar: DefAppBar(
              centerTitle: "申请开课",
            ),
            body: defaultTargetPlatform == TargetPlatform.iOS ? FormKeyboardActions(
              child: _buildBody(),
            ) : SingleChildScrollView(
              child: _buildBody(),
            )
        );
      },
    );
  }

  _buildBody(){
    return Container(
      child: Column(
        children: <Widget>[
          LoadAssetImage("mine/applyclassbanner",width: ScreenUtil.getScreenW(context),height: ScreenUtil.getScreenW(context)*0.4),
          Gaps.vGap15,
          TextFieldItem(
            title: "姓名",
            hintText: "请输入姓名",
            controller: _nameController,
            focusNode: _nodeText1,
              config: Utils.getKeyboardActionsConfig(context, [_nodeText1, _nodeText2,_nodeText3, _nodeText4,_nodeText5, _nodeText6]),
          ),
          TextFieldItem(
            title: "医院",
            hintText: "请输入医院名称",
            controller: _hospitalController,
            focusNode: _nodeText2,
          ),
          TextFieldItem(
            title: "职称",
            hintText: "请输入职称",
            controller: _positionController,
            focusNode: _nodeText3,
          ),
          TextFieldItem(
            title: "擅长领域",
            hintText: "请输入您擅长的领域",
            controller: _skillController,
            focusNode: _nodeText4,
          ),
          TextFieldItem(
            title: "联系电话",
            hintText: "请输入您的联系电话",
            controller: _phoneController,
            focusNode: _nodeText5,
            keyboardType: TextInputType.phone,
          ),
          Gaps.vGap10,
          Container(
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "备注",
              style: TextStyle(fontSize: Dimens.font_sp18),
            ),
          ),
          Gaps.vGap10,
          Container(
            color: ThemeUtils.getViewBgColor(context),
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextField(
                maxLength: 200,
                maxLines: 5,
                controller: _remarkController,
                focusNode: _nodeText6,
                decoration: InputDecoration(
                  hintText: "请输入备注",
                  border: InputBorder.none,
                  //hintStyle: TextStyles.textGrayC14
                )
            ),
          ),
        ],
      ),
    );
  }
}
