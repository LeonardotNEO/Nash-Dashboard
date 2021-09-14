import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

String viewID = "your-view-id";

class NashCashView extends StatefulWidget {
  @override
  _NashCashViewState createState() => _NashCashViewState();
}

class _NashCashViewState extends State<NashCashView> {
  WebViewController _controller;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _index,
      children: [
        Center(
          child: CircularProgressIndicator(),
        ),
        Container(
          height: 600,
          width: 500,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets();
              _finishedLoadingNashLink();
            },
            javascriptMode: JavascriptMode.unrestricted,
          ),
        )
      ],
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/index.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  void _finishedLoadingNashLink() {
    setState(() {
      _index = 1;
    });
  }
}
