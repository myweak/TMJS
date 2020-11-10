class SearchReslut {
  int id;
  String title;
  String contentAbstract;
  double totalPrice;
  String bannerImg;
  String prodType;


  static SearchReslut fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    SearchReslut searchReslut = SearchReslut();
    searchReslut.id = map["id"];
    searchReslut.bannerImg = map["bannerImg"];
    searchReslut.title = map["title"];
    searchReslut.contentAbstract = map["contentAbstract"];
    searchReslut.totalPrice = map["totalPrice"];
    searchReslut.prodType = map["prodType"];
    return searchReslut;
  }

  Map tojson() => {
    "id": id,
    "bannerImg": bannerImg,
    "title": title,
    "contentAbstract": contentAbstract,
    "totalPrice": totalPrice,
    "prodType": prodType,
  };
}