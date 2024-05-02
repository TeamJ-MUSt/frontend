import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;


class RecommandWidget extends StatelessWidget {
  RecommandWidget({super.key, required this.title, required this.artist, required this.thumbnail});
  final String title;
  final String artist;
  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      height: 50.h,
      child: Row(
        children: [
          SizedBox(width: 70.w, child: Image.network(thumbnail),),
          SizedBox(width: 5.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: myStyle.textTheme.headlineLarge,),
              Text(artist,style: myStyle.textTheme.headlineMedium,)
            ],
          )
        ],
      ),
    );
  }
}
