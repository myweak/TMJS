import 'dart:async';

// import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school/provider/view_state_list_model.dart';
import 'package:school/provider/view_state_refresh_list_model.dart';
import 'package:school/service/app_repository.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kSearchHotList = 'kSearchHotList';
const String kSearchHistory = 'kSearchHistory';

class SearchHotKeyModel extends ViewStateListModel {
  final String type;
  SearchHotKeyModel({this.type});

  @override
  Future<List> loadData() async {
//    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
////    localStorage.deleteItem(keySearchHotList);//测试没有缓存
//    await localStorage.ready;
//    List localList = (localStorage.getItem(kSearchHotList) ?? []).map<String>((item) {
//      return item;
//    }).toList();
//
//    if (localList.isEmpty) {
//      //缓存为空,需要同步加载网络数据
//      List netList = await AppRepository.fetchSearchHotKey(type);
//      localStorage.setItem(kSearchHotList, netList);
//      return netList;
//    } else {
////      localList.removeRange(0, 3);//测试缓存与网络数据不一致
//      AppRepository.fetchSearchHotKey(type).then((netList) {
//        netList = netList ?? [];
//        if (!ListEquality().equals(netList, localList)) {
//          list = netList;
//          localStorage.setItem(kSearchHotList, list);
//          setIdle();
//        }
//      });
//      return localList;
//    }

    AppRepository.fetchSearchHotKey(type).then((netList) {
      netList = netList ?? [];
      list = netList;
      setIdle();
    });
    return list;
  }

  shuffle() {
    list.shuffle();
    notifyListeners();
  }
}

class SearchHistoryModel extends ViewStateListModel<String> {
  clearHistory() async {
    debugPrint('clearHistory');
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(kSearchHistory);
    list.clear();
    setEmpty();
  }

  addHistory(String keyword) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var histories = sharedPreferences.getStringList(kSearchHistory) ?? [];
    histories
      ..remove(keyword)
      ..insert(0, keyword);
    await sharedPreferences.setStringList(kSearchHistory, histories);
    notifyListeners();
  }

  @override
  Future<List<String>> loadData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(kSearchHistory) ?? [];
  }
}

class SearchHomeResultModel extends ViewStateRefreshListModel {
  final String keyword;
  final SearchHistoryModel searchHistoryModel;
  final String type;
  SearchHomeResultModel({this.keyword, this.searchHistoryModel, this.type});

  @override
  Future<List> loadData({int pageNum}) async {
    if (keyword.isEmpty) return [];
    searchHistoryModel.addHistory(keyword);
    if (type == "COLUMN") {
      return await AppRepository.fetchTeacherSearchResult(pageNum, keyword);
    } else {
      return await AppRepository.fetchHomeSearchResult(pageNum, keyword);
    }
  }
}

//class SearchTeacherResultModel extends ViewStateRefreshListModel {
//  final String keyword;
//  final SearchHistoryModel searchHistoryModel;
//
//  SearchTeacherResultModel({this.keyword, this.searchHistoryModel});
//
//  @override
//  Future<List> loadData({int pageNum}) async {
//    if (keyword.isEmpty) return [];
//    searchHistoryModel.addHistory(keyword);
//    return await AppRepository.fetchTeacherSearchResult(pageNum,keyword);
//  }
//}
