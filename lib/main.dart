import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:must/View/LearningView/SoundQuizView.dart';
import 'package:must/View/LoginView.dart';
import './style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'View/mainView.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

