import 'package:flutter/material.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/styles.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/click_item.dart';

class CouponSelect extends StatefulWidget {

  CouponSelect({
    Key key,
  }) : super(key : key);

  @override
  _CouponSelectState createState() => _CouponSelectState();
}

class _CouponSelectState extends State<CouponSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(//创建透明层
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      // 键盘弹出收起动画过渡
      body: AnimatedContainer(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInCubic,
        child: Container(
            decoration: BoxDecoration(
              color: ThemeUtils.getDialogBackgroundColor(context),
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: 270.0,
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "优惠卷",
                      style: TextStyles.textBold18,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      ClickItem(
                        imgStr: "mine/applyclass",
                        title: "支付宝",
                      ),
                      ClickItem(
                        imgStr: "mine/applyclass",
                        title: "支付宝",
                      ),
                      ClickItem(
                        imgStr: "mine/applyclass",
                        title: "支付宝",
                      )
                    ],
                  ),
                ),
//                Gaps.vGap8,
//                Gaps.line,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 48.0,
                        child: FlatButton(
                          child: const Text(
                            "取消",
                            style: TextStyle(
                                fontSize: Dimens.font_sp18
                            ),
                          ),
                          textColor: Colours.text_gray,
                          onPressed: (){
//                            NavigatorUtils.goBack(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 48.0,
                      width: 0.6,
                      child: const VerticalDivider(),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 48.0,
                        child: FlatButton(
                          child: const Text(
                            "确定",
                            style: TextStyle(
                                fontSize: Dimens.font_sp18
                            ),
                          ),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: (){
//                            onPressed();
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
}
