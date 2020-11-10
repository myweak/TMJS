import 'package:school/model/teacher_detail.dart';
import 'package:school/provider/view_state_model.dart';
import 'package:school/provider/view_state_refresh_list_model.dart';
import 'package:school/service/app_repository.dart';

class TeacherListModel extends ViewStateRefreshListModel {
  @override
  Future<List> loadData({int pageNum}) async{
    return await AppRepository.fetchTeachers(pageNum);
  }
}


class TeacherDetailModel extends ViewStateModel {
  String type;
  TeacherDetailModel({this.type});

  TeacherDetail teacherDetail;
  int currentIndex = 0;
  bool collectionStatus = false;
  bool articleLikeStatus = false;
  String urlStr = "";
  int radioGroupA = 0;
  List<int> list = []; //选中视频id
  List<int> checkBoxList = [];

  double totalPrice = 0.0; //合计总价
  double noDiscountPrice = 0.0;//没有打折前的价格
  bool isSelectAllCourse = false;//是否选中全部课程

  initData(int id) async {
    setBusy();
    try {
      teacherDetail = await AppRepository.fetchAlbumDetail(id);
      collectionStatus = teacherDetail.collectionStatus;
      articleLikeStatus = false;
      urlStr = teacherDetail?.courseVOS[0]?.videoUrl??"";

      for(int i = 0;i < teacherDetail.courseVOS.length; i++){
        checkBoxList.add(0);
      }

      //获取所以课程价格的总和
      for(int i = 0;i<teacherDetail?.courseVOS?.length??0;i++){
        CourseVOS courseVOS = teacherDetail.courseVOS[i];
        noDiscountPrice += courseVOS.price;
      }

      setIdle();
    }catch(e, s) {
      setError(e, s);
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

  void setCurrentIndex(int value){
    currentIndex = value;
    notifyListeners();
  }

  void setRadioGroupA(int value){
    radioGroupA = value;
    notifyListeners();
  }

  ///单个课程选中按钮点击
  void setCourseVOSList(int index,bool val,CourseVOS courseVOS){
    checkBoxList[index] = val?1:0;

    if(val){
      list.add(courseVOS.id);
      totalPrice += courseVOS.price;
    }else{
      if(list.length > 0){
        list.remove(courseVOS.id);
      }
      totalPrice -= courseVOS.price;
      if(totalPrice <= 0){
        totalPrice = 0.0;
      }
    }

    ///判断是否全部选中状态
    if(list.length == checkBoxList.length){
      isSelectAllCourse = true;
    }else{
      isSelectAllCourse = false;
    }
    notifyListeners();
  }

  ///全选按钮点击
  void setSelectAllCourse(bool val,List<dynamic> courseList){
    isSelectAllCourse = val;
    totalPrice = 0.0;
    list.clear();
    checkBoxList.clear();

    for(int i = 0;i<courseList.length;i++){
      checkBoxList.insert(i, val?1:0);
    }

    for(int i = 0;i<courseList.length;i++){
      CourseVOS courseVOS = courseList[i];
      if(val){
        list.add(courseVOS.id);
        totalPrice += courseVOS.price;
      }else{
        if(list.length > 0){
          list.remove(courseVOS.id);
        }

        totalPrice -= courseVOS.price;
        if(totalPrice <= 0){
          totalPrice = 0.0;
        }
      }
    }
    notifyListeners();
  }
}
