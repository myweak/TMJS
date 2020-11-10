import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/app/home/page/special_training_detail_page.dart';
import 'package:school/model/list_comment.dart';
import 'package:school/model/offline_study.dart';
import 'package:school/model/special_training.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/res/colors.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/res/styles.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/util/image_utils.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/util/toast.dart';
import 'package:school/view_model/list_comment_model.dart';
import 'package:school/view_model/special_training_model.dart';
import 'package:school/widgets/load_image.dart';

class ListCommentItemWidget extends StatelessWidget {

  final String type;
  final ListComment listComment;
  final ListCommentModel listCommentModel;
  final FocusNode commentFocus;
  ListCommentItemWidget({Key key,this.type,this.listComment,this.listCommentModel,this.commentFocus}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeUtils.getViewBgColor(context),
        padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Provider.of<SpecialTrainingDetailModel>(context).setParentId(listComment.id);
                  Provider.of<SpecialTrainingDetailModel>(context).setParentName("回复${listComment.nickname}");
                  debugPrint("parrentname:"+Provider.of<SpecialTrainingDetailModel>(context).parentName+Provider.of<SpecialTrainingDetailModel>(context).parentId.toString());
                  FocusScope.of(context).requestFocus(commentFocus);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildTopView(context,listComment.id.toString(),listComment.headimg, listComment.nickname,listComment.likes,listComment.likeStatus,listComment.createTime,false),
                    Container(
                        padding: EdgeInsets.only(left: 48, top: 8, bottom: 8),
                        alignment: Alignment.centerLeft,
                        child: Text('${listComment?.content}'))
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: listComment.followList.length,
                  padding: EdgeInsets.only(left: 28, top: 0, right: 10.0),
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 8, top: 8, bottom: 8),
                      color: ThemeUtils.getBackgroundColor(context),
                      child: Column(children: <Widget>[
                        _buildTopView(context,listComment?.followList[index]?.id.toString(),listComment?.followList[index]?.headimg, listComment?.followList[index]?.nickname,listComment?.followList[index]?.likes,listComment?.followList[index]?.likeStatus,"",false),
                        Container(
                          padding: EdgeInsets.only(
                              left: 40, top: 8,bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${listComment?.followList[index]?.content??""}',
                            style: TextStyles.textDarkGray14,
                          ),
                        ),
                        Gaps.line,
                      ]),
                    ),
                  )
              ),
              Gaps.line
            ]
        )
    );
//    return ProviderWidget<SpecialTrainingDetailModel>(
//        model: SpecialTrainingDetailModel(),
//        onModelReady: (currentIndexProvide) {
////          currentIndexProvide.setParentId(0);
////          currentIndexProvide.setParentName("发表评论...");
//        },
//        builder: (context, currentIndexProvide, child) {
//          return Container(
//              color: ThemeUtils.getViewBgColor(context),
//              padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
//              child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    GestureDetector(
//                      behavior: HitTestBehavior.translucent,
//                      onTap: () {
//                        Provider.of<SpecialTrainingDetailModel>(context).setParentId(listComment.id);
//                        Provider.of<SpecialTrainingDetailModel>(context).setParentName("回复${listComment.nickname}");
//
//                        debugPrint("parrentname:"+Provider.of<SpecialTrainingDetailModel>(context).parentName+Provider.of<SpecialTrainingDetailModel>(context).parentId.toString());
////                        FocusScope.of(context).requestFocus(commentFocus);
//                      },
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
////                          BuildTopView(listComment.id.toString(),listComment.headimg, listComment.nickname,listComment.likes,listComment.likeStatus,listComment.createTime,false,listCommentModel),
//                          _buildTopView(context,listComment.id.toString(),listComment.headimg, listComment.nickname,listComment.likes,listComment.likeStatus,listComment.createTime,false),
//                          Container(
//                              padding: EdgeInsets.only(left: 48, top: 8, bottom: 8),
//                              alignment: Alignment.centerLeft,
//                              child: Text('${listComment?.content}'))
//                        ],
//                      ),
//                    ),
//                    ListView.builder(
//                        itemCount: listComment.followList.length,
//                        padding: EdgeInsets.only(left: 28, top: 0, right: 10.0),
//                        primary: false,
//                        physics: NeverScrollableScrollPhysics(),
//                        shrinkWrap: true,
//                        itemBuilder: (context, index) => GestureDetector(
//                          behavior: HitTestBehavior.translucent,
//                          onTap: () {},
//                          child: Container(
//                            padding: EdgeInsets.only(
//                                left: 8, top: 8, bottom: 8),
//                            color: ThemeUtils.getBackgroundColor(context),
//                            child: Column(children: <Widget>[
//                              _buildTopView(context,listComment?.followList[index]?.id.toString(),listComment?.followList[index]?.headimg, listComment?.followList[index]?.nickname,listComment?.followList[index]?.likes,listComment?.followList[index]?.likeStatus,"",false),
//                              Container(
//                                padding: EdgeInsets.only(
//                                    left: 40, top: 8,bottom: 8),
//                                alignment: Alignment.centerLeft,
//                                child: Text(
//                                  '${listComment?.followList[index]?.content??""}',
//                                  style: TextStyles.textDarkGray14,
//                                ),
//                              ),
//                              Gaps.line,
//                            ]),
//                          ),
//                        )
//                    ),
//                    Gaps.line
//                  ]
//              )
//          );
//        }
//     );
  }

  Widget _buildTopView(BuildContext context,String id,String headImg, String nickName, int likes, bool likeStatus,String publishTime, bool isSub) {
    return Row(
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: Theme.of(context).dividerColor,
            backgroundImage: ImageUtils.getImageProvider(headImg,holderImg: ""),
          ),
          Gaps.hGap8,
          Text('${nickName}'),
          Gaps.hGap8,
          Text("${publishTime}"),
          Spacer(),
          isSub?Gaps.empty:Text(
            "${Provider.of<SpecialTrainingDetailModel>(context).likes.toString()}",
            style: TextStyle(color: Provider.of<SpecialTrainingDetailModel>(context).likeStatus?Theme.of(context).primaryColor:Colors.grey),
          ),
          Gaps.hGap4,
          isSub?Gaps.empty:InkWell(
              onTap: () async{
                if(!likeStatus){
                  bool isSuccess = await AppRepository.fetchAddLikeToComment(id);
                  if(isSuccess){
                    likeStatus = true;
                    Provider.of<SpecialTrainingDetailModel>(context).setLikeStatus(true);
                    Provider.of<SpecialTrainingDetailModel>(context).addLikeValue();
                  }else{
                    Toast.show("点赞失败");
                  }
                }
              },
              child: LoadAssetImage(Provider.of<SpecialTrainingDetailModel>(context).likeStatus?"special/zan_s":"special/zan",width: 15.0,height: 15.0,)
          ),
        ]
    );
  }
}