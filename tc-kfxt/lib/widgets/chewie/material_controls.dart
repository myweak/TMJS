import 'dart:async';
import 'dart:ui' as ui;
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:school/res/dimens.dart';
import 'package:school/res/gaps.dart';
import 'package:school/widgets/chewie/chewie_player.dart';
import 'package:school/widgets/chewie/video_progress_colors.dart';
import 'package:school/widgets/chewie/material_progress_bar.dart';
import 'package:school/widgets/chewie/utils.dart';
import 'package:school/widgets/load_image.dart';
import 'package:video_player/video_player.dart';

class MaterialControls extends StatefulWidget {
  const MaterialControls({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MaterialControlsState();
  }
}

class _MaterialControlsState extends State<MaterialControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  final barHeight = 48.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  ChewieController chewieController;

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
        context,
        chewieController.videoPlayerController.value.errorDescription,
      ) : Center(
        child: Icon(
          Icons.error,
          color: Colors.white,
          size: 42,
        ),
      );
    } else if((chewieController.videoPayStatus == 1)) {///视频试看
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black87,
                  ),
                  height: 60,
                  child: FlatButton(
                    onPressed: (){
                      chewieController.setVideoPayStatus(2);///点击试看，进入试看状态
                      controller.play();
                    },
                    child: Text(
                      '试看',
                      maxLines: 1,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if((chewieController.videoPayStatus == 2) && (_latestValue.position.inMinutes >= chewieController.trialDuration)) { ///免费试看时间到

      _hideStuff = true;
      _hideTimer?.cancel();
      controller.pause();
      chewieController.setVideoPayStatus(3);

    }else if(chewieController.videoPayStatus == 3){ ///付费才能观看
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.0),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: (){
                    chewieController.setVideoPayStatus(4);
                    controller.play();
                  },
                  child: Center(
                    child: LoadImage("teacher/player/pay_lock",width: 50.0,height: 50.0,),
                  ),
                ),
              ),
            ),
            Container(
              height: 30.0,
              padding: EdgeInsets.only(left: 10.0,bottom: 10.0),
              child: Text(
                "当前内容需要购买才可以观看哦",
                style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Column(
            children: <Widget>[
              Container(
                height: barHeight,
              ),
              _latestValue != null &&
                          !_latestValue.isPlaying &&
                          _latestValue.duration == null ||
                      _latestValue.isBuffering || ((_latestValue.position.inMilliseconds <= 0))
                  ? const Expanded(
                      child: const Center(
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : _buildHitArea(),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(BuildContext context) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        height: barHeight,
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: chewieController.videoPayStatus == 3,
                  child: Container(
                    height: 10,
                  ),
                ),
                _buildPlayPause(controller),
                chewieController.isLive
                    ? Expanded(child: const Text('LIVE'))
                    : _buildPosition(),
                chewieController.isLive ? const SizedBox() : _buildProgressBar(),
                chewieController.allowFullScreen
                    ? _buildExpandButton()
                    : Container(),
              ],
            ),
            Visibility(
              visible: chewieController.videoPayStatus == 3,
              child: Positioned(
                top: 0.0,
                left: 20.0,
                child: Text(
                  "试看中你可以试看了了",
                  style: TextStyle(
                      fontSize: Dimens.font_sp10
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    int videoPayStatus = chewieController.videoPayStatus;
    return Expanded(
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: AnimatedOpacity(
            opacity:
            _latestValue != null && !_latestValue.isPlaying && !_dragging
                ? 1.0
                : 0.0,
            duration: Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () {
                if (_latestValue != null && _latestValue.isPlaying) {
                  if (_displayTapped) {
                    if(this.mounted){
                      setState(() {
                        _hideStuff = true;
                      });
                    }
                  } else
                    _cancelAndRestartTimer();
                } else {
                  _playPause();

                  if(this.mounted){
                    setState(() {
                      _hideStuff = true;
                    });
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(48.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.play_arrow, size: 32.0,color: Colors.white,),
//                  child: Icon((videoPayStatus==0)?Icons.remove_red_eye:((videoPayStatus==1)?Icons.payment:Icons.play_arrow), size: 32.0,color: Colors.white,),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 8.0, right: 4.0),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPosition() {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: Text(
        '${formatDuration(position)}/${formatDuration(duration)}',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    if(this.mounted){
      setState(() {
        _hideStuff = false;
        _displayTapped = true;
      });
    }
  }

  Future<Null> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        if(this.mounted){
          setState(() {
            _hideStuff = false;
          });
        }
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        if(this.mounted){
          setState(() {
            _cancelAndRestartTimer();
          });
        }
      });
    });
  }

  void _playPause() {

    bool isFinished = _latestValue.position >= _latestValue.duration;
    if(this.mounted){
      setState(() {
        if (controller.value.isPlaying) {
          _hideStuff = false;
          _hideTimer?.cancel();
          controller.pause();
        } else {
          _cancelAndRestartTimer();

          if (!controller.value.initialized) {
            controller.initialize().then((_) {
              controller.play();
            });
          } else {
            if (isFinished) {
              controller.seekTo(Duration(seconds: 0));
            }
            controller.play();
          }
        }
      });
    }
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if(this.mounted){
        setState(() {
          _hideStuff = true;
        });
      }

    });
  }

  void _updateState() {
    if(this.mounted){
      setState(() {
        _latestValue = controller.value;
      });
    }
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            if(this.mounted){
              setState(() {
                _dragging = true;
              });
            }

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            if(this.mounted){
              setState(() {
                _dragging = false;
              });
            }

            _startHideTimer();
          },
//          colors: chewieController.materialProgressColors ??
//              ChewieProgressColors(
//                  playedColor: Theme.of(context).accentColor,
//                  handleColor: Theme.of(context).accentColor,
//                  bufferedColor: Theme.of(context).backgroundColor,
//                  backgroundColor: Theme.of(context).disabledColor),
        ),
      ),
    );
  }
}
