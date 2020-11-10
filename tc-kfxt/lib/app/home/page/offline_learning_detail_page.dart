import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:school/model/offline_study.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/photo_view_simple.dart';

class OfflineLearningDetailPage extends StatefulWidget {
  
  final OfflineStudy offlineStudy;
  OfflineLearningDetailPage({this.offlineStudy});

  @override
  _OfflineLearningDetailState createState() => _OfflineLearningDetailState();
}

class _OfflineLearningDetailState extends State<OfflineLearningDetailPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ThemeUtils.getViewBgColor(context),
      appBar: DefAppBar(
        centerTitle: "线下进修",
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: LoadImage(widget.offlineStudy.bannerImg,width: ScreenUtil.getScreenW(context)-20),
                        ),
                        Gaps.vGap10,
                        Text(
                          widget.offlineStudy.title,
                          style: TextStyles.textBold18,
                        ),
                        Gaps.vGap10,
                        _buildRowWidget("报名时间", widget.offlineStudy.signupStarttime.substring(0,10)+"~"+widget.offlineStudy.signupEndtime.substring(0,10)),
                        Gaps.vGap8,
                        _buildRowWidget("进修地址", widget.offlineStudy.detailAddr),
                        Gaps.vGap8,
                        _buildRowWidget("进修时间", widget.offlineStudy.studyStarttime.substring(0,10)+"~"+widget.offlineStudy.studyEndtime.substring(0,10)),
                        Gaps.vGap8,
                        _buildRowWidget("主讲人", widget.offlineStudy.teacher),
                        Gaps.vGap8,
                        _buildRowWidget("报名人数", widget.offlineStudy.signupNum.toString()+"/"+widget.offlineStudy.totalNum.toString()+"人",showPriceLabel:true ),
                        Gaps.vGap15,
                      ],
                    ),
                  ),
                  Container(
                    height: 10.0,
                    color: ThemeUtils.getDialogTextFieldColor(context),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0,right: 10.0),
                    alignment: Alignment.centerLeft,
                    height: 40,
                    child: Text(
                      "进修简介",
                      style: TextStyles.textBold16,
                    ),
                  ),
                  Html(
                    padding: EdgeInsets.only(left: 10.0,right: 10.0),
                    data: widget.offlineStudy.content,
                    useRichText: false,
                    onImageTap: (src){
                      NavigatorUtils.pushResultWithParm(context,
                          PhotoViewSimpleScreen(
                            imageProvider: CachedNetworkImageProvider(src),
                            heroTag: 'simple',
                          ), (result){
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
//            color: Theme.of(context).primaryColor,
            color: (widget.offlineStudy.signupStatus == 1)? Theme.of(context).primaryColor : (widget.offlineStudy.signupStatus == 2 ? Colors.deepOrange[200] : (widget.offlineStudy.signupStatus == 3) ? Colours.green_color : Colors.grey[300]),
            width: ScreenUtil.getScreenW(context),
            height: 50.0,
            child: FlatButton(
              child: Text(
                (widget.offlineStudy.signupStatus == 1)? "即将开始" : (widget.offlineStudy.signupStatus == 2 ? "立即报名" : (widget.offlineStudy.signupStatus == 3 ? "报名结束" : "活动结束")) ,
                style: TextStyle(
                  color: (widget.offlineStudy.signupStatus == 4)? Theme.of(context).textTheme.subtitle.color : Colors.white ,
                  fontSize: Dimens.font_sp14,
                ),
              ),
//              child: Text("${widget.offlineStudy.signupStatusName}",style: TextStyle(fontSize: Dimens.font_sp14),),
            ),
          ),
          Container(
            height: ScreenUtil.getBottomBarH(context),
          )
        ],
      ),
    );
  }

  _buildRowWidget(String title,String desc,{showPriceLabel = false}){
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: 3.0,
            height: 12.0,
          ),
          Gaps.hGap5,
          Text(
            title+":",
            style: TextStyle(fontSize: Dimens.font_sp14),
          ),
          Gaps.hGap5,
          Expanded(
            child: Text(
              desc,
              maxLines: 10,
              style: TextStyle(fontSize: Dimens.font_sp14),
              overflow: TextOverflow.clip,
            ),
          ),
          !showPriceLabel?Container():RichText(
            text: TextSpan(
              text: "报名费用: ",
              style: TextStyle(fontSize: Dimens.font_sp14,color: Theme.of(context).textTheme.body1.color),
              children: [
                TextSpan(
                    text: "¥${widget.offlineStudy.price}/人",
                    style: TextStyle(fontSize: Dimens.font_sp14,color: Theme.of(context).primaryColor)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
