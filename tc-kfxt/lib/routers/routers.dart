import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/app/home/page/list_comment_page.dart';
import 'package:school/app/login/page/forget_pwd_page.dart';
import 'package:school/app/login/page/login_page.dart';
import 'package:school/app/login/page/register_page.dart';
import 'package:school/app/mine/page/apply_class_page.dart';
import 'package:school/app/mine/page/change_name_page.dart';
import 'package:school/app/mine/page/setting_page.dart';
import 'package:school/app/tab/tab_navigator.dart';
import 'package:school/routers/404.dart';
import 'package:school/widgets/page_route_anim.dart';




//class RouteName {
//  static const String splash = 'splash';
//  static const String tab = '/';
//  static const String search = 'search';
//  static const String setting = 'setting';
//  static const String changename = 'changename';
//  static const String login = 'login';
//
////  static const String login = 'login';
////  static const String register = 'register';
////  static const String articleDetail = 'articleDetail';
////  static const String structureList = 'structureList';
////  static const String favouriteList = 'favouriteList';
////  static const String setting = 'setting';
////  static const String coinRecordList = 'coinRecordList';
////  static const String coinRankingList = 'coinRankingList';
//}
//
//class Routers {
//  static Route<dynamic> generateRoute(RouteSettings settings) {
//    switch (settings.name) {
////      case RouteName.splash:
////        return NoAnimRouteBuilder(SplashPage());
//      case RouteName.tab:
//        return NoAnimRouteBuilder(TabNavigator());
//      case RouteName.setting:
//        return CupertinoPageRoute(builder: (_) => SettingPage());
//      case RouteName.changename:
//        return CupertinoPageRoute(builder: (_) => ChangeNamePage());
//      case RouteName.login:
//        return CupertinoPageRoute(builder: (_) => LoginPage());
//      default:
//        return CupertinoPageRoute(
//            builder: (_) => Scaffold(
//              body: Center(
//                child: Text('No route defined for ${settings.name}'),
//              ),
//            ));
//    }
//  }
//}
//
///// Pop路由
//class PopRoute extends PopupRoute {
//  final Duration _duration = Duration(milliseconds: 300);
//  Widget child;
//
//  PopRoute({@required this.child});
//
//  @override
//  Color get barrierColor => null;
//
//  @override
//  bool get barrierDismissible => true;
//
//  @override
//  String get barrierLabel => null;
//
//  @override
//  Widget buildPage(BuildContext context, Animation<double> animation,
//      Animation<double> secondaryAnimation) {
//    return child;
//  }
//
//  @override
//  Duration get transitionDuration => _duration;
//}



class Routes {

  static const String tab = '/tab';
  static const String setting = '/setting'; //设置
  static const String changename = '/changename'; //修改名称
  static const String login = '/login'; //登陆
  static const String register = '/register'; //注册
  static const String forgetPwd = '/forgetPwd'; //忘记密码
  static const String applyClass = '/applyClass'; //申请开课
  static const String listComment = '/listComment'; //评论页面

  static void configureRoutes(Router router) {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          debugPrint("未找到目标页");
          return WidgetNotFound();
        });


    router.define(tab, handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) => TabNavigator()));

    router.define(login, handler: Handler(handlerFunc: (_, params) => LoginPage()));
    router.define(register, handler: Handler(handlerFunc: (_, params) => RegisterPage()));
    router.define(setting, handler: Handler(handlerFunc: (_, params) => SettingPage()));
    router.define(changename, handler: Handler(handlerFunc: (_, params) => ChangeNamePage(title: null,)));
    router.define(forgetPwd, handler: Handler(handlerFunc: (_, params) => ForgetPwdPage()));
    router.define(applyClass, handler: Handler(handlerFunc: (_, params) => ApplyClassPage()));
    router.define(listComment, handler: Handler(handlerFunc: (_, params) => ListCommentPage()));

//    router.define(webViewPage, handler: Handler(handlerFunc: (_, params){
//      String title = params['title']?.first;
//      String url = params['url']?.first;
//      return WebViewPage(title: title, url: url);
//    }));
  }
}
