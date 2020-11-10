import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:school/app/teacher/page/search_delegate.dart';
import 'package:school/app/teacher/view/teacher_item.dart';
import 'package:school/model/teacher.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/provider/view_state_widget.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/view_model/search_model.dart';
import 'package:school/view_model/teacher_model.dart';
import 'package:school/widgets/article_skeleton.dart';
import 'package:school/widgets/search.dart';
import 'package:school/widgets/skeleton.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: ThemeUtils.getViewBgColor(context),
              title: GestureDetector(
                child: SearchWidget(),
                onTap: (){
                  SearchHotKeyModel searchHotKeyModel = SearchHotKeyModel(type: "COLUMN");
                  showSearch(context: context, delegate: DefaultSearchDelegate(type: "COLUMN",searchHotKeyModel: searchHotKeyModel)); //HOME 首页进入；COLUMN 名师进入
                },
              ),
            ),
            preferredSize: Size.fromHeight(48.0)
        ),
      body: ProviderWidget<TeacherListModel>(
        model: TeacherListModel(),
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
                    Teacher item = model.list[index];
                    return TeacherItemWidget(item);
                  })
          );
        },
      )
    );
  }
}