
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailView.dart';

class SongListWidget extends StatelessWidget {
  SongListWidget({required this.song, required this.thumbnail, super.key});

  SearchSong song;
  var thumbnail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => SongDetailView(song: song, thumbnail: thumbnail, ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        height: 45.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50.w,
                  child: thumbnail != null
                      ? Image.memory(thumbnail!, width: 50, height: 50)
                      : Container(width: 50, height: 50, color: Colors.grey),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: myStyle.textTheme.bodySmall,
                    ),
                    Text(
                      song.artist,
                      style: myStyle.textTheme.displaySmall,
                    )
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.bookmark_border_outlined,
                    color: myStyle.mainColor,
                  ),
                ),
                Container(
                  height: 15.h,
                  width: 40.w,
                  // color: myStyle.mainColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: myStyle.mainColor,
                      width: 0,
                    ),
                    color: myStyle.mainColor,
                  ),
                  child: Center(
                    child: Text(
                      "어려움",
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
