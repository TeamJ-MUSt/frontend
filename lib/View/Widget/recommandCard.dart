
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/Widget/recommandWidget.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailView.dart';
class RecommandCard extends StatelessWidget {
  RecommandCard({required this.songs, required this.thumbnails, super.key});
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      height: 125.h,
      decoration: BoxDecoration(color: myStyle.mainColor),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: myStyle.mainColor,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "오늘의 오스스메",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'NotoSansCJK',
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    if (songs.isNotEmpty && thumbnails.containsKey(songs[0].songId))
                      RecommandWidget(
                        title: songs[0].title,
                        artist: songs[0].artist,
                        thumbnail: thumbnails[songs[0].songId],
                      )
                    else
                      Container(
                        // width: 50.w,
                        height: 70.h,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: (){
                  Get.to(()=>SongDetailView(
                    song: songs[0],
                    thumbnail: thumbnails[songs[0].songId],
                  ));
                },
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_outlined,
                        size: 35.h,
                        color: myStyle.mainColor,
                      ),
                      Text(
                        "학습 바로가기",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'NotoSansCJK',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFCC2036)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
