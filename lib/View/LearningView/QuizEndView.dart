import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizEndView extends StatelessWidget {
  final int correctCnt;

  QuizEndView({required this.correctCnt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "퀴즈 결과",
          style: myStyle.textTheme.labelMedium,
        ),
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '퀴즈를 완료했습니다!',
                style: myStyle.textTheme.titleLarge,
              ),
              SizedBox(height: 20.h),
              Text(
                '맞은 개수: $correctCnt',
                style: myStyle.textTheme.headlineMedium,
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // 이전 화면으로 돌아가기
                },
                style: ElevatedButton.styleFrom(
                  primary: myStyle.mainColor,
                ),
                child: Text(
                  '돌아가기',
                  style: myStyle.textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
