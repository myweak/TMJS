import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school/provider/provider_widget.dart';
import 'package:school/provider/view_state_list_model.dart';
import 'package:school/view_model/search_model.dart';

class SearchSuggestions<T> extends StatelessWidget {
  final SearchDelegate<T> delegate;
  final String type;
  SearchSuggestions({@required this.delegate,this.type});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: IconTheme(
                data: Theme.of(context)
                    .iconTheme
                    .copyWith(opacity: 0.6, size: 16),
                child: MultiProvider(
                  providers: [
                    Provider<TextStyle>.value(
                        value: Theme.of(context).textTheme.body1),
                    ProxyProvider<TextStyle, Color>(
                      update: (context, textStyle, _) =>
                          textStyle.color.withOpacity(0.5),
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SearchHistoriesWidget(delegate: delegate),
                      SearchHotKeysWidget(delegate: delegate,type: type),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchHotKeysWidget extends StatefulWidget {
  final SearchDelegate delegate;
  final String type;
  SearchHotKeysWidget({@required this.delegate,this.type, key}) : super(key: key);

  @override
  _SearchHotKeysWidgetState createState() => _SearchHotKeysWidgetState();
}

class _SearchHotKeysWidgetState extends State<SearchHotKeysWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Provider.of<SearchHotKeyModel>(context).initData();
      ProviderWidget<SearchHotKeyModel>(
        model: SearchHotKeyModel(type: widget.type),
        onModelReady: (model){
          model.initData();
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "热门搜索",
                  style: Provider.of<TextStyle>(context),
                ),
              ),
              Consumer<SearchHotKeyModel>(
                builder: (context, model, _) {
                  return Visibility(
                      visible: !model.busy,
                      child: model.idle
                          ? FlatButton.icon(
                              textColor: Provider.of<Color>(context),
                              onPressed: model.shuffle,
                              icon: Icon(
                                Icons.autorenew,
                              ),
                              label: Text(
                                "换一换",
                              ))
                          : FlatButton.icon(
                              textColor: Provider.of<Color>(context),
                              onPressed: model.initData,
                              icon: Icon(Icons.refresh),
                              label: Text("重试")));
                },
              )
            ],
          ),
        ),
        SearchSuggestionStateWidget<SearchHotKeyModel, String>(
          builder: (context, item) => ActionChip(
            label: Text(item),
            onPressed: () {
              widget.delegate.query = item;
              widget.delegate.showResults(context);
            },
          ),
        ),
      ],
    );
  }
}

class SearchHistoriesWidget<T> extends StatefulWidget {
  final SearchDelegate<T> delegate;

  SearchHistoriesWidget({@required this.delegate, key}) : super(key: key);

  @override
  _SearchHistoriesWidgetState createState() => _SearchHistoriesWidgetState();
}

class _SearchHistoriesWidgetState extends State<SearchHistoriesWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Provider.of<SearchHistoryModel>(context).initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "历史搜索",
                  style: Provider.of<TextStyle>(context),
                ),
              ),
              Consumer<SearchHistoryModel>(
                builder: (context, model, child) => Visibility(
                    visible: !model.busy && !model.empty,
                    child: model.idle
                        ? FlatButton.icon(
                            textColor: Provider.of<Color>(context),
                            onPressed: model.clearHistory,
                            icon: Icon(Icons.clear),
                            label: Text("清空"))
                        : FlatButton.icon(
                            textColor: Provider.of<Color>(context),
                            onPressed: model.initData,
                            icon: Icon(Icons.refresh),
                            label: Text("重试"))),
              ),
            ],
          ),
        ),
        SearchSuggestionStateWidget<SearchHistoryModel, String>(
          builder: (context, item) => ActionChip(
            label: Text(item),
            onPressed: () {
              widget.delegate.query = item;
              widget.delegate.showResults(context);
            },
          ),
        ),
      ],
    );
  }
}

class SearchSuggestionStateWidget<T extends ViewStateListModel, E>
    extends StatelessWidget {
  final Widget Function(BuildContext context, E data) builder;

  SearchSuggestionStateWidget({@required this.builder});

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
        builder: (context, model, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: model.idle
                  ? Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      children: List.generate(model.list.length, (index) {
                        E item = model.list[index];
                        return builder(context, item);
                      }),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      alignment: Alignment.center,
                      child: Builder(builder: (context) {
                        if (model.busy) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: CupertinoActivityIndicator(),
                          );
                        } else if (model.error) {
                          return const Icon(
                            Icons.error,
                            size: 60,
                            color: Colors.grey,
                          );
                        } else if (model.empty) {
                          return const Icon(
                            Icons.hourglass_empty,
                            size: 70,
                            color: Colors.grey,
                          );
                        }
                        return SizedBox.shrink();
                      }),
                    ),
            ));
  }
}
