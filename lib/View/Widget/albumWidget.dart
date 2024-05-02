import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/json.dart';
import '../SongDetailView/SongDetailBasic.dart';

class AlbumWidget extends StatelessWidget {
  AlbumWidget(this.songs, {super.key});

  List<Song> songs;

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
                songs[index].thumbnail,
                songs[index].lyrics.replaceAll('\n', '\\n'),
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
                    child: Image.network(
                      songs[index].thumbnail,
                      fit: BoxFit.fitWidth,
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
