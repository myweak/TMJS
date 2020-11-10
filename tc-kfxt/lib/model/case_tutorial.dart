import 'dart:convert' as convert;
class CaseTutorial {
  int id;
  List<dynamic> bannerImg;
  String title;
  String contentAbstract;
  int category;
  int hits;
  int likes;
  int comments;
  double price;
  bool collectionStatus;


  static CaseTutorial fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    CaseTutorial offlineStudy = CaseTutorial();
    offlineStudy.id = map["id"];
    offlineStudy.bannerImg = convert.jsonDecode(map["bannerImg"]);
    offlineStudy.title = map["title"];
    offlineStudy.contentAbstract = map["contentAbstract"];
    offlineStudy.category = map["category"];
    offlineStudy.hits = map["hits"];
    offlineStudy.likes = map["likes"];
    offlineStudy.comments = map["comments"];
    offlineStudy.price = map["price"];
    offlineStudy.collectionStatus = map["collectionStatus"];
    return offlineStudy;
  }

  Map tojson() => {
    "id": id,
    "bannerImg": bannerImg,
    "title": title,
    "contentAbstract": contentAbstract,
    "category": category,
    "hits": hits,
    "likes": likes,
    "comments": comments,
    "price": price,
    "collectionStatus": collectionStatus,
  };
}