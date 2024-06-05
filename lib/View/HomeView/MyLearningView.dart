import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/BookMarkView.dart';
import 'package:must/View/MySettingView.dart';
import 'package:must/View/Widget/FillCard.dart';
import 'package:must/View/Widget/recommandCard.dart';
import 'package:must/View/WordBookView/WordBookView.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';
import '../../data/bookmark_controller.dart';
import '../../data/getApi.dart';
import '../../data/searchJson.dart';
import '../../data/specialData.dart';
import '../../data/wordJson.dart';
import '../global_state.dart';

class MyLearningView extends StatefulWidget {
  @override
  State<MyLearningView> createState() => _MyLearningViewState();
}

class _MyLearningViewState extends State<MyLearningView> {
  SpecialData? specialData;
  List<Word> words = [];
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    fetchSongsAndThumbnails();
  }

  Future<void> _loadData() async {
    try {
      SpecialData data = await loadSpecialData();
      print((data==null)?"null" : 'ok');
      print(data.word);
      setState(() {
        specialData = data;
        print(data.word);
      });
    } catch (e) {
      print('Error in _loadData: $e');
    }
  }

  Future<void> getWordlength() async{
    try {
      List<Word> loadedWords = await getWordbook(1);
      updateGlobalWordsLength(loadedWords.length); // Update global length
    }catch(e){
      print(e);
    }
  }


  Future<void> fetchSongsAndThumbnails() async {
    try {
      songs = await fetchSongData();
      print('fetch end');
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
    final BookmarkController bookmarkController =
    Get.find<BookmarkController>();
    // Filter the list of songs to only include bookmarked ones
    final List<SearchSong> bookmarkedSongs = songs
        .where((song) => bookmarkController.isBookmarked(song.songId))
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "오늘의 단어  ",
                style: myStyle.textTheme.bodyMedium,
              ),
              Text(
                "일본의 독특한 단어들을 소개합니다",
                style: myStyle.textTheme.displaySmall,
              ),
            ],
          ),
          specialData != null
              ? Container(
                  height: 60.h,
                  width: ScreenUtil().screenWidth,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${specialData!.word} (${specialData!.reading})",
                        style: myStyle.textTheme.labelSmall,
                      ),
                      Text(
                        specialData!.meaning,
                        style: myStyle.textTheme.labelSmall,
                      ),
                    ],
                  ),
                )
              : CircularProgressIndicator(),
          RecommandCard(songs: songs, thumbnails: thumbnails),
          Text(
            '내 학습 상태',
            style: myStyle.textTheme.bodyLarge,
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            children: [
              FillCard(globalWordsLength, "공부한 단어", false, WordBookView()),
              SizedBox(
                width: 10.w,
              ),
              FillCard(
                bookmarkedSongs.length,
                "북마크 된 곡",
                true,
                BookMarkView(),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
