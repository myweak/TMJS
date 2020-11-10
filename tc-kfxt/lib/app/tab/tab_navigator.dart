import 'package:flutter/material.dart';
import 'package:school/app/home/page/home_page.dart';
import 'package:school/app/mine/page/mine_page.dart';
import 'package:school/app/teacher/page/teacher_page.dart';
import 'package:school/common/app_init.dart';
import 'package:school/widgets/load_image.dart';

List<Widget> pages = <Widget>[HomePage(), TeacherPage(), MinePage()];

class TabNavigator extends StatefulWidget {
  TabNavigator({Key key}) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  var _pageController = PageController();
  int _selectedIndex = 0;
  DateTime _lastPressed;

  var _tabImages = [
    [
      const LoadAssetImage("tab/home", height: 22.0),
      const LoadAssetImage("tab/home_selected", height: 22.0),
    ],
    [
      const LoadAssetImage("tab/teacher", height: 22.0),
      const LoadAssetImage("tab/teacher_selected", height: 22.0),
    ],
    [
      const LoadAssetImage("tab/mine", height: 22.0),
      const LoadAssetImage("tab/mine_selected", height: 22.0),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    AppUtilInit.screenUtilInit(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (_lastPressed == null ||
              DateTime.now().difference(_lastPressed) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressed = DateTime.now();
            return false;
          }
          return true;
        },
        child: PageView.builder(
          itemBuilder: (ctx, index) => pages[index],
          itemCount: pages.length,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _tabImages[0][0],
            activeIcon: _tabImages[0][1],
            title: Text("首页"),
          ),
          BottomNavigationBarItem(
            icon: _tabImages[1][0],
            activeIcon: _tabImages[1][1],
            title: Text("名师"),
          ),
          BottomNavigationBarItem(
            icon: _tabImages[2][0],
            activeIcon: _tabImages[2][1],
            title: Text("我的"),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  @override
  void initState() {
//    checkAppUpdate(context);
    super.initState();
  }
}
