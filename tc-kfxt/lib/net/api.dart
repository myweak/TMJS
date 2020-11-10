import 'dart:convert';

import 'package:dio/native_imp.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:school/common/common.dart';

export 'package:dio/dio.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class BaseHttp extends DioForNative {
  BaseHttp() {
    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors..add(HeaderInterceptor());
    init();
  }

  void init();
}

/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    options.connectTimeout = 1000 * 45;
    options.receiveTimeout = 1000 * 45;

//    options.headers['token'] = "eyJhbGciOiJIUzUxMiIsInppcCI6IkRFRiJ9.eNoUzTsOwyAQRdG9ULtgGIYB78BNtmDxs0IigxRwFWXvwc0rro70vuI1iliFxcPLwxEggDYuBYaZSFrKzstMYhH9ChO2pJyTULfHNrfGoqQ8t0epSakG5Zyw9D4hWKOQyGnmu_khViBm1IaRF3H1_NlLuq-VklO08cx1H-2d64yBokGIwORREx2WjYs6RY0Kgw5S_P4AAAD__w.BhI8gvenMIM7nG3P93SZoZahAdRis1FqJhtc8X0DH9xh1gd1K_mgP82rXCyHtVWo57GrrWdwG_eoRdpdACM19g";
    options.headers['token'] = SpUtil.getString(Constant.token);
    options.headers['appid'] = Constant.appId;
    return options;
  }
}

/// 子类需要重写
abstract class BaseResponseData {
  int code = 0;
  String msg;
  String token;
  dynamic data;
  bool get success;
  BaseResponseData({this.code, this.msg, this.token, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $msg, token: $token, data: $data}';
  }
}


/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  String message;

  NotSuccessException.fromRespData(BaseResponseData respData) {
    message = respData.msg;
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}


