import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/bookmark_controller.dart';
import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailView.dart';

class mySongListWidget extends StatelessWidget {
  mySongListWidget({required this.song, required this.thumbnail, super.key});

  final SearchSong song;
  final Uint8List? thumbnail;

  // Method to return the bookmark status
  bool isBookmarked() {
    final BookmarkController bookmarkController = Get.find<BookmarkController>();
    return bookmarkController.isBookmarked(song.songId);
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkController bookmarkController = Get.find<BookmarkController>();

    return Material(
      child: InkWell(
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
                  Obx(() {
                    bool bookmarked = isBookmarked();
                    return InkWell(
                      onTap: () {
                        bookmarkController.toggleBookmark(song.songId);
                      },
                      child: Icon(
                        bookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
                        color: bookmarked ? myStyle.mainColor : myStyle.mainColor,
                      ),
                    );
                  }),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
