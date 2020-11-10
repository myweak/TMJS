import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:school/app/home/view/special_training_item.dart';
import 'package:school/app/teacher/page/confirmation_order_page.dart';
import 'package:school/app/teacher/view/teacher_detail_item.dart';
import 'package:school/app/teacher/view/teacher_item.dart';
import 'package:school/app/teacher/view/teacher_rules_item.dart';
import 'package:school/model/list_comment.dart';
import 'package:school/model/special_training.dart';
import 'package:school/model/teacher.dart';
import 'package:school/model/teacher_detail.dart';
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
import 'package:school/view_model/teacher_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/app_indicator.dart';
import 'package:school/widgets/chewie/chewie_player.dart';
import 'package:school/widgets/chewie/video_progress_colors.dart';
import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/photo_view_simple.dart';
import 'package:video_player/video_player.dart';

class TeacherDetailPage extends StatefulWidget {
  final String type;
  final int productId;
  final String imgBg;
  TeacherDetailPage({this.type,this.productId,this.imgBg});

  @override
  _TeacherDetailPageState createState() => _TeacherDetailPageState();
}

class _TeacherDetailPageState extends State<TeacherDetailPage> with AutomaticKeepAliveClientMixin{

  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  final List<Tab> _myTabs = <Tab>[
    Tab(text: '课程介绍'),
    Tab(text: '内容列表'),
  ];

  FocusNode _commentFocus = FocusNode();
  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();

//    videoPlayerController = VideoPlayerController.network(
//        'http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4');
    videoPlayerController = VideoPlayerController.network("");
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      placeholder: LoadImage(widget.imgBg),
      showControls: false,
      aspectRatio: 5/3,
//      autoPlay: false,
//      looping: false,
//      videoPayStatus: 3,
//      autoInitialize: true,

    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: ThemeUtils.getViewBgColor(context),
//        appBar: DefAppBar(
//          centerTitle: "名师详情",
//        ),
        body: ProviderWidget2<TeacherDetailModel,RecommendModel>(
          model1: TeacherDetailModel(type: widget.type),
          model2: RecommendModel(type: widget.type,currentId: widget.productId),
          onModelReady: (teacherDetailModel,reCommendModel) {
            teacherDetailModel.initData(widget.productId);
            reCommendModel.initData();
          },
          builder: (context, teacherDetailModel,reCommendModel, child) {
            if (teacherDetailModel.busy) {
              return AppIndicatorNoBar();
            } else if (teacherDetailModel.error && teacherDetailModel.teacherDetail == null) {
              return ViewStateErrorWidget(
                  error: teacherDetailModel.viewStateError, onPressed: teacherDetailModel.initData(widget.productId));
            } else if (teacherDetailModel.empty) {
              return ViewStateEmptyWidget(onPressed: teacherDetailModel.initData(widget.productId));
            } else if (teacherDetailModel.unAuthorized){
              return ViewStateUnAuthWidget(onPressed: () async {
                NavigatorUtils.push(context, Routes.login,clearStack: true);
              });
            }

            return DefaultTabController(
                length: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: ThemeUtils.getBackgroundColor(context),
                              child: Chewie(
                                controller: chewieController,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${teacherDetailModel.teacherDetail.title}",
                                      style: TextStyles.textBold16,
                                    ),
                                  ),
                                  Gaps.hGap10,
                                  InkWell(
                                    onTap: () async{
                                      if(!Provider.of<TeacherDetailModel>(context).articleLikeStatus){
                                        bool isSuccess = await AppRepository.fetchAddCommonLikes(widget.type,widget.productId.toString());
                                        if(isSuccess){
                                          Provider.of<TeacherDetailModel>(context).setArticleLikeStatus(true);
                                        }else{
                                          Toast.show("文章点赞失败");
                                        }
                                      }
                                    },
                                    child: LoadImage(Provider.of<TeacherDetailModel>(context).articleLikeStatus?"special/zan_s":"special/zan",width: 25,height: 25),
                                  ),
                                  Gaps.hGap10,
                                  InkWell(
                                    onTap: () async{
                                      bool isSuccess;
                                      if(Provider.of<TeacherDetailModel>(context).collectionStatus){
                                        isSuccess = await AppRepository.fetchDeleteCollect(widget.productId.toString(),widget.type);
                                        if(isSuccess){
                                          Provider.of<TeacherDetailModel>(context).setCollectValue(false);
                                        }else{
                                          Toast.show("取消收藏失败");
                                        }
                                      }else{
                                        isSuccess = await AppRepository.fetchAddCollect(widget.productId.toString(),widget.type);
                                        if(isSuccess){
                                          Provider.of<TeacherDetailModel>(context).setCollectValue(true);
                                        }else{
                                          Toast.show("收藏失败");
                                        }
                                      }
                                    },
                                    child: LoadImage(Provider.of<TeacherDetailModel>(context).collectionStatus?"special/collection_s":"special/collection",width: 25,height: 25),
                                  ),
                                  Gaps.hGap10
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10.0,bottom: 10.0),
                              child: RichText(
                                text: TextSpan(
                                    text: "折扣价",
                                    style: TextStyle(
                                        fontSize: Dimens.font_sp12,
                                        color: Theme.of(context).textTheme.title.color
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " ${teacherDetailModel.teacherDetail.totalPrice} ",
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp18,
                                            color: Colors.red
                                        ),
                                      ),
                                      TextSpan(
                                        text: "元",
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp12,
                                            color: Theme.of(context).textTheme.title.color
                                        ),
                                      ),
                                      TextSpan(
                                        text: "   原价:${teacherDetailModel.noDiscountPrice} 元",
                                        style: TextStyle(
                                            fontSize: Dimens.font_sp10,
//                                            decoration: TextDecoration.lineThrough,
                                            color: Theme.of(context).textTheme.subtitle.color
                                        ),
                                      )
                                    ]
                                ),
                              ),
                            ),
                            Container(
                              height: 10.0,
                              color: ThemeUtils.getBackgroundColor(context),
                            ),
                            Container(
                              width: ScreenUtil.getScreenW(context),
                              color: ThemeUtils.getViewBgColor(context),
                              child: TabBar(
                                labelColor: Theme.of(context).primaryColor,
                                unselectedLabelColor: ThemeUtils.isDark(context) ? Colours.text_gray : Colours.text,
                                indicatorWeight: 1,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorPadding: EdgeInsets.only(top: 0,bottom: 0),
                                labelStyle: TextStyle(fontSize: 14),
                                tabs: _myTabs,
                                onTap: (value){
                                  Provider.of<TeacherDetailModel>(context).setCurrentIndex(value);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TabBarView(
                                children: <Widget>[
                                  SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0,bottom: 15.0),
                                            child: Text(
                                              "${teacherDetailModel.teacherDetail.contentAbstract}",
                                              style: TextStyles.textSize12,
                                            ),
                                          ),
                                          Container(
                                            height: 10.0,
                                            color: ThemeUtils.getBackgroundColor(context),
                                          ),
//                                          Container( //拼团规则
//                                            padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0),
//                                            child: RichText(
//                                              text: TextSpan(
//                                                  children: <TextSpan>[
//                                                    TextSpan(
//                                                        text: "拼团规则",
//                                                        style: TextStyle(
//                                                            fontSize: Dimens.font_sp14,
//                                                            color: Theme.of(context).primaryColor,
//                                                            decoration: TextDecoration.underline
//                                                        )
//                                                    ),
//                                                    TextSpan(
//                                                      text: "  邀请好友或参与开团，可快速成团",
//                                                      style: TextStyle(
//                                                          fontSize: Dimens.font_sp14,
//                                                          color: Theme.of(context).textTheme.title.color
//                                                      ),
//                                                    ),
//                                                  ]
//                                              ),
//                                            ),
//                                          ),
//                                          MediaQuery.removePadding(
//                                            context: context,
//                                            removeTop: true,
//                                            removeBottom: true,
//                                            child: ListView.builder(
//                                                shrinkWrap: true,
//                                                physics: NeverScrollableScrollPhysics(),
//                                                itemCount: teacherDetailModel.teacherDetail.courseVOS?.length,
//                                                itemBuilder: (context, index) {
//                                                  CourseVOS item = teacherDetailModel.teacherDetail.courseVOS[index];
//                                                  return InkWell(
//                                                    onTap: (){},
//                                                    child: TeacherRulesItemWidget(item),
//                                                  );
//                                                }),
//                                          ),
//                                          Container(
//                                            height: 10.0,
//                                            color: ThemeUtils.getBackgroundColor(context),
//                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0),
                                            child: Text(
                                              "讲师介绍",
                                              style: TextStyles.textBold14,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                                            child: Html(
                                              data: teacherDetailModel.teacherDetail?.content??"",
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
                                          ),
                                          _recommandAndEvaluate(reCommendModel),
                                        ],
                                      )
                                  ),
                                  SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          (teacherDetailModel.teacherDetail.courseVOS==null)?Gaps.empty:MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            removeBottom: true,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: teacherDetailModel.teacherDetail.courseVOS?.length,
                                                itemBuilder: (context, index) {
                                                  CourseVOS item = teacherDetailModel.teacherDetail.courseVOS[index];
                                                  return InkWell(
                                                    onTap: (){
                                                      videoPlayerController.pause();
                                                      if(item.bought){//购买过了
                                                        if(this.mounted){
                                                          setState(() {
                                                            videoPlayerController = VideoPlayerController.network(item.videoUrl);
                                                            chewieController = ChewieController(
                                                              videoPlayerController: videoPlayerController,
                                                              aspectRatio: 5/3,
                                                              autoPlay: false,
                                                              looping: false,
                                                              videoPayStatus: 4,
                                                              autoInitialize: true,
                                                            );
                                                          });
                                                        }
                                                      }else{//还没够买过
                                                        if(item.preview){ //可以试看
                                                          if(this.mounted){
                                                            setState(() {
                                                              videoPlayerController = VideoPlayerController.network(item.videoUrl);
                                                              chewieController = ChewieController(
                                                                videoPlayerController: videoPlayerController,
                                                                aspectRatio: 5/3,
                                                                autoPlay: false,
                                                                looping: false,
                                                                videoPayStatus: 1,
                                                                autoInitialize: true,
                                                              );
                                                            });
                                                          }
                                                        }else{ //购买才可以看
                                                          if(this.mounted){
                                                            setState(() {
                                                              videoPlayerController = VideoPlayerController.network("https://imagetc.rrdkf.com/1201565350275254.mp4");//随便填写的一个视频地址
                                                              chewieController = ChewieController(
                                                                videoPlayerController: videoPlayerController,
                                                                aspectRatio: 5/3,
                                                                autoPlay: false,
                                                                looping: false,
                                                                videoPayStatus: 3,
                                                                autoInitialize: true,
                                                              );
                                                            });
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: TeacherDetailItemWidget(item,index),
                                                  );
                                                }),
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Offstage(
                              offstage: (Provider.of<TeacherDetailModel>(context).currentIndex != 0),
                              child: Offstage(
                                offstage: teacherDetailModel.teacherDetail.famousAlbumBuyStatus,
                                child: Container(
                                  width: double.infinity,
                                  height: 45.0,
                                  color: Theme.of(context).primaryColor,
                                  child: FlatButton(
                                    child: Text("¥${teacherDetailModel.teacherDetail.totalPrice} 购买",style: TextStyle(color: Colors.white),),
                                    onPressed: (){
                                      NavigatorUtils.pushResultWithParm(context,
                                          ConfirmationOrderPage(
                                            imgStr: teacherDetailModel.teacherDetail.bannerImg,
                                            titleStr: teacherDetailModel.teacherDetail.bannerImg,
                                            priceDou: teacherDetailModel.teacherDetail.totalPrice,
                                          ), (result){
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ),
//                            Gaps.line,
                            Offstage(
                              offstage: (Provider.of<TeacherDetailModel>(context).currentIndex != 1),
                              child: Offstage(
                                offstage: teacherDetailModel.teacherDetail.famousAlbumBuyStatus,
                                child: Container(
                                  width: double.infinity,
                                  height: 45.0,
                                  color: ThemeUtils.getBackgroundColor(context),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 60,
                                        child: Checkbox(
                                          value: Provider.of<TeacherDetailModel>(context).isSelectAllCourse,
                                          onChanged: (bool val){
                                            Provider.of<TeacherDetailModel>(context).setSelectAllCourse(val,teacherDetailModel.teacherDetail.courseVOS);
                                          },
                                        ),
                                      ),
                                      Text("全选",style: TextStyle(color: Theme.of(context).textTheme.title.color),),
                                      Spacer(),
                                      Provider.of<TeacherDetailModel>(context).totalPrice<=0.0?Container():
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Text("¥${Provider.of<TeacherDetailModel>(context).totalPrice.toString()}",style: TextStyle(color: Theme.of(context).primaryColor),),
                                      ),
                                      Provider.of<TeacherDetailModel>(context).totalPrice<=0.0?Container():
                                      Container(
                                        width: ScreenUtil.getScreenW(context)/2,
                                        color: Theme.of(context).primaryColor,
                                        child: FlatButton(
                                          child: Text("去支付",style: TextStyle(color: Colors.white),),
                                          onPressed: (){
                                            NavigatorUtils.pushResultWithParm(context,
                                                ConfirmationOrderPage(
                                                  imgStr: teacherDetailModel.teacherDetail.bannerImg,
                                                  titleStr: teacherDetailModel.teacherDetail.bannerImg,
                                                  priceDou: teacherDetailModel.teacherDetail.totalPrice,
                                                ), (result){
                                                });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: ScreenUtil.getBottomBarH(context),
                      )
                    ],
                  ),
                )
            );
          },
        ),
    );
  }

  _recommandAndEvaluate(reCommendModel){
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
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reCommendModel.list.length,
                itemBuilder: (context, index) {
                  SpecialTraining item = reCommendModel.list[index];
                  return SpecialTrainingItemWidget(specialTraining: item,type: widget.type);
                }),
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


//
//class BuildCommentView extends StatelessWidget {
//  final ListCommentModel listCommentModel;
//  final bool collectionStatus;
//  final int productId;
//  final String type;
//  final FocusNode commentFocus;
//  BuildCommentView(this.listCommentModel, this.collectionStatus,this.productId,this.type,this.commentFocus);
//
//  TextEditingController searchEditer = TextEditingController();
//
//  @override
//  Widget build(BuildContext context) {
////    return ProviderWidget<SpecialTrainingDetailModel>(
////        model: SpecialTrainingDetailModel(),
////        onModelReady: (detailModel) {
////          detailModel.setCollectValue(collectionStatus);
////          detailModel.setArticleLikeStatus(false);
////          detailModel.setParentId(0);
////          detailModel.setParentName("发表评论...");
////        },
////        builder: (context, detailModel, child) {
//
//          return Container(
//              height: 50,
//              width: ScreenUtil.getScreenW(context),
//              color: ThemeUtils.getViewBgColor(context),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Container(
//                    alignment: Alignment.centerLeft,
//                    width: ScreenUtil.getScreenW(context)-100,
//                    height: 36,
//                    decoration: BoxDecoration(
//                      color: ThemeUtils.isDark(context)?Colours.dark_text_gray:Colours.bg_color,
//                      borderRadius: BorderRadius.circular(18),
//                    ),
//                    child: TextField(
//                      style: TextStyle(fontSize: 14, color: ThemeUtils.isDark(context)?Colours.bg_gray:Colours.dark_bg_gray,textBaseline: TextBaseline.alphabetic),
//                      controller: searchEditer,
//                      textInputAction: TextInputAction.send,
//                      focusNode: commentFocus,
//                      decoration: InputDecoration(
//                        contentPadding: EdgeInsets.all(11.0),
//                        hintText: Provider.of<SpecialTrainingDetailModel>(context).parentName,
//                        hintStyle: TextStyle(color: ThemeUtils.isDark(context)?Colours.bg_gray:Colours.dark_bg_gray),
//                        border: InputBorder.none,
//                      ),
//                      onSubmitted: (value) async{
//                        debugPrint("parrentname:"+Provider.of<SpecialTrainingDetailModel>(context).parentName+Provider.of<SpecialTrainingDetailModel>(context).parentId.toString());
//                        if(!Utils.isEmpty(value)){
//                          try {
//                            bool isSuccess = await AppRepository.fetchAddComment(value,productId.toString(),type,parentId: ((Provider.of<SpecialTrainingDetailModel>(context).parentId==0)?0:Provider.of<SpecialTrainingDetailModel>(context).parentId));
//                            if(isSuccess){
//                              listCommentModel.refresh();
//                              Provider.of<SpecialTrainingDetailModel>(context).setParentName("发表评论...");
//                              Provider.of<SpecialTrainingDetailModel>(context).setParentId(0);
//                              Toast.show("评论成功");
//                            }else{
//                              Toast.show("评论失败");
//                            }
//                          } catch (e) {
//                            Toast.show(e.error.message);
//                          }
//                        }else{
//                          Toast.show("请输入评论内容");
//                        }
//                      },
//                    ),
////            child: Text("你是谁"),
//                  ),
//                  InkWell(
//                    onTap: () async{
//                      if(!Provider.of<SpecialTrainingDetailModel>(context).articleLikeStatus){
//                        bool isSuccess = await AppRepository.fetchAddCommonLikes(type,productId.toString());
//                        if(isSuccess){
//                          Provider.of<SpecialTrainingDetailModel>(context).setArticleLikeStatus(true);
//                        }else{
//                          Toast.show("文章点赞失败");
//                        }
//                      }
//                    },
//                    child: LoadImage(Provider.of<SpecialTrainingDetailModel>(context).articleLikeStatus?"special/zan_s":"special/zan",width: 30,height: 30),
//                  ),
//                  InkWell(
//                    onTap: () async{
//                      bool isSuccess;
//                      if(Provider.of<SpecialTrainingDetailModel>(context).collectionStatus){
//                        isSuccess = await AppRepository.fetchDeleteCollect(productId.toString(),type);
//                        if(isSuccess){
//                          Provider.of<SpecialTrainingDetailModel>(context).setCollectValue(false);
//                        }else{
//                          Toast.show("取消收藏失败");
//                        }
//                      }else{
//                        isSuccess = await AppRepository.fetchAddCollect(productId.toString(),type);
//                        if(isSuccess){
//                          Provider.of<SpecialTrainingDetailModel>(context).setCollectValue(true);
//                        }else{
//                          Toast.show("收藏失败");
//                        }
//                      }
//                    },
//                    child: LoadImage(Provider.of<SpecialTrainingDetailModel>(context).collectionStatus?"special/collection_s":"special/collection",width: 30,height: 30),
//                  ),
//                ],
//              )
//          );
////        }
////    );
//  }
//}

