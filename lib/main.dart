import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'View/mainView.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'data/bookmark_controller.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // .env 파일을 로드합니다.
  Get.put(BookmarkController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (BuildContext context, child) => GetMaterialApp(
        title: 'MUSt',
        debugShowCheckedModeBanner: false,
        theme: myStyle.theme,
        home: const MainView(),
      ),
    );
  }
}

