class CategoryBanner {
  int id;
  String bannerImg;
  int providerId;
  String startTime;
  String endTime;

  static CategoryBanner fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    CategoryBanner mine = CategoryBanner();
    mine.id = map["id"];
    mine.bannerImg = map["bannerImg"];
    mine.providerId = map["providerId"];
    mine.startTime = map["startTime"];
    mine.endTime = map["endTime"];
    return mine;
  }

  Map tojson() => {
    "id": id,
    "bannerImg": bannerImg,
    "providerId": providerId,
    "startTime": startTime,
    "endTime": endTime,
  };
}