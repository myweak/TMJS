import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school/routers/fluro_navigator.dart';
import 'package:school/widgets/chewie/chewie_player.dart';
import 'package:school/widgets/chewie/material_controls.dart';
import 'package:video_player/video_player.dart';

class PlayerWithControls extends StatelessWidget {
  PlayerWithControls({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    return Center(
      child: Container(
        width: ScreenUtil.getScreenW(context),
        height: ScreenUtil.getScreenW(context)*0.6,
        child: AspectRatio(
          aspectRatio:
              chewieController.aspectRatio ?? _calculateAspectRatio(context),
          child: _buildPlayerWithControls(chewieController, context),
        ),
      ),
    );
  }

  Container _buildPlayerWithControls(ChewieController chewieController, BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: ScreenUtil.getScreenW(context),
            height: ScreenUtil.getScreenW(context)*0.6,
            child: chewieController.placeholder ?? Container(),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: chewieController.aspectRatio ??
                  _calculateAspectRatio(context),
              child: VideoPlayer(chewieController.videoPlayerController),
            ),
          ),
          chewieController.overlay ?? Container(),
          _buildControls(context, chewieController),
          _buildHeader(context,""), ///头部返回和分享按钮
        ],
      ),
    );
  }

  AnimatedOpacity _buildHeader(BuildContext context, String title) {
    final iconColor = Theme.of(context).primaryColor;
    return new AnimatedOpacity(
      opacity: 1.0,
      duration: new Duration(milliseconds: 300),
      child: new Container(
        padding: EdgeInsets.only(top: ScreenUtil.getStatusBarH(context)),
        height: 44+ScreenUtil.getStatusBarH(context),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: ScreenUtil.getStatusBarH(context),
            ),
            new IconButton( ///返回按钮
              onPressed: (){
                NavigatorUtils.goBack(context);
              },
              color: iconColor,
              icon: new Icon(Icons.arrow_back_ios),
            ),
            Spacer(),
            new IconButton( ///分享按钮
              onPressed: (){},
              color: iconColor,
              icon: new Icon(Icons.share),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, ChewieController chewieController) {
    return chewieController.showControls
        ? chewieController.customControls != null
            ? chewieController.customControls:MaterialControls()
//            : Theme.of(context).platform == TargetPlatform.android
//                ? MaterialControls()
//                : CupertinoControls(
//                    backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
//                    iconColor: Color.fromARGB(255, 200, 200, 200),
//                  )
        : Container();
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}
