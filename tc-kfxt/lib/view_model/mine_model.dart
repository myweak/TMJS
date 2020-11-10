import 'package:school/model/apply_class.dart';
import 'package:school/model/mine.dart';
import 'package:school/provider/view_state_model.dart';
import 'package:school/service/app_repository.dart';

///申请开课
class ApplyClassModel extends ViewStateModel {
  ApplyClass applyClass;
  initData() async {
    setBusy();
    try {
      applyClass = await AppRepository.fetchApplyClass();
      setIdle();
    }catch(e, s) {
      setError(e, s);
    }
  }
}

///我的页面
class MineModel extends ViewStateModel {
  Mine mine;
  initData() async {
    setBusy();
    try {
      mine = await AppRepository.fetchSummary();
      setIdle();
    }catch(e, s) {
      setError(e, s);
    }
  }
}