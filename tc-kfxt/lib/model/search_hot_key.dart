class SearchHotKey {
  List<String> data;

  static SearchHotKey fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
		SearchHotKey searchBean = SearchHotKey();
    searchBean.data = map['data'];
//    searchBean.data = List()..addAll((map["data"] as List ?? []).map((o) => String.fromCharCode(o)));
    return searchBean;
  }

  Map toJson() => {
    "data": data,
  };
}