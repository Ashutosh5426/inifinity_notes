import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_notes/core/services/db/db.dart';
import 'package:infinity_notes/core/services/db/entity.dart';
import 'package:infinity_notes/core/uuid/unique_id.dart';

class CustomOverlay extends StatefulWidget{
  const CustomOverlay({super.key});

  @override
  State<CustomOverlay> createState() => _CustomOverlayState();
}

class _CustomOverlayState extends State<CustomOverlay> {
  bool _enableAddButton = false;
  ReceivePort _receivePort = ReceivePort();

  @override
  void initState() {
    _initOverlayIsolate();
    super.initState();
  }

  @override
  void dispose() {
    _receivePort.close();
    super.dispose();
  }

  void _initOverlayIsolate() {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      'CustomOverlay',
    );

    _receivePort.listen((dynamic data) {
      log('Message from main isolate: $data');
      // Handle message received from main isolate
    });
  }

  // Method to send message to main isolate
  void _sendMessageToMain(String message) {
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('MainApp');
    sendPort?.send(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: () {
          if (_enableAddButton) {
            _sendMessageToMain('Message from overlay');
            // _saveNameIntoDB();
            return;
          }
          _enableAddButton = true;
          setState(() {});
          Future.delayed(
            const Duration(seconds: 7),
            () {
              _enableAddButton = false;
              setState(() {});
            },
          );
        },
        child: Container(
          width: _enableAddButton ? 100 : 40,
          height: 40,
          decoration: BoxDecoration(
            shape: _enableAddButton ? BoxShape.rectangle : BoxShape.circle,
            color: Colors.black.withOpacity(0.2),
          ),
          child: Center(
            child: Text(
              _enableAddButton ? "Add" : "",
            ),
          ),
        ),
      ),
    );
  }

  void _saveNameIntoDB() async {
    String? name = await getData('text/plain');
    if (name != null) {
      Database().instance.addPerson(
          Person(name: name, age: 0, personId: UniqueId.generateV1()));
    }
  }

  Future<String?> getData(String format) async {
    String? data = await _getClipboardData();
    // String? clipboardData = await ClipboardManager.getClipboardData();
    // if (clipboardData != null) {
    //   print("Clipboard data: $clipboardData");
    // }
    // String? data;
    // FlutterClipboard.paste().then((value) {
    //   /// Do what ever you want with the value.
    //   setState(() {
    //     data = value;
    //   });
    // });

    return data;
  }

  // Future<String?> _getClipboardData() async {
  //   // final String? text = await ClipboardChannel.getClipboardText();
  //   // return text;
  // }


  Future<String?> _getClipboardData() async {
    String text = await FlutterClipboard.paste();

    print(text);


    Map<String, dynamic> result =
    await SystemChannels.platform.invokeMethod('Clipboard.getData');
    if (result != null) {
      return result['text'].toString();
    }
    return null;
    // try {
    //   ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    //   return clipboardData?.text;
    // } catch (e) {
    //   print('Failed to get clipboard data: $e');
    //   return null;
    // }
  }
}
