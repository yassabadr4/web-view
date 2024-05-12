import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

late WebViewController _controller;

class _MyWebViewState extends State<MyWebView> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              zoomEnabled: false,
              initialUrl: 'https://locked-in-app.vercel.app/',
              gestureNavigationEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onWebViewCreated: (WebViewController webViewController) {
                _getUserDataChannel(context);
                _controller = webViewController;
                _cacheUserData('userData');
                _disableZoom();
              },
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                  name: 'flutter_inappwebview',
                  onMessageReceived: (JavascriptMessage message) {},
                ),
              ].toSet(),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void handleFileUpload(String dataUrl) {
    print('File uploaded: $dataUrl');
  }

  JavascriptChannel _getUserDataChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'UserDataChannel',
      onMessageReceived: (JavascriptMessage message) {
        _cacheUserData(message.message);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ModalRoute.of(context)?.addScopedWillPopCallback(() async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      });
    });
  }

  void _disableZoom() async{
    // Disabling zoom using embedded JavaScript
    await _controller.evaluateJavascript('''
      document.addEventListener('gesturestart', function (e) {
        e.preventDefault();
      });
    ''');
  }
}

void _cacheUserData(String userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user_data', userData);
  print('user_data $userData');
}
