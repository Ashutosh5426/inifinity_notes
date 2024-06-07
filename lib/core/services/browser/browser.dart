import 'dart:async';
// import 'dart:html';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:infinity_notes/core/values/app_colors.dart';

class BrowserService {
  BrowserService._();

  static final BrowserService _instance = BrowserService._();

  factory BrowserService() {
    return _instance;
  }

  // List<BrowserEvent> _events = [];
  // StreamSubscription<BrowserEvent>? _browserEvents;

  // Future<void> openBrowserTab(Uri uri) async {
  //   await FlutterWebBrowser.openWebPage(url: uri.path);
  // }
  //
  // openWebPage (Uri uri) {
  //   if(Platform.isAndroid){
  //     FlutterWebBrowser.openWebPage(
  //       url: 'https://${uri.path}',
  //       customTabsOptions: const CustomTabsOptions(
  //         colorScheme: CustomTabsColorScheme.dark,
  //         darkColorSchemeParams: CustomTabsColorSchemeParams(
  //           toolbarColor: Colors.deepPurple,
  //           secondaryToolbarColor: Colors.green,
  //           navigationBarColor: Colors.amber,
  //           navigationBarDividerColor: Colors.cyan,
  //         ),
  //         shareState: CustomTabsShareState.on,
  //         instantAppsEnabled: true,
  //         showTitle: true,
  //         urlBarHidingEnabled: true,
  //       ),
  //     );
  //   } else if (Platform.isIOS) {
  //     FlutterWebBrowser.openWebPage(
  //       url: "https://flutter.io/",
  //       safariVCOptions: const SafariViewControllerOptions(
  //         barCollapsingEnabled: true,
  //         preferredBarTintColor: Colors.green,
  //         preferredControlTintColor: Colors.amber,
  //         dismissButtonStyle:
  //         SafariViewControllerDismissButtonStyle.close,
  //         modalPresentationCapturesStatusBarAppearance: true,
  //         modalPresentationStyle: UIModalPresentationStyle.popover,
  //       ),
  //     );
  //   }
  // }
}