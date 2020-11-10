import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:school/app/teacher/view/search_result_item.dart';
import 'package:school/model/search_result.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/provider/view_state_widget.dart';
import 'package:school/view_model/search_model.dart';

class SearchResults extends StatelessWidget {
  final String keyword;
  final SearchHistoryModel searchHistoryModel;
  final String type;
  SearchResults({this.keyword, this.searchHistoryModel,this.type});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SearchHomeResultModel>(
      model: SearchHomeResultModel(
          keyword: keyword, searchHistoryModel: searchHistoryModel,type: type),
      onModelReady: (model) {
        model.initData();
      },
      builder: (context, model, child) {
        if (model.busy) {
          return ViewStateBusyWidget();
        } else if (model.error && model.list.isEmpty) {
          return ViewStateErrorWidget(
              error: model.viewStateError, onPressed: model.initData);
        } else if (model.empty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
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
                  SearchReslut item = model.list[index];
                  return SearchResultItemWidget(type,item);
                }));
      },
    );
  }
}
