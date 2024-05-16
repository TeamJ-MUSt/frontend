import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/musicjson.dart';
import '../../data/searchJson.dart';


class SongDetailCardAPI extends StatelessWidget {
  SongDetailCardAPI({required this.song, required this.thumbnail, super.key});

  SearchSong song;
  var thumbnail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.h,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54,
              blurRadius: 1.0,
              offset: Offset(1.0, 2.0))
        ],
        color: Colors.white,
      ),
      // width: 340.w,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100.w, child: Image.memory(thumbnail, fit: BoxFit.cover,)),
          SizedBox(
            width: 10.w,
          ),
          Flexible(
            child: SizedBox(
              // color: Colors.deepPurple,
              width: 170.w,
              height: 80.h,
              // margin: EdgeInsets.symmetric(vertical: 15.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "level",
                  ),
                  Text(
                    song.title,
                    style: myStyle.textTheme.bodyMedium,
                  ),
                  Text(
                    song.artist,
                    style: myStyle.textTheme.displayMedium,
                  )
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_border_outlined,
              size: 25.h,
              color: myStyle.mainColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
