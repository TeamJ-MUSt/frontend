import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

class RecommandWidget extends StatelessWidget {
  RecommandWidget({super.key, required this.title, required this.artist, this.thumbnail});
  final String title;
  final String artist;
  Uint8List? thumbnail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      height: 75.h,
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: thumbnail != null
                ? Image.memory(thumbnail!, width: 70.w, height: 70.h,fit:BoxFit.fitHeight)
                : Container(width: 50, height: 50, color: Colors.grey),
          ),
          SizedBox(width: 5.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: myStyle.textTheme.headlineLarge,),
              Text(artist, style: myStyle.textTheme.headlineMedium,)
            ],
          )
        ],
      ),
    );
  }
}
