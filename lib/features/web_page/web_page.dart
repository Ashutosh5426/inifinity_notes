import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_notes/core/values/app_colors.dart';
import 'package:infinity_notes/core/values/constants.dart';
import 'package:infinity_notes/features/notes/notes_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;

  const WebPage({required this.url, super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final WebViewController _webViewController = WebViewController();
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _searchController = TextEditingController();
    _focusNode = FocusNode();

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            _searchController.text = url;
            _webViewController.runJavaScript(_jsCode);
            debugPrint('Page finished loading: $url');
            // _loadTapEventListener();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request){
            if(request.url.contains('googleads.g.')){
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) async {
            _searchController.text = change.url ?? _searchController.text;
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(_getUrl()));

    super.initState();
  }

  // JavascriptChannel _createLongPressListenerJavascriptChannel() {
  //   return JavascriptChannel(
  //     name: 'LongPressListener',
  //     onMessageReceived: (JavascriptMessage message) {
  //       if (message.message == 'linkLongPressed') {
  //         print('User long-pressed on a link');
  //         // Add your code to handle the long-press event here
  //       }
  //     },
  //   );
  // }

  final String _jsCode = '''
    document.addEventListener('click', function() {
      window.flutter_inappwebview.callHandler('onTap');
    });
  ''';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canGoBack = await _webViewController.canGoBack();
        if (canGoBack) {
          _webViewController.goBack();
          return false; // Prevent Flutter's back navigation
        }
        return true; // Allow Flutter's back navigation
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: AppColors.black,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        bool canGoBack = await _webViewController.canGoBack();
                        if (canGoBack) {
                          _webViewController.goBack();
                          return;
                        }
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: _handleSubmitted,
                        style: const TextStyle(color: AppColors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Strings.searchOrEnterAddress,
                          hintStyle: TextStyle(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _webViewController.goForward();
                      },
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _navigatesToNotesPage();
                      },
                      child: const Icon(
                        Icons.edit_note,
                        color: AppColors.white,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: WebViewWidget(
                controller: _webViewController,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                  Factory<TapGestureRecognizer>(
                    () => TapGestureRecognizer()
                      ..onTap = () async {
                        final isVideoPlaying =
                            await _webViewController.runJavaScriptReturningResult(
                            'document.fullscreenElement != null');
                        print('VIDEO: $isVideoPlaying');
                        print('User tapped in WebView');
                        // Add your code to handle the tap event here
                      },
                  ),
                },
              )),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _toggleFullScreen,
        //   child: const Icon(Icons.fullscreen),
        // ),
      ),
    );
  }

  void _handleSubmitted(String value) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return WebPage(url: value);
    }));
    // _browserService.openWebPage(Uri(path: value));
    // _browserService.openBrowserTab(Uri(path: value));

    // FlutterWebBrowser.openWebPage(
    //   url: "https://flutter.io/",
    //   customTabsOptions: CustomTabsOptions(
    //     colorScheme: CustomTabsColorScheme.dark,
    //     darkColorSchemeParams: CustomTabsColorSchemeParams(
    //       toolbarColor: Colors.deepPurple,
    //       secondaryToolbarColor: Colors.green,
    //       navigationBarColor: Colors.amber,
    //       navigationBarDividerColor: Colors.cyan,
    //     ),
    //     shareState: CustomTabsShareState.on,
    //     instantAppsEnabled: true,
    //     showTitle: true,
    //     urlBarHidingEnabled: true,
    //   ),
    // );
  }

  void _navigatesToNotesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotesPage()),
    );
  }

  String _getUrl() {
    if (widget.url.contains('http')) {
      return widget.url;
    }
    return 'https://${widget.url}';
  }

void _toggleFullScreen() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // // Inject JavaScript to toggle full screen
  // await _webViewController.runJavaScript(
  //     'document.querySelector("video").requestFullscreen();');
}

// void _loadTapEventListener() async {
//   // Load the JavaScript function into the WebView
//   await _webViewController.runJavaScript("""
//     function addTapEventListener() {
//       var video = document.querySelector('video');
//
//       if (video) {
//         video.addEventListener('click', function() {
//           // Send tap event to Flutter
//           window.flutter_inappwebview.callHandler('onVideoTap');
//         });
//       }
//     }
//
//     // Call the function when the document is ready
//     document.addEventListener('DOMContentLoaded', addTapEventListener);
//   """);
// }
}
