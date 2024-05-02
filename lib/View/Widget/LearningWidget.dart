import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/style.dart' as myStyle;

class LearningWidget extends StatelessWidget {

  LearningWidget({required this.content, required this.comment, required this.moveTo, super.key});
  String content;
  String comment;
  Widget moveTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(() => moveTo);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
        child: Row(
          children: [
            Icon(
              Icons.circle_outlined,
              color: myStyle.mainColor,
              size: 30.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: myStyle.textTheme.bodySmall,
                ),
                Text(
                  comment,
                  style: myStyle.textTheme.displaySmall,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
