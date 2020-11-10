import 'package:school/model/special_training.dart';
import 'package:school/provider/view_state_model.dart';
import 'package:school/provider/view_state_refresh_list_model.dart';
import 'package:school/service/app_repository.dart';

class RecommendModel extends ViewStateRefreshListModel {
  String type;
  int currentId;
  RecommendModel({this.type, this.currentId});

  @override
  Future<List> loadData({int pageNum}) async {
    return await AppRepository.fetchRecommend(type,currentId);
  }
}
