import 'package:school/model/special_training.dart';
import 'package:school/provider/view_state_model.dart';
import 'package:school/provider/view_state_refresh_list_model.dart';
import 'package:school/service/app_repository.dart';

class SpecialTrainingModel extends ViewStateRefreshListModel {
  int tagType;
  SpecialTrainingModel({this.tagType:0});


  @override
  Future<List> loadData({int pageNum}) async {
    return await AppRepository.fetchSpecialTraining(pageNum,tagType);
  }

  void changeTagTypeValue(int type){
    tagType = type;
    notifyListeners();
  }
}

class SpecialTrainingDetailModel extends ViewStateModel {
  String type;
  SpecialTrainingDetailModel({this.type});

  SpecialTrainingDetail specialTrainingDetail;

  bool collectionStatus = false;
  bool articleLikeStatus = false;
  bool likeStatus = false;
  int likes = 0;

  int parentId = 0; //评论用户的父id
  String parentName = ""; //评论当前用户的名称

  initData(int id) async {
    setBusy();
    try {
      if(type == "SPECIAL"){
        specialTrainingDetail = await AppRepository.fetchSpecialTrainingDetail(id);
      }else {
        specialTrainingDetail = await AppRepository.fetchCaseTutorialDetail(id);
      }
      collectionStatus = specialTrainingDetail.collectionStatus;
      articleLikeStatus = false;
      setIdle();
    }catch(e, s) {
      setError(e, s);
    }
  }

  ///发布评论
  Future<bool> addComment(String content,String productId,String productType) async {
    setBusy();
    try {
      await AppRepository.fetchAddComment(content, productId,productType);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }

  ///添加收藏
  Future<bool> addCollect(String productId,String type) async {
    setBusy();
    try {
      await AppRepository.fetchAddCollect(productId, type);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }

  ///取消收藏
  Future<bool> deleteCollect(String prodType,String albumId) async {
    setBusy();
    try {
      await AppRepository.fetchDeleteCollect(prodType, albumId);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }

  ///评论列表添加点赞
  Future<bool> addLikeToComment(String commentId) async {
    setBusy();
    try {
      await AppRepository.fetchAddLikeToComment(commentId);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }

  ///文章添加点赞
  Future<bool> addCommonLikes(String type,String objectId) async {
    setBusy();
    try {
      await AppRepository.fetchAddCommonLikes(type,objectId);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }


  ///文章收藏
  void setCollectValue(bool collect){
    collectionStatus = collect;
    notifyListeners();
  }
  ///文章点赞状态
  void setArticleLikeStatus(bool like){
    articleLikeStatus = like;
    notifyListeners();
  }


  ///评论列表点赞数量
  void setLikeValue(int likeValue){
    likes = likeValue;
    notifyListeners();
  }
  ///评论列表点赞数量
  void addLikeValue(){
    likes += 1;
    notifyListeners();
  }
  ///评论列表点赞状态
  void setLikeStatus(bool like){
    likeStatus = like;
    notifyListeners();
  }

  ///评论用户的父id
  void setParentId(int id){
    parentId = id;
    notifyListeners();
  }

  ///评论当前用户的用户名
  void setParentName(String name){
    parentName = name;
    notifyListeners();
  }
}
