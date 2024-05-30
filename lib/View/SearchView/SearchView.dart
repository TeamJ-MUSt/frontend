import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/SearchView/NoDataView.dart';
import 'package:must/style.dart' as myStyle;
import '../../data/api_service.dart';
import '../../data/musicjson.dart';
import '../../data/searchJson.dart';
import '../EnrollView/EnrollSearchView.dart';
import '../Widget/mySongListWidget.dart';

class SearchView extends StatefulWidget {
  SearchView({required this.query, super.key});
  final String query;

  @override
  State<SearchView> createState() => _SearchViewState(query: query);
}

class _SearchViewState extends State<SearchView> {
  _SearchViewState({required this.query});
  final String query;
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};

  @override
  void initState() {
    super.initState();
    fetchSongsAndThumbnails();
  }

  Future<void> fetchSongsAndThumbnails() async {
    try {
      var response = await searchSongData2(widget.query);
      if (response.success && response.songs != null) {
        songs = response.songs!;
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
      } else {
        print('No songs found or request failed');
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
      body: FutureBuilder<ApiResponse>(
        future: searchSongData2(widget.query),
        builder: (BuildContext context, AsyncSnapshot<ApiResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("로딩중");
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                color: Colors.blue,
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.songs.isNotEmpty) {
            songs = snapshot.data!.songs;
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
                        SearchSong song = songs[index];
                        return mySongListWidget(
                          song: song,
                          thumbnail: thumbnails[song.songId],
                        );
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
            return Center(
              child: InkWell(
                onTap: () {
                  Get.to(() => EnrollSearchView(query: query));
                },
                child: Text(
                  '원하는 노래가 없나요?',
                  style: myStyle.textTheme.displayMedium,
                ),
              ),
            );
          }
        },
      ),
    );
  }

}
