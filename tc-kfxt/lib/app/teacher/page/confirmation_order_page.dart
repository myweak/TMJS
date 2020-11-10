import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/app/mine/view/exit_dialog.dart';
import 'package:school/app/teacher/view/coupon_select.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/click_item.dart';
import 'package:school/widgets/load_image.dart';

class ConfirmationOrderPage extends StatefulWidget {

  final String imgStr;
  final String titleStr;
  final double priceDou;
  ConfirmationOrderPage({this.imgStr,this.titleStr,this.priceDou});

  @override
  _ConfirmationOrderPageState createState() => _ConfirmationOrderPageState();
}

class _ConfirmationOrderPageState extends State<ConfirmationOrderPage> {

  int gopValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefAppBar(
        centerTitle: "确认订单",
      ),
      body: Container(
        color: ThemeUtils.getBackgroundColor(context),
        child: Column(
          children: <Widget>[
            classInfoView(),
            Container(
              height: 50.0,
              padding: EdgeInsets.only(left: 10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "选择支付方式",
                style: TextStyle(
                    color: Theme.of(context).textTheme.title.color,
                    fontSize: Dimens.font_sp14
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                InkWell(
                  child: ClickItem(
                    imgStr: "mine/applyclass",
                    title: "支付宝",
                  ),
                  onTap: (){
                    if(mounted){
                      setState(() {
                        this.gopValue = 1;
                      });
                    }
                  },
                ),
                Positioned(
                  right: 10.0,
                  child: Radio(value: 1, groupValue: gopValue, onChanged: (int val){
                    if(mounted){
                      setState(() {
                        this.gopValue = val;
                      });
                    }
                  }),
                )
              ],
            ),
            Stack(
              children: <Widget>[
                InkWell(
                  child: ClickItem(
                    imgStr: "mine/feedback",
                    title: "微信",
                  ),
                  onTap: (){
                    if(mounted){
                      setState(() {
                        this.gopValue = 2;
                      });
                    }
                  },
                ),
                Positioned(
                  right: 10.0,
                  child: Radio(value: 2, groupValue: gopValue, onChanged: (int val){
                    if(mounted){
                      setState(() {
                        this.gopValue = val;
                      });
                    }
                  }),
                )
              ],
            ),
            ClickItem(
                imgStr: "mine/feedback",
                title: "使用优惠卷",
                content: "不使用优惠卷",
                onTap: (){
//                  showDialog(
//                      context: context,
//                      barrierDismissible: true,
//                      builder: (_) => CouponSelect()
//                  );
                }
            ),
            Spacer(),
            payView()
          ],
        ),
      ),
    );
  }

  ///课程信息
  Widget classInfoView(){
    return Container(
      color: ThemeUtils.getViewBgColor(context),
      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 10.0),
      height: 100.0,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LoadImage(widget.imgStr,width: 110),
          ),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "为手苏七康复-关节炎",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Dimens.font_sp16,
                    color: Theme.of(context).textTheme.title.color
                  ),
                ),
                Text(
                  "永久有效",
                  style: TextStyle(
                      fontSize: Dimens.font_sp12,
                      color: Theme.of(context).textTheme.subtitle.color
                  ),
                ),
                Spacer(),
                Text(
                  "¥298",
                  style: TextStyle(
                      fontSize: Dimens.font_sp16,
                      color: Theme.of(context).primaryColor
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///支付及价格试图
  Widget payView(){
    return Container(
      width: double.infinity,
      height: 45.0,
      color: ThemeUtils.getViewBgColor(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "已减¥0",
                style: TextStyle(
                    fontSize: Dimens.font_sp10,
                    color: Theme.of(context).textTheme.subtitle.color
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
//            child: Text("总金额 ¥298",style: TextStyle(color: Theme.of(context).primaryColor),),
            child: RichText(
              text: TextSpan(
                text: "总金额: ",
                style: TextStyle(color: Theme.of(context).textTheme.title.color,fontSize: Dimens.font_sp14),
                children: <TextSpan>[
                  TextSpan(
                      text: "¥${widget.priceDou}",
                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: Dimens.font_sp14),
                  )
                ]
              ),
            ),
          ),
          Container(
            width: ScreenUtil.getScreenW(context)*0.4,
            color: Theme.of(context).primaryColor,
            child: FlatButton(
              child: Text("去支付",style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp14),),
              onPressed: (){
              },
            ),
          )
        ],
      ),
    );
  }
}
