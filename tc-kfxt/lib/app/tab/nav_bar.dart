import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/common/color_tools.dart';
import 'package:school/tools/app_tools.dart';

sqAppBar(String title,
    {bool canBack = true, String rightButton = "", Function onButtonPressed}) {
  return new DefAppbar(title, canBack, rightButton, onButtonPressed);
//  return AppBar(title: Text(title,textAlign: TextAlign.center,style: new TextStyle(fontSize: 17.0),),elevation: 0,);
}

/**
 * 这是一个可以指定SafeArea区域背景色的AppBar
 * PreferredSizeWidget提供指定高度的方法
 * 如果没有约束其高度，则会使用PreferredSizeWidget指定的高度
 */
class DefAppbar extends StatefulWidget implements PreferredSizeWidget {
//  final double contentHeight; //从外部指定高度
//  final Widget contentChild;  //从外部指定内容
//  final Color statusBarColor; //设置statusbar的颜色
  final String title; //标题
  final bool canBack;
  final String rightButton;
  final Function onButtonPressed;
  DefAppbar(this.title, this.canBack, this.rightButton, this.onButtonPressed)
      : super();

  @override
  State<StatefulWidget> createState() {
    return new _DefAppbarState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(45.0);
}

/**
 * 这里没有直接用SafeArea，而是用Container包装了一层
 * 因为直接用SafeArea，会把顶部的statusBar区域留出空白
 * 外层Container会填充SafeArea，指定外层Container背景色也会覆盖原来SafeArea的颜色
 */
class _DefAppbarState extends State<DefAppbar> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new SafeArea(
        top: true,
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    widget.canBack
                        ? showBackButton()
                        : Container(
                            width: 44,
                            height: 44,
                          ),
                    Expanded(
                        flex: 1,
                        child: Text(widget.title,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(fontSize: 17))),
                    widget.rightButton.isNotEmpty
                        ? showRightButton()
                        : Container(
                            width: 44,
                            height: 44,
                          ),
                    SizedBox(
                      width: 10,
                    )
//                  Container(
//                    width: 44,
//                    height: 44,
//                    child: GestureDetector(
//                      child: Image.asset('assets/images/no_go_left.png',width: 48,height: 58,),
//                      onTap: (){
//                        Navigator.pop(context);
//                      },
//                    ),
//                  ),
                  ],
                ),
                Container(
                  color: SQColor.bgGrayColor,
                  height: 1,
                  width: screenWidth(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showBackButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 44,
        height: 44,
        child: Image.asset('assets/images/back.png'),
      ),
    );
  }

  Widget showRightButton() {
    return GestureDetector(
      onTap: () {
//        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => DashBoardPage()));
        widget.onButtonPressed();
      },
      child: Container(
        width: 40,
        height: 40,
        child: Image.asset(widget.rightButton),
      ),
    );
  }
}
