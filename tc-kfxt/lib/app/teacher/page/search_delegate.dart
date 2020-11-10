import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/view_model/search_model.dart';

import 'search_results.dart';
import 'search_suggestions.dart';

class DefaultSearchDelegate extends SearchDelegate {

  final String type;
  final SearchHotKeyModel searchHotKeyModel;
  DefaultSearchDelegate({this.type,this.searchHotKeyModel});

  SearchHistoryModel _searchHistoryModel = SearchHistoryModel();
//  SearchHotKeyModel _searchHotKeyModel = SearchHotKeyModel(type: "HOME");

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context);
    return super.appBarTheme(context).copyWith(
        primaryColor: theme.scaffoldBackgroundColor,
        primaryColorBrightness: theme.brightness);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    debugPrint('buildResults-query' + query);
    if (query.length > 0) {
      return SearchResults(
          keyword: query, searchHistoryModel: _searchHistoryModel,type: type);
    }
    return SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

//    _searchHotKeyModel = SearchHotKeyModel(type: type);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchHistoryModel>.value(value: _searchHistoryModel),
        ChangeNotifierProvider<SearchHotKeyModel>.value(value: searchHotKeyModel),
      ],
      child: SearchSuggestions(delegate: this,type: type),
    );
  }

  @override
  void close(BuildContext context, result) {
    _searchHistoryModel.dispose();
    searchHotKeyModel.dispose();
    super.close(context, result);
  }
}
