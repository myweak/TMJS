import 'package:school/model/category_banner.dart';
import 'package:school/provider/view_state_model.dart';
import 'package:school/provider/view_state_refresh_list_model.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/view_model/special_training_model.dart';

class CaseTutorialModel extends ViewStateRefreshListModel {
  @override
  Future<List> loadData({int pageNum}) async {
    return await AppRepository.fetchCaseTutorial(pageNum);
  }
}

class CaseTutorialDetailModel extends ViewStateModel {

  SpecialTrainingDetailModel specialTrainingDetail;
  initData(int id) async {
    setBusy();
    try {
      specialTrainingDetail = await AppRepository.fetchCaseTutorialDetail(id);
      setIdle();
    }catch(e, s) {
      setError(e, s);
    }
  }
}


class CaseTutorialBannerModel extends ViewStateModel {

  List<CategoryBanner> list;
  initData(int type) async {
    setBusy();
    try {
      list = await AppRepository.fetchCategoryBanner(type);
      setIdle();
    }catch(e, s) {
      setError(e, s);
    }
  }
}