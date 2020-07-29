import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class TwitterScreen extends StatefulWidget {
  @override
  _TwitterScreenState createState() => _TwitterScreenState();
}

class _TwitterScreenState extends State<TwitterScreen> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  bool _finished = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          WebView(
            initialUrl: "https://twitter.com/DFS_India?ref_src=twsrc%5Etfw",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (String url) {
              setState(() => _finished = true);
            },
          ),
          if(!_finished)
            Center(child: CircularProgressIndicator()),
        ],
      ) ,
    );
  }
}
