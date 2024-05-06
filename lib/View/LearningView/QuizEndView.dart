import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/EnrollView/PerformEnroll.dart';
import 'package:must/View/SongDetailView/SongDetailView.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';
import '../../data/searchJson.dart';
import '../mainView.dart';

class QuizEndView extends StatelessWidget {
  QuizEndView({required this.correctCnt, super.key});
  int correctCnt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Center(
        child: InkWell(
            onTap:(){
              Get.offAll(() => MainView());
            },
            child: Text("맞은 개수는 ${correctCnt.toString()}개 입니다", style: myStyle.textTheme.bodyMedium,)),
      ),
    );
  }
}
