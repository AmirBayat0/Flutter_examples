import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/main_wrapper_controller.dart';
import '../../main_wrapper.dart';
import '../../utils/themes.dart';

/////////////////////////////////
// 🔥 CodeWithFlexz on Instagram

// 🚀 AmirBayat0 on Github
// 👽 Programming with Flexz on Youtube
////////////////////////////////

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bottom AppBar',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: Get.put(MainWrapperController()).theme,
      home: MainWrapper(),
    );
  }
}
