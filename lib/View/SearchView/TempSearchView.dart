import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/SearchView/FindDataView.dart';
import 'package:must/View/SearchView/NoDataView.dart';
import 'package:must/style.dart' as myStyle;
import '../../data/api_service.dart';
import '../../data/json2.dart';
import '../../data/searchJson.dart';
import '../EnrollView/EnrollSearchView.dart';
import '../Widget/SongListWidget.dart';

class TempSearchView extends StatefulWidget {
  TempSearchView({required this.query,super.key});
  String query;

  @override
  State<TempSearchView> createState() => _TempSearchViewState(query : query);
}

class _TempSearchViewState extends State<TempSearchView> {
  _TempSearchViewState({required this.query});
  String query;
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};


  @override
  void initState() {
    super.initState();
    fetchSongsAndThumbnails();
  }

  Future<void> fetchSongsAndThumbnails() async {
    try {
      songs = await searchSongData(widget.query);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: FutureBuilder<List<SearchSong>>(
        future: searchSongData(widget.query),
        builder: (BuildContext context, AsyncSnapshot<List<SearchSong>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("로딩중");
            // 로딩 중 인디케이터
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 에러 발생 시
            return Center(
              child: Container(
                color: Colors.blue,
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // 데이터가 있고, 비어있지 않은 경우
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${query}에 대한 검색 결과입니다",
                    style: myStyle.textTheme.bodyMedium,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        SearchSong song = songs[index]; // Retrieve the thumbnail using songId
                        return SongListWidget(song: song,thumbnail: thumbnails[song.songId],);
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => EnrollSearchView(query: query));
                    },
                    child: Text(
                      '원하는 노래가 없나요?',
                      style: myStyle.textTheme.displayMedium,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // 데이터가 비어 있는 경우
            return NoDataView(query: widget.query);
          }
        },
      ),
    );
  }
}
