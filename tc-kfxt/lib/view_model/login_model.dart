import 'package:school/provider/view_state_model.dart';
import 'package:school/service/app_repository.dart';
import 'package:school/view_model/user_model.dart';

class LoginModel extends ViewStateModel {
  final UserModel userModel;

  LoginModel(this.userModel) : assert(userModel != null);

//  String getLoginName() {
//    return StorageManager.sharedPreferences.getString(kLoginName);
//  }

  Future<bool> login(loginType,phone, password) async {
    setBusy();
    try {
      var user = await AppRepository.fetchLogin(loginType,phone, password);
      userModel.saveUser(user);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }

  Future<bool> logout() async {
    if (!userModel.hasUser) {
      //防止递归
      return false;
    }
    setBusy();
    try {
//      await AppRepository.logout();
      userModel.clearUser();
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }

  ///获取验证码
  Future<bool> getCode(String phone, String codeType) async {
    setBusy();
    try {
      await AppRepository.fetchGetCode(phone, codeType);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e,s);
      return false;
    }
  }
}