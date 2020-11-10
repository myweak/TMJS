import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school/res/colors.dart';

class ChewieProgressColors {
  ChewieProgressColors({
    Color playedColor: Colours.app_main,
    Color handleColor: Colours.app_main,
    Color bufferedColor: Colors.white,
    Color backgroundColor: Colors.grey,
  })  : playedPaint = Paint()..color = playedColor,
        bufferedPaint = Paint()..color = bufferedColor,
        handlePaint = Paint()..color = handleColor,
        backgroundPaint = Paint()..color = backgroundColor;

  final Paint playedPaint;
  final Paint bufferedPaint;
  final Paint handlePaint;
  final Paint backgroundPaint;
}
