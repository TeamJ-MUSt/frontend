import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/json.dart';
class SongListSmall extends StatelessWidget {

  var songWidget;
  // final List<Song> songs = songWidget;
  SongListSmall({required this.songWidget,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      height: 50.h,
      child: Row(
        children: [
          SizedBox(width: 50.w, child: Image.network(songWidget.thumbnail),),
          SizedBox(width: 5.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(songWidget.title,style: myStyle.textTheme.bodySmall,),
              Text(songWidget.artist,style: myStyle.textTheme.displaySmall,)
            ],
          )
        ],
      ),
    );
  }
}
