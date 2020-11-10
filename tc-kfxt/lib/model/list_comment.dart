class ListComment {
  int id;
  String headimg;
  int productId;
  List<ListComment> followList;
  int userId;
  String content;
  int parentId;
  String createTime;
  String phone;
  String nickname;
  bool likeStatus;
  String productType;
  int likes;

  static ListComment fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    ListComment listComment = ListComment();
    listComment.id = map["id"];
    listComment.headimg = map["headimg"];
    listComment.productId = map["productId"];
    listComment.followList = List()..addAll((map['followList'] as List ?? []).map((o) => ListComment.fromMap(o)));
    listComment.userId = map["userId"];
    listComment.content = map["content"];
    listComment.parentId = map["parentId"];
    listComment.createTime = map["createTime"];
    listComment.phone = map["phone"];
    listComment.nickname = map["nickname"];
    listComment.likeStatus = map["likeStatus"];
    listComment.productType = map["productType"];
    listComment.likes = map["likes"];
    return listComment;
  }


  Map tojson() => {
    "id": id,
    "headimg": headimg,
    "productId": productId,
    "followList": followList,
    "userId": userId,
    "content": content,
    "parentId": parentId,
    "createTime": createTime,
    "phone": phone,
    "nickname": nickname,
    "likeStatus": likeStatus,
    "productType": productType,
    "likes": likes,
  };
}



//import 'dart:convert' as convert;
//
//class ListComment {
//  int id;
//  String headimg;
//
//
//  static ListComment fromMap(Map<String, dynamic> map) {
//    if(map == null) return null;
//    ListComment offlineStudy = ListComment();
//    offlineStudy.id = map["id"];
//    offlineStudy.headimg = map["headimg"];
//    return offlineStudy;
//  }
//
//  Map tojson() => {
//    "id": id,
//    "headimg": headimg,
//  };
//}