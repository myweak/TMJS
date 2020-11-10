class OfflineStudy {
  int id;
  String bannerImg;
  String title;
  String signupStarttime;
  String signupEndtime;
  String cityName;
  String areaName;
  String detailAddr;
  double price;
  int signupStatus;

  String teacher;
  int payType;
  String content;
  String signupStatusName;
  String studyStarttime;
  String studyEndtime;
  int totalNum;
  int signupNum;



  static OfflineStudy fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    OfflineStudy offlineStudy = OfflineStudy();
    offlineStudy.id = map["id"];
    offlineStudy.bannerImg = map["bannerImg"];
    offlineStudy.title = map["title"];
    offlineStudy.signupStarttime = map["signupStarttime"];
    offlineStudy.signupEndtime = map["signupEndtime"];
    offlineStudy.cityName = map["cityName"];
    offlineStudy.areaName = map["areaName"];
    offlineStudy.detailAddr = map["detailAddr"];
    offlineStudy.price = map["price"];
    offlineStudy.signupStatus = map["signupStatus"];

    offlineStudy.teacher = map["teacher"];
    offlineStudy.payType = map["payType"];
    offlineStudy.content = map["content"];
    offlineStudy.signupStatusName = map["signupStatusName"];
    offlineStudy.studyStarttime = map["studyStarttime"];
    offlineStudy.studyEndtime = map["studyEndtime"];
    offlineStudy.totalNum = map["totalNum"];
    offlineStudy.signupNum = map["signupNum"];
    return offlineStudy;
  }

  Map tojson() => {
    "id": id,
    "bannerImg": bannerImg,
    "title": title,
    "signupStarttime": signupStarttime,
    "signupEndtime": signupEndtime,
    "cityName": cityName,
    "areaName": areaName,
    "detailAddr": detailAddr,
    "price": price,
    "signupStatus": signupStatus,

    "teacher": teacher,
    "payType": payType,
    "content": content,
    "signupStatusName": signupStatusName,
    "studyStarttime": studyStarttime,
    "studyEndtime": studyEndtime,
    "totalNum": totalNum,
    "signupNum": signupNum,
  };
}