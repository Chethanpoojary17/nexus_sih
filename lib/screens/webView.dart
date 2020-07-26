import 'dart:async';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;


  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  bool _finished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.selectedUrl,
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
        ));
  }
}