import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailView.dart';

class SongListWidget extends StatelessWidget {
  SongListWidget({required this.song, required this.thumbnail, super.key});

  final SearchSong song;
  final Uint8List? thumbnail; // 수정: Uint8List? 타입으로 변경

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => SongDetailView(
          song: song,
          thumbnail: thumbnail,
        ));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 5.h),
        height: 45.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
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
                      song.level != null
                          ? song.level == 1
                          ? "쉬움"
                          : song.level == 2
                          ? "보통"
                          : "어려움"
                          : "알 수 없음", // 수정: level이 null일 경우 대비
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
