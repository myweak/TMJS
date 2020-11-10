import 'package:flutter/material.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/widgets/app_bar.dart';

/// 由于app不管明暗模式,都是有底色
/// 所以将indicator颜色为亮色
class AppIndicator extends StatelessWidget {
  final String title;
  AppIndicator({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefAppBar(
          centerTitle: title,
        ),
        body: Center(
          child: Container(
            color: ThemeUtils.getBackgroundColor(context),
            child: CircularProgressIndicator(),
          ),
        )
    );
  }
}


class AppIndicatorNoBar extends StatelessWidget {
  AppIndicatorNoBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            color: ThemeUtils.getBackgroundColor(context),
            child: CircularProgressIndicator(),
          ),
        )
    );
  }
}