/*
      "id": 35,
			"title": "第七期：TG-FaMST6 MDT系列研讨会暨病例大赛",
			"bannerImg": "http://imagetc.rrdkf.com/c42cc37ac6250ec0afd6d8a645f0a08b.jpg",
			"contentAbstract": "本期大赛由6位临床一线治疗师讲解骨科围手术期精品病例，并有刘刚主任对各要点进行点评。",
			"totalPrice": 0.00,
			"hits": 172,
			"likes": 0,
			"collects": 3,
			"prodType": "",
			"buyGroup": false,
			"activeState": 0,
			"collectionStatus": false,
			"famousAlbumBuyStatus": false
 */
class Teacher {
  int id;
  String title;
  String bannerImg;
  String contentAbstract;
  double totalPrice;
  int hits;
  int likes;
  int collects;
  String prodType;
  bool buyGroup;
  int activeState;
  bool collectionStatus;
  bool famousAlbumBuyStatus;

  static Teacher fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    Teacher teacherBean = Teacher();
    teacherBean.id = map["id"];
    teacherBean.title = map["title"];
    teacherBean.bannerImg = map["bannerImg"];
    teacherBean.contentAbstract = map["contentAbstract"];
    teacherBean.totalPrice = map["totalPrice"];
    teacherBean.hits = map["hits"];
    teacherBean.likes = map["likes"];
    teacherBean.collects = map["collects"];
    teacherBean.prodType = map["prodType"];
    teacherBean.buyGroup = map["buyGroup"];
    teacherBean.activeState = map["activeState"];
    teacherBean.collectionStatus = map["collectionStatus"];
    teacherBean.famousAlbumBuyStatus = map["famousAlbumBuyStatus"];
    return teacherBean;
  }

  Map tojson() => {
    "id": id,
    "title": title,
    "bannerImg": bannerImg,
    "contentAbstract": contentAbstract,
    "totalPrice": totalPrice,
    "hits": hits,
    "likes": likes,
    "collects": collects,
    "prodType": prodType,
    "buyGroup": buyGroup,
    "activeState": activeState,
    "collectionStatus": collectionStatus,
    "famousAlbumBuyStatus": famousAlbumBuyStatus,
  };
}