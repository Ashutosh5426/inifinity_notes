import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:infinity_notes/core/services/db/db.dart';
import 'package:infinity_notes/core/values/app_colors.dart';
import 'package:infinity_notes/features/custom_overlay.dart';
import 'package:infinity_notes/features/home_page/home_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database().init();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomOverlay(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PiPMaterialApp(
      debugShowCheckedModeBanner: false,
      pipParams: const PiPParams(
        pipWindowWidth: 50,
        pipWindowHeight: 50,
        bottomSpace: 60,
      ),
      home: const HomePage(),
    );
  }
}