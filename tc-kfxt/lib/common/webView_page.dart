import 'dart:core';

import 'package:flutter/material.dart';
import 'package:school/app/tab/nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewPage extends StatefulWidget {
  final String url;
  String title;

  WebViewPage(this.url, this.title);
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    print('👱👱${widget.url}');
    WebViewController _controller;

    return Scaffold(
      appBar: sqAppBar(widget.title),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          ///通过拦截url来实现js与flutter交互
          if (request.url.startsWith('js://webview')) {
            // Fluttertoast.showToast(msg:'JS调用了Flutter By navigationDelegate');
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;

            ///阻止路由替换，不能跳转，因为这是js交互给我们发送的消息
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) async {
          print('Page finished loading: $url');
          await _controller.evaluateJavascript("document.title").then((result) {
            setState(() {
              widget.title = result;
            });
          });
        },
        gestureNavigationEnabled: true,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WebviewScaffold(
  //       clearCache: true,
  //       appBar: renderAppBar(widget.title),
  //       url: widget.url,
  //       withZoom: false,
  //       withLocalStorage: true,
  //       withJavascript: true,
  //     );
  // }

}

JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      });
}
