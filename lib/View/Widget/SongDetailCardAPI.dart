import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/bookmark_controller.dart';
import '../../data/musicjson.dart';
import '../../data/searchJson.dart';


class SongDetailCardAPI extends StatelessWidget {
  SongDetailCardAPI({required this.song, required this.thumbnail, super.key});

  SearchSong song;
  var thumbnail;
  final BookmarkController bookmarkController = Get.put(BookmarkController());

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
                  Container(
                    height: 15.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: song.level != null
                          ? song.level == 1
                          ? Colors.green
                          : song.level == 2
                          ? myStyle.pointColor
                          : myStyle.mainColor
                          : myStyle.basicGray,
                    ),
                    child: Center(
                      child: Text(
                        song.level != null
                            ? song.level == 1
                            ? "쉬움"
                            : song.level == 2
                            ? "보통"
                            : "어려움"
                            : "알 수 없음",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
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
          InkWell(
            onTap: () {
              bookmarkController.toggleBookmark(song.songId);
            },
            child: Obx(() {
              bool isBookmarked = bookmarkController.isBookmarked(song.songId);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
                  color: isBookmarked ? myStyle.mainColor : myStyle.mainColor,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
