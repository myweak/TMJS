import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/common/common.dart';
import 'package:school/net/api.dart';
import 'package:school/util/storage_utils.dart';
import 'package:school/util/toast.dart';

class Api {
  Api() {}
  get user_agreement {
    //产生
    String urlStr = "https://tcpatient.rrdkf.com/#/user-agreement"; //用户协议地址
    assert(() {
      urlStr =
          "https://tmwechat.dev.goto-recovery.com/#/user-agreement"; //用户协议地址
    }());
  }
}

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = 'http://tcapi.rrdkf.com/';
    assert(() {
      // options.baseUrl = 'https://dev.goto-recovery.com/tc/';
      options.baseUrl = 'https://uat.goto-recovery.com/tc/';
    }());
//    options.baseUrl = 'http://tcuat.rrdkf.com/';
    interceptors
      ..add(ApiInterceptor())
      // cookie持久化 异步
      ..add(CookieManager(
          PersistCookieJar(dir: StorageManager.temporaryDirectory.path)));
  }
}

/// 玩Android API
class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}');
//    debugPrint('---api-request--->data--->${options.data}');
    return options;
  }

  @override
  onResponse(Response response) {
    debugPrint('---api-response--->resp----->${response.data}');
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      if (null != respData.token) {
        SpUtil.putString(Constant.token, respData.token);
      }
      response.data = respData.data;
      return http.resolve(response);
    } else {
      if (respData.code == 401) {
        SpUtil.putString(Constant.token, "");
        throw const UnAuthorizedException(); // 需要登录
      } else {
        throw NotSuccessException.fromRespData(respData);
      }
    }
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'];
    token = json['token'];
  }
}
