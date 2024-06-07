import 'package:flutter/services.dart';

class ClipboardService {
  static const MethodChannel _channel = MethodChannel('clipboard_channel');

  static Future<String?> getClipboardData() async {
    try {
      final String? clipboardData =
      await _channel.invokeMethod<String>('getClipboardData');
      return clipboardData;
    } on PlatformException catch (e) {
      print("Failed to get clipboard data: '${e.message}'.");
      return null;
    }
  }
}