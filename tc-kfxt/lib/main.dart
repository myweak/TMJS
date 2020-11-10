import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:school/app/tab/tab_navigator.dart';
import 'package:school/provider/theme_provider.dart';
import 'package:school/routers/application.dart';
import 'package:school/routers/routers.dart';
import 'package:school/util/storage_utils.dart';

import 'app/login/page/login_page.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  await SpUtil.getInstance();
  runApp(MyApp());

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  MyApp() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    Application.context = context; //设置全局 context
    return FlutterEasyLoading(
        child: OKToast(
      child: ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (_, provider, __) {
            return RefreshConfiguration(
              hideFooterWhenNotFull: true,
              child: MaterialApp(
                theme: provider.getTheme(),
                darkTheme: provider.getTheme(isDarkMode: true),
                localizationsDelegates: const [
                  RefreshLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: const [
                  Locale("zh", "CH"),
//                  Locale("en", "US")
                ],
                locale: const Locale("en", "US"),
                onGenerateRoute: Application.router.generator,
//                initialRoute: RouteName.tab,
                home: showLoginOrHome(),
              ),
            );
          },
        ),
      ),
    ));
  }

  showLoginOrHome() {
    String token = SpUtil.getString("token");
    if (token.isNotEmpty) {
      return TabNavigator();
    } else {
      return LoginPage();
    }
  }
}
