import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/Widget/recommandWidget.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/api_service.dart';
import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailBasic.dart';
import '../Widget/albumWidget.dart';



class NavigationTem extends StatefulWidget {
  const NavigationTem({super.key});

  @override
  State<NavigationTem> createState() => _NavigationTemState();
}

class _NavigationTemState extends State<NavigationTem> {
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};

  @override
  void initState() {
    super.initState();
    fetchSongsAndThumbnails();
  }

  Future<void> fetchSongsAndThumbnails() async {
    try {
      songs = await fetchSongData();
      print('fetch end');
      for (var song in songs) {
        if (song.songId != null) { //노래 데이터를 찾으면 썸네일을 가져옵니다
          Uint8List? thumbnail = await fetchSongThumbnail(song.songId);
          if (thumbnail != null) {
            thumbnails[song.songId] = thumbnail; // Correct key to songId
            print('Thumbnail for song ID ${song.songId} fetched');
          }
        } else {
          print('no song id!');
        }
      }
      setState(() {}); // Refresh UI with fetched data
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<Song> songs = Song.parseUserList(jsonString);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
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
                    flex: 3,
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
                          RecommandWidget(
                              title: songs[0].title,
                              artist: songs[0].artist,
                              thumbnail: thumbnails[songs[0].songId])
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
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
                ],
              ),
            ),
          ),
          Text(
            "인기 Top10",
            style: myStyle.textTheme.bodyMedium,
          ),
          SizedBox(
            height: 5.h,
          ),
          Expanded(
            child : GridView.builder(
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
                        thumbnails,
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
                            child: Image.memory(
                              thumbnails! as Uint8List,
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
                })
            // child: Container(
              // color: Colors.black,
              // child: AlbumWidget(songs),
            // ),
          )
        ],
      ),
    );
  }
}
