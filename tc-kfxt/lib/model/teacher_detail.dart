class TeacherDetail {
  int id;
  String title;
  String bannerImg;
  String contentAbstract;
  String content;
  int orderNum;
  double totalPrice;
  int status;
  bool valid;
  bool banner;
  String createTime;
  int hits;
  int likes;
  int comments;
  int collects;
  int shares;
  List<CourseVOS> courseVOS;
  String prodType;
  bool buyGroup;
  int activeState;
  bool collectionStatus;
  bool famousAlbumBuyStatus;

  TeacherDetail(
      {this.id,
        this.title,
        this.bannerImg,
        this.contentAbstract,
        this.content,
        this.orderNum,
        this.totalPrice,
        this.status,
        this.valid,
        this.banner,
        this.createTime,
        this.hits,
        this.likes,
        this.comments,
        this.collects,
        this.shares,
        this.courseVOS,
        this.prodType,
        this.buyGroup,
        this.activeState,
        this.collectionStatus,
        this.famousAlbumBuyStatus});

  TeacherDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bannerImg = json['bannerImg'];
    contentAbstract = json['contentAbstract'];
    content = json['content'];
    orderNum = json['orderNum'];
    totalPrice = json['totalPrice'];
    status = json['status'];
    valid = json['valid'];
    banner = json['banner'];
    createTime = json['createTime'];
    hits = json['hits'];
    likes = json['likes'];
    comments = json['comments'];
    collects = json['collects'];
    shares = json['shares'];
    if (json['courseVOS'] != null) {
      courseVOS = new List<CourseVOS>();
      json['courseVOS'].forEach((v) {
        courseVOS.add(new CourseVOS.fromJson(v));
      });
    }
    prodType = json['prodType'];
    buyGroup = json['buyGroup'];
    activeState = json['activeState'];
    collectionStatus = json['collectionStatus'];
    famousAlbumBuyStatus = json['famousAlbumBuyStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['bannerImg'] = this.bannerImg;
    data['contentAbstract'] = this.contentAbstract;
    data['content'] = this.content;
    data['orderNum'] = this.orderNum;
    data['totalPrice'] = this.totalPrice;
    data['status'] = this.status;
    data['valid'] = this.valid;
    data['banner'] = this.banner;
    data['createTime'] = this.createTime;
    data['hits'] = this.hits;
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['collects'] = this.collects;
    data['shares'] = this.shares;
    if (this.courseVOS != null) {
      data['courseVOS'] = this.courseVOS.map((v) => v.toJson()).toList();
    }
    data['prodType'] = this.prodType;
    data['buyGroup'] = this.buyGroup;
    data['activeState'] = this.activeState;
    data['collectionStatus'] = this.collectionStatus;
    data['famousAlbumBuyStatus'] = this.famousAlbumBuyStatus;
    return data;
  }
}

class CourseVOS {
  int id;
  int albumId;
  String title;
  String videoUrl;
  double price;
  bool preview;
  int doctorId;
  int trialDuration;
  bool bought;

  CourseVOS(
      {this.id,
        this.albumId,
        this.title,
        this.videoUrl,
        this.price,
        this.preview,
        this.doctorId,
        this.trialDuration,
        this.bought});

  CourseVOS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumId = json['albumId'];
    title = json['title'];
    videoUrl = json['videoUrl'];
    price = json['price'];
    preview = json['preview'];
    doctorId = json['doctorId'];
    trialDuration = json['trialDuration'];
    bought = json['bought'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['albumId'] = this.albumId;
    data['title'] = this.title;
    data['videoUrl'] = this.videoUrl;
    data['price'] = this.price;
    data['preview'] = this.preview;
    data['doctorId'] = this.doctorId;
    data['trialDuration'] = this.trialDuration;
    data['bought'] = this.bought;
    return data;
  }
}