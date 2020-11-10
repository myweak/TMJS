import 'package:flutter/material.dart';
import 'package:school/app/home/page/case_tutorial_page.dart';
import 'package:school/app/home/page/special_training_page.dart';
import 'package:school/app/teacher/page/search_delegate.dart';
import 'package:school/res/colors.dart';
import 'package:school/routers/routers.dart';
import 'package:school/util/theme_utils.dart';
import 'package:school/view_model/search_model.dart';
import 'package:school/widgets/app_bar.dart';
import 'package:school/widgets/search.dart';

import 'offline_learning_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: ThemeUtils.getViewBgColor(context),
            title: GestureDetector(
              child: SearchWidget(),
              onTap: () {
                SearchHotKeyModel searchHotKeyModel =
                    SearchHotKeyModel(type: "HOME");
                showSearch(
                    context: context,
                    delegate: DefaultSearchDelegate(
                        type: "HOME",
                        searchHotKeyModel:
                            searchHotKeyModel)); //HOME 首页进入；COLUMN 名师进入
              },
            ),
          ),
          preferredSize: Size.fromHeight(48.0)),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            Container(
              color: ThemeUtils.getViewBgColor(context),
              child: TabBar(
                labelColor: Theme.of(context).primaryColor, //选择颜色
                unselectedLabelColor: ThemeUtils.isDark(context)
                    ? Colours.text_gray
                    : Colours.text,
                indicatorWeight: 1,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.only(bottom: 5.0),

                labelStyle: TextStyle(fontSize: 14),
                tabs: <Widget>[
                  Tab(text: '全部'),
                  Tab(text: '专项培训'),
                  Tab(text: '病例教程'),
                  Tab(text: '线下进修'),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                children: <Widget>[
                  ListViewContnet(),
                  SpecialTrainingPage(),
                  CaseTutorialPage(),
                  OfflineLearningPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListViewContnet extends StatelessWidget {
  const ListViewContnet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
        ListTile(title: Text("111")),
      ],
    );
  }
}
