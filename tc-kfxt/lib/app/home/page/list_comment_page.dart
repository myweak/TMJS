import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:school/app/home/view/list_comment_item.dart';
import 'package:school/app/home/view/special_training_item.dart';
import 'package:school/app/teacher/view/teacher_item.dart';
import 'package:school/model/list_comment.dart';
import 'package:school/model/special_training.dart';
import 'package:school/model/teacher.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/provider/view_state_widget.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/view_model/list_comment_model.dart';
import 'package:school/view_model/special_training_model.dart';
import 'package:school/view_model/teacher_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/article_skeleton.dart';
import 'package:school/widgets/skeleton.dart';

class ListCommentPage extends StatefulWidget {

  String type;
  int currentId;
  ListCommentPage({this.type, this.currentId});

  @override
  _ListCommentPageState createState() => _ListCommentPageState();
}

class _ListCommentPageState extends State<ListCommentPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: DefAppBar(
        centerTitle: "评论列表",
      ),
      body: ProviderWidget2<ListCommentModel,SpecialTrainingDetailModel>(
        model1: ListCommentModel(type: widget.type, currentId: widget.currentId),
        model2: SpecialTrainingDetailModel(type: widget.type),
        onModelReady: (model,detailModel) {
          model.initData();
          detailModel.setParentId(0);
          detailModel.setParentName("发表评论...");
        },
        builder: (context, model,detailModel, child) {
          if (model.busy) {
            return SkeletonList(
              builder: (context, index) => ArticleSkeletonItem(),
            );
          } else if (model.error && model.list.isEmpty) {
            return ViewStateErrorWidget(
                error: model.viewStateError, onPressed: model.initData);
          } else if (model.empty) {
            return ViewStateEmptyWidget(onPressed: model.initData);
          } else if (model.unAuthorized){
            return ViewStateUnAuthWidget(onPressed: () async {
//            Navigator.of(context).pushNamed(Routes.login);
              NavigatorUtils.push(context, Routes.login,clearStack: true);
            });
          }
          return SmartRefresher(
              controller: model.refreshController,
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              onRefresh: model.refresh,
              onLoading: model.loadMore,
              enablePullUp: true,
              child: ListView.builder(
                  itemCount: model.list.length,
                  itemBuilder: (context, index) {
                    ListComment item = model.list[index];
                    return ListCommentItemWidget(key:const Key("listComment"),type: widget.type,listComment: item);
                  })
          );
        },
      ),
    );
  }
}
