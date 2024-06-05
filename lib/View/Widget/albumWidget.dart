import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/SongDetailView/SongDetailView.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailBasic.dart';

class AlbumWidget extends StatelessWidget {
  AlbumWidget(this.songs, {super.key});

  List<SearchSong> songs;
  var thumbnail;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: songs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: (5 / 7),
          crossAxisSpacing: 3.w,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              List selectSong = [
                songs[index].title,
                songs[index].artist,
                thumbnail,
                songs[index].lyrics?.replaceAll('\n', '\\n'),
              ];
              Get.to(() => SongDetail(musicInfo:selectSong));
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 95.w,
                    height: 90.h,
                    child: SizedBox(
                      width: 50.w,
                      child: thumbnail != null
                          ? Image.memory(thumbnail!, width: 50, height: 50)
                          : Container(width: 50, height: 50, color: Colors.grey),
                    ),
                  ),
                  Text(
                    songs[index].title,
                    style: myStyle.textTheme.labelLarge,
                  ),
                  Text(
                    songs[index].artist,
                    style: myStyle.textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
