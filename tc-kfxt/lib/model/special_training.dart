import 'dart:convert' as convert;

class SpecialTraining {
  int id;
  String bannerImg;
  String title;
  String contentAbstract;
  int category;
  int hits;
  int likes;
  int comments;
  double price;
  double totalPrice;
  bool collectionStatus;


  static SpecialTraining fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    SpecialTraining specialTraining = SpecialTraining();
    specialTraining.id = map["id"];
    specialTraining.bannerImg = map["bannerImg"];
    specialTraining.title = map["title"];
    specialTraining.contentAbstract = map["contentAbstract"];
    specialTraining.category = map["category"];
    specialTraining.hits = map["hits"];
    specialTraining.likes = map["likes"];
    specialTraining.comments = map["comments"];
    specialTraining.price = map["price"];
    specialTraining.totalPrice = map["totalPrice"];
    specialTraining.collectionStatus = map["collectionStatus"];
    return specialTraining;
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
    "totalPrice": totalPrice,
    "collectionStatus": collectionStatus,
  };
}


class SpecialTrainingDetail {
  int id;
  String title;
  String bannerImg;
  String contentAbstract;
  String content;
  double price;
  int category;
  int hits;
  int likes;
  int comments;
  bool collectionStatus;
  String createTime;
  String updateTime;

  String caseEvaluation; //评论详情
  String recoveryTarget; //康复目标
  String recovery; //康复治疗
  String mission; //康复宣教


  static SpecialTrainingDetail fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    SpecialTrainingDetail specialTrainingDetail = SpecialTrainingDetail();
    specialTrainingDetail.id = map["id"];
    specialTrainingDetail.bannerImg = map["bannerImg"];
    specialTrainingDetail.title = map["title"];
    specialTrainingDetail.contentAbstract = map["contentAbstract"];
    specialTrainingDetail.content = map["content"];
    specialTrainingDetail.category = map["category"];
    specialTrainingDetail.hits = map["hits"];
    specialTrainingDetail.likes = map["likes"];
    specialTrainingDetail.comments = map["comments"];
    specialTrainingDetail.price = map["price"];
    specialTrainingDetail.collectionStatus = map["collectionStatus"];
    specialTrainingDetail.createTime = map["createTime"];
    specialTrainingDetail.updateTime = map["updateTime"];


    specialTrainingDetail.caseEvaluation = map["caseEvaluation"];
    specialTrainingDetail.recoveryTarget = map["recoveryTarget"];
    specialTrainingDetail.recovery = map["recovery"];
    specialTrainingDetail.mission = map["mission"];
    return specialTrainingDetail;
  }

  Map tojson() => {
    "id": id,
    "bannerImg": bannerImg,
    "title": title,
    "contentAbstract": contentAbstract,
    "content": content,
    "category": category,
    "hits": hits,
    "likes": likes,
    "comments": comments,
    "price": price,
    "collectionStatus": collectionStatus,
    "createTime": createTime,
    "updateTime": updateTime,

    "caseEvaluation": caseEvaluation,
    "recoveryTarget": recoveryTarget,
    "recovery": recovery,
    "mission": mission,
  };
}


class CaseEvaluation {
  List<Tits> tits;

  CaseEvaluation({this.tits});

  CaseEvaluation.fromJson(Map<String, dynamic> json) {
    if (json['tits'] != null) {
      tits = new List<Tits>();
      json['tits'].forEach((v) {
        tits.add(new Tits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tits != null) {
      data['tits'] = this.tits.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tits {
  List<Conts> conts;
  String mName;
  int ob;
  String tit;

  Tits({this.conts, this.mName, this.ob, this.tit});

  Tits.fromJson(Map<String, dynamic> json) {
    if (json['conts'] != null) {
      conts = new List<Conts>();
      json['conts'].forEach((v) {
        conts.add(new Conts.fromJson(v));
      });
    }
    mName = json['mName'];
    ob = json['ob'];
    tit = json['tit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.conts != null) {
      data['conts'] = this.conts.map((v) => v.toJson()).toList();
    }
    data['mName'] = this.mName;
    data['ob'] = this.ob;
    data['tit'] = this.tit;
    return data;
  }
}

class Conts {
  String mName;
  int ob;
  String text;
  List<Urls> urls;

  Conts({this.mName, this.ob, this.text, this.urls});

  Conts.fromJson(Map<String, dynamic> json) {
    mName = json['mName'];
    ob = json['ob'];
    text = json['text'];
    if (json['urls'] != null) {
      urls = new List<Urls>();
      json['urls'].forEach((v) {
        urls.add(new Urls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mName'] = this.mName;
    data['ob'] = this.ob;
    data['text'] = this.text;
    if (this.urls != null) {
      data['urls'] = this.urls.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Urls {
  String type;
  String url;

  Urls({this.type, this.url});

  Urls.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}