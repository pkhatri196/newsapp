import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class NewsView extends StatefulWidget {
  final String url;
  NewsView(this.url);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
 late String finalUrl;
  final Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  void initState() {
    if(widget.url.toString().contains("http://")){
      finalUrl=widget.url.toString().replaceAll("http://","https://");
    }
    else{
      finalUrl=widget.url;
    }
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Pk news"),
        centerTitle: true,
        backgroundColor:Colors.purple,
      ),
      body:Container(
        child: WebView(
          initialUrl:finalUrl,
          javascriptMode:JavaScriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController){
            setState(() {
              controller.complete(webViewController);
            });
          },
        )
      ),
    );
  }
}

