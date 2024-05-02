import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../EnrollView/EnrollSearchView.dart';
class NoDataView extends StatelessWidget {
  String query;
  NoDataView({required this.query, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${query}에 대한 검색 결과입니다",
            style: myStyle.textTheme.bodyMedium,
          ),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              "미등록된 노래입니다",
              style: myStyle.textTheme.displayLarge,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => EnrollSearchView(query: query));
            },
            child: Text(
              "등록하러가기 ➡️",
              style: myStyle.textTheme.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
