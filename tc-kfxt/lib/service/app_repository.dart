import 'package:school/model/apply_class.dart';
import 'package:school/model/case_tutorial.dart';
import 'package:school/model/category_banner.dart';
import 'package:school/model/list_comment.dart';
import 'package:school/model/mine.dart';
import 'package:school/model/offline_study.dart';
import 'package:school/model/search_result.dart';
import 'package:school/model/special_training.dart';
import 'package:school/model/teacher.dart';
import 'package:school/model/teacher_detail.dart';
import 'package:school/model/user.dart';
import 'package:school/net/app_api.dart';

class AppRepository {
  static Future fetchTeachers(int pageNum) async {
    var response = await http.get("app/album/list",queryParameters: {
      "pageNum":pageNum,
      "pageSize":10
    });

    return response.data["records"].map<Teacher>((item) => Teacher.fromMap(item)).toList();
  }

  //搜索热门关键词
  static Future fetchSearchHotKey(String type) async {
    var response = await http.get("app/public/home_component/hotSreach",queryParameters: {
      "type":type,
    });

    return response.data;
  }

  //首页搜索结果
  static Future fetchHomeSearchResult(int pageNum,String keyWork) async {
    var response = await http.get("app/public/home_component/homeSearch",queryParameters: {
      "pageNum":pageNum,
      "pageSize":10,
      "keyWork":keyWork
    });

    return response.data["records"].map<SearchReslut>((item) => SearchReslut.fromMap(item)).toList();
  }

  //名师搜索结果
  static Future fetchTeacherSearchResult(int pageNum,String title) async {
    var response = await http.get("app/album/list",queryParameters: {
      "pageNum":pageNum,
      "pageSize":10,
      "title":title
    });
    return response.data["records"].map<SearchReslut>((item) => SearchReslut.fromMap(item)).toList();
  }


  //线下进修
  static Future fetchOfflineStudy(int pageNum) async {
    var response = await http.get("app/offlinestudy/selectPage",queryParameters: {
      "pageNum":pageNum,
      "pageSize":10,
    });
    return response.data["list"].map<OfflineStudy>((item) => OfflineStudy.fromMap(item)).toList();
  }

  //病例教程
  static Future fetchCaseTutorial(int pageNum) async {
    var response = await http.get("app/caseTutorial/selectPage",queryParameters: {
      "pageNum":pageNum,
      "pageSize":10,
    });
    return response.data["list"].map<CaseTutorial>((item) => CaseTutorial.fromMap(item)).toList();
  }

  //病例教程详情
  static Future fetchCaseTutorialDetail(int id) async {
    var response = await http.get("app/caseTutorial/selectById?id=$id");
    return SpecialTrainingDetail.fromMap(response.data);
  }

  //专项培训
  static Future fetchSpecialTraining(int pageNum,int tagType) async {
    var response = await http.get("app/specialTaining/selectPage",queryParameters: {
      "pageNum":pageNum,
      "pageSize":10,
      "tagType":tagType
    });
    return response.data["list"].map<SpecialTraining>((item) => SpecialTraining.fromMap(item)).toList();
  }
  //专项培训详情
  static Future fetchSpecialTrainingDetail(int id) async {
    var response = await http.get("app/specialTaining/selectById?id=$id");
    return SpecialTrainingDetail.fromMap(response.data);
  }

  //banner列表 type=0病例教程  type=2线下进修
  static Future fetchCategoryBanner(int type) async {
    var response = await http.post("app/categoryBanner/getlist?type=$type");
    return response.data.map<CategoryBanner>((item) => CategoryBanner.fromMap(item)).toList();
  }

  //特别推荐
  static Future fetchRecommend(String type,int currentId) async {
    var response = await http.get("app/common/listRecommend",queryParameters: {
      "type":type,
      "currentId":currentId,
    });
    return response.data.map<SpecialTraining>((item) => SpecialTraining.fromMap(item)).toList();
  }

  //文字评论列表
  static Future fetchListComment(String type,int currentId,int pageNum) async {
    var response = await http.get("app/common/listComment",queryParameters: {
      "type":type,
      "objectId":currentId,
      "pageNum":pageNum,
      "pageSize":10,
    });
    return response.data["list"].map<ListComment>((item) => ListComment.fromMap(item)).toList();
  }


  //发布评论
  static Future fetchAddComment(String content,String productId,String productType,{int parentId = 0}) async {
    var response = await http.post("app/common/addComment", data: {
      "content":content,
      "productId":productId,
      "productType":productType,
      "${parentId!=0?"parentId":""}":parentId
    });
    return true;
  }


  //添加收藏
  static Future fetchAddCollect(String productId,String type) async {
    var response = await http.post("app/collect/add", data: {
      "productId":productId,
      "type":type,
    });
    return true;
  }

  //取消收藏
  static Future fetchDeleteCollect(String albumId,String prodType) async {
    var response = await http.get("app/collect/delete", queryParameters: {
      "prodType":prodType,
      "albumId":albumId,
    });
    return true;
  }

  //评论列表添加点赞
  static Future fetchAddLikeToComment(String commentId) async {
    var response = await http.get("app/common/addLikeToComment", queryParameters: {
      "commentId":commentId,
    });
    return true;
  }

  //文章添加点赞
  static Future fetchAddCommonLikes(String type,String objectId) async {
    var response = await http.get("app/common/likes", queryParameters: {
      "type":type,
      "objectId":objectId,
    });
    return true;
  }


  //名师专栏详情
  static Future fetchAlbumDetail(int id) async {
    var response = await http.get("app/album/getAlbum?id=$id");
    return TeacherDetail.fromJson(response.data);
  }


  //申请开课
  static Future fetchApplyClass() async {
    var response = await http.get("app/startClassRecord/getStartClassRecord");
    return ApplyClass.fromMap(response.data);
  }

  //我的页面
  static Future fetchSummary() async {
    var response = await http.get("app/userInfo/summary");
    return Mine.fromMap(response.data);
  }

  //我的信息
  static Future fetchGetUser() async {
    var response = await http.get("app/userInfo/getUser");
    return User.fromMap(response.data);
  }

  //修改昵称和头像
  static Future fetchUpdateUserInfo(String name) async {
    var response = await http.post("app/userInfo/updateUserInfo", data: {
      "name":name
    });
    return true;
  }

  //登陆
  static Future fetchLogin(String loginType,String username, String password) async {
    var response = await http.post("app/public/login", data: {
      'phone': username,
      loginType: password,
    });
    return User.fromMap(response.data);
  }

  //注册
  static Future fetchRegister(String phone, String password ,String code) async {
    var response = await http.post("app/public/register", data: {
      'phone': phone,
      "password": password,
      'code': code,
    });
    return true;
  }

  //修改密码
  static Future fetchRest(String phone, String password ,String code) async {
    var response = await http.post("app/public/rest", data: {
      'phone': phone,
      "password": password,
      'code': code,
    });
    return true;
  }


  //获取验证码
  static Future fetchGetCode(String phone,String codeType) async {
    var response = await http.post("app/public/code",data: {
      "phone":phone,
      "codeType":codeType
//      codeType
    });
    return true;
  }

}