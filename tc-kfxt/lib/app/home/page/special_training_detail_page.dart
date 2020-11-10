import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:school/app/home/page/list_comment_page.dart';
import 'package:school/app/home/view/list_comment_item.dart';
import 'package:school/app/home/view/special_training_item.dart';
import 'package:school/app/teacher/view/teacher_item.dart';
import 'package:school/model/list_comment.dart';
import 'package:school/model/special_training.dart';
import 'package:school/model/teacher.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/provider/view_state_widget.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/util/toast.dart';
import 'package:school/util/utils.dart';
import 'package:school/view_model/list_comment_model.dart';
import 'package:school/view_model/recommend_model.dart';
import 'package:school/view_model/special_training_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/app_indicator.dart';
import 'dart:convert' as convert;

import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/photo_view_simple.dart';

class SpecialTrainingDetailPage extends StatefulWidget {
  final String type;
  final int productId;
  SpecialTrainingDetailPage({this.type,this.productId});

  @override
  _SpecialTrainingDetailPageState createState() => _SpecialTrainingDetailPageState();
}

class _SpecialTrainingDetailPageState extends State<SpecialTrainingDetailPage> with AutomaticKeepAliveClientMixin{

  FocusNode _commentFocus = FocusNode();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: ThemeUtils.getViewBgColor(context),
        appBar: DefAppBar(
          centerTitle: (widget.type == "SPECIAL")?"专项培训":"病例教程",
        ),
        body: ProviderWidget3<SpecialTrainingDetailModel,RecommendModel,ListCommentModel>(
          model1: SpecialTrainingDetailModel(type: widget.type),
          model2: RecommendModel(type: widget.type,currentId: widget.productId),
          model3: ListCommentModel(type: widget.type,currentId: widget.productId),
          onModelReady: (specialTrainingDetailModel,reCommendModel,listCommentModel) {
            specialTrainingDetailModel.initData(widget.productId);
            specialTrainingDetailModel.setParentId(0);
            specialTrainingDetailModel.setParentName("发表评论...");

            reCommendModel.initData();
            listCommentModel.initData();
          },
          builder: (context, specialTrainingDetailModel,reCommendModel,listCommentModel, child) {
            if (specialTrainingDetailModel.busy) {
              return AppIndicatorNoBar();
            } else if (specialTrainingDetailModel.error && specialTrainingDetailModel.specialTrainingDetail == null) {
              return ViewStateErrorWidget(
                  error: specialTrainingDetailModel.viewStateError, onPressed: specialTrainingDetailModel.initData(widget.productId));
            } else if (specialTrainingDetailModel.empty) {
              return ViewStateEmptyWidget(onPressed: specialTrainingDetailModel.initData(widget.productId));
            } else if (specialTrainingDetailModel.unAuthorized){
              return ViewStateUnAuthWidget(onPressed: () async {
                NavigatorUtils.push(context, Routes.login,clearStack: true);
              });
            }

            if(widget.type == "SPECIAL"){
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Provider.of<SpecialTrainingDetailModel>(context).setParentName("发表评论...");
                  Provider.of<SpecialTrainingDetailModel>(context).setParentId(0);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: ThemeUtils.getViewBgColor(context),
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${specialTrainingDetailModel.specialTrainingDetail.title}",
                                    style: TextStyles.textBold18,
                                  ),
                                  Gaps.vGap10,
                                  Text(
                                    "${specialTrainingDetailModel.specialTrainingDetail.createTime}",
                                    style: TextStyles.textSize12,
                                  ),
                                  Gaps.vGap10,
                                  Text(
                                    "${specialTrainingDetailModel.specialTrainingDetail.contentAbstract}",
                                    style: TextStyles.textSize12,
                                  ),
                                  Html(
                                    data: specialTrainingDetailModel.specialTrainingDetail.content,
                                    useRichText: true,
                                    onImageTap: (src){
                                      NavigatorUtils.pushResultWithParm(context,
                                          PhotoViewSimpleScreen(
                                            imageProvider: CachedNetworkImageProvider(src),
                                            heroTag: 'simple',
                                          ), (result){
                                          });
                                    },
                                  ),
//                                  Text(
//                                    "${specialTrainingDetailModel.specialTrainingDetail.createTime}",
//                                    style: TextStyles.textSize12,
//                                  ),
                                  _bottomTip()
                                ],
                              ),
                            ),
                            _recommandAndEvaluate(reCommendModel,listCommentModel),
                          ],
                        ),
                      ),
                    ),
                    Gaps.line,
                    BuildCommentView(listCommentModel,specialTrainingDetailModel.specialTrainingDetail.collectionStatus,widget.productId,widget.type,_commentFocus),
                    Container(
                      height: ScreenUtil.getBottomBarH(context),
                    )
                  ],
                ),
              );
            }else {

              var caseEvaluationList;
              if(specialTrainingDetailModel?.specialTrainingDetail?.caseEvaluation == null){
                caseEvaluationList = new CaseEvaluation();
              }else {
                Map<String, dynamic> caseEvaluationMap = convert.jsonDecode(specialTrainingDetailModel?.specialTrainingDetail?.caseEvaluation);
                caseEvaluationList = new CaseEvaluation.fromJson(caseEvaluationMap);
              }

              var recoveryList;
              if(specialTrainingDetailModel?.specialTrainingDetail?.recovery == null){
                recoveryList = new CaseEvaluation();
              }else {
                Map<String, dynamic> caseEvaluationMap = convert.jsonDecode(specialTrainingDetailModel?.specialTrainingDetail?.recovery);
                recoveryList = new CaseEvaluation.fromJson(caseEvaluationMap);
              }
              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Provider.of<SpecialTrainingDetailModel>(context).setParentName("发表评论...");
                    Provider.of<SpecialTrainingDetailModel>(context).setParentId(0);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: DefaultTabController(
                      length: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${specialTrainingDetailModel.specialTrainingDetail.title}",
                                    style: TextStyles.textBold18,
                                  ),
                                  Gaps.vGap10,
                                  Text(
                                    "${specialTrainingDetailModel.specialTrainingDetail.createTime}",
                                    style: TextStyles.textSize12,
                                  ),
                                  Gaps.vGap10,
                                  Text(
                                    "${specialTrainingDetailModel.specialTrainingDetail.contentAbstract}",
                                    style: TextStyles.textSize12,
                                  ),
                                  Gaps.vGap10,
                                  Container(
                                    width: ScreenUtil.getScreenW(context),
                                    color: ThemeUtils.getViewBgColor(context),
                                    child: TabBar(
                                      labelColor: Theme.of(context).primaryColor,
                                      unselectedLabelColor: ThemeUtils.isDark(context) ? Colours.text_gray : Colours.text,
                                      indicatorWeight: 1,
                                      isScrollable: true,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicatorPadding: EdgeInsets.only(bottom: 5.0),
                                      labelStyle: TextStyle(fontSize: 14),
                                      tabs: <Widget>[
                                        Tab(text: '病情特点'),
                                        Tab(text: '评论详情'),
                                        Tab(text: '康复目标'),
                                        Tab(text: '康复治疗'),
                                        Tab(text: '康复宣教'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TabBarView(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Html(
                                                  data: specialTrainingDetailModel?.specialTrainingDetail?.content??"",
                                                  useRichText: true,
                                                  onImageTap: (src){
                                                    NavigatorUtils.pushResultWithParm(context,
                                                        PhotoViewSimpleScreen(
                                                          imageProvider: CachedNetworkImageProvider(src),
                                                          heroTag: 'simple',
                                                        ), (result){
                                                        });
                                                  },
                                                ),
                                                _bottomTip(),
                                                _recommandAndEvaluate(reCommendModel,listCommentModel),
                                              ],
                                            )
                                        ),
                                        SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Gaps.vGap10,
                                                (caseEvaluationList.tits==null)?Gaps.empty:ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: caseEvaluationList?.tits?.length,
                                                    itemBuilder: (context, index) {
                                                      Tits item = caseEvaluationList?.tits[index];
                                                      return _caseEvaluationView(item);
                                                    }),
                                                _bottomTip(),
                                                _recommandAndEvaluate(reCommendModel,listCommentModel),
                                              ],
                                            )
                                        ),
                                        SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: specialTrainingDetailModel?.specialTrainingDetail?.recoveryTarget??"",
                                                        style: TextStyle(color: Theme.of(context).textTheme.body1.color)
                                                    ),
                                                  ),
                                                ),
                                                _bottomTip(),
                                                _recommandAndEvaluate(reCommendModel,listCommentModel),
                                              ],
                                            )
                                        ),
                                        SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Gaps.vGap10,
                                                (recoveryList.tits == null)?Gaps.empty:ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: recoveryList?.tits?.length,
                                                    itemBuilder: (context, index) {
                                                      Tits item = recoveryList?.tits[index];
                                                      return _caseEvaluationView(item);
                                                    }),
                                                _bottomTip(),
                                                _recommandAndEvaluate(reCommendModel,listCommentModel),
                                              ],
                                            )
                                        ),
                                        SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                        text: specialTrainingDetailModel?.specialTrainingDetail?.mission??"",
                                                        style: TextStyle(color: Theme.of(context).textTheme.body1.color)
                                                    ),
                                                  ),
                                                ),
                                                _bottomTip(),
                                                _recommandAndEvaluate(reCommendModel,listCommentModel),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gaps.line,
                            BuildCommentView(listCommentModel,specialTrainingDetailModel.specialTrainingDetail.collectionStatus,widget.productId,widget.type,_commentFocus),
                            Container(
                              height: ScreenUtil.getBottomBarH(context),
                            )
                          ],
                        ),
                      )
                  )
              );
            }
          },
        ),
    );
  }


  _caseEvaluationView(Tits tits){
    List<Conts> conts = tits?.conts??[];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Offstage(
            offstage: Utils.isEmpty(tits.tit),
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 40.0,
              color: Colors.blue[50],
              child: Text(
                "${tits.tit}",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Offstage(
            offstage: conts.length <= 0,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: new BoxDecoration(
                  border: new Border.all(color: Theme.of(context).dividerColor)
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: conts.length,
                  itemBuilder: (context, index) {
                    Conts item = conts[index];
                    return _contsView(item);
                  }),
            )
          ),
        ],
      ),
    );
  }


  _contsView(Conts conts){
    return Container(
      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Utils.isEmpty(conts.mName)?Gaps.empty:Gaps.vGap5,
          Offstage(
            offstage: Utils.isEmpty(conts.mName),
            child: Text(
              "${conts.mName}",
              style: TextStyle(color: Theme.of(context).textTheme.body1.color),
            ),
          ),
          Utils.isEmpty(conts.text)?Gaps.empty:Gaps.vGap5,
          Offstage(
            offstage: Utils.isEmpty(conts.text),
            child: RichText(
              text: TextSpan(
                  text: "${conts.text}",
                  style: TextStyle(color: Theme.of(context).textTheme.subtitle.color)
              ),
            ),
          ),
          Utils.isEmpty(conts.urls)?Gaps.empty:Gaps.vGap5,
          Offstage(
            offstage: Utils.isEmpty(conts.urls),
            child: Utils.isEmpty(conts.urls)?Gaps.empty:
            SizedBox(
              height: (ScreenUtil.getScreenW(context)-60)/4,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: conts.urls.length,
                  itemBuilder: (context, index) {
                    Urls item = conts.urls[index];
                    return _urlView(item);
                  }),
            ),
          ),
          Gaps.vGap10
        ],
      ),
    );
  }

  _urlView(Urls urls){
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          onTap: (){
            if(urls.type == "pic"){
              NavigatorUtils.pushResultWithParm(context,
                  PhotoViewSimpleScreen(
                    imageProvider: CachedNetworkImageProvider(urls.url),
                    heroTag: 'simple',
                  ), (result){
                  });
            }
          },
          child: LoadImage(urls.url,width: (ScreenUtil.getScreenW(context)-60)/3),
        ),
      ),
    );
  }

  _recommandAndEvaluate(reCommendModel,listCommentModel){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: ThemeUtils.getBackgroundColor(context),
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            color: ThemeUtils.getViewBgColor(context),
            height: 45.0,
            width: ScreenUtil.getScreenW(context),
            child: Text(
              "推荐",
              style: TextStyles.textBold18,
            ),
          ),
          Gaps.line,
          (reCommendModel.list.length <= 0) ? Container():
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reCommendModel.list.length,
              itemBuilder: (context, index) {
                SpecialTraining item = reCommendModel.list[index];
                return SpecialTrainingItemWidget(specialTraining: item,type: widget.type);
              }),
          Container(
            padding: EdgeInsets.all(10.0),
            color: ThemeUtils.getViewBgColor(context),
            height: 45.0,
            width: ScreenUtil.getScreenW(context),
            child: Text(
              "最新评论",
              style: TextStyles.textBold18,
            ),
          ),
          Gaps.line,
          (listCommentModel.list.length <= 0) ? Container(
            color: ThemeUtils.getViewBgColor(context),
            alignment: Alignment.center,
            height: 100.0,
            child: Text("暂无评论"),
          ):
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (listCommentModel.list.length<3)?listCommentModel.list.length:3,
              itemBuilder: (context, index) {
                ListComment item = listCommentModel.list[index];
                return ListCommentItemWidget(type: widget.type,listComment: item,listCommentModel: listCommentModel,commentFocus: _commentFocus);
              }),
          (listCommentModel.list.length<=3)?Container():Container(
            color: ThemeUtils.getViewBgColor(context),
            alignment: Alignment.center,
            height: 60.0,
            child: FlatButton(
              onPressed: (){
                NavigatorUtils.pushResultWithParm(context,
                    ListCommentPage(type: widget.type,currentId: widget.productId),(result){});
              },
              child: Text("加载更多"),
            ),
          ),
          Container(
            height: ScreenUtil.getBottomBarH(context),
          ),
        ],
      ),
    );
  }

  _bottomTip(){
    return Container(
      padding: EdgeInsets.only(top: 20.0,bottom: 10.0),
      child: Text(
        "文章图及图片来源于网络转载，如有侵权，请关注康复小助手服务号，留言沟通，谢谢！",
        style: TextStyle(fontSize: Dimens.font_sp12,color: Theme.of(context).textTheme.subtitle.color),
      ),
    );
  }
}

class BuildCommentView extends StatelessWidget {
  final ListCommentModel listCommentModel;
  final bool collectionStatus;
  final int productId;
  final String type;
  final FocusNode commentFocus;
  BuildCommentView(this.listCommentModel, this.collectionStatus,this.productId,this.type,this.commentFocus);

  TextEditingController searchEditer = TextEditingController();

  @override
  Widget build(BuildContext context) {
//    return ProviderWidget<SpecialTrainingDetailModel>(
//        model: SpecialTrainingDetailModel(),
//        onModelReady: (detailModel) {
//          detailModel.setCollectValue(collectionStatus);
//          detailModel.setArticleLikeStatus(false);
//          detailModel.setParentId(0);
//          detailModel.setParentName("发表评论...");
//        },
//        builder: (context, detailModel, child) {

          return Container(
              height: 50,
              width: ScreenUtil.getScreenW(context),
              color: ThemeUtils.getViewBgColor(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: ScreenUtil.getScreenW(context)-100,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ThemeUtils.isDark(context)?Colours.dark_text_gray:Colours.bg_color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 14, color: ThemeUtils.isDark(context)?Colours.bg_gray:Colours.dark_bg_gray,textBaseline: TextBaseline.alphabetic),
                      controller: searchEditer,
                      textInputAction: TextInputAction.send,
                      focusNode: commentFocus,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(11.0),
                        hintText: Provider.of<SpecialTrainingDetailModel>(context).parentName,
                        hintStyle: TextStyle(color: ThemeUtils.isDark(context)?Colours.bg_gray:Colours.dark_bg_gray),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) async{
                        debugPrint("parrentname:"+Provider.of<SpecialTrainingDetailModel>(context).parentName+Provider.of<SpecialTrainingDetailModel>(context).parentId.toString());
                        if(!Utils.isEmpty(value)){
                          try {
                            bool isSuccess = await AppRepository.fetchAddComment(value,productId.toString(),type,parentId: ((Provider.of<SpecialTrainingDetailModel>(context).parentId==0)?0:Provider.of<SpecialTrainingDetailModel>(context).parentId));
                            if(isSuccess){
                              listCommentModel.refresh();
                              Provider.of<SpecialTrainingDetailModel>(context).setParentName("发表评论...");
                              Provider.of<SpecialTrainingDetailModel>(context).setParentId(0);
                              Toast.show("评论成功");
                            }else{
                              Toast.show("评论失败");
                            }
                          } catch (e) {
                            Toast.show(e.error.message);
                          }
                        }else{
                          Toast.show("请输入评论内容");
                        }
                      },
                    ),
//            child: Text("你是谁"),
                  ),
                  InkWell(
                    onTap: () async{
                      if(!Provider.of<SpecialTrainingDetailModel>(context).articleLikeStatus){
                        bool isSuccess = await AppRepository.fetchAddCommonLikes(type,productId.toString());
                        if(isSuccess){
                          Provider.of<SpecialTrainingDetailModel>(context).setArticleLikeStatus(true);
                        }else{
                          Toast.show("文章点赞失败");
                        }
                      }
                    },
                    child: LoadImage(Provider.of<SpecialTrainingDetailModel>(context).articleLikeStatus?"special/zan_s":"special/zan",width: 30,height: 30),
                  ),
                  InkWell(
                    onTap: () async{
                      bool isSuccess;
                      if(Provider.of<SpecialTrainingDetailModel>(context).collectionStatus){
                        isSuccess = await AppRepository.fetchDeleteCollect(productId.toString(),type);
                        if(isSuccess){
                          Provider.of<SpecialTrainingDetailModel>(context).setCollectValue(false);
                        }else{
                          Toast.show("取消收藏失败");
                        }
                      }else{
                        isSuccess = await AppRepository.fetchAddCollect(productId.toString(),type);
                        if(isSuccess){
                          Provider.of<SpecialTrainingDetailModel>(context).setCollectValue(true);
                        }else{
                          Toast.show("收藏失败");
                        }
                      }
                    },
                    child: LoadImage(Provider.of<SpecialTrainingDetailModel>(context).collectionStatus?"special/collection_s":"special/collection",width: 30,height: 30),
                  ),
                ],
              )
          );
//        }
//    );
  }
}

