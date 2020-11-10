import 'package:school/provider/view_state_refresh_list_model.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/view_model/login_model.dart';

class OfflineStudyModel extends ViewStateRefreshListModel {
  LoginModel loginModel;
  OfflineStudyModel({this.loginModel});

  @override
  Future<List> loadData({int pageNum}) async {
    return await AppRepository.fetchOfflineStudy(pageNum);

  }
}
