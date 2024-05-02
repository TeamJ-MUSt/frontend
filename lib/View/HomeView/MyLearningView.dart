import 'package:flutter/material.dart';
import 'package:must/View/BookMarkView.dart';
import 'package:must/View/MySettingView.dart';
import 'package:must/View/Widget/FillCard.dart';
import 'package:must/View/WordBookView/WordBookView.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;
class MyLearningView extends StatelessWidget {
  const MyLearningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '내 학습 상태',
            style: myStyle.textTheme.bodyLarge,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            '곡 학습',
            style: myStyle.textTheme.bodyMedium,
          ),
          SizedBox(height: 5.h,),
          Row(
            children: [
              FillCard(4, "학습 완료된 곡", false, const MySettingView()),
              SizedBox(
                width: 10.w,
              ),
              FillCard(3, "북마크 된 곡", true, const BookMarkView()),
            ],
          ),
          SizedBox(height: 10.h,),
          Text(
            '단어 학습',
            style: myStyle.textTheme.bodyMedium,
          ),
          SizedBox(height: 5.h,),
          Row(
            children: [
              FillCard(20, "공부한 단어", false, WordBookView()),
              SizedBox(width: 10.w,),
              FillCard(3, "암기 완료 단어", true, WordBookView())
            ],
          ),
        ],
      ),
    );
  }
}
