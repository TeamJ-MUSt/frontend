import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

class SequenceQuizView extends StatelessWidget {
  const SequenceQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "순서 퀴즈",
          style: myStyle.textTheme.labelMedium,
        ),
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
        child: Column(
          children: [
            Text(
              '2/30',
              style: myStyle.textTheme.bodyMedium,
            ),
            Expanded(
              flex: 1,
              child: Center(
                // color: myStyle.mainColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("일본어"),

                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: myStyle.basicGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
