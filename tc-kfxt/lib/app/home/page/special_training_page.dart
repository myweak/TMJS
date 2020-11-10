import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:school/app/home/view/special_training_item.dart';
import 'package:school/app/teacher/view/teacher_item.dart';
import 'package:school/model/special_training.dart';
import 'package:school/model/teacher.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/provider/view_state_widget.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/view_model/special_training_model.dart';
import 'package:school/view_model/teacher_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/article_skeleton.dart';
import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/skeleton.dart';

class SpecialTrainingPage extends StatefulWidget {
  @override
  _SpecialTrainingPageState createState() => _SpecialTrainingPageState();
}

class _SpecialTrainingPageState extends State<SpecialTrainingPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<SpecialTrainingModel>(
      model: SpecialTrainingModel(),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
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

        int currentStatus = Provider.of<SpecialTrainingModel>(context).tagType;

        return SmartRefresher(
            controller: model.refreshController,
            header: WaterDropHeader(),
            footer: ClassicFooter(),
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            enablePullUp: true,
//            child: ListView.builder(
//                itemCount: model.list.length,
//                itemBuilder: (context, index) {
//                  SpecialTraining item = model.list[index];
//                  return SpecialTrainingItemWidget(specialTraining: item,type: "SPECIAL");
//                })
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  color: ThemeUtils.getViewBgColor(context),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          Provider.of<SpecialTrainingModel>(context).changeTagTypeValue(0);
                          model.refresh();
                        },
                        child: Stack(
                          children: <Widget>[
                            LoadAssetImage("special/specialTag1",width: (ScreenUtil.getScreenW(context)-30)/3),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: Text("基本与评估",style: TextStyle(fontSize: Dimens.font_sp14,color: (currentStatus == 0)?Theme.of(context).primaryColor:Theme.of(context).textTheme.body1.color)),
                            )
                          ],
                        ),
                      ),

                      Gaps.hGap5,
                      InkWell(
                        onTap: (){
                          Provider.of<SpecialTrainingModel>(context).changeTagTypeValue(1);
                          model.refresh();
                        },
                        child: Stack(
                          children: <Widget>[
                            LoadAssetImage("special/specialTag2",width: (ScreenUtil.getScreenW(context)-30)/3),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: Text("康复技术",style: TextStyle(fontSize: Dimens.font_sp14,color: (currentStatus == 1)?Theme.of(context).primaryColor:Theme.of(context).textTheme.body1.color)),
                            )
                          ],
                        ),
                      ),
                      Gaps.hGap5,
                      InkWell(
                        onTap: (){
                          Provider.of<SpecialTrainingModel>(context).changeTagTypeValue(2);
                          model.refresh();
                        },
                        child: Stack(
                          children: <Widget>[
                            LoadAssetImage("special/specialTag3",width: (ScreenUtil.getScreenW(context)-30)/3),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: Text("治疗方案",style: TextStyle(fontSize: Dimens.font_sp14,color: (currentStatus == 2)?Theme.of(context).primaryColor:Theme.of(context).textTheme.body1.color)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                  SpecialTraining item = model.list[index];
                  return SpecialTrainingItemWidget(specialTraining: item,type: "SPECIAL");
                },
                childCount: model.list.length),
              ),
            ]),
        );
      },
    );
  }
}
