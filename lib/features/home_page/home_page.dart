import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:infinity_notes/core/services/browser/browser.dart';
import 'package:infinity_notes/core/services/db/db.dart';
import 'package:infinity_notes/core/services/db/entity.dart';
import 'package:infinity_notes/core/uuid/unique_id.dart';
import 'package:infinity_notes/core/values/app_colors.dart';
import 'package:infinity_notes/core/values/constants.dart';
import 'package:infinity_notes/features/notes/notes_page.dart';
import 'package:infinity_notes/features/web_page/web_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 100),

              /// Search bar
              Container(
                width: double.maxFinite,
                height: 50,
                padding: const EdgeInsets.only(left: 22),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextFormField(
                  controller: _controller,
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

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),

      /// Bottom sheet
      bottomSheet: Container(
        width: double.maxFinite,
        height: 54,
        decoration: const BoxDecoration(
            color: AppColors.black,
            border:
                Border(top: BorderSide(color: AppColors.white, width: 0.5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
            GestureDetector(
              onTap: () {
                if (PictureInPicture.isActive) {
                  PictureInPicture.stopPiP();
                } else {
                  PictureInPicture.startPiP(
                    pipWidget: PiPWidget(
                      onPiPClose: () {},
                      child: InkWell(
                        onTap: () {
                          Clipboard.getData('text/plain').then((value) {
                            log(value?.text ?? '');
                            if ((value?.text != null)) {
                              print("Clipboard data: ${value?.text}");
                              Database().instance.addPerson(
                                    Person(
                                        name: value!.text!,
                                        age: 0,
                                        personId: UniqueId.generateV1()),
                                  );
                            }
                          });
                        },
                        child: const Icon(
                          Icons.note_add,
                          size: 40,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.copy_sharp,
                color: AppColors.white,
                size: 28,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.settings,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String value) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_){
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
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   OverlayEntry? _overlayEntry;
//   bool _isShowingWindow = false;
//   bool _isUpdatedWindow = false;
//   SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
//   static const String _mainAppPort = 'MainApp';
//   final _receivePort = ReceivePort();
//   SendPort? homePort;
//   String? latestMessageFromOverlay;
//   late TextEditingController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initPlatformState();
//     _requestPermissions();
//     _controller = TextEditingController();
//     if (homePort != null) return;
//     _initOverlayCommunication();
//   }
//
//   void _initOverlayCommunication() {
//     final res = IsolateNameServer.registerPortWithName(
//       _receivePort.sendPort,
//       _mainAppPort,
//     );
//     log("$res: OVERLAY");
//     _receivePort.listen((message) {
//       Clipboard.getData('text/plain').then((value) {
//         log(value?.text ?? '');
//         if ((value?.text != null)) {
//           Database().instance.addPerson(
//                 Person(
//                     name: value!.text!,
//                     age: 0,
//                     personId: UniqueId.generateV1()),
//               );
//         }
//       });
//       // log("message from OVERLAY: $message");
//     });
//   }
//
//   @override
//   void dispose() {
//     SystemAlertWindow.removeOnClickListener();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {}
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             const Text('System Alert Window Example App \n with flutterview'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: MaterialButton(
//                 onPressed: _showOverlayWindow,
//                 textColor: Colors.white,
//                 color: Colors.deepOrange,
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: !_isShowingWindow
//                     ? const Text("Show system alert window")
//                     // : !_isUpdatedWindow
//                     // ? const Text("Update system alert window")
//                     : const Text("Close system alert window"),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: MaterialButton(
//                 onPressed: () =>
//                     SystemAlertWindow.sendMessageToOverlay("message from main"),
//                 textColor: Colors.white,
//                 child: Text("send message to overlay"),
//                 color: Colors.deepOrange,
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//               ),
//             ),
//             // TextButton(
//             //     onPressed: () async {
//             //       String? logFilePath = await SystemAlertWindow.getLogFile;
//             //       if (logFilePath != null && logFilePath.isNotEmpty) {
//             //         // Share.shareFiles([logFilePath]);
//             //       } else {
//             //         print("Path is empty");
//             //       }
//             //     },
//             //     child: Text("Back Pip")),
//
//             const SizedBox(height: 20),
//
//             OutlinedButton(
//               onPressed: () async {
//                 PictureInPicture.startPiP(
//                     pipWidget:PiPWidget(
//                       onPiPClose: (){
//                         //Handle closing events e.g. dispose controllers.
//
//                       },
//                       elevation: 10,        //Optional
//                       pipBorderRadius: 10,
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Clipboard.getData('text/plain').then((value) {
//                             log(value?.text ?? '');
//                             if ((value?.text != null)) {
//                               print("Clipboard data: ${value?.text}");
//                               Database().instance.addPerson(
//                                 Person(
//                                     name: value!.text!,
//                                     age: 0,
//                                     personId: UniqueId.generateV1()),
//                               );
//                             }
//                           });
//                         },
//                         child: const Text('Pip Mode'),
//                       ),  //Optional
//                     )
//                 );
//               },
//               child: Text('Paste'),
//             ),
//
//             OutlinedButton(
//               onPressed: (){
//                 PictureInPicture.stopPiP();
//               },
//               child: Text('Exit Pip Mode'),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _controller,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   OutlinedButton(
//                     onPressed: () {
//                       Database().instance.addPerson(
//                             Person(
//                                 name: _controller.text,
//                                 age: 0,
//                                 personId: UniqueId.generateV1()),
//                           );
//                       _controller.clear();
//                       print(Database().instance.getAllPeople());
//                     },
//                     child: const Text('See Notes'),
//                   ),
//                 ],
//               ),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const NotesPage(),
//                   ),
//                 );
//               },
//               child: const Text('See Notes'),
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> _initPlatformState() async {
//     await SystemAlertWindow.enableLogs(true);
//     String? platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await SystemAlertWindow.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//     if (!mounted) return;
//   }
//
//   Future<void> _requestPermissions() async {
//     await SystemAlertWindow.requestPermissions(prefMode: prefMode);
//   }
//
//   void _showOverlayWindow() async {
//     if (!_isShowingWindow) {
//       await SystemAlertWindow.sendMessageToOverlay('show system window');
//       SystemAlertWindow.showSystemWindow(
//         height: 40,
//         width: 100,
//         // width: MediaQuery.of(context).size.width.floor(),
//         gravity: SystemWindowGravity.CENTER,
//         prefMode: prefMode,
//       );
//       setState(() {
//         _isShowingWindow = true;
//       });
//     }
//     // else if (!_isUpdatedWindow) {
//     //   await SystemAlertWindow.sendMessageToOverlay('update system window');
//     //   SystemAlertWindow.updateSystemWindow(
//     //       height: 200,
//     //       width: MediaQuery.of(context).size.width.floor(),
//     //       gravity: SystemWindowGravity.CENTER,
//     //       prefMode: prefMode,
//     //       isDisableClicks: true);
//     //   setState(() {
//     //     _isUpdatedWindow = true;
//     //     SystemAlertWindow.sendMessageToOverlay(_isUpdatedWindow);
//     //   });
//     // }
//     else {
//       setState(() {
//         _isShowingWindow = false;
//         // _isUpdatedWindow = false;
//         // SystemAlertWindow.sendMessageToOverlay(_isUpdatedWindow);
//       });
//       SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
//     }
//   }
//
// // void setUpSystemAlertWindowListener() {
// //   SystemAlertWindow.registerOnClickListener((String tag) {
// //     print("Button clicked: $tag");
// //     if(tag == "simple_button") {
// //       // Perform your action
// //     }
// //   });
// // }
// }
