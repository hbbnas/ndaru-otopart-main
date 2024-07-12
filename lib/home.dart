import 'dart:async';
// import 'dart:io';
// import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({super.key});

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController ? _webViewController;

  @override
  void initState() {
    super.initState();
  }

Future<bool> onWillPop({required BuildContext context}) async {
    if (await _webViewController!.canGoBack()) {
      _webViewController!.goBack();
      print("Masuk Sini");
      return Future.value(false);
    } else {
      // ignore: use_build_context_synchronously
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => CupertinoAlertDialog(
          title: Text(
            'Peringatan!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar Aplikasi?',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              height: 1.4,
            ),
          ),
          actions: [
            CupertinoButton(
              child: Text(
                'YA',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.red.shade700,
                  fontSize: 16.0
                ),
              ), 
              onPressed: (){
                SystemNavigator.pop();
              }
            ),
            CupertinoButton(
              child: Text(
                'TIDAK',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.blue.shade600,
                ),
              ), 
              onPressed: (){
                Navigator.of(context).pop();
              }
            )
          ],
        )
      );
      return Future.value(true);
    }
  }



// 


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context: context),
      child: Scaffold(
          body: Container(
              child: Column(children: <Widget>[
                Expanded(
                  child: Container(
                    child: InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: Uri.parse('https://hbbnas.github.io/ndaru-otopart/')),
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            mediaPlaybackRequiresUserGesture: true,
                            allowFileAccessFromFileURLs: true,
                            javaScriptEnabled: true,
                            allowUniversalAccessFromFileURLs: true,
                          ),

                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          _webViewController = controller;
                        },
                        
                        onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
                          print("Error $code: $message");
                        },
                        
                        androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                          return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                        }
                    ),
                  ),
                ),
              ]))
      ),
    );
  }
}

