import 'package:flutter/material.dart';
import 'package:school/widgets/app_bar.dart';

class WidgetNotFound extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DefAppBar(
        centerTitle: "页面不存在",
      ),
      body: Center(
        child: Text(
          "页面不存在"
        ),
      ),
    );
  }
}
