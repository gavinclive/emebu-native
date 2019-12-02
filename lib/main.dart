import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(emebuColor, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return MaterialApp(
      home: InAppWebViewPage()
    );
  }
}

class InAppWebViewPage extends StatefulWidget {
  @override
  _InAppWebViewPageState createState() => new _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController webView;
  int _page = 2;
  bool _loadError = false;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none && webView != null) {
        print("reload");
        _loadError = false;
        webView.reload();
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize( 
        child: Container(),
        preferredSize: Size.fromHeight(0.0),
      ), 
      body: IndexedStack(
        index: _page,
        children: <Widget>[
            InAppWebView(
              initialUrl: "https://emebu.herokuapp.com/m/login",
              initialHeaders: {},
              initialOptions: InAppWebViewWidgetOptions(
                inAppWebViewOptions: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                  debuggingEnabled: true,
                  userAgent: 'Wolvpack/0.0.1'
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {

              },
              onLoadStop: (InAppWebViewController controller, String url) {
                print(url);
                setState(() {
                  if (!_loadError) {
                    _page = 0;
                  } else {
                    _page = 1;
                  }
                });
              },
              onPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                print(origin);
                print(resources);
                return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
              },
              onLoadError: (InAppWebViewController controller, String url, int code, String message) async {
                print("error $url: $code, $message");
                _loadError = true;
              },
              onLoadHttpError: (InAppWebViewController controller, String url, int statusCode, String description) async {
                print("HTTP error $url: $statusCode, $description");
              },
            ),
            Container(
              color: emebuColor,
              child: Center(
                child: ListView(
                  children: <Widget>[
                    Text("Sorry an error has occured. Please try again later."),
                    Text("Maaf telah terjadi kesalahan. Mohon coba kembali nanti.")
                  ]
                ),
              ),
            ),
            Container(
              color: emebuColor,
              child: Center(
                child: new Image.asset(
                  'assets/image.png',
                  width: 150
                )
              ),
            )
          ])
    );
  }
}

const MaterialColor emebuColor = const MaterialColor(
    0xFF258EFE, const <int, Color>{50: const Color(0xFF258EFE)});
