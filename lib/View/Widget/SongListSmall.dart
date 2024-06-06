import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/EnrollView/PerformEnroll.dart';
import 'package:must/data/api_service.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/searchJson.dart';

class SongListSmall extends StatelessWidget {
  SongListSmall({required this.song, required this.thumbnail, super.key});

  SearchSong song;
  var thumbnail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => PerformEnroll(
          song: song,
          thumbnail: thumbnail,
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        height: 50.h,
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
                    style: myStyle.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
                    style: myStyle.textTheme.displaySmall,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}