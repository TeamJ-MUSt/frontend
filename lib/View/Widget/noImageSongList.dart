
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailView.dart';

class NoImageSongList extends StatelessWidget {
  NoImageSongList({required this.song,super.key});

  SearchSong song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        width: double.infinity,
        height: 45.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  SizedBox(
                    width: 50.w,
                    child: Container(width: 50, height: 50, color: Colors.grey),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          overflow: TextOverflow.ellipsis,
                          style: myStyle.textTheme.bodySmall,
                        ),
                        Text(
                          song.artist,
                          style: myStyle.textTheme.displaySmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
