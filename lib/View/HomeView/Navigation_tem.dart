import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must/View/Widget/recommandWidget.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/api_service.dart';
import '../../data/searchJson.dart';
import '../SongDetailView/SongDetailView.dart';

class NavigationTem extends StatefulWidget {
  const NavigationTem({super.key});

  @override
  State<NavigationTem> createState() => _NavigationTemState();
}

class _NavigationTemState extends State<NavigationTem> {
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};
  List<int> displayIndexes = [3, 1, 6, 10, 13, 11, 14, 4, 40, 21]; // 여기서 특정 인덱스를 지정합니다.

  @override
  void initState() {
    super.initState();
    fetchSongsAndThumbnails();
  }

  Future<void> fetchSongsAndThumbnails() async {
    try {
      songs = await fetchSongData();
      print('fetch end');
      print(songs);
      for (var song in songs) {
        if (song.songId != null) {
          Uint8List? thumbnail = await fetchSongThumbnail(song.songId);
          if (thumbnail != null) {
            thumbnails[song.songId] = thumbnail;
            print('Thumbnail for song ID ${song.songId} fetched');
          }
        } else {
          print('no song id!');
        }
      }
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      onTap: () {
                        Get.to(() => SongDetailView(song: songs[0], thumbnail: thumbnails[songs[0].songId]));
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
          ),
          Text(
            "인기 Top10",
            style: myStyle.textTheme.bodyMedium,
          ),
          SizedBox(
            height: 5.h,
          ),
          Expanded(
            child: GridView.builder(
              itemCount: displayIndexes.length, // displayIndexes를 기준으로 항목 수 설정
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (5 / 7),
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.h,
              ),
              itemBuilder: (context, index) {
                int displayIndex = displayIndexes[index] - 1; // 실제 인덱스는 0부터 시작하므로
                if (displayIndex >= songs.length) {
                  return SizedBox(); // 범위를 벗어난 경우 빈 위젯 반환
                }
                return GestureDetector(
                  onTap: () {
                    Get.to(() => SongDetailView(
                      song: songs[displayIndex],
                      thumbnail: thumbnails[songs[displayIndex].songId],
                    ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 95.w,
                        height: 90.h,
                        child: thumbnails[songs[displayIndex].songId] != null
                            ? Image.memory(
                          thumbnails[songs[displayIndex].songId]!,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 95.w,
                          height: 90.h,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        songs[displayIndex].title,
                        overflow: TextOverflow.ellipsis,
                        style: myStyle.textTheme.labelLarge,
                      ),
                      Text(
                        songs[displayIndex].artist,
                        overflow: TextOverflow.ellipsis,
                        style: myStyle.textTheme.displaySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
