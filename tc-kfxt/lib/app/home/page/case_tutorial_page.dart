import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:school/app/home/page/special_training_detail_page.dart';
import 'package:school/app/home/view/case_tutorial_item.dart';
import 'package:school/app/login/page/login_page.dart';
import 'package:school/app/teacher/view/teacher_item.dart';
import 'package:school/model/case_tutorial.dart';
import 'package:school/model/category_banner.dart';
import 'package:school/model/teacher.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/provider/view_state_widget.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/routers/routers.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/view_model/case_tutorial_model.dart';
import 'package:school/view_model/teacher_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/article_skeleton.dart';
import 'package:school/widgets/load_image.dart';
import 'package:school/widgets/skeleton.dart';

class CaseTutorialPage extends StatefulWidget {
  @override
  _CaseTutorialPageState createState() => _CaseTutorialPageState();
}

class _CaseTutorialPageState extends State<CaseTutorialPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget2<CaseTutorialModel,CaseTutorialBannerModel>(
      model1: CaseTutorialModel(),
      model2: CaseTutorialBannerModel(),
      onModelReady: (model1,model2) {
        model1.initData();
        model2.initData(0);
      },
      builder: (context, model1, model2, child) {
        if (model1.busy) {
          return SkeletonList(
            builder: (context, index) => ArticleSkeletonItem(),
          );
        } else if (model1.error && model1.list.isEmpty) {
          return ViewStateErrorWidget(
              error: model1.viewStateError, onPressed: model1.initData);
        } else if (model1.empty) {
          return ViewStateEmptyWidget(onPressed: model1.initData);
        } else if (model1.unAuthorized){
          return ViewStateUnAuthWidget(onPressed: () async {
//            Navigator.of(context).pushNamed(Routes.login);
            NavigatorUtils.push(context, Routes.login,clearStack: true);
          });
        }
        var banners = model2?.list ?? [];
        return SmartRefresher(
            controller: model1.refreshController,
            header: WaterDropHeader(),
            footer: ClassicFooter(),
            onRefresh: model1.refresh,
            onLoading: model1.loadMore,
            enablePullUp: true,
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: (banners.length <= 0) ? Container() : Container(
                  color: ThemeUtils.getViewBgColor(context),
                  margin: EdgeInsets.all(10.0),
                  height: (ScreenUtil.getScreenW(context)-20)/3+20,
                  child: Swiper(
                    scale:0.8,
                    fade:0.8,
                    duration: 3000,
                    itemBuilder: (c, index) {
                      return InkWell(
                        onTap: (){
                          NavigatorUtils.pushResultWithParm(context,
                              SpecialTrainingDetailPage(
                                type: "CASE",
                                productId: model2.list[index].providerId,
                              ), (result){
                              });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: LoadImage(banners[index].bannerImg,width: ScreenUtil.getScreenW(context)-20),
//                          child: UrlImage(url: banners[index].bannerImg, width: ScreenUtil.getScreenW(context)-20, height: (ScreenUtil.getScreenW(context)-20)/3+20),
                        ),
                      );
                    },
                    itemCount: banners.length,
                    pagination: new SwiperPagination(),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context,int index){
                  CaseTutorial item = model1.list[index];
                  return CaseTutorialItemWidget(caseTutorial: item,type: "CASE");
                },
                childCount: model1.list.length),
              ),
            ]),
        );
      },
    );
  }
}
