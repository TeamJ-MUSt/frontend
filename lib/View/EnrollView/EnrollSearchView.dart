import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:must/View/Widget/SongListSmall.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/api_service.dart';
import '../../data/searchJson.dart';

class EnrollSearchView extends StatefulWidget {
  EnrollSearchView({required this.query, super.key});
  String query;

  @override
  State<EnrollSearchView> createState() => _EnrollSearchViewState();
}

class _EnrollSearchViewState extends State<EnrollSearchView> {
  @override
  void initState() {
    super.initState();
    print(widget.query);
    fetchSongsAndThumbnails();
  }

  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};

  Future<void> fetchSongsAndThumbnails() async {
    try {
      songs = await totalSearchSongData(widget.query);
      print('fetch end');
      for (var song in songs) {
        if (song.songId != null) {
          //노래 데이터를 찾으면 썸네일을 가져옵니다
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
      body:  FutureBuilder<List<SearchSong>>(
        future: totalSearchSongData(widget.query),
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
            print(snapshot);
            // 데이터가 있고, 비어있지 않은 경우
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.query}에 대한 검색 결과입니다",
                    style: myStyle.textTheme.bodyMedium,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        SearchSong song = songs[index]; // Retrieve the thumbnail using songId
                        return SongListSmall(song: song,thumbnail: thumbnails[song.songId],);
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
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
            return Text("NO DATA");
          }
        },
      ),
    );
  }
}
